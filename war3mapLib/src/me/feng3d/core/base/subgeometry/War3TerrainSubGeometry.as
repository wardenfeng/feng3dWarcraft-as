package me.feng3d.core.base.subgeometry
{
	import me.feng3d.core.buffer.War3Context3DBufferTypeID;

	/**
	 * war3地形渲染数据缓冲
	 * @author warden_feng 2014-7-31
	 */
	public class War3TerrainSubGeometry extends SubGeometry
	{
		public function War3TerrainSubGeometry()
		{
			super();
		}

		override protected function initBuffers():void
		{
			super.initBuffers();

			mapVABuffer(War3Context3DBufferTypeID.WAR3TERRAINU_VA_4, 4);
			mapVABuffer(War3Context3DBufferTypeID.WAR3TERRAINV_VA_4, 4);
		}

		public function get uData():Vector.<Number>
		{
			var _uData:Vector.<Number> = getVAData(War3Context3DBufferTypeID.WAR3TERRAINU_VA_4);
			return _uData;
		}

		public function updateUData(value:Vector.<Number>):void
		{
			setVAData(War3Context3DBufferTypeID.WAR3TERRAINU_VA_4, value);
		}

		public function get vData():Vector.<Number>
		{
			var _vData:Vector.<Number> = getVAData(War3Context3DBufferTypeID.WAR3TERRAINV_VA_4);
			return _vData;
		}

		public function updateVData(value:Vector.<Number>):void
		{
			setVAData(War3Context3DBufferTypeID.WAR3TERRAINV_VA_4, value);
		}
	}
}
