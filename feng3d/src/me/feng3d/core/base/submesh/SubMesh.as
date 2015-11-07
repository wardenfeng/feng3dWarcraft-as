package me.feng3d.core.base.submesh
{
	import flash.events.Event;

	import me.feng3d.arcane;
	import me.feng3d.animators.IAnimator;
	import me.feng3d.animators.base.data.AnimationSubGeometry;
	import me.feng3d.core.base.renderable.RenderableBase;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.entities.Entity;
	import me.feng3d.entities.Mesh;
	import me.feng3d.events.MeshEvent;
	import me.feng3d.materials.MaterialBase;

	use namespace arcane;

	/**
	 * 子网格，可渲染对象
	 */
	public class SubMesh extends RenderableBase
	{
		protected var _parentMesh:Mesh;
		protected var _subGeometry:SubGeometry;
		arcane var _index:uint;

		protected var _materialSelf:MaterialBase;
		private var _material:MaterialBase;
		private var _materialDirty:Boolean;

		private var _animator:IAnimator;

		private var _animationSubGeometry:AnimationSubGeometry;

		/**
		 * 创建一个子网格
		 * @param subGeometry 子几何体
		 * @param parentMesh 父网格
		 * @param material 材质
		 */
		public function SubMesh(subGeometry:SubGeometry, parentMesh:Mesh, material:MaterialBase = null)
		{
			_parentMesh = parentMesh;
			this.subGeometry = subGeometry;
			this.material = material;

			_parentMesh.addEventListener(MeshEvent.MATERIAL_CHANGE, onMaterialChange);
		}

		/**
		 * 渲染材质
		 */
		override public function get material():MaterialBase
		{
			if (_materialDirty)
				updateMaterial();
			return _material;
		}

		/**
		 * 自身材质
		 */
		public function get materialSelf():MaterialBase
		{
			return _materialSelf;
		}

		public function set material(value:MaterialBase):void
		{
			_materialSelf = value;
			_materialDirty = true;
		}

		/**
		 * 更新材质
		 */
		private function updateMaterial():void
		{
			var value:MaterialBase = _materialSelf ? _materialSelf : _parentMesh.material;
			if (value == _material)
				return;

			if (_material)
			{
				_material.removeOwner(this);
			}
			_material = value;
			if (_material)
			{
				_material.addOwner(this);
			}
		}

		/**
		 * 所属实体
		 */
		override public function get sourceEntity():Entity
		{
			return _parentMesh;
		}

		/**
		 * 子网格
		 */
		public function get subGeometry():SubGeometry
		{
			return _subGeometry;
		}

		public function set subGeometry(value:SubGeometry):void
		{
			if (_subGeometry)
			{
				removeChildBufferOwner(_subGeometry);
			}
			_subGeometry = value;
			if (_subGeometry)
			{
				addChildBufferOwner(_subGeometry);
			}
		}

		/**
		 * 动画顶点数据(例如粒子特效的时间、位置偏移、速度等等)
		 */
		public function get animationSubGeometry():AnimationSubGeometry
		{
			return _animationSubGeometry;
		}

		public function set animationSubGeometry(value:AnimationSubGeometry):void
		{
			if (_animationSubGeometry)
			{
				removeChildBufferOwner(_animationSubGeometry);
			}
			_animationSubGeometry = value;
			if (_animationSubGeometry)
			{
				addChildBufferOwner(_animationSubGeometry);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function get animator():IAnimator
		{
			return _animator;
		}

		public function set animator(value:IAnimator):void
		{
			if (_animator)
			{
				removeChildBufferOwner(_animator);
				material.animationSet = null;
			}
			_animator = value;
			if (_animator)
			{
				addChildBufferOwner(_animator);
				material.animationSet = _animator.animationSet;
			}
		}

		/**
		 * 父网格
		 */
		arcane function get parentMesh():Mesh
		{
			return _parentMesh;
		}

		public override function get castsShadows():Boolean
		{
			return _parentMesh.castsShadows;
		}

		/**
		 * @inheritDoc
		 */
		override public function get mouseEnabled():Boolean
		{
			return _parentMesh.mouseEnabled || _parentMesh.ancestorsAllowMouseEnabled;
		}

		/**
		 * @inheritDoc
		 */
		override public function get numTriangles():uint
		{
			return _subGeometry.numTriangles;
		}

		/**
		 * 处理材质变化事件
		 */
		private function onMaterialChange(event:Event):void
		{
			_materialDirty = true;
		}

		/**
		 * 销毁
		 */
		public function dispose():void
		{
			material = null;
		}
	}
}
