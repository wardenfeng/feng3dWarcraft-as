package me.feng3d.parsers
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	import me.feng3d.war3.blp.BlpData;

	/**
	 * blp贴图文件解析
	 * @author warden_feng 2014-7-20
	 */
	public class BlpParser extends ParserBase
	{
		private var _byteData:ByteArray;

		public var blpData:BlpData;

		public function BlpParser()
		{
			super(ParserDataFormat.BINARY);
		}

		protected override function startParsing(frameLimit:Number):void
		{
			super.startParsing(frameLimit);

			_byteData = getByteData();

			//parse header
			_byteData.endian = Endian.LITTLE_ENDIAN;

			blpData = new BlpData();

			parseHeader();
		}

		private var loadstate:int = 0;

		protected override function proceedParsing():Boolean
		{
			if (loadstate == 0)
			{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
				loader.loadBytes(blpData.jpegData);
				loadstate = 1;
				return MORE_TO_PARSE;
			}
			if (loadstate == 1)
				return MORE_TO_PARSE;
			return PARSING_DONE;
		}

		protected function onComplete(event:Event):void
		{
			blpData.bitmap = event.target.content;
			var bmd1:BitmapData = blpData.bitmap.bitmapData;

			var bmd2:BitmapData = new BitmapData(bmd1.width, bmd1.height, true, 0);
//			var pt:Point = new Point(0, 0);
//			var rect:Rectangle = bmd2.rect;
//			var threshold:uint = 0;
//			var color:uint = 0;
//			var maskColor:uint = 0x00FFFFFF;
//			bmd2.threshold(bmd1, rect, pt, "==", threshold, color, maskColor, true);

			bmd2.unlock();
			for (var i:int = 0; i < bmd1.width; i++)
			{
				for (var j:int = 0; j < bmd1.height; j++)
				{
					var color1:uint = bmd1.getPixel32(i, j);
					var r:uint = (color1 >> 16) & 0xff;
					var g:uint = (color1 >> 8) & 0xff;
					var b:uint = color1 & 0xff;
					if (r < 20 && g < 20 && b < 20)
					{
						color1 = 0x0;
					}
					bmd2.setPixel32(i, j, color1);
				}
			}
			bmd2.lock();

			blpData.bitmap.bitmapData = bmd2;

			loadstate = 2;
		}

		/**
		 * 一不小心在这里把所有数据解析完了
		 */
		private function parseHeader():void
		{
			blpData.szTag = _byteData.readUTFBytes(4);
			blpData.uCompress = _byteData.readInt();
			blpData.uNumMipMaps = _byteData.readInt();
			blpData.width = _byteData.readInt();
			blpData.height = _byteData.readInt();
			blpData.uPicType = _byteData.readInt();
			blpData.uPicSubType = _byteData.readInt();

			var i:int;
			for (i = 0; i < 16; i++)
			{
				blpData.uMipmapOffset[i] = _byteData.readUnsignedInt();
			}
			for (i = 0; i < 16; i++)
			{
				blpData.uMipmapSize[i] = _byteData.readUnsignedInt();
			}

			var uJpegHeaderSize:int = _byteData.readUnsignedInt();

			var jpegData:ByteArray = new ByteArray();

			_byteData.readBytes(jpegData, 0, uJpegHeaderSize);

			_byteData.position = blpData.uMipmapOffset[0];
			_byteData.readBytes(jpegData, jpegData.length, blpData.uMipmapSize[0]);

			blpData.jpegData = jpegData;
		}

		private function parseNextBlock():void
		{

		}
	}
}
