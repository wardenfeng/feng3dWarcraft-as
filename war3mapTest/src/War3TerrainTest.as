package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	import me.feng.core.GlobalDispatcher;
	import me.feng.debug.DebugCommon;
	import me.feng.load.Load;
	import me.feng.task.Task;
	import me.feng.task.TaskEvent;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.containers.Scene3D;
	import me.feng3d.containers.View3D;
	import me.feng3d.entities.War3Terrain1;
	import me.feng3d.entities.War3TerrainTile;
	import me.feng3d.test.TestBaseWar3Map;
	import me.feng3d.textures.War3BitmapTexture;
	import me.feng3d.war3.map.w3e.W3eData;

	import war3Terrain.task.War3TerrainDataTask;


	[SWF(backgroundColor = "#ffffff", frameRate = "60", quality = "LOW", width = "670", height = "380")]
	public class War3TerrainTest extends TestBaseWar3Map
	{
		private var dispatcher:GlobalDispatcher = GlobalDispatcher.instance;

		//engine variables
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;

		private var terrain:War3Terrain1;

//		private var configUrl:String = "assets/war3map/test/war3map.w3e";

//		private var configUrl:String = "assets/war3map/BootyBay/war3map.w3e";
		private var configUrl:String = "assets/war3map/LostTemple/war3map.w3e";

		/**
		 * Constructor
		 */
		public function War3TerrainTest()
		{
			War3TerrainTile.stage = this.stage;
			super();
		}

		public function init():void
		{
			DebugCommon.loggerFunc = trace;

			initEngine();
			initListeners();

			Task.init();
			Load.init();


			loadTerrainData();
		}

		/**
		 * 加载地形数据
		 */
		private function loadTerrainData():void
		{
			var war3TerrainDataTask:War3TerrainDataTask = new War3TerrainDataTask();
			war3TerrainDataTask.addEventListener(TaskEvent.COMPLETED, onCompleted);
			war3TerrainDataTask.init(configUrl);
			war3TerrainDataTask.execute();
		}

		/**
		 * 地形数据加载完成
		 * @param event
		 */
		private function onCompleted(event:TaskEvent):void
		{
			var war3TerrainDataTask:War3TerrainDataTask = event.currentTarget as War3TerrainDataTask;
			war3TerrainDataTask.removeEventListener(TaskEvent.COMPLETED, onCompleted);

			createTerrain0(war3TerrainDataTask.w3eLoadParseTask.w3eData, war3TerrainDataTask.war3TextureInfoTask.tileTextures);
		}

		/**
		 * Initialise the engine
		 */
		private function initEngine():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			camera = new Camera3D();
			camera.lens.near = 0.01;
			camera.lens.far = 40000;
			view = new View3D(null, camera);
			scene = view.scene;

			camera.transform3D.y = 300;

			addChild(view);
		}

		private function createTerrain0(w3eData:W3eData, tileTextures:Array):void
		{

			var war3BitmapTexture:War3BitmapTexture = new War3BitmapTexture(Vector.<BitmapData>(tileTextures));

			addChild(new Bitmap(war3BitmapTexture.bitmapData));

			terrain = new War3Terrain1(w3eData, war3BitmapTexture);
			scene.addChild(terrain);

			//将需要以线框查看的模型顶点索引以及顶点数据传入即可
//			var _wireframeTriangle:WireframeGeometry = new WireframeGeometry();
//			_wireframeTriangle.setDrawGeometry(terrain.geometry);
//			scene.addChild(_wireframeTriangle);
		}

		/**
		 * Initialise the listeners
		 */
		private function initListeners():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			onResize();
		}

		private var keyDic:Dictionary = new Dictionary();

		protected function onKeyDown(event:KeyboardEvent):void
		{
			keyDic[event.keyCode] = true;
		}

		protected function onKeyUp(event:KeyboardEvent):void
		{
			keyDic[event.keyCode] = false;
		}

		protected function onMouseMove(event:MouseEvent):void
		{
			view.camera.transform3D.rotationX = (2 * event.stageY / stage.stageHeight - 1) * 90;
		}

		/**
		 * Navigation and render loop
		 */
		private function onEnterFrame(event:Event):void
		{
			var positionStep:Number = 50;

			if (keyDic[Keyboard.W])
			{
				view.camera.transform3D.x += view.camera.transform3D.forwardVector.x * positionStep;
				view.camera.transform3D.z += view.camera.transform3D.forwardVector.z * positionStep;
			}
			if (keyDic[Keyboard.S])
			{
				view.camera.transform3D.x -= view.camera.transform3D.forwardVector.x * positionStep;
				view.camera.transform3D.z -= view.camera.transform3D.forwardVector.z * positionStep;
			}
			if (keyDic[Keyboard.A])
			{
				view.camera.transform3D.rotationY--;
			}
			if (keyDic[Keyboard.D])
			{
				view.camera.transform3D.rotationY++;
			}

			//set the camera height based on the terrain (with smoothing)
			if (terrain)
//				camera.transform3D.y += 0.2 * (terrain.getHeightAt(camera.transform3D.x, camera.transform3D.z) + 500 - camera.transform3D.y);
				camera.transform3D.y += 0.2 * (500 - camera.transform3D.y);

			view.render();
		}

		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
		}
	}
}


