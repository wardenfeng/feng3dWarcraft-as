package me.feng3d.passes
{
	import flash.geom.Matrix3D;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.core.buffer.context3d.VCMatrixBuffer;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.fagal.fragment.F_War3Terrain;
	import me.feng3d.fagal.params.WarcraftShaderParams;
	import me.feng3d.fagal.vertex.V_War3Terrain;
	import me.feng3d.fagalRE.FagalRE;
	import me.feng3d.fagalRE.FagalShaderResult;
	import me.feng3d.textures.TextureProxyBase;
	import me.feng3d.textures.War3BitmapTexture;

	use namespace arcane;

	/**
	 * 魔兽争霸地形通道
	 * @author feng 2016-3-15
	 */
	public class War3TerrainPass1 extends MaterialPassBase
	{
		private var modelViewProjection:Matrix3D = new Matrix3D();

		private var war3BitmapTexture:War3BitmapTexture;

		public function War3TerrainPass1()
		{
			super();
		}

		override protected function initBuffers():void
		{
			super.initBuffers();

			context3DBufferOwner.mapContext3DBuffer(_.projection_vc_matrix, updateProjectionBuffer);
		}

		/** 设置投影矩阵 */
		private function updateProjectionBuffer(projectionBuffer:VCMatrixBuffer):void
		{
			projectionBuffer.update(modelViewProjection, true);
		}

		override arcane function updateProgramBuffer(programBuffer:ProgramBuffer):void
		{
			var result:FagalShaderResult = FagalRE.runShader(V_War3Terrain, F_War3Terrain);

			//上传程序
			programBuffer.update(result.vertexCode, result.fragmentCode);
		}

		override arcane function render(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, renderIndex:int):void
		{
			modelViewProjection.identity();
			modelViewProjection.append(renderable.sourceEntity.sceneTransform);
			modelViewProjection.append(camera.viewProjection);

			super.render(renderable, stage3DProxy, camera, renderIndex);
		}

		override arcane function activate(camera:Camera3D, target:TextureProxyBase = null):void
		{
			super.activate(camera, target);

			var warcraftShaderParams:WarcraftShaderParams = shaderParams.getOrCreateComponentByClass(WarcraftShaderParams);

		}
	}
}


