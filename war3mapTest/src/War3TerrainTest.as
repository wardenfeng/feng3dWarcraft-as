package
{
	import flash.display.Bitmap;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	import me.feng.core.GlobalDispatcher;
	import me.feng.load.Load;
	import me.feng.task.Task;
	import me.feng.task.TaskEvent;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.containers.Scene3D;
	import me.feng3d.containers.View3D;
	import me.feng3d.core.base.Object3D;
	import me.feng3d.entities.War3Terrain1;
	import me.feng3d.entities.War3TerrainTile;
	import me.feng3d.test.TestBaseWar3Map;

	import war3Terrain.War3TerrainData;


	[SWF(backgroundColor = "#ffffff", frameRate = "60", quality = "LOW", width = "670", height = "380")]
	public class War3TerrainTest extends TestBaseWar3Map
	{
		private var dispatcher:GlobalDispatcher = GlobalDispatcher.instance;

		//engine variables
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;

		private var terrain:Object3D;

//		private var configUrl:String = "assets/war3map/test/war3map.w3e";
//		private var configUrl:String = "assets/war3map/BootyBay/war3map.w3e";
		private var configUrl:String = "assets/war3map/LostTemple/war3map.w3e";

		private var war3TerrainData:War3TerrainData = new War3TerrainData();

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
			initEngine();
			initListeners();

			Task.init();
			Load.init();


			readyTerrainData();
		}

		private function readyTerrainData():void
		{
			war3TerrainData.init(configUrl);
			war3TerrainData.execute();
		}

		private function onPrepared(event:TaskEvent):void
		{
			createTerrain0();
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

			camera.y = 300;

			addChild(view);
		}

		private function createTerrain0():void
		{
			addChild(new Bitmap(war3TerrainData.war3TextureInfo.tileTextures[1].bitmapData.clone()));

			terrain = new War3Terrain1(war3TerrainData.w3ePreparationItem.w3eData, war3TerrainData.war3TextureInfo.tileTextures);
			scene.addChild(terrain);
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
			war3TerrainData.addEventListener(TaskEvent.COMPLETED, onPrepared);
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
			view.camera.rotationX = (2 * event.stageY / stage.stageHeight - 1) * 90;
		}

		/**
		 * Navigation and render loop
		 */
		private function onEnterFrame(event:Event):void
		{
			var positionStep:Number = 50;

			if (keyDic[Keyboard.W])
			{
				view.camera.x += view.camera.forwardVector.x * positionStep;
				view.camera.z += view.camera.forwardVector.z * positionStep;
			}
			if (keyDic[Keyboard.S])
			{
				view.camera.x -= view.camera.forwardVector.x * positionStep;
				view.camera.z -= view.camera.forwardVector.z * positionStep;
			}
			if (keyDic[Keyboard.A])
			{
				view.camera.rotationY--;
			}
			if (keyDic[Keyboard.D])
			{
				view.camera.rotationY++;
			}

			//set the camera height based on the terrain (with smoothing)
			if (terrain)
//				camera.y += 0.2 * (terrain.getHeightAt(camera.x, camera.z) + 500 - camera.y);
				camera.y += 0.2 * (500 - camera.y);

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


