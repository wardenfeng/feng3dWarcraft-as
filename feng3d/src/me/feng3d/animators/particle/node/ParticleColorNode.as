package me.feng3d.animators.particle.node
{
	import flash.geom.ColorTransform;

	import me.feng3d.arcane;
	import me.feng3d.animators.particle.ParticleAnimationSet;
	import me.feng3d.animators.particle.data.ParticleProperties;
	import me.feng3d.animators.particle.data.ParticlePropertiesMode;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.fagal.params.ShaderParams;

	use namespace arcane;

	/**
	 * 粒子颜色节点
	 * @author feng 2015-1-20
	 */
	public class ParticleColorNode extends ParticleNodeBase
	{
		/** 是否使用Multiplier数据对渲染中颜色进行变换 */
		private var _usesMultiplier:Boolean;
		/** 是否使用offset数据对渲染中颜色进行变换 */
		private var _usesOffset:Boolean;
		/** 开始颜色数据 */
		private var _startColor:ColorTransform;
		/** 结束颜色数据 */
		private var _endColor:ColorTransform;

		private var _startMultiplierData:Vector.<Number>;
		private var _deltaMultiplierData:Vector.<Number>;
		private var _startOffsetData:Vector.<Number>;
		private var _deltaOffsetData:Vector.<Number>;

		/**
		 * 开始颜色属性
		 */
		public static const COLOR_START_COLORTRANSFORM:String = "ColorStartColorTransform";

		/**
		 * 结束颜色属性
		 */
		public static const COLOR_END_COLORTRANSFORM:String = "ColorEndColorTransform";

		/**
		 * 创建一个粒子颜色节点
		 * @param mode					属性模式
		 * @param usesMultiplier		是否使用Multiplier数据对渲染中颜色进行变换
		 * @param usesOffset			是否使用offset数据对渲染中颜色进行变换
		 * @param usesCycle
		 * @param usesPhase
		 * @param startColor			开始颜色数据
		 * @param endColor				结束颜色数据
		 * @param cycleDuration
		 * @param cyclePhase
		 */
		public function ParticleColorNode(mode:uint, usesMultiplier:Boolean = true, usesOffset:Boolean = true, usesCycle:Boolean = false, usesPhase:Boolean = false, startColor:ColorTransform = null, endColor:ColorTransform = null, cycleDuration:Number = 1, cyclePhase:Number = 0)
		{
			_usesMultiplier = usesMultiplier;
			_usesOffset = usesOffset;

			_startColor = startColor || new ColorTransform();
			_endColor = endColor || new ColorTransform();

			super("ParticleColor", mode, (_usesMultiplier && _usesOffset) ? 16 : 8, ParticleAnimationSet.COLOR_PRIORITY);

			updateColorData();
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();

			if (mode == ParticlePropertiesMode.GLOBAL)
			{
				mapContext3DBuffer(_.particleStartColorMultiplier_vc_vector, updateStartColorMultiplierConstBuffer);
				mapContext3DBuffer(_.particleDeltaColorMultiplier_vc_vector, updateDeltaColorMultiplierConstBuffer);

				mapContext3DBuffer(_.particleStartColorOffset_vc_vector, updateStartColorOffsetConstBuffer);
				mapContext3DBuffer(_.particleDeltaColorOffset_vc_vector, updateDeltaColorOffsetConstBuffer);
			}
		}

		private function updateStartColorMultiplierConstBuffer(vcVectorBuffer:VCVectorBuffer):void
		{
			vcVectorBuffer.update(_startMultiplierData);
		}

		private function updateDeltaColorMultiplierConstBuffer(vcVectorBuffer:VCVectorBuffer):void
		{
			vcVectorBuffer.update(_deltaMultiplierData);
		}

		private function updateStartColorOffsetConstBuffer(vcVectorBuffer:VCVectorBuffer):void
		{
			vcVectorBuffer.update(_startOffsetData);
		}

		private function updateDeltaColorOffsetConstBuffer(vcVectorBuffer:VCVectorBuffer):void
		{
			vcVectorBuffer.update(_deltaOffsetData);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function generatePropertyOfOneParticle(param:ParticleProperties):void
		{
			var startColor:ColorTransform = param[COLOR_START_COLORTRANSFORM];
			if (!startColor)
				throw(new Error("there is no " + COLOR_START_COLORTRANSFORM + " in param!"));

			var endColor:ColorTransform = param[COLOR_END_COLORTRANSFORM];
			if (!endColor)
				throw(new Error("there is no " + COLOR_END_COLORTRANSFORM + " in param!"));

			var i:uint;

			//multiplier
			if (_usesMultiplier)
			{
				_oneData[i++] = startColor.redMultiplier;
				_oneData[i++] = startColor.greenMultiplier;
				_oneData[i++] = startColor.blueMultiplier;
				_oneData[i++] = startColor.alphaMultiplier;
				_oneData[i++] = endColor.redMultiplier - startColor.redMultiplier;
				_oneData[i++] = endColor.greenMultiplier - startColor.greenMultiplier;
				_oneData[i++] = endColor.blueMultiplier - startColor.blueMultiplier;
				_oneData[i++] = endColor.alphaMultiplier - startColor.alphaMultiplier;
			}

			//offset
			if (_usesOffset)
			{
				_oneData[i++] = startColor.redOffset / 255;
				_oneData[i++] = startColor.greenOffset / 255;
				_oneData[i++] = startColor.blueOffset / 255;
				_oneData[i++] = startColor.alphaOffset / 255;
				_oneData[i++] = (endColor.redOffset - startColor.redOffset) / 255;
				_oneData[i++] = (endColor.greenOffset - startColor.greenOffset) / 255;
				_oneData[i++] = (endColor.blueOffset - startColor.blueOffset) / 255;
				_oneData[i++] = (endColor.alphaOffset - startColor.alphaOffset) / 255;
			}
		}

		/**
		 * 更新颜色数据
		 */
		private function updateColorData():void
		{
			if (mode == ParticlePropertiesMode.GLOBAL)
			{
				if (_usesMultiplier)
				{
					_startMultiplierData = Vector.<Number>([_startColor.redMultiplier, _startColor.greenMultiplier, _startColor.blueMultiplier, _startColor.alphaMultiplier]);
					_deltaMultiplierData = Vector.<Number>([(_endColor.redMultiplier - _startColor.redMultiplier), (_endColor.greenMultiplier - _startColor.greenMultiplier), (_endColor.blueMultiplier - _startColor.blueMultiplier), (_endColor.alphaMultiplier - _startColor.alphaMultiplier)]);
				}

				if (_usesOffset)
				{
					_startOffsetData = Vector.<Number>([_startColor.redOffset / 255, _startColor.greenOffset / 255, _startColor.blueOffset / 255, _startColor.alphaOffset / 255]);
					_deltaOffsetData = Vector.<Number>([(_endColor.redOffset - _startColor.redOffset) / 255, (_endColor.greenOffset - _startColor.greenOffset) / 255, (_endColor.blueOffset - _startColor.blueOffset) / 255, (_endColor.alphaOffset - _startColor.alphaOffset) / 255]);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override arcane function processAnimationSetting(shaderParam:ShaderParams):void
		{
			shaderParam.changeColor++;
			shaderParam[name] = true;
		}
	}
}
