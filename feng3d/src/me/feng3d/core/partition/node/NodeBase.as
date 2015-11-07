package me.feng3d.core.partition.node
{
	import me.feng3d.arcane;
	import me.feng3d.core.math.Plane3D;
	import me.feng3d.core.traverse.PartitionTraverser;
	import me.feng3d.entities.Entity;
	import me.feng3d.primitives.WireframePrimitiveBase;

	use namespace arcane;

	/**
	 * 分区节点基类
	 * @author feng 2015-3-8
	 */
	public class NodeBase
	{
		protected var _childNodes:Vector.<NodeBase>;
		protected var _numChildNodes:uint;
		protected var _debugPrimitive:WireframePrimitiveBase;

		/**
		 * 父分区节点
		 */
		arcane var _parent:NodeBase;

		arcane var _numEntities:int;
		arcane var _collectionMark:uint;

		/**
		 * 创建一个分区节点基类
		 */
		public function NodeBase()
		{
			_childNodes = new Vector.<NodeBase>();
		}

		/**
		 * 父分区节点
		 */
		public function get parent():NodeBase
		{
			return _parent;
		}

		/**
		 * 是否显示调试边界
		 */
		public function get showDebugBounds():Boolean
		{
			return _debugPrimitive != null;
		}

		/**
		 * @private
		 */
		public function set showDebugBounds(value:Boolean):void
		{
			if (Boolean(_debugPrimitive) == value)
				return;

			if (value)
				_debugPrimitive = createDebugBounds();
			else
			{
//				_debugPrimitive.dispose();
				_debugPrimitive = null;
			}

			for (var i:uint = 0; i < _numChildNodes; ++i)
				_childNodes[i].showDebugBounds = value;
		}

		/**
		 * 添加节点
		 * @param node	节点
		 */
		arcane function addNode(node:NodeBase):void
		{
			node._parent = this;
			_numEntities += node._numEntities;
			_childNodes[_numChildNodes++] = node;
			node.showDebugBounds = _debugPrimitive != null;

			var numEntities:int = node._numEntities;
			node = this;

			do
				node._numEntities += numEntities;
			while ((node = node._parent) != null);
		}

		/**
		 * 移除节点
		 * @param node 节点
		 */
		arcane function removeNode(node:NodeBase):void
		{
			var index:uint = _childNodes.indexOf(node);
			_childNodes[index] = _childNodes[--_numChildNodes];
			_childNodes.pop();

			var numEntities:int = node._numEntities;
			node = this;

			do
				node._numEntities -= numEntities;
			while ((node = node._parent) != null);
		}

		/**
		 * 为给定实体查找分区节点
		 * @param entity		实体
		 * @return 				实体所在分区节点
		 */
		public function findPartitionForEntity(entity:Entity):NodeBase
		{
			entity = entity;
			return this;
		}

		/**
		 * 接受横越者
		 * @param traverser		访问节点的横越者
		 */
		public function acceptTraverser(traverser:PartitionTraverser):void
		{
			if (_numEntities == 0 && !_debugPrimitive)
				return;

			if (traverser.enterNode(this))
			{
				var i:uint;
				while (i < _numChildNodes)
					_childNodes[i++].acceptTraverser(traverser);

				if (_debugPrimitive)
					traverser.applyRenderable(_debugPrimitive);
			}
		}

		/**
		 * 创建调试边界
		 */
		protected function createDebugBounds():WireframePrimitiveBase
		{
			return null;
		}

		/**
		 * 更新多个实体
		 * @param value 数量
		 */
		protected function updateNumEntities(value:int):void
		{
			var diff:int = value - _numEntities;
			var node:NodeBase = this;

			do
				node._numEntities += diff;
			while ((node = node._parent) != null);
		}

		/**
		 * 测试是否出现在摄像机视锥体内
		 * @param planes		视锥体面向量
		 * @param numPlanes		面数
		 * @return 				true：在视锥体内
		 */
		public function isInFrustum(planes:Vector.<Plane3D>, numPlanes:int):Boolean
		{
			return true;
		}
	}
}
