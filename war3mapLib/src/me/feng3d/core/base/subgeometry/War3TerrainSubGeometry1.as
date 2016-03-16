package me.feng3d.core.base.subgeometry
{
	import me.feng3d.core.buffer.War3Context3DBufferTypeID;

	/**
	 * war3地形渲染数据缓冲
	 * @author warden_feng 2014-7-31
	 */
	public class War3TerrainSubGeometry1 extends SubGeometry
	{
		public function War3TerrainSubGeometry1()
		{
			super();
		}

		override protected function initBuffers():void
		{
			super.initBuffers();

			mapVABuffer(War3Context3DBufferTypeID.WAR3TERRAINUVINDICES_VA_4, 4);
			mapVABuffer(War3Context3DBufferTypeID.WAR3TERRAINUVWEIGHTS_VA_4, 4);
		}

		public function updateUVIndicesData(value:Vector.<Number>):void
		{
			setVAData(War3Context3DBufferTypeID.WAR3TERRAINUVINDICES_VA_4, value);
		}

		public function updateUVWeightsData(value:Vector.<Number>):void
		{
			setVAData(War3Context3DBufferTypeID.WAR3TERRAINUVWEIGHTS_VA_4, value);
		}
	}
}


