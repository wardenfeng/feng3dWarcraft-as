package me.feng3d.war3.map.w3e
{

	/**
	 * war3地图块item
	 * @author warden_feng 2014-7-20
	 */
	public class W3eTilePoint
	{
		//	一个 tilepoint 用一个7bytes的块来定义。
		//	block的数量= Mx*My.
		//		short: 地面高度
		//	C000h: 最低高度(-16384)
		//	2000h: 正常高度(零地水准平面)
		//	3FFFh: 最高高度(+16383)
		public var height:int;
		/**	short: 水面 + 标记*（地图边缘的阴影范围）*/
		public var waterFlag:int;
		/**	4bit: 标记*   */
		public var flag:int;
		/**	4bit: 地面构造类型 (草地，泥土，岩石,…)   */
		public var texturetype:int;
		/**	1byte: 细节纹理 (石头, 洞, 骨头,…).   */
		public var textureDetail:int;
		/**	4bit: 悬崖构造类型   */
		public var cliffType:int;
		/**	4bit: 层的高度   */
		public var layerHeight:int;
	}
}
