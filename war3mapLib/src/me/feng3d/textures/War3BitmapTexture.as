package me.feng3d.textures
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

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
		 * tile的UV步长
		 */
		private static const TILE_UV_STEP:Number = 1 / TILE_LEN;

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
		 * @return				uv坐标
		 */
		public function getUV(tileIndex:int, styleIndex:int):Point
		{
			return new Point( //
				int(tileIndex % TILE_LEN) * TILE_UV_STEP + int(styleIndex / STYLE_LEN) * STYLE_UV_STEP, //
				int(tileIndex / TILE_LEN) * TILE_UV_STEP + int(styleIndex % STYLE_LEN) * STYLE_UV_STEP //
				);
		}
	}
}
