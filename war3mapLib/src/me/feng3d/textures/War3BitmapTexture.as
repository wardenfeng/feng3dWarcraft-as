package me.feng3d.textures
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import me.feng.debug.assert;
	import me.feng3d.core.base.data.UV;

	/**
	 * war3位图纹理
	 * @author feng 2016-3-13
	 */
	public class War3BitmapTexture extends BitmapTexture
	{
		/**
		 * LEN*LEN 个tile贴图
		 */
		private static const TILE_LEN:int = 4;

		/**
		 * tile贴图尺寸
		 */
		private static const TILE_SIZE:int = 256;

		/**
		 * 每个tile贴图有 4*4 个样式
		 */
		private static const STYLE_LEN:int = 4;

		/**
		 * style的UV步长
		 */
		private static const STYLE_UV_STEP:Number = 1 / TILE_LEN / STYLE_LEN;

		private var _tileBitmapDatas:Vector.<BitmapData>;

		/**
		 * 创建war3位图纹理
		 * @param tileTextures
		 * @param generateMipmaps
		 */
		public function War3BitmapTexture(tileBitmapDatas:Vector.<BitmapData>, generateMipmaps:Boolean = true)
		{
			bitmapData = new BitmapData(TILE_LEN * TILE_SIZE, TILE_LEN * TILE_SIZE, true, 0);
			super(bitmapData, generateMipmaps);
			this.tileBitmapDatas = tileBitmapDatas;

			assert(test());
		}

		/**
		 * 地形tile贴图数据
		 */
		public function get tileBitmapDatas():Vector.<BitmapData>
		{
			return _tileBitmapDatas;
		}

		public function set tileBitmapDatas(value:Vector.<BitmapData>):void
		{
			_tileBitmapDatas = value;
			bitmapData.fillRect(bitmapData.rect, 0);
			for (var i:int = 0; i < _tileBitmapDatas.length; i++)
			{
				var tileBitmapData:BitmapData = _tileBitmapDatas[i];
				bitmapData.copyPixels(tileBitmapData, new Rectangle(0, 0, TILE_SIZE, TILE_SIZE), new Point((i % TILE_LEN) * TILE_SIZE, int(i / TILE_LEN) * TILE_SIZE));
			}
			bitmapData = bitmapData;
		}

		/**
		 * 获取uv坐标
		 * @param tileIndex		tile索引
		 * @param styleIndex	style索引
		 * @return				uv索引			{(ret%(TILE_LEN * STYLE_LEN)/(TILE_LEN * STYLE_LEN)),int(ret/(TILE_LEN * STYLE_LEN))/(TILE_LEN * STYLE_LEN)}
		 */
		public function getUVIndex(tileIndex:int, styleIndex:int):int
		{
			return (int(tileIndex / TILE_LEN) * STYLE_LEN + int(styleIndex % STYLE_LEN)) * (TILE_LEN * STYLE_LEN) + //
				(int(tileIndex % TILE_LEN) * STYLE_LEN + int(styleIndex / STYLE_LEN));
		}

		/**
		 * 根据UV索引获取UV
		 * @param uvIndex		UV索引
		 * @return				UV
		 */		
		public function getUVByUVIndex(uvIndex:int):UV
		{
			var uv:UV = new UV();
			uv.u = (uvIndex % (TILE_LEN * STYLE_LEN)) / (TILE_LEN * STYLE_LEN);
			uv.v = int(uvIndex / (TILE_LEN * STYLE_LEN)) / (TILE_LEN * STYLE_LEN);
			return uv;
		}

		/**
		 * 等价于getUVIndex，用于测试
		 * @param tileIndex
		 * @param styleIndex
		 * @return
		 */
		private function getUVIndex1(tileIndex:int, styleIndex:int):int
		{
			//
			var x:int = tileIndex % TILE_LEN;
			var y:int = int(tileIndex / TILE_LEN);
			x *= STYLE_LEN;
			y *= STYLE_LEN;

			//
			x += int(styleIndex / STYLE_LEN);
			y += int(styleIndex % STYLE_LEN);

			//
			var uvIndex:int = x + y * TILE_LEN * STYLE_LEN;

			return uvIndex;
		}

		/**
		 * 测试getUVIndex
		 */
		private function test():Boolean
		{
			for (var i:int = 0; i < TILE_LEN * TILE_LEN; i++)
			{
				for (var j:int = 0; j < STYLE_LEN * STYLE_LEN; j++)
				{
					if (getUVIndex(i, j) != getUVIndex1(i, j))
						return false;
				}
			}

			return true;
		}
	}
}


