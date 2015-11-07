package me.feng3d.parsers.mdl
{
	import flash.geom.Vector3D;
	
	/**
	 * 模型信息
	 * @author warden_feng 2014-6-26
	 */
	public class Model
	{
		/** 模型名称 */
		public var name:String;
		/** 混合时间 */
		public var BlendTime:int;
		/** 最小范围 */
		public var MinimumExtent:Vector3D;
		/** 最大范围 */
		public var MaximumExtent:Vector3D;
	}
}