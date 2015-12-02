package
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.ComboBox;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.VBox;

	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	import me.feng.core.GlobalDispatcher;
	import me.feng.events.load.LoadModuleEvent;
	import me.feng.events.load.LoadModuleEventData;
	import me.feng.load.Load;
	import me.feng.load.LoadUrlEvent;
	import me.feng.load.data.LoadTaskItem;
	import me.feng.task.Task;
	import me.feng3d.configs.Context3DBufferIDConfig;
	import me.feng3d.containers.View3D;
	import me.feng3d.entities.Mesh;
	import me.feng3d.events.ParserEvent;
	import me.feng3d.fagalRE.FagalRE;
	import me.feng3d.parsers.MdlParser;
	import me.feng3d.parsers.mdl.AnimInfo;
	import me.feng3d.parsers.mdl.War3Model;

	/**
	 * war3的mdl文件解析测试
	 * @author warden_feng 2014-4-29
	 */
	[SWF(width = "640", height = "480", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class MdlParserTest extends TestBase
	{
		public var view:View3D;

		private var _showMesh:Mesh;

		private var configUrl:String = "http://images.feng3d.me/feng3dDemo/assets/war3/modelShow.config";

		private var rooturl:String;

		/** 模型数据列表 */
		private var modelDataList:Array;

		/** 模型状态字典（0、未加载；1、加载中；2、解析中；3、解析完毕） */
		private var stateDic:Dictionary = new Dictionary();

		private var modelDic:Dictionary = new Dictionary();

		private var war3ModelDic:Dictionary = new Dictionary();

		private var _showWar3Model:War3Model;

		private var vbox:VBox;
		/** 模型下拉框 */
		private var modelCB:ComboBox;

		/** 动画下拉框 */
		private var actionCB:ComboBox;

		/** 网眼显示框 */
		private var meshPanel:Panel;

		private var meshShowCBList:Array = [];

		private var _selectedModel:Object;

		/** 相机旋转角度 */
		private var cameraAngle:Number = 0;

		/** 相机起始离物体的距离 */
		private var len:Number = 200;

		private var dispatcher:GlobalDispatcher = GlobalDispatcher.instance;

		public function MdlParserTest()
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

			view = new View3D();
			addChild(view);

			initUI();

			Task.init();
			Load.init();

			//配置3d缓存编号
			FagalRE.addBufferID(Context3DBufferIDConfig.bufferIdConfigs);

			loadConfig();


			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		protected function onMouseMove(event:MouseEvent):void
		{
			cameraAngle = int(event.stageX * 360 / stage.stageWidth) - 180;

			updateCamera();
		}

		protected function onMouseWheel(event:MouseEvent):void
		{
			if (event.delta > 0)
			{
				len *= 1.2;
			}
			else
			{
				len /= 1.2;
			}
			updateCamera();
		}

		/** 更新照相机位置角度 */
		private function updateCamera():void
		{
			view.camera.z = len * Math.cos(cameraAngle / 180 * Math.PI);
			view.camera.x = len * Math.sin(cameraAngle / 180 * Math.PI);
			view.camera.y = 100;

			view.camera.lookAt(new Vector3D(0,0,0));
		}

		private function initUI():void
		{
			vbox = new VBox(this);

			modelCB = new ComboBox(vbox);

			modelCB.addEventListener(Event.SELECT, onSelect);

			actionCB = new ComboBox(vbox);
			new Label(meshPanel, 0, 0, "show mesh");
			meshPanel = new Panel(vbox);
		}

		private function onSelect(event:Event):void
		{
			selectedModel = modelCB.selectedItem;
		}

		private function loadConfig():void
		{

			//加载资源
			var loadObj:LoadModuleEventData = new LoadModuleEventData();
			loadObj.urls = [];
			loadObj.urls.push(configUrl + "?version="+Math.random());
			loadObj.addEventListener(LoadUrlEvent.LOAD_SINGLE_COMPLETE, onLoadSingleComplete);

			rooturl = configUrl.substring(0, configUrl.lastIndexOf("/") + 1);

			dispatcher.dispatchEvent(new LoadModuleEvent(LoadModuleEvent.LOAD_RESOURCE, loadObj));
		}

		protected function onLoadSingleComplete(event:LoadUrlEvent):void
		{
			var content:String = event.loadTaskItem.loadingItem.content;
			modelDataList = JSON.parse(content) as Array;

			modelCB.items = modelDataList;
			modelCB.selectedIndex = 0;
		}		


		private function loadModel(model:Object):void
		{
			stateDic[model] = 1;

			//加载资源
			var loadObj:LoadModuleEventData = new LoadModuleEventData();
			loadObj.urls = [rooturl + model.url];
			loadObj.data = model;
			loadObj.addEventListener(LoadUrlEvent.LOAD_SINGLE_COMPLETE, configLoadCompleted);
			dispatcher.dispatchEvent(new LoadModuleEvent(LoadModuleEvent.LOAD_RESOURCE, loadObj));
		}

		private function configLoadCompleted(event:LoadUrlEvent):void
		{
			var loadTaskItem:LoadTaskItem = event.loadTaskItem;
			var content:String = loadTaskItem.loadingItem.content;
			var model:Object = event.data;

			stateDic[model] = 2;

			var myParser:MdlParser = new MdlParser();
			myParser.war3Model.root = loadTaskItem.url.substring(0, loadTaskItem.url.lastIndexOf("/") + 1);
			myParser.addEventListener(ParserEvent.PARSE_COMPLETE, onParseComplete);
			myParser.parseAsync(content);

			modelDic[myParser] = model;
		}

		private function onParseComplete(event:ParserEvent):void
		{
			var myParser:MdlParser = event.currentTarget as MdlParser;
			var model:Object = modelDic[myParser]

			stateDic[model] = 3;

			war3ModelDic[model] = myParser.war3Model;

			selectedModel = model;
		}

		private function initActionCB():void
		{
			var items:Array = [];
			for each (var animInfo:AnimInfo in showWar3Model.sequences)
			{
				items.push({label: animInfo.name, start: animInfo.interval.start, end: animInfo.interval.end});
			}

			actionCB.items = items;
			actionCB.selectedIndex = 0;
		}

		private function initmeshPanel():void
		{
			for (var j:int = meshPanel.numChildren - 1; j >= 0; j--)
			{
				if (meshPanel.getChildAt(j) is CheckBox)
				{
					meshPanel.removeChildAt(j);
				}
			}

			for (var i:int = 0; i < showWar3Model.geosets.length; i++)
			{
				var cb:CheckBox = new CheckBox(meshPanel, 5, 15 * i + 20, "mesh " + i);
				cb.selected = true;
				meshShowCBList[i] = cb;
			}
		}

		private function _onEnterFrame(e:Event):void
		{
			if (showWar3Model)
			{
				var time:int = getTimer();

				var item:Object = actionCB.selectedItem;

				var meshtime:int = (time % (item.end - item.start)) + item.start;

				var meshs:Vector.<Mesh> = showWar3Model.updateAnim(meshtime);

				for (var i:int = 0; i < meshs.length; i++)
				{
					var cb:CheckBox = meshShowCBList[i];
					meshs[i].visible = cb.selected;
				}
			}

			view.render();
		}

		public function get selectedModel():Object
		{
			return _selectedModel;
		}

		public function set selectedModel(value:Object):void
		{
			_selectedModel = value;

			if (stateDic[_selectedModel] == null|| stateDic[_selectedModel] == 0)
			{
				loadModel(_selectedModel);
			}
			else if (stateDic[_selectedModel] == 3)
			{
				showWar3Model = war3ModelDic[_selectedModel];
			}
		}

		public function get showWar3Model():War3Model
		{
			return _showWar3Model;
		}

		public function set showWar3Model(value:War3Model):void
		{
			_showWar3Model = value;

			initActionCB();
			initmeshPanel();

			showMesh = showWar3Model.getMesh();
		}

		public function get showMesh():Mesh
		{
			return _showMesh;
		}

		public function set showMesh(value:Mesh):void
		{
			if (_showMesh)
				view.scene.removeChild(_showMesh);

			_showMesh = value;

			if (_showMesh)
				view.scene.addChild(showMesh);
		}


	}
}


