package me.feng3d.animators.war3.nodes
{
	import me.feng3d.animators.skeleton.SkeletonClipNode;
	
	/**
	 *
	 * @author warden_feng 2014-6-28
	 */
	public class SkeletonClipNodeWar3 extends SkeletonClipNode
	{
		public function SkeletonClipNodeWar3()
		{
			super();
		}

		override protected function updateStitch():void
		{
			_stitchDirty = false;

//			_lastFrame = (_looping && _stitchFinalFrame) ? _numFrames : _numFrames - 1;

			_totalDuration = 500;
			_totalDelta.x = 0;
			_totalDelta.y = 0;
			_totalDelta.z = 0;
		}
	}
}
