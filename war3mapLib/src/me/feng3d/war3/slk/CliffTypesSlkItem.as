package me.feng3d.war3.slk
{
	/**
	 * TerrainArt\CliffTypes.slk 文件单条数据结构
	 * @author warden_feng 2014-7-20
	 */
	public class CliffTypesSlkItem
	{
		/** 悬崖ID */
		public var cliffID:String;
		/** 悬崖模型路径 */
		public var cliffModelDir:String;
		/** 悬崖饰物模型路径 */
		public var rampModelDir:String;
		/** 贴图路径 */
		public var texDir:String;
		/** 贴图文件 */
		public var texFile:String;
		/** 名称 */
		public var name:String;
		/** 地面名 */
		public var groundTile:String;
		/** 上部名称(这一栏全空) */
		public var upperTile:String;
		/** 悬崖类别 */
		public var cliffClass:String;
		/** 老ID */
		public var oldID:String;

		public function toString():String
		{
			return JSON.stringify(this);
		}
	}
}
