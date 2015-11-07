package me.feng3d.entities
{
	import me.feng3d.arcane;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.core.partition.node.EntityNode;
	import me.feng3d.core.partition.node.SkyBoxNode;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.materials.SkyBoxMaterial;
	import me.feng3d.textures.CubeTextureBase;

	use namespace arcane;

	/**
	 * 天空盒类用于渲染的场景中的天空。
	 * 总是被认为是静态的,在无穷远处,并且总是集中在相机的位置和大小符合在相机的视锥体,
	 * 确保天空盒总是尽可能大而不被裁剪。
	 * @author feng 2014-7-11
	 */
	public class SkyBox extends Mesh
	{
		private var subGeometry:SubGeometry;

		/**
		 * 创建天空盒实例
		 * @param cubeMap		立方体贴图
		 */
		public function SkyBox(cubeMap:CubeTextureBase)
		{
			super();
			material = new SkyBoxMaterial(cubeMap);

			subGeometry = new SubGeometry();
			geometry.addSubGeometry(subGeometry);

			buildGeometry();
		}

		/**
		 * 创建天空盒 顶点与索引数据
		 */
		private function buildGeometry():void
		{
			subGeometry.numVertices = 8;
			//八个顶点，32个number
			var vertexData:Vector.<Number> = new <Number>[ //
				-1, 1, -1, 1, 1, -1, //
				1, 1, 1, -1, 1, 1, //
				-1, -1, -1, 1, -1, -1, //
				1, -1, 1, -1, -1, 1 //
				];
			subGeometry.updateVertexPositionData(vertexData);

			//6个面，12个三角形，36个顶点索引
			var indexData:Vector.<uint> = new <uint>[ //
				0, 1, 2, 2, 3, 0, //
				6, 5, 4, 4, 7, 6, //
				2, 6, 7, 7, 3, 2, //
				4, 5, 1, 1, 0, 4, //
				4, 0, 3, 3, 7, 4, //
				2, 1, 5, 5, 6, 2 //
				];

			subGeometry.updateIndexData(indexData);
		}

		/**
		 * @inheritDoc
		 */
		override protected function createEntityPartitionNode():EntityNode
		{
			return new SkyBoxNode(this);
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateBounds():void
		{
			_boundsInvalid = false;
		}

		/**
		 * 天空盒不会投射阴影，始终为false
		 */
		override public function get castsShadows():Boolean
		{
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public override function get assetType():String
		{
			return AssetType.SKYBOX;
		}
	}
}
