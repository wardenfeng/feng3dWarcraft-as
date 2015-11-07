package me.feng3d.entities
{
	import flash.display.BitmapData;

	import me.feng3d.core.base.Geometry;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	
	import me.feng3d.materials.MaterialBase;

	/**
	 * 高度地形
	 * @author feng 2014-7-16
	 */
	public class Elevation extends Mesh
	{
		private var _segmentsW:uint;
		private var _segmentsH:uint;
		private var _width:Number;
		private var _height:Number;
		private var _depth:Number;
		private var _heightMap:BitmapData;
		private var _minElevation:uint;
		private var _maxElevation:uint;
		protected var _geomDirty:Boolean = true;
		protected var _uvDirty:Boolean = true;
		private var _subGeometry:SubGeometry;

		/**
		 * 创建高度地形 拥有segmentsW*segmentsH个顶点
		 * @param    material	地形纹理
		 * @param    heightMap	高度图
		 * @param    width	地形宽度
		 * @param    height	地形高度
		 * @param    depth	地形深度
		 * @param    segmentsW	x轴上网格段数
		 * @param    segmentsH	y轴上网格段数
		 * @param    maxElevation	最大地形高度
		 * @param    minElevation	最小地形高度
		 * @param    smoothMap	是否平滑
		 */
		public function Elevation(material:MaterialBase, heightMap:BitmapData, width:Number = 1000, height:Number = 100, depth:Number = 1000, segmentsW:uint = 30, segmentsH:uint = 30, maxElevation:uint = 255, minElevation:uint = 0)
		{
			_subGeometry = new SubGeometry();
			super(new Geometry(), material);
			this.geometry.addSubGeometry(_subGeometry);

			_heightMap = heightMap;
			_segmentsW = segmentsW;
			_segmentsH = segmentsH;
			_width = width;
			_height = height;
			_depth = depth;
			_maxElevation = maxElevation;
			_minElevation = minElevation;

			_subGeometry.numVertices = (_segmentsH + 1) * (_segmentsW + 1);

			buildUVs();
			buildGeometry();
		}


		/**
		 * 创建顶点坐标
		 */
		private function buildGeometry():void
		{
			var vertices:Vector.<Number>;
			var indices:Vector.<uint>;
			var x:Number, z:Number;
			var numInds:uint;
			var base:uint;
			//一排顶点数据
			var tw:uint = _segmentsW + 1;
			//总顶点数量
			var numVerts:uint = (_segmentsH + 1) * tw;
			//一个格子所占高度图X轴像素数
			var uDiv:Number = (_heightMap.width - 1) / _segmentsW;
			//一个格子所占高度图Y轴像素数
			var vDiv:Number = (_heightMap.height - 1) / _segmentsH;
			var u:Number, v:Number;
			var y:Number;

			vertices = _subGeometry.vertexPositionData || new Vector.<Number>(numVerts * 3, true);
			indices = _subGeometry.indexData || new Vector.<uint>(_segmentsH * _segmentsW * 6, true);

			numVerts = 0;
			var col:uint;

			for (var zi:uint = 0; zi <= _segmentsH; ++zi)
			{
				for (var xi:uint = 0; xi <= _segmentsW; ++xi)
				{
					//顶点坐标
					x = (xi / _segmentsW - .5) * _width;
					z = (zi / _segmentsH - .5) * _depth;
					//格子对应高度图uv坐标
					u = xi * uDiv;
					v = (_segmentsH - zi) * vDiv;

					//获取颜色值
					col = _heightMap.getPixel(u, v) & 0xff;
					//计算高度值
					y = (col > _maxElevation) ? (_maxElevation / 0xff) * _height : ((col < _minElevation) ? (_minElevation / 0xff) * _height : (col / 0xff) * _height);

					//保存顶点坐标
					vertices[numVerts++] = x;
					vertices[numVerts++] = y;
					vertices[numVerts++] = z;

					if (xi != _segmentsW && zi != _segmentsH)
					{
						//增加 一个顶点同时 生成一个格子或两个三角形
						base = xi + zi * tw;
						indices[numInds++] = base;
						indices[numInds++] = base + tw;
						indices[numInds++] = base + tw + 1;
						indices[numInds++] = base;
						indices[numInds++] = base + tw + 1;
						indices[numInds++] = base + 1;
					}
				}
			}

			_subGeometry.updateVertexPositionData(vertices);
			_subGeometry.updateIndexData(indices);
		}

		/**
		 * 创建uv坐标
		 */
		private function buildUVs():void
		{
			var uvs:Vector.<Number> = new Vector.<Number>();
			var numUvs:uint = (_segmentsH + 1) * (_segmentsW + 1) * 2;

			uvs = _subGeometry.UVData;
			if (uvs == null || numUvs != uvs.length)
				uvs = new Vector.<Number>(numUvs, true);

			numUvs = 0;
			//计算每个顶点的uv坐标
			for (var yi:uint = 0; yi <= _segmentsH; ++yi)
			{
				for (var xi:uint = 0; xi <= _segmentsW; ++xi)
				{
					uvs[numUvs++] = xi / _segmentsW;
					uvs[numUvs++] = 1 - yi / _segmentsH;
				}
			}

			_subGeometry.updateUVData( uvs);
		}

		/**
		 * 获取位置在（x，z）处的高度y值
		 * @param x x坐标
		 * @param z z坐标
		 * @return 高度
		 */
		public function getHeightAt(x:Number, z:Number):Number
		{
			//得到高度图中的值
			var u:uint = (x / _width + .5) * (_heightMap.width - 1);
			var v:uint = (-z / _depth + .5) * (_heightMap.height - 1);

			var col:uint = _heightMap.getPixel(u, v) & 0xff;

			var h:Number;
			if (col > _maxElevation)
			{
				h = (_maxElevation / 0xff) * _height;
			}
			else if (col < _minElevation)
			{
				h = (_minElevation / 0xff) * _height;
			}
			else
			{
				h = (col / 0xff) * _height;
			}

			return h;
		}
	}
}
