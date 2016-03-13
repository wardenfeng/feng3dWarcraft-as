package war3Terrain
{
	import me.feng.task.TaskEvent;
	import me.feng.task.type.TaskQueue;

	/**
	 * war3地面数据准备队列
	 * @author warden_feng 2014-7-28
	 */
	public class War3TerrainData extends TaskQueue
	{
		public var w3ePreparationItem:W3eTaskItem;
		public var war3SmallMapItem:War3SmallMapTaskItem;
		public var war3TextureInfo:War3TextureInfo;

		public var configUrl:String;

		public function War3TerrainData()
		{
			super();
		}

		public function init(configUrl:String):void
		{
			this.configUrl = configUrl;

			w3ePreparationItem = new W3eTaskItem(configUrl);
			addItem(w3ePreparationItem);

			war3SmallMapItem = new War3SmallMapTaskItem(configUrl);

			w3ePreparationItem.addEventListener(TaskEvent.COMPLETED, onW3ePrepared);

			war3TextureInfo = new War3TextureInfo();
			addItem(war3TextureInfo);
		}

		private function onW3ePrepared(event:TaskEvent):void
		{
			war3TextureInfo.tilesetsIDs = w3ePreparationItem.w3eData.tilesetsIDs;
			war3TextureInfo.execute();
		}
	}
}


