package me.feng3d.animators.skeleton
{
	import me.feng3d.arcane;
	import me.feng3d.animators.AnimationType;
	import me.feng3d.animators.IAnimationSet;
	import me.feng3d.animators.base.AnimationSetBase;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.passes.MaterialPassBase;

	use namespace arcane;

	/**
	 * 骨骼动画集合
	 * @author feng 2014-5-20
	 */
	public class SkeletonAnimationSet extends AnimationSetBase implements IAnimationSet
	{
		private var _jointsPerVertex:uint;

		private var _numJoints:uint;

		/**
		 * 创建一个骨骼动画集合
		 * @param jointsPerVertex 每个顶点关联关节的数量
		 */
		public function SkeletonAnimationSet(jointsPerVertex:uint = 4)
		{
			_jointsPerVertex = jointsPerVertex;
		}

		/**
		 * 每个顶点关联关节的数量
		 */
		public function get jointsPerVertex():uint
		{
			return _jointsPerVertex;
		}

		/**
		 * @inheritDoc
		 */
		override public function activate(shaderParams:ShaderParams, pass:MaterialPassBase):void
		{
			shaderParams.numJoints = _numJoints;
			shaderParams.jointsPerVertex = _jointsPerVertex;

			if (usesCPU)
				shaderParams.animationType = AnimationType.SKELETON_CPU;
			else
				shaderParams.animationType = AnimationType.SKELETON_GPU;
		}

		/**
		 * 设置关节数量
		 */
		public function set numJoints(value:uint):void
		{
			_numJoints = value;
		}
	}
}
