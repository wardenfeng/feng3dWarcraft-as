package me.feng3d.parsers.mdl
{
	import flash.geom.Vector3D;
	
	/**
	 * 全局动作信息
	 * @author warden_feng 2014-6-26
	 */
	public class AnimInfo
	{
		/** 动作名称 */
		public var name:String;
		/** 动作间隔 */
		public var interval:Interval;
		/** 最小范围 */
		public var MinimumExtent:Vector3D;
		/** 最大范围 */
		public var MaximumExtent:Vector3D;
		/** 半径范围 */
		public var BoundsRadius:Number;
		/** 发生频率 */
		public var Rarity:Number;
		/** 是否循环 */
		public var loop:Boolean = true;
		/** 移动速度 */
		public var MoveSpeed:Number;
	}
}