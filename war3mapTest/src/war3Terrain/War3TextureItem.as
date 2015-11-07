package war3Terrain
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	import br.com.stimuli.loading.BulkLoader;

	import me.feng.core.GlobalDispatcher;
	import me.feng.events.load.LoadModuleEvent;
	import me.feng.events.load.LoadModuleEventData;
	import me.feng.load.LoadUrlEvent;
	import me.feng.task.TaskItem;
	import me.feng3d.events.ParserEvent;
	import me.feng3d.parsers.BlpParser;
	import me.feng3d.textures.BitmapTexture;
	import me.feng3d.utils.Cast;

	/**
	 *
	 * @author warden_feng 2014-7-22
	 */
	public class War3TextureItem extends TaskItem
	{
		private var dispatcher:GlobalDispatcher = GlobalDispatcher.instance;

		public var id:String;
		public var url:String;

		public var content:ByteArray;

		public var bitmap:Bitmap;

		public var bitmapTexture:BitmapTexture;

		public function War3TextureItem()
		{
			super();
		}

		override public function execute(params:* = null):void
		{
			super.execute();
			prepareTexture();
		}

		public function prepareTexture():void
		{
			var loadData:LoadModuleEventData = new LoadModuleEventData([{url: url, type: BulkLoader.TYPE_BINARY}]);
			loadData.addEventListener(LoadUrlEvent.LOAD_SINGLE_COMPLETE, onSingleLoadComplete);

			dispatcher.dispatchEvent(new LoadModuleEvent(LoadModuleEvent.LOAD_RESOURCE, loadData));
		}

		private function onSingleLoadComplete(event:LoadUrlEvent):void
		{
			content = event.loadTaskItem.loadingItem.content;

			var myParser:BlpParser = new BlpParser();
			myParser.addEventListener(ParserEvent.PARSE_COMPLETE, onBlpParseComplete);
			myParser.parseAsync(content);
		}

		private function onBlpParseComplete(event:ParserEvent):void
		{
			event.currentTarget.removeEventListener(ParserEvent.PARSE_COMPLETE, onBlpParseComplete);

			var myParser:BlpParser = event.currentTarget as BlpParser;
			bitmap = myParser.blpData.bitmap;

			var newSize:int = Math.min(bitmap.bitmapData.width, bitmap.bitmapData.height);
			var newBmd:BitmapData = new BitmapData(newSize, newSize);
			newBmd.copyPixels(bitmap.bitmapData, new Rectangle(0, 0, newSize, newSize), new Point());

			bitmapTexture = Cast.bitmapTexture(newBmd);

			doComplete();
		}

	}
}


