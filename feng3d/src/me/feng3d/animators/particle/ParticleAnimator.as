package me.feng3d.animators.particle
{
	import me.feng3d.arcane;
	import me.feng3d.animators.IAnimator;
	import me.feng3d.animators.base.AnimatorBase;
	import me.feng3d.animators.base.data.AnimationSubGeometry;
	import me.feng3d.animators.particle.states.ParticleStateBase;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.base.submesh.SubMesh;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;

	use namespace arcane;

	/**
	 * 粒子动画
	 * @author feng 2014-11-13
	 */
	public class ParticleAnimator extends AnimatorBase implements IAnimator
	{
		private var _particleAnimationSet:ParticleAnimationSet;

		private var _animationParticleStates:Vector.<ParticleStateBase> = new Vector.<ParticleStateBase>;
		private var _timeParticleStates:Vector.<ParticleStateBase> = new Vector.<ParticleStateBase>;

		/** 常量数据 */
		private const vertexZeroConst:Vector.<Number> = Vector.<Number>([0, 1, 2, 0]);

		/** 时间常数（粒子当前时间） */
		private const timeConstData:Vector.<Number> = new Vector.<Number>(4);

		/**
		 * 创建粒子动画
		 * @param particleAnimationSet 粒子动画集合
		 */
		public function ParticleAnimator(particleAnimationSet:ParticleAnimationSet)
		{
			super(particleAnimationSet);
			_particleAnimationSet = particleAnimationSet;

			addChildBufferOwner(_particleAnimationSet);

//			var state:ParticleStateBase;
//			var node:ParticleNodeBase;
//			for each (node in _particleAnimationSet.particleNodes)
//			{
//				state = getAnimationState(node) as ParticleStateBase;
//				_animationParticleStates.push(state);
//				if (state.needUpdateTime)
//					_timeParticleStates.push(state);
//			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(_.particleCommon_vc_vector, updateParticleConstDataBuffer);
			mapContext3DBuffer(_.particleTime_vc_vector, updateTimeConstBuffer);
		}

		private function updateTimeConstBuffer(timeConstBuffer:VCVectorBuffer):void
		{
			timeConstBuffer.update(timeConstData);
		}

		private function updateParticleConstDataBuffer(particleConstDataBuffer:VCVectorBuffer):void
		{
			particleConstDataBuffer.update(vertexZeroConst);
		}

		/**
		 * @inheritDoc
		 */
		public function setRenderState(renderable:IRenderable, camera:Camera3D):void
		{
			var subMesh:SubMesh = renderable as SubMesh;

			if (!subMesh)
				throw(new Error("Must be subMesh"));

			if (!subMesh.animationSubGeometry)
				_particleAnimationSet.generateAnimationSubGeometries(subMesh.parentMesh);

			var animationSubGeometry:AnimationSubGeometry = subMesh.animationSubGeometry;

			timeConstData[0] = timeConstData[1] = timeConstData[2] = timeConstData[3] = time / 1000;

			_particleAnimationSet.setRenderState(renderable, camera)
		}

		/**
		 * @inheritDoc
		 */
		override public function start():void
		{
			super.start();
			for each (var state:ParticleStateBase in _timeParticleStates)
				state.offset(_absoluteTime);
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateDeltaTime(dt:Number):void
		{
			_absoluteTime += dt;

			for each (var state:ParticleStateBase in _timeParticleStates)
				state.update(_absoluteTime);
		}

	}
}
