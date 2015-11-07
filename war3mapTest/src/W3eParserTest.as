package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.ByteArray;

	import br.com.stimuli.loading.BulkLoader;

	import me.feng.core.GlobalDispatcher;
	import me.feng.events.load.LoadModuleEvent;
	import me.feng.events.load.LoadModuleEventData;
	import me.feng.load.Load;
	import me.feng.load.LoadUrlEvent;
	import me.feng.task.Task;
	import me.feng3d.events.ParserEvent;
	import me.feng3d.parsers.W3eParser;


	/**
	 * 测试slk文件解析
	 * @author warden_feng 2014-7-20
	 */
	public class W3eParserTest extends Sprite
	{
		private var configUrl:String = "assets/war3map/LostTemple/war3map.w3e";

		private var dispatcher:GlobalDispatcher = GlobalDispatcher.instance;

		public function W3eParserTest()
		{
			if (stage != null)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void
		{
			if (hasEventListener(Event.ADDED_TO_STAGE))
				removeEventListener(Event.ADDED_TO_STAGE, init);

			stage.frameRate = 60;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			Task.init();
			Load.init();
			loadConfig();
		}

		private function loadConfig():void
		{
			var loadData:LoadModuleEventData = new LoadModuleEventData([{url: configUrl + "?version=" + Math.random(), type: BulkLoader.TYPE_BINARY}]);
			loadData.addEventListener(LoadUrlEvent.LOAD_SINGLE_COMPLETE,//
				function(event:LoadUrlEvent):void
				{
					var content:ByteArray = event.loadTaskItem.loadingItem.content;

					var myParser:W3eParser = new W3eParser();
					myParser.addEventListener(ParserEvent.PARSE_COMPLETE, onParseComplete);
					myParser.parseAsync(content);

				});

			dispatcher.dispatchEvent(new LoadModuleEvent(LoadModuleEvent.LOAD_RESOURCE, loadData));
		}

		private function onParseComplete(event:ParserEvent):void
		{
			var myParser:W3eParser = event.currentTarget as W3eParser;
			myParser.war3mapTileData;
		}

	}
}


