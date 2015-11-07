package me.feng3d.events
{
	import me.feng.events.FEvent;

	/**
	 * 动画事件
	 * @author feng 2014-5-27
	 */
	public class AnimatorEvent extends FEvent
	{
		/** 开始播放动画 */
		public static const START:String = "start";

		/** 继续播放动画 */
		public static const PLAY:String = "play";

		/** 停止播放动画 */
		public static const STOP:String = "stop";

		/** 周期完成 */
		public static const CYCLE_COMPLETE:String = "cycle_complete";

		/**
		 * 创建一个动画时间
		 * @param type			事件类型
		 * @param data			事件数据
		 * @param bubbles		是否冒泡
		 */
		public function AnimatorEvent(type:String, data:* = null, bubbles:Boolean = false)
		{
			super(type, data, bubbles);
		}
	}
}
