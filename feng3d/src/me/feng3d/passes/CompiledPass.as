package me.feng3d.passes
{

	import flash.geom.Matrix3D;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.core.buffer.context3d.VCMatrixBuffer;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.events.ShadingMethodEvent;
	import me.feng3d.materials.methods.BasicAmbientMethod;
	import me.feng3d.materials.methods.BasicDiffuseMethod;
	import me.feng3d.materials.methods.BasicNormalMethod;
	import me.feng3d.materials.methods.BasicSpecularMethod;
	import me.feng3d.materials.methods.ShaderMethodSetup;
	import me.feng3d.materials.methods.ShadowMapMethodBase;
	import me.feng3d.textures.TextureProxyBase;

	use namespace arcane;

	/**
	 * 编译通道
	 * <p>用于处理复杂的渲染通道</p>
	 * @author feng 2014-6-5
	 */
	public class CompiledPass extends MaterialPassBase
	{
		arcane var _passes:Vector.<MaterialPassBase>;

		/**
		 * 物体投影变换矩阵（模型空间坐标-->GPU空间坐标）
		 */
		protected const modelViewProjection:Matrix3D = new Matrix3D();

		/**
		 * 法线场景变换矩阵（模型空间坐标-->世界空间坐标）
		 */
		protected const normalSceneMatrix:Matrix3D = new Matrix3D();

		/**
		 * 场景变换矩阵（模型空间坐标-->世界空间坐标）
		 */
		protected const sceneTransformMatrix:Matrix3D = new Matrix3D();

		/**
		 * 世界投影矩阵（世界空间坐标-->投影空间坐标）
		 */
		protected const worldProjectionMatrix:Matrix3D = new Matrix3D();

		protected var _ambientLightR:Number;
		protected var _ambientLightG:Number;
		protected var _ambientLightB:Number;

		/**
		 * 通用数据
		 */
		protected const commonsData:Vector.<Number> = Vector.<Number>([0.5, 0, 1 / 255, 1]);

		/**
		 * 摄像机世界坐标
		 */
		protected const cameraPosition:Vector.<Number> = new Vector.<Number>(4);

		/**
		 * 是否开启灯光衰减
		 */
		protected var _enableLightFallOff:Boolean = true;

		/**
		 * 创建一个编译通道类
		 */
		public function CompiledPass()
		{
			init();
		}

		/**
		 * 初始化
		 */
		private function init():void
		{
			_methodSetup = new ShaderMethodSetup();
			_methodSetup.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			addChildBufferOwner(_methodSetup);
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(_.commonsData_fc_vector, updateCommonsDataBuffer);
			mapContext3DBuffer(_.cameraPosition_vc_vector, updateCameraPositionBuffer);
			mapContext3DBuffer(_.projection_vc_matrix, updateProjectionBuffer);
			mapContext3DBuffer(_.normalSceneTransform_vc_matrix, updateSceneNormalMatrixBuffer);
			mapContext3DBuffer(_.sceneTransform_vc_matrix, updateSceneTransformMatrixBuffer);
			mapContext3DBuffer(_.wordProjection_vc_matrix, updateWordProjectionMatrixBuffer);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function activate(camera:Camera3D, target:TextureProxyBase = null):void
		{
			super.activate(camera, target);

			shaderParams.useLightFallOff = _enableLightFallOff;

			_methodSetup.activate(shaderParams);

			_ambientLightR = _ambientLightG = _ambientLightB = 0;
			if (usesLights())
				updateLightConstants();

			var ambientMethod:BasicAmbientMethod = _methodSetup.ambientMethod;
			ambientMethod._lightAmbientR = _ambientLightR;
			ambientMethod._lightAmbientG = _ambientLightG;
			ambientMethod._lightAmbientB = _ambientLightB;
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateConstantData(renderable:IRenderable, camera:Camera3D):void
		{
			super.updateConstantData(renderable, camera);

			//场景变换矩阵（物体坐标-->世界坐标）
			var sceneTransform:Matrix3D = renderable.sourceEntity.getRenderSceneTransform(camera);
			//投影矩阵（世界坐标-->投影坐标）
			var projectionmatrix:Matrix3D = camera.viewProjection;

			//全局变换矩阵
			sceneTransformMatrix.copyFrom(sceneTransform);

			//投影矩阵
			worldProjectionMatrix.copyFrom(projectionmatrix);

			//法线全局变换矩阵
			normalSceneMatrix.copyFrom(sceneTransform);

			//物体投影变换矩阵
			modelViewProjection.identity();
			modelViewProjection.append(sceneTransform);
			modelViewProjection.append(projectionmatrix);

			//摄像机世界坐标
			cameraPosition[0] = camera.scenePosition.x;
			cameraPosition[1] = camera.scenePosition.y;
			cameraPosition[2] = camera.scenePosition.z;
			cameraPosition[3] = 1;

			_methodSetup.setRenderState(renderable, camera);
		}

		/**
		 * 更新摄像机坐标缓冲
		 * @param cameraPositionBuffer		摄像机坐标缓冲
		 */
		protected function updateCameraPositionBuffer(cameraPositionBuffer:VCVectorBuffer):void
		{
			cameraPositionBuffer.update(cameraPosition);
		}

		/**
		 * 更新通用缓冲
		 * @param commonsDataBuffer		通用缓冲
		 */
		protected function updateCommonsDataBuffer(commonsDataBuffer:FCVectorBuffer):void
		{
			commonsDataBuffer.update(commonsData);
		}

		/**
		 * 更新投影矩阵缓冲
		 * @param projectionBuffer		投影矩阵缓冲
		 */
		protected function updateProjectionBuffer(projectionBuffer:VCMatrixBuffer):void
		{
			projectionBuffer.update(modelViewProjection, true);
		}

		/**
		 * 更新摄像机投影矩阵缓冲
		 * @param cameraProjectionMatrixBuffer		摄像机投影矩阵缓冲
		 */
		protected function updateWordProjectionMatrixBuffer(worldProjectionMatrixBuffer:VCMatrixBuffer):void
		{
			worldProjectionMatrixBuffer.update(worldProjectionMatrix, true);
		}

		/**
		 * 更新场景变换矩阵缓冲
		 * @param sceneTransformMatrixBuffer		场景变换矩阵缓冲
		 */
		protected function updateSceneTransformMatrixBuffer(sceneTransformMatrixBuffer:VCMatrixBuffer):void
		{
			sceneTransformMatrixBuffer.update(sceneTransformMatrix, true);
		}

		/**
		 * 更新法线场景变换矩阵缓冲
		 * @param normalSceneMatrixBuffer			法线场景变换矩阵缓冲
		 */
		protected function updateSceneNormalMatrixBuffer(normalSceneMatrixBuffer:VCMatrixBuffer):void
		{
			normalSceneMatrixBuffer.update(normalSceneMatrix, true);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function updateProgramBuffer(programBuffer:ProgramBuffer):void
		{
			reset();
			super.updateProgramBuffer(programBuffer);
		}

		/**
		 * 重置编译通道
		 */
		private function reset():void
		{
			initConstantData();
		}

		/**
		 * 初始化常量数据
		 */
		private function initConstantData():void
		{
			updateMethodConstants();
		}

		/**
		 * 更新函数常量数据
		 */
		protected function updateMethodConstants():void
		{
			_methodSetup.initConstants();
		}

		/**
		 * 漫反射方法，默认为BasicDiffuseMethod
		 */
		public function get diffuseMethod():BasicDiffuseMethod
		{
			return _methodSetup.diffuseMethod;
		}

		public function set diffuseMethod(value:BasicDiffuseMethod):void
		{
			_methodSetup.diffuseMethod = value;
		}

		/**
		 * 镜面反射方法，默认为BasicSpecularMethod
		 */
		public function get specularMethod():BasicSpecularMethod
		{
			return _methodSetup.specularMethod;
		}

		public function set specularMethod(value:BasicSpecularMethod):void
		{
			_methodSetup.specularMethod = value;
		}

		/**
		 * 环境光方法，默认为BasicAmbientMethod
		 */
		public function get ambientMethod():BasicAmbientMethod
		{
			return _methodSetup.ambientMethod;
		}

		public function set ambientMethod(value:BasicAmbientMethod):void
		{
			_methodSetup.ambientMethod = value;
		}

		/**
		 * 法线函数，默认为BasicNormalMethod
		 */
		public function get normalMethod():BasicNormalMethod
		{
			return _methodSetup.normalMethod;
		}

		public function set normalMethod(value:BasicNormalMethod):void
		{
			_methodSetup.normalMethod = value;
		}

		/**
		 * 是否开启灯光衰减，可以提高灯光渲染性能与真实性
		 */
		public function get enableLightFallOff():Boolean
		{
			return _enableLightFallOff;
		}

		public function set enableLightFallOff(value:Boolean):void
		{
			if (value != _enableLightFallOff)
				invalidateShaderProgram();
			_enableLightFallOff = value;
		}

		/**
		 * 处理渲染失效事件
		 */
		private function onShaderInvalidated(event:ShadingMethodEvent):void
		{
			var oldPasses:Vector.<MaterialPassBase> = _passes;
			_passes = new Vector.<MaterialPassBase>();

			if (_methodSetup)
				addPassesFromMethods();



			invalidateShaderProgram();
		}

		/**
		 * Adds any possible passes needed by the used methods.
		 */
		protected function addPassesFromMethods():void
		{
			if (_methodSetup.normalMethod && _methodSetup.normalMethod.hasOutput)
				addPasses(_methodSetup.normalMethod.passes);
			if (_methodSetup.ambientMethod)
				addPasses(_methodSetup.ambientMethod.passes);
			if (_methodSetup.shadowMethod)
				addPasses(_methodSetup.shadowMethod.passes);
			if (_methodSetup.diffuseMethod)
				addPasses(_methodSetup.diffuseMethod.passes);
			if (_methodSetup.specularMethod)
				addPasses(_methodSetup.specularMethod.passes);
		}

		/**
		 * Adds internal passes to the material.
		 *
		 * @param passes The passes to add.
		 */
		protected function addPasses(passes:Vector.<MaterialPassBase>):void
		{
			if (!passes)
				return;

			var len:uint = passes.length;

			for (var i:uint = 0; i < len; ++i)
			{
				passes[i].material = material;
				passes[i].lightPicker = _lightPicker;
				_passes.push(passes[i]);
			}
		}

		/**
		 * 更新灯光常数数据
		 */
		protected function updateLightConstants():void
		{
		}

		/**
		 * 阴影映射函数
		 */
		public function get shadowMethod():ShadowMapMethodBase
		{
			return _methodSetup.shadowMethod;
		}

		public function set shadowMethod(value:ShadowMapMethodBase):void
		{
			_methodSetup.shadowMethod = value;
		}
	}
}
