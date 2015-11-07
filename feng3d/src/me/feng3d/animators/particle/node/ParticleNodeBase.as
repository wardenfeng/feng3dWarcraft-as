package me.feng3d.animators.particle.node
{
	import me.feng.error.AbstractClassError;
	import me.feng.error.AbstractMethodError;
	import me.feng3d.arcane;
	import me.feng3d.animators.base.node.AnimationNodeBase;
	import me.feng3d.animators.particle.data.ParticleProperties;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.fagal.params.ShaderParams;

	use namespace arcane;

	/**
	 * 粒子节点
	 * @author feng 2014-11-13
	 */
	public class ParticleNodeBase extends AnimationNodeBase
	{
		/** 模式列表 */
		private static var MODES:Object = { //
				0: GLOBAL, //
				1: LOCAL_STATIC, //
				2: LOCAL_DYNAMIC //
			};

		//模式名称
		private static var GLOBAL:String = 'Global';
		private static var LOCAL_STATIC:String = 'LocalStatic';
		private static var LOCAL_DYNAMIC:String = 'LocalDynamic';

		protected var _mode:uint;
		private var _priority:int;

		protected var _dataLength:uint = 3;
		protected var _oneData:Vector.<Number>;

		/**
		 * 顶点数据编号
		 */
		public function get vaId():String
		{
			throw new AbstractMethodError();
		}

		/**
		 * 顶点数据长度
		 */
		public function get vaLen():uint
		{
			throw new AbstractMethodError();
		}

		/**
		 * 创建一个粒子节点
		 * @param animationName		节点名称
		 * @param mode				模式
		 * @param dataLength		数据长度
		 * @param priority			优先级
		 */
		public function ParticleNodeBase(animationName:String, mode:uint, dataLength:uint, priority:int = 1)
		{
			name = animationName + MODES[mode];

			_mode = mode;
			_priority = priority;
			_dataLength = dataLength;

			_oneData = new Vector.<Number>(_dataLength, true);

			super();

			AbstractClassError.check(this);
		}

		/**
		 * 优先级
		 */
		public function get priority():int
		{
			return _priority;
		}

		/**
		 * 数据长度
		 */
		public function get dataLength():int
		{
			return _dataLength;
		}

		/**
		 * 单个粒子数据
		 */
		public function get oneData():Vector.<Number>
		{
			return _oneData;
		}

		/**
		 * 粒子属性模式
		 */
		public function get mode():uint
		{
			return _mode;
		}

		/**
		 * 创建单个粒子属性
		 */
		arcane function generatePropertyOfOneParticle(param:ParticleProperties):void
		{

		}

		/**
		 * 设置粒子渲染参数
		 * @param particleShaderParam 粒子渲染参数
		 */
		arcane function processAnimationSetting(shaderParam:ShaderParams):void
		{
			throw new Error("必须设置对应的渲染参数");
		}

		/**
		 * 设置渲染状态
		 * @param stage3DProxy			显卡代理
		 * @param renderable			渲染实体
		 * @param camera				摄像机
		 */
		public function setRenderState(renderable:IRenderable, camera:Camera3D):void
		{

		}

	}
}
