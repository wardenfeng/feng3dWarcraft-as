package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	
	import me.feng3d.parsers.mdl.FBitmap;

	/**
	 *
	 * @author warden_feng 2014-7-5
	 */
	public dynamic class TextureLib
	{
		private static var _defaultTextureBitmapData:BitmapData;

//		[Embed(source = "../war3/Textures/HeroBladeMaster.jpg")]
//		private static var Textures_HeroBladeMaster:Class;
//
//		[Embed(source = "../war3/Textures/Tornado2b.JPG")]
//		private static var Textures_Tornado2b:Class;
//
//		[Embed(source = "../war3/Textures/Red_Glow3.JPG")]
//		private static var Textures_Red_Glow3:Class;
//
//		[Embed(source = "../war3/Textures/Arthas.JPG")]
//		private static var Textures_Arthas:Class;
//
//		[Embed(source = "../war3/Textures/sentinelspell.JPG")]
//		private static var Textures_sentinelspell:Class;
//
//		[Embed(source = "../war3/Textures/Green_Glow3.JPG")]
//		private static var Textures_Green_Glow3:Class;
		
		[Embed(source = "../war3/Textures/DryadSkinPurple.JPG")]
		private static var DryadSkinPurple:Class;
		
		[Embed(source = "../war3/Textures/DryadEyeGlow.JPG")]
		private static var DryadEyeGlow:Class;
		
		[Embed(source = "../war3/Textures/Bow_1H_Epic01.JPG")]
		private static var Bow_1H_Epic01:Class;
		
		[Embed(source = "../war3/Textures/HumanHunterQuiver.JPG")]
		private static var HumanHunterQuiver:Class;
		
		private static var textureDic:Dictionary = new Dictionary();

		public function TextureLib()
		{
		}

		public static function getTexture(fBitmap:FBitmap, context3D:Context3D):Texture
		{
			var myTexture:Texture = textureDic[fBitmap];

			if (!myTexture)
			{
				var myTextureData:BitmapData = getBitmapData(fBitmap);
				myTexture = context3D.createTexture(myTextureData.width, myTextureData.height, Context3DTextureFormat.BGRA, false);
				uploadTextureWithMipmaps(myTexture, myTextureData);

				textureDic[fBitmap] = myTexture;
			}

			return myTexture;
		}

		private static function getBitmapData(fBitmap:FBitmap):BitmapData
		{
			var bitmapData:BitmapData;

			if (!fBitmap || fBitmap.image == null || fBitmap.image.length == 0)
			{
				return defaultBitmapData;
			}

			var image:String = fBitmap.image;
			image = image.substring(0, image.indexOf("."));
			while (image.indexOf("\\") != -1)
			{
				image = image.replace("\\", "_");
			}

			var cla:Class = TextureLib[image];

			var bitmap:Bitmap = new cla();
			bitmapData = bitmap.bitmapData;

			return bitmapData;
		}

		public static function uploadTextureWithMipmaps(dest:Texture, src:BitmapData):void
		{
			var ws:int = src.width;
			var hs:int = src.height;
			var level:int = 0;
			var tmp:BitmapData;
			var transform:Matrix = new Matrix();
			var tmp2:BitmapData;

			tmp = new BitmapData(src.width, src.height, true, 0x00000000);

			while (ws >= 1 && hs >= 1)
			{
				tmp.draw(src, transform, null, null, null, true);
				dest.uploadFromBitmapData(tmp, level);
				transform.scale(0.5, 0.5);
				level++;
				ws >>= 1;
				hs >>= 1;
				if (hs && ws)
				{
					tmp.dispose();
					tmp = new BitmapData(ws, hs, true, 0x00000000);
				}
			}
			tmp.dispose();
		}

		private static function get defaultBitmapData():BitmapData
		{
			_defaultTextureBitmapData = new BitmapData(8, 8, false, 0x0);

			//create chekerboard
			var i:uint, j:uint;
			for (i = 0; i < 8; i++)
			{
				for (j = 0; j < 8; j++)
				{
					if ((j & 1) ^ (i & 1))
						_defaultTextureBitmapData.setPixel(i, j, 0XFFFFFF);
				}
			}

			return _defaultTextureBitmapData;
		}
	}
}
