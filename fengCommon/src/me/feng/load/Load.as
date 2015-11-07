package me.feng.load
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	import me.feng.debug.assert;
	import me.feng.task.Task;

	/**
	 * 加载模块类
	 * @author feng 2014-7-25
	 */
	public class Load
	{
		private static var loadManager:LoadManager;

		/**
		 * 初始化加载模块
		 */
		public static function init():void
		{
			loadManager || (loadManager = new LoadManager());

			assert(Task.isInit, "加载模块依赖任务模块，请先初始化任务模块");
		}

		/**
		 * 加载器
		 */
		public static function get loader():BulkLoader
		{
			return loadManager.loader;
		}

		/**
		 * 根据类名获取类定义
		 * @param className			类名
		 * @return					类定义
		 */
		public static function getDefinitionByName(className:String):Object
		{
			for each (var loadingItem:LoadingItem in loader.items)
			{
				var imageItem:ImageItem = loadingItem as ImageItem;
				if (imageItem && imageItem.content)
				{
					if (imageItem.getDefinitionByName(className))
						return imageItem.getDefinitionByName(className);
				}
			}
			return null;
		}

		/**
		 * 根据类名获取实例
		 * @param className		类名
		 * @return 				实例
		 */
		public static function getInstance(className:String):*
		{
			var cls:Class = getDefinitionByName(className) as Class;
			if (cls)
				return new cls();
			return null;
		}
	}
}
