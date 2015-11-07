package me.feng3d.test
{
	import me.feng.load.LoadUrlEvent;
	import me.feng3d.configs.WarContext3DBufferIDConfig;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 魔兽争霸地图测试基类
	 * @author feng 2015-11-7
	 */
	public class TestBaseWar3Map extends TestBase
	{
		public function TestBaseWar3Map()
		{
			super();
		}

		override protected function allItemsLoaded(event:LoadUrlEvent):void
		{
			//配置3d缓存编号
			FagalRE.addBufferID(WarContext3DBufferIDConfig.bufferIdConfigs);

			super.allItemsLoaded(event);
		}
	}
}

