package me.feng3d.parsers
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import me.feng3d.war3.map.w3e.W3eData;
	import me.feng3d.war3.map.w3e.W3eTilePoint;

	/**
	 * 魔兽配置文件slk解析
	 * @author warden_feng 2014-7-20
	 */
	public class W3eParser extends ParserBase
	{
		private var _byteData:ByteArray;

		private var _body:ByteArray;

		public var war3mapTileData:W3eData;
		
		public function W3eParser()
		{
			super(ParserDataFormat.BINARY);
		}

		protected override function startParsing(frameLimit:Number):void
		{
			super.startParsing(frameLimit);

			_byteData = getByteData();

			//parse header
			_byteData.endian = Endian.LITTLE_ENDIAN;
			
			war3mapTileData = new W3eData();

			parseHeader();

			_body = _byteData;
		}

		protected override function proceedParsing():Boolean
		{
			//block的数量= Mx*My.
			while (_body.bytesAvailable > 0 && !parsingPaused && hasTime())
				parseNextBlock();

			// Return complete status
			if (_body.bytesAvailable == 0)
				return PARSING_DONE;
			else
				return MORE_TO_PARSE;
		}

		private function parseHeader():void
		{
			_byteData.position = 4;
			war3mapTileData._version = _byteData.readInt();
			war3mapTileData._main_tileset = _byteData.readUTFBytes(1);
			war3mapTileData._custom_tilesets_flag = _byteData.readInt();

			var i:int;
			//int: tilesets组的编号 (高高低低原则) (注意: 不能大于16 ，因为tilesets 标注在tilepoints 的定义中)
			var tilesets:int = _byteData.readInt();
			//char[4][a]: 地表 tilesets IDs (tilesets目录)
			//例如: “Ldrt” 代表了 “洛丹伦的夏天“地表
			//(想要了解更多，请参阅war3.mpq中“TerrainArt\Terrain.slk“文件)
			war3mapTileData.tilesetsIDs = [];
			for (i = 0; i < tilesets; i++)
			{
				var tilesetsID:String = _byteData.readUTFBytes(4);
				war3mapTileData.tilesetsIDs[i] = tilesetsID;
			}
			//int: cliff tilesets的编号(高高低低原则) (注意: 不能大于16，原因同上)
			var cliff_tilesets:int = _byteData.readInt();
			//char[4][b]: cliff tilesets IDs (悬崖tilesets 目录)
			//例如: “CLdi”代表了洛丹伦悬崖泥土
			//(想要了解更多，请参阅war3,mpq中“TerrainArt\CliffTypes.slk“文件)
			war3mapTileData.cliff_tilesetsIDs = [];
			for (i = 0; i < cliff_tilesets; i++)
			{
				var cliff_tilesetsID:String = _byteData.readUTFBytes(4);
				war3mapTileData.cliff_tilesetsIDs[i] = cliff_tilesetsID;
			}

			//int: 地图宽度+ 1 = Mx
			//int: 地图高度 + 1 = My
			//例如: 您的地图大小是160×128, Mx=A1h and My=81h
			war3mapTileData._mapWidth = _byteData.readInt() - 1;
			war3mapTileData._mapHeight = _byteData.readInt() - 1;

			//float: 地图X坐标中心偏移
			//float: 地图Y坐标中心偏移
			war3mapTileData._offsetX = _byteData.readFloat();
			war3mapTileData._offsetY = _byteData.readFloat();

//			 这两个偏移用于脚本文件，小装饰物，还有其他一些地方。
//			  原始坐标（0，0）位于地图左下角，比传统在地图正中间做（0，0）更易于使用。
//			  下面是偏移的算法：
//			  -1*(Mx-1)*128/2 and -1*(My-1)*128/2
//			  
//			  在这里  
//			  (Mx-1) 和 (My-1) 是地图的宽度和高度
//			   	128是地图里tile的大小
//			    /2 是取长度的中间值 
//			    -1* 因为我们是“translating” 地图区域，而不是定义新坐标
		}

		private function parseNextBlock():void
		{
			var tilepoint:W3eTilePoint = new W3eTilePoint();

			tilepoint.height = _body.readShort();
			tilepoint.height = transformHeight(tilepoint.height);
			tilepoint.waterFlag = _body.readShort();
			var byteValue:int = _body.readUnsignedByte();
			tilepoint.flag = (byteValue & 0xF0) >> 4;
			tilepoint.texturetype = byteValue & 0xF;
			tilepoint.textureDetail = _body.readUnsignedByte();
			byteValue = _body.readUnsignedByte();
			tilepoint.cliffType = (byteValue & 0xF0) >> 4;
			tilepoint.layerHeight = byteValue & 0xF;

			war3mapTileData.tilepoints.push(tilepoint);
		}
		
		//		short: 地面高度
		//	C000h: 最低高度(-16384)
		//	2000h: 正常高度(零地水准平面,8192)
		//	3FFFh: 最高高度(+16383)
		private function transformHeight(height:int):int
		{
			return height - 8192;
		}
	}
}
