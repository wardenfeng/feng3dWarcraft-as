package me.feng3d.passes
{
	import flash.display3D.Context3DWrapMode;
	import flash.geom.Matrix3D;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.buffer.War3Context3DBufferTypeID;
	import me.feng3d.core.buffer.context3d.FSArrayBuffer;
	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.core.buffer.context3d.VCMatrixBuffer;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.fagal.fragment.F_War3Terrain;
	import me.feng3d.fagal.vertex.V_War3Terrain;
	import me.feng3d.fagalRE.FagalRE;
	import me.feng3d.fagalRE.FagalShaderResult;
	import me.feng3d.textures.Texture2DBase;
	import me.feng3d.textures.TextureProxyBase;

	use namespace arcane;

	/**
	 * 魔兽争霸地形通道
	 * @author warden_feng 2014-8-1
	 */
	public class War3TerrainPass extends MaterialPassBase
	{
		private var modelViewProjection:Matrix3D = new Matrix3D();

		private var _blendingTexture:Texture2DBase;
		private var _splats:Array;
		private var _numSplattingLayers:uint;

		public function War3TerrainPass(layerNum:int = 4)
		{
			super();
			_numSplattingLayers = layerNum;
		}


		public function get splats():Array
		{
			return _splats;
		}

		public function set splats(value:Array):void
		{
			_splats = value;
			_numSplattingLayers = _splats.length;
			if (_numSplattingLayers > 4)
				throw new Error("More than 4 splatting layers is not supported!");

			markBufferDirty(War3Context3DBufferTypeID.WAR3TERRAINTEXTURE_FS_ARRAY);
		}

		override protected function initBuffers():void
		{
			super.initBuffers();

			mapContext3DBuffer(_.war3TerrainTexture_fs_array, updateWar3terraintextureBuffer);
			mapContext3DBuffer(_.projection_vc_matrix, updateProjectionBuffer);
		}

		protected function updateWar3terraintextureBuffer(terrainTextureBufferArr:FSArrayBuffer):void
		{
			terrainTextureBufferArr.update(splats);
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

			super.render(renderable,stage3DProxy,camera,renderIndex);
		}

		override arcane function activate(camera:Camera3D, target:TextureProxyBase = null):void
		{
			super.activate(camera,target);

			shaderParams.splatNum_war3Terrain = _numSplattingLayers;
			shaderParams.addSampleFlags(War3Context3DBufferTypeID.WAR3TERRAINTEXTURE_FS_ARRAY, splats[0], Context3DWrapMode.CLAMP);
		}
	}
}


