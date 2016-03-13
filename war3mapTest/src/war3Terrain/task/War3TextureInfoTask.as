package war3Terrain.task
{
	import me.feng.core.GlobalDispatcher;
	import me.feng.task.TaskEvent;
	import me.feng.task.type.TaskQueue;
	import me.feng3d.war3.slk.TerrainSlkItem;
	import me.feng3d.war3.slk.War3MapConfig;

	/**
	 * 处理war3纹理信息
	 * @author warden_feng 2014-7-22
	 */
	public class War3TextureInfoTask extends TaskQueue
	{
		private var dispatcher:GlobalDispatcher = GlobalDispatcher.instance;

		public var tilesetsIDs:Array;

		public var tileTextures:Array = [];

		private var _war3MapConfig:War3MapConfig;

		public function War3TextureInfoTask()
		{
			super();
		}

		override public function execute(params:* = null):void
		{
			if (tilesetsIDs)
			{
				init();
				super.execute();
			}
		}

		private function init():void
		{
			var tilesetsID:String;
			var terrainObj:TerrainSlkItem;
			var war3TextureItem:War3TextureTask;
			for (var i:int = 0; i < tilesetsIDs.length; i++)
			{
				tilesetsID = tilesetsIDs[i];
				terrainObj = war3MapConfig.terrainslkDic[tilesetsID];

				war3TextureItem = new War3TextureTask();
				war3TextureItem.id = tilesetsID;
				war3TextureItem.url = "assets/war3mpq/" + terrainObj.url + ".blp?version=" + Math.random();
				trace(war3TextureItem.url);

				addItem(war3TextureItem);
			}
		}

		override protected function onCompletedItem(event:TaskEvent):void
		{
			var war3TextureItem:War3TextureTask = event.target as War3TextureTask;

			tileTextures[tilesetsIDs.indexOf(war3TextureItem.id)] = war3TextureItem.bitmapData;
			super.onCompletedItem(event);
		}

		public function get war3MapConfig():War3MapConfig
		{
			return _war3MapConfig ||= War3MapConfig.instance;
		}
	}
}


