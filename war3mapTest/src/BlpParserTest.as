package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.utils.ByteArray;

	import br.com.stimuli.loading.BulkLoader;

	import me.feng.core.GlobalDispatcher;
	import me.feng.events.load.LoadModuleEvent;
	import me.feng.events.load.LoadModuleEventData;
	import me.feng.load.Load;
	import me.feng.load.LoadUrlEvent;
	import me.feng.task.Task;
	import me.feng3d.events.ParserEvent;
	import me.feng3d.parsers.BlpParser;
	import me.feng3d.test.TestBaseWar3Map;


	/**
	 * 测试blp文件解析
	 * @author warden_feng 2014-7-20
	 */
	public class BlpParserTest extends TestBaseWar3Map
	{
//		private var configUrl:String = "assets/war3map/LostTemple/Lords_Grass.BLP";
		private var configUrl:String = "assets/war3mpq/TerrainArt/LordaeronSummer/Lords_Dirt.blp";
//		private var configUrl:String = "assets/war3mpq/TerrainArt/LordaeronSummer/Lords_DirtRough.blp";
//		private var configUrl:String = "assets/war3mpq/TerrainArt/LordaeronSummer/Lords_DirtGrass.blp";
//		private var configUrl:String = "assets/war3mpq/TerrainArt/LordaeronSummer/Lords_Grass.blp";
//		private var configUrl:String = "assets/war3mpq/TerrainArt/Cityscape/City_SquareTiles.blp";
//		private var configUrl:String = "assets/war3mpq/TerrainArt/Cityscape/City_RoundTiles.blp";
//		private var configUrl:String = "assets/war3mpq/TerrainArt/Cityscape/City_GrassTrim.blp";

		private var dispatcher:GlobalDispatcher = GlobalDispatcher.instance;

		public function BlpParserTest()
		{
			super();
		}

		public function init():void
		{

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

					var myParser:BlpParser = new BlpParser();
					myParser.addEventListener(ParserEvent.PARSE_COMPLETE, onParseComplete);
					myParser.parseAsync(content);

				});

			dispatcher.dispatchEvent(new LoadModuleEvent(LoadModuleEvent.LOAD_RESOURCE, loadData));
		}

		private function onParseComplete(event:ParserEvent):void
		{
			var myParser:BlpParser = event.currentTarget as BlpParser;
			addChild(myParser.blpData.bitmap);
		}

	}
}


