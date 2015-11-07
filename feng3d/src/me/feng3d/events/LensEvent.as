package me.feng3d.events
{
	import me.feng.events.FEvent;
	import me.feng3d.cameras.lenses.LensBase;

	/**
	 * 镜头事件
	 * @author feng 2014-10-14
	 */
	public class LensEvent extends FEvent
	{
		public static const MATRIX_CHANGED:String = "matrixChanged";

		public function LensEvent(type:String, lens:LensBase = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}

		public function get lens():LensBase
		{
			return data as LensBase;
		}
	}
}
