package me.feng3d.entities
{
	import me.feng3d.containers.ObjectContainer3D;
	import me.feng3d.war3.map.w3e.W3eData;
	import me.feng3d.war3.map.w3e.W3eTilePoint;

	/**
	 * war3地形模块
	 * @author warden_feng 2014-7-21
	 */
	public class War3Terrain extends ObjectContainer3D
	{
		private static const TILE_SIZE:int = 128;

		private var _w3eData:W3eData;
		private var _tileTextures:Array;

		private var tilepoints:Vector.<W3eTilePoint>

		private var _segmentsW:uint;
		private var _segmentsH:uint;

		private var _width:Number;
		private var _depth:Number;

		public function War3Terrain(w3eData:W3eData, tileTextures:Array)
		{
			super();

			_w3eData = w3eData;
			_tileTextures = tileTextures;

			_segmentsW = _w3eData._mapWidth;
			_segmentsH = _w3eData._mapHeight;
			_width = _segmentsW * TILE_SIZE;
			_depth = _segmentsH * TILE_SIZE;

			tilepoints = _w3eData.tilepoints;

			buildGeometry();
		}

		/**
		 * 创建顶点坐标
		 */
		private function buildGeometry():void
		{
			var x:Number, z:Number;
			//一排顶点数据
			var tw:uint = _segmentsW + 1;
			//总顶点数量
			var numVerts:uint = _segmentsH * _segmentsW * 4;
			//格子数
			var numTile:uint = _segmentsH * _segmentsW;

			var war3TerrainTile:War3TerrainTile;

			var number:int = 1;

			var index:int;
			for (var zi:uint = _segmentsH / 2 - number; zi < _segmentsH / 2 + number; ++zi)
			{
				for (var xi:uint = _segmentsH / 2 - number; xi < _segmentsW / 2 + number; ++xi)
				{
					war3TerrainTile = new War3TerrainTile();


					index = zi * _segmentsW + xi;

					//计算高度值
					var bottomLeft:W3eTilePoint = tilepoints[xi + zi * tw];
					var topLeft:W3eTilePoint = tilepoints[xi + (zi + 1) * tw];
					var topRight:W3eTilePoint = tilepoints[xi + 1 + (zi + 1) * tw];
					var bottomRight:W3eTilePoint = tilepoints[xi + 1 + zi * tw];

					//格子坐标
					war3TerrainTile.x = (xi - _segmentsW * .5) * TILE_SIZE;
					war3TerrainTile.z = (zi - _segmentsH * .5) * TILE_SIZE;

					war3TerrainTile.buttonLeft = bottomLeft;
					war3TerrainTile.topLeft = topLeft;
					war3TerrainTile.topRight = topRight;
					war3TerrainTile.buttonRight = bottomRight;

					war3TerrainTile.tileX = xi;
					war3TerrainTile.tileZ = zi;

					war3TerrainTile.tileTextures = _tileTextures;

					war3TerrainTile.buildGeometry();

					addChild(war3TerrainTile);
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


