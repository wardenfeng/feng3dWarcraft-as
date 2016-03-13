package war3Terrain.task
{
	import me.feng.task.TaskEvent;
	import me.feng.task.type.TaskQueue;

	/**
	 * war3地面数据任务
	 * @author warden_feng 2014-7-28
	 */
	public class War3TerrainDataTask extends TaskQueue
	{
		public var w3eLoadParseTask:W3eLoadParseTask;
		public var war3SmallMapItem:War3SmallMapTask;
		public var war3TextureInfo:War3TextureInfoTask;

		public var configUrl:String;

		public function War3TerrainDataTask()
		{
			super();
		}

		public function init(configUrl:String):void
		{
			this.configUrl = configUrl;

			w3eLoadParseTask = new W3eLoadParseTask(configUrl);
			addItem(w3eLoadParseTask);

			war3SmallMapItem = new War3SmallMapTask(configUrl);

			w3eLoadParseTask.addEventListener(TaskEvent.COMPLETED, onW3ePrepared);

			war3TextureInfo = new War3TextureInfoTask();
			addItem(war3TextureInfo);
		}

		private function onW3ePrepared(event:TaskEvent):void
		{
			war3TextureInfo.tilesetsIDs = w3eLoadParseTask.w3eData.tilesetsIDs;
			war3TextureInfo.execute();
		}
	}
}


