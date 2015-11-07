package me.feng.load
{
	import flash.events.Event;
	import flash.utils.Dictionary;

	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;

	import me.feng.arcaneCommon;
	import me.feng.core.FModuleManager;
	import me.feng.events.task.TaskModuleEvent;
	import me.feng.events.task.TaskModuleEventDispatchTaskData;
	import me.feng.task.Task;
	import me.feng.events.load.LoadModuleEvent;

	use namespace arcaneCommon;

	/**
	 * 加载管理器
	 * @author feng 2014-7-25
	 */
	public class LoadManager extends FModuleManager
	{
		/** 加载器 */
		public var loader:BulkLoader;

		/** 完成一个资源后执行的函数字典 */
		private var urlFuncsDic:Dictionary = new Dictionary();

		/** 完成一组资源后执行的函数字典 */
		private var urlsFuncsDic:Dictionary = new Dictionary();

		/**
		 * 创建一个加载管理器
		 */
		public function LoadManager()
		{
			init();
		}

		/**
		 * 初始化加载模块
		 */
		override protected function init():void
		{
			// creates a BulkLoader instance with a name of "main-site", that can be used to retrieve items without having a reference to this instance
			loader = new BulkLoader("main-site");
			// set level to verbose, for debugging only
			loader.logLevel = BulkLoader.LOG_ERRORS;

			addListeners();
		}

		/**
		 * 添加事件监听器
		 */
		private function addListeners():void
		{
			loader.addEventListener(BulkLoader.COMPLETE, onAllItemsLoaded);

			loader.addEventListener(BulkLoader.PROGRESS, onAllItemsProgress);

			addEventListener(LoadModuleEvent.LOAD_RESOURCE, onLoadResource);
		}

		/**
		 * 处理加载资源事件
		 * @param event
		 */
		private function onLoadResource(event:LoadModuleEvent):void
		{
			var taskModuleEventData:TaskModuleEventDispatchTaskData = event.loadEventData.taskModuleEventData;
			taskModuleEventData.params = loader;

			dispatchEvent(new TaskModuleEvent(TaskModuleEvent.DISPATCH_TASK, taskModuleEventData));

			if (!loader.isRunning)
				loader.start();
		}

		/**
		 * 加载完成所有资源事件
		 * @param evt
		 */
		private function onAllItemsLoaded(evt:Event):void
		{
//			logger("every thing is loaded!");
		}

		/**
		 * 加载进度事件
		 */
		private function onAllItemsProgress(evt:BulkProgressEvent):void
		{
//			logger(evt.loadingStatus());
		}

	}
}
