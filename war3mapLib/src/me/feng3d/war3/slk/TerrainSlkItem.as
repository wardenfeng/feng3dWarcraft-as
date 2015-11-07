package me.feng3d.war3.slk
{

	/**
	 * TerrainArt\Terrain.slk 文件单条数据结构
	 * @author warden_feng 2014-7-20
	 */
	public class TerrainSlkItem
	{
		/** 内部编码 */
		public var tileID:String;
		/** 路径 */
		public var dir:String;
		/** 文件 */
		public var file:String;
		/** 说明 */
		public var comment:String;
		/** 名称(real name) */
		public var name:String;
		/** 是否可建筑 */
		public var buildable:String;
		/** 是否可以留下脚印 */
		public var footprints:String;
		/** 是否可以在上面行走 */
		public var walkable:String;
		/** 是否可飞越 */
		public var flyable:String;
		/** 当选中时，在它下面的tile是否都被选中 */
		public var blightPri:String;
		/** 当变化时变化的优先级(即先变成什么) */
		public var convertTo:String;
		/** 是否是Beta版中的 */
		public var InBeta:String;

		public function get url():String
		{
			return dir + "/" + file;
		}

		public function toString():String
		{
			return JSON.stringify(this);
		}
	}
}
