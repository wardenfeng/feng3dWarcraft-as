package me.feng3d.animators.base.node
{
	import flash.geom.Vector3D;

	/**
	 * 动画剪辑节点基类(用于控制动画播放，包含每帧持续时间，是否循环播放等)
	 * @author feng 2014-5-20
	 */
	public class AnimationClipNodeBase extends AnimationNodeBase
	{
		protected var _looping:Boolean = true;
		protected var _totalDuration:uint = 0;
		protected var _lastFrame:uint;

		protected var _stitchDirty:Boolean = true;
		protected var _stitchFinalFrame:Boolean = false;
		protected var _numFrames:uint = 0;

		protected var _durations:Vector.<uint> = new Vector.<uint>();
		protected var _totalDelta:Vector3D = new Vector3D();

		/** 是否稳定帧率 */
		public var fixedFrameRate:Boolean = true;

		/**
		 * 创建一个动画剪辑节点基类
		 */
		public function AnimationClipNodeBase()
		{
			super();
		}

		/**
		 * 持续时间列表（ms）
		 */
		public function get durations():Vector.<uint>
		{
			return _durations;
		}

		/**
		 * 总坐标偏移量
		 */
		public function get totalDelta():Vector3D
		{
			if (_stitchDirty)
				updateStitch();

			return _totalDelta;
		}

		/**
		 * 是否循环播放
		 */
		public function get looping():Boolean
		{
			return _looping;
		}

		public function set looping(value:Boolean):void
		{
			if (_looping == value)
				return;

			_looping = value;

			_stitchDirty = true;
		}

		/**
		 * 是否过渡结束帧
		 */
		public function get stitchFinalFrame():Boolean
		{
			return _stitchFinalFrame;
		}

		public function set stitchFinalFrame(value:Boolean):void
		{
			if (_stitchFinalFrame == value)
				return;

			_stitchFinalFrame = value;

			_stitchDirty = true;
		}

		/**
		 * 总持续时间
		 */
		public function get totalDuration():uint
		{
			if (_stitchDirty)
				updateStitch();

			return _totalDuration;
		}

		/**
		 * 最后帧数
		 */
		public function get lastFrame():uint
		{
			if (_stitchDirty)
				updateStitch();

			return _lastFrame;
		}

		/**
		 * 更新动画播放控制状态
		 */
		protected function updateStitch():void
		{
			_stitchDirty = false;

			_lastFrame = (_looping && _stitchFinalFrame) ? _numFrames : _numFrames - 1;

			_totalDuration = 0;
			_totalDelta.x = 0;
			_totalDelta.y = 0;
			_totalDelta.z = 0;
		}
	}
}
