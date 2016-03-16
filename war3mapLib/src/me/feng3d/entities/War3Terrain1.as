package me.feng3d.entities
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import me.feng3d.core.base.subgeometry.War3TerrainSubGeometry;
	import me.feng3d.materials.War3TerrainMaterial1;
	import me.feng3d.textures.War3BitmapTexture;
	import me.feng3d.war3.map.w3e.W3eData;
	import me.feng3d.war3.map.w3e.W3eTilePoint;

	/**
	 * war3地形模块
	 * @author warden_feng 2014-7-21
	 */
	public class War3Terrain1 extends Mesh
	{
		private static const TILE_SIZE:int = 64;

		private var _w3eData:W3eData;
		private var _war3BitmapTexture:War3BitmapTexture;

		private var tilepoints:Vector.<W3eTilePoint>

		private var _segmentsW:uint;
		private var _segmentsH:uint;

		private var _width:Number;
		private var _depth:Number;

		/**
		 * 数据缓冲
		 */
		private var _subGeometry:War3TerrainSubGeometry;

		public function War3Terrain1(w3eData:W3eData, war3BitmapTexture:War3BitmapTexture)
		{
			super();

			_w3eData = w3eData;
			_war3BitmapTexture = war3BitmapTexture;

			_segmentsW = _w3eData._mapWidth;
			_segmentsH = _w3eData._mapHeight;
			_width = _segmentsW * TILE_SIZE;
			_depth = _segmentsH * TILE_SIZE;

			tilepoints = _w3eData.tilepoints;

			buildGeometry();
			material = new War3TerrainMaterial1(_war3BitmapTexture);

			transform3D.x = -_segmentsW * .5 * TILE_SIZE;
			transform3D.z = - _segmentsH * .5 * TILE_SIZE;
		}

		/**
		 * 创建顶点坐标
		 */
		private function buildGeometry():void
		{
			_subGeometry = new War3TerrainSubGeometry();
			geometry.addSubGeometry(_subGeometry);

			var s:Number = 0.1;

			var x:Number, z:Number;
			//一排顶点数据
			var tw:uint = _segmentsW + 1;
			//总顶点数量
			var numVerts:uint = _segmentsH * _segmentsW * 4;
			//格子数
			var numTile:uint = _segmentsH * _segmentsW;

			var war3TerrainTile:War3TerrainTile;

			var vertices:Vector.<Number> = new Vector.<Number>();
			var indices:Vector.<uint> = new Vector.<uint>();

			//贴图u坐标
			var us:Vector.<Number> = new Vector.<Number>();
			//贴图v坐标
			var vs:Vector.<Number> = new Vector.<Number>();
			//uv混合权重
			var uvWeights:Vector.<Number> = new Vector.<Number>();

			var number:int = 50;

			var zStart:int = _segmentsH / 2 - number;
			var zEnd:int = _segmentsH / 2 + number;

			var xStart:int = _segmentsW / 2 - number;
			var xEnd:int =  _segmentsW / 2 + number;

			var index:int;
			for (var zi:uint = zStart; zi < zEnd; ++zi)
			{
				for (var xi:uint = xStart; xi < xEnd; ++xi)
				{
					war3TerrainTile = new War3TerrainTile();

					index = ((zi-zStart) * (xEnd-xStart) + (xi-xStart)) * 4;

					//计算高度值
					var bottomLeft:W3eTilePoint = tilepoints[xi + zi * tw];
					var topLeft:W3eTilePoint = tilepoints[xi + (zi + 1) * tw];
					var topRight:W3eTilePoint = tilepoints[xi + 1 + (zi + 1) * tw];
					var bottomRight:W3eTilePoint = tilepoints[xi + 1 + zi * tw];

					//格子坐标
					var baseX:Number = xi * TILE_SIZE;
					var baseZ:Number = zi * TILE_SIZE;

					//4个顶点坐标（12个number）
					vertices.push( //
						baseX, bottomLeft.height * s, baseZ, //
						baseX, topLeft.height * s, baseZ + TILE_SIZE, //
						baseX + TILE_SIZE, topRight.height * s, baseZ + TILE_SIZE, //
						baseX + TILE_SIZE, bottomRight.height * s, baseZ //
						);

					indices.push( //
						index, index + 1, index + 2, //
						index + 2, index + 3, index //
						);

					makeUVData(us, vs, uvWeights, topRight.texturetype, topLeft.texturetype, bottomRight.texturetype, bottomLeft.texturetype);
				}
			}

			_subGeometry.updateIndexData(indices);
			_subGeometry.numVertices = vertices.length / 3;
			_subGeometry.updateVertexPositionData(vertices);

			_subGeometry.updateUData(us);
			_subGeometry.updateVData(vs);
			_subGeometry.updateUVWeightsData(uvWeights);
		}

		/**
		 * 制作uv数据
		 * @param uvIndices
		 * @param uvWeights
		 * @param topRightTexturetype
		 * @param topLeftTexturetype
		 * @param bottomRightTexturetype
		 * @param bottomLeftTexturetype
		 */
		private function makeUVData(us:Vector.<Number>, vs:Vector.<Number>, uvWeights:Vector.<Number>, topRightTexturetype:int, topLeftTexturetype:int, bottomRightTexturetype:int, bottomLeftTexturetype:int):void
		{
			var valueDic:Dictionary = new Dictionary();

			//计算4个贴图的索引块
			valueDic[topRightTexturetype] = int(valueDic[topRightTexturetype]) + 1;
			valueDic[topLeftTexturetype] = int(valueDic[topLeftTexturetype]) + 2;
			valueDic[bottomRightTexturetype] = int(valueDic[bottomRightTexturetype]) + 4;
			valueDic[bottomLeftTexturetype] = int(valueDic[bottomLeftTexturetype]) + 8;

			//收集贴图个数
			var textureArr:Array = [];
			for (var texturetype:* in valueDic)
			{
				textureArr.push({tileIndex: texturetype, styleIndex: valueDic[texturetype]});
			}

			//uvIndicesStart == uvWeightsStart
			var uvIndicesStart:int = us.length;
			us.length += 16;
			vs.length += 16;
			var uvWeightsStart:int = uvWeights.length;
			uvWeights.length += 16;
			for (var i:int = 0; i < 4; i++)
			{
//				us[uvIndicesStart] = 0;
//				us[uvIndicesStart + 4] = 0;
//				us[uvIndicesStart + 8] = 0;
//				us[uvIndicesStart + 12] = 0;
//
//				us[uvIndicesStart] = 0;
//				us[uvIndicesStart + 4] = 0;
//				us[uvIndicesStart + 8] = 0;
//				us[uvIndicesStart + 12] = 0;
//
//				uvWeights[uvWeightsStart] = 0;
//				uvWeights[uvWeightsStart + 4] = 0;
//				uvWeights[uvWeightsStart + 8] = 0;
//				uvWeights[uvWeightsStart + 12] = 0;

				if (i < textureArr.length)
				{
					var tileIndex:int = textureArr[i].tileIndex;
					var styleIndex:int = textureArr[i].styleIndex;
					var rct:Rectangle = _war3BitmapTexture.getTextureuvs((tileIndex % 4) * 4 + int(styleIndex / 4), int(tileIndex / 4) * 4 + (styleIndex % 4));

					//uv索引（一个方形块）
					us[uvIndicesStart] = rct.left;
					us[uvIndicesStart + 4] = rct.left;
					us[uvIndicesStart + 8] = rct.right;
					us[uvIndicesStart + 12] = rct.right;

					vs[uvIndicesStart] = rct.bottom;
					vs[uvIndicesStart + 4] = rct.top;
					vs[uvIndicesStart + 8] = rct.top;
					vs[uvIndicesStart + 12] = rct.bottom;

					//权重
					uvWeights[uvWeightsStart] = 1;
					uvWeights[uvWeightsStart + 4] = 1;
					uvWeights[uvWeightsStart + 8] = 1;
					uvWeights[uvWeightsStart + 12] = 1;
				}

			}
		}

		/**
		 * 获取位置在（x，z）处的高度y值
		 * @param x x坐标
		 * @param z z坐标
		 * @return 高度
		 */
		public function getHeightAt(x:Number, z:Number):Number
		{
//			//得到高度图中的值
//			var u:uint = (x / _width + .5) * _segmentsW;
//			var v:uint = (-z / _depth + .5) * _segmentsH;
//
//			var index:int = v * (_segmentsW + 1) + z;
//			//计算高度值
//			var w3eTilePoint:W3eTilePoint = tilepoints[index];
//			return w3eTilePoint.height;
			return 0;
		}
	}
}


