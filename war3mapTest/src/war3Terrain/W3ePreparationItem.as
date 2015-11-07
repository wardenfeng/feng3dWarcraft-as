package war3Terrain
{
	import flash.utils.ByteArray;

	import br.com.stimuli.loading.BulkLoader;

	import me.feng.core.GlobalDispatcher;
	import me.feng.events.load.LoadModuleEvent;
	import me.feng.events.load.LoadModuleEventData;
	import me.feng.load.LoadUrlEvent;
	import me.feng.task.TaskItem;
	import me.feng3d.events.ParserEvent;
	import me.feng3d.parsers.W3eParser;
	import me.feng3d.war3.map.w3e.W3eData;

	/**
	 * W3e数据准备元素
	 * @author warden_feng 2014-7-28
	 */
	public class W3ePreparationItem extends TaskItem
	{
		private var dispatcher:GlobalDispatcher = GlobalDispatcher.instance;

		private var configUrl:String;

		public var w3eData:W3eData;

		public function W3ePreparationItem(configUrl:String)
		{
			this.configUrl = configUrl;
		}

		override public function execute(params:* = null):void
		{
			var loadData:LoadModuleEventData = new LoadModuleEventData([{url: configUrl + "?version=" + Math.random(), type: BulkLoader.TYPE_BINARY}]);
			loadData.addEventListener(LoadUrlEvent.LOAD_SINGLE_COMPLETE, //
				function(event:LoadUrlEvent):void
				{
					var content:ByteArray = event.loadTaskItem.loadingItem.content;

					//解析w3e地图文件
					var myParser:W3eParser = new W3eParser();
					myParser.addEventListener(ParserEvent.PARSE_COMPLETE, onW3eParseComplete);
					myParser.parseAsync(content);

				});

			dispatcher.dispatchEvent(new LoadModuleEvent(LoadModuleEvent.LOAD_RESOURCE, loadData));
		}

		private function onW3eParseComplete(event:ParserEvent):void
		{
			event.currentTarget.removeEventListener(ParserEvent.PARSE_COMPLETE, onW3eParseComplete);

			var myParser:W3eParser = event.currentTarget as W3eParser;
			w3eData = myParser.war3mapTileData;

			doComplete();
		}
	}
}
