package me.feng3d.parsers.mdl
{
	import me.feng3d.core.math.Quaternion;

	/**
	 *
	 * @author warden_feng 2014-6-26
	 */
	public class Rotation
	{
		/** 时间 */
		public var time:int;
		/**  */
		public var value:Quaternion;

		public var InTan:Quaternion;

		public var OutTan:Quaternion;
	}
}
