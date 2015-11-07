package me.feng3d.war3.map.w3e
{

	/**
	 * war3地图块数据
	 * @author warden_feng 2014-7-20
	 */
	public class W3eData
	{
		/** int: w3e format version [0B 00 00 00]h = version 11 */
		public var _version:int;
		/** char: main tileset [TS] */
		public var _main_tileset:String;
		/** int: custom tilesets flag (1 = using cutom, 0 = not using custom tilesets) */
		public var _custom_tilesets_flag:int;
		/** char[4][a]: 地表 tilesets IDs (tilesets目录) */
		public var tilesetsIDs:Array;
		/** char[4][b]: cliff tilesets IDs (悬崖tilesets 目录) */
		public var cliff_tilesetsIDs:Array;
		/** 地图宽度 */
		public var _mapWidth:int;
		/** 地图高度 */
		public var _mapHeight:int;
		/** 地图X坐标中心偏移 */
		public var _offsetX:Number;
		/** 地图Y坐标中心偏移 */
		public var _offsetY:Number;
		/** 地图块数据 */
		public var tilepoints:Vector.<W3eTilePoint> = new Vector.<W3eTilePoint>();
	}
}
