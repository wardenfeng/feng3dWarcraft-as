package me.feng3d.containers
{
	import me.feng3d.arcane;
	import me.feng3d.core.base.InteractiveObject3D;
	import me.feng3d.core.base.Object3D;
	import me.feng3d.core.partition.Partition3D;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;

	use namespace arcane;

	/**
	 * 3d对象容器
	 * @author feng 2014-3-21
	 */
	public class ObjectContainer3D extends InteractiveObject3D implements IAsset
	{
		/** 容器内对象列表 */
		protected var _children:Vector.<Object3D> = new Vector.<Object3D>();

		private var _mouseChildren:Boolean = true;

		/** 是否给根容器 */
		public var _isRoot:Boolean = false;

		public function ObjectContainer3D()
		{
			super();
		}

		/**
		 * 添加子对象
		 * @param child		子对象
		 * @return			新增的子对象
		 */
		public function addChild(child:Object3D):Object3D
		{
			if (!child._explicitPartition)
				child.implicitPartition = _implicitPartition;

			child.parent = this;
			child.scene = scene;
			_children.push(child);
			return child;
		}

		/**
		 * 移出指定索引的子对象
		 * @param childIndex	子对象索引
		 * @return				被移除对象
		 */
		public function removeChildAt(childIndex:int):Object3D
		{
			var child:Object3D = getChildAt(childIndex);
			removeChildInternal(childIndex, child);
			return child;
		}

		/**
		 * 移除子对象
		 * @param child		子对象
		 */
		public function removeChild(child:Object3D):void
		{
			var childIndex:int = _children.indexOf(child);
			if (childIndex != -1)
			{
				removeChildInternal(childIndex, child);
			}
		}

		/**
		 * 内部移除子对象
		 * @param childIndex	移除子对象所在索引
		 * @param child			移除子对象
		 */
		private function removeChildInternal(childIndex:uint, child:Object3D):void
		{
			_children.splice(childIndex, 1);

			child.parent = null;
			child.scene = null;
		}

		override public function set scene(scene:Scene3D):void
		{
			super.scene = scene;

			var len:uint = _children.length;
			for (var i:int = 0; i < len; i++)
			{
				_children[i].scene = scene;
			}
		}

		/**
		 * 使变换矩阵失效，子对象变化矩阵也将失效
		 */
		override public function invalidateTransform():void
		{
			var len:uint = _children.length;
			for (var i:int = 0; i < len; i++)
			{
				_children[i].invalidateTransform();
			}
			super.invalidateTransform();
		}

		/**
		 * 子对象个数
		 */
		public function get numChildren():uint
		{
			return _children.length;
		}

		/**
		 * 获取子对象
		 * @param index
		 * @return
		 */
		public function getChildAt(index:uint):Object3D
		{
			return _children[index];
		}

		/**
		 * 是否包含该对象
		 * @param child
		 * @return
		 */
		public function contains(child:Object3D):Boolean
		{
			return _children.indexOf(child) >= 0;
		}

		/**
		 * 确定对象的子级是否支持鼠标或用户输入设备。
		 */
		public function get mouseChildren():Boolean
		{
			return _mouseChildren;
		}

		public function set mouseChildren(value:Boolean):void
		{
			_mouseChildren = value;
		}

		/**
		 * 祖先是否允许鼠标事件
		 */
		public function get ancestorsAllowMouseEnabled():Boolean
		{
			return mouseChildren && (parent ? parent.ancestorsAllowMouseEnabled : true);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function set implicitPartition(value:Partition3D):void
		{
			if (value == _implicitPartition)
				return;

			_implicitPartition = value;

			var i:uint;
			var len:uint = _children.length;
			var child:Object3D;

			while (i < len)
			{
				child = _children[i];
				i++;

				if (!child._explicitPartition)
					child.implicitPartition = value;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get assetType():String
		{
			return AssetType.CONTAINER;
		}
	}
}
