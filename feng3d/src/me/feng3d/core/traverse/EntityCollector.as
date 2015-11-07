package me.feng3d.core.traverse
{
	import flash.geom.Vector3D;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.data.EntityListItemPool;
	import me.feng3d.core.data.RenderableListItem;
	import me.feng3d.core.data.RenderableListItemPool;
	import me.feng3d.core.math.Matrix3DUtils;
	import me.feng3d.core.math.Plane3D;
	import me.feng3d.core.partition.node.NodeBase;
	import me.feng3d.entities.Entity;
	import me.feng3d.entities.SkyBox;
	import me.feng3d.lights.DirectionalLight;
	import me.feng3d.lights.LightBase;
	import me.feng3d.lights.PointLight;
	import me.feng3d.materials.MaterialBase;

	use namespace arcane;

	/**
	 * 实体收集器
	 * <p>为场景分区收集所有场景图中被认为潜在显示对象</p>
	 *
	 * @see me.feng3d.core.partition.Partition3D
	 * @see me.feng3d.entities.Entity
	 *
	 * @author feng 2015-3-1
	 */
	public class EntityCollector extends PartitionTraverser
	{
		protected var _skyBox:SkyBox;
		protected var _opaqueRenderableHead:RenderableListItem;
		protected var _blendedRenderableHead:RenderableListItem;

		protected var _renderableListItemPool:RenderableListItemPool;
		protected var _entityListItemPool:EntityListItemPool;
		//----------------------------
		//			灯光
		//----------------------------
		protected var _lights:Vector.<LightBase>;
		private var _directionalLights:Vector.<DirectionalLight>;
		private var _pointLights:Vector.<PointLight>;
		protected var _numLights:uint;
		private var _numDirectionalLights:uint;
		private var _numPointLights:uint;
		//
		protected var _numTriangles:uint;
		protected var _numMouseEnableds:uint;
		protected var _camera:Camera3D;
		protected var _cameraForward:Vector3D;
		private var _customCullPlanes:Vector.<Plane3D>;
		private var _cullPlanes:Vector.<Plane3D>;
		private var _numCullPlanes:uint;

		/**
		 * 创建一个实体收集器
		 */
		public function EntityCollector()
		{
			init();
		}

		/**
		 * 初始化
		 */
		private function init():void
		{
			_lights = new Vector.<LightBase>();
			_directionalLights = new Vector.<DirectionalLight>();
			_pointLights = new Vector.<PointLight>();
			_renderableListItemPool = new RenderableListItemPool();
			_entityListItemPool = new EntityListItemPool();
		}

		/**
		 * 清除
		 */
		public function clear():void
		{
			if (_camera)
			{
				_entryPoint = _camera.scenePosition;
				_cameraForward = Matrix3DUtils.getForward(_camera.transform, _cameraForward);
			}
			_cullPlanes = _customCullPlanes ? _customCullPlanes : (_camera ? _camera.frustumPlanes : null);
			_numCullPlanes = _cullPlanes ? _cullPlanes.length : 0;
			_numTriangles = _numMouseEnableds = 0;
			_blendedRenderableHead = null;
			_opaqueRenderableHead = null;
			_renderableListItemPool.freeAll();
			_entityListItemPool.freeAll();
			_skyBox = null;
			if (_numLights > 0)
				_lights.length = _numLights = 0;
			if (_numDirectionalLights > 0)
				_directionalLights.length = _numDirectionalLights = 0;
			if (_numPointLights > 0)
				_pointLights.length = _numPointLights = 0;
		}

		/**
		 * 提供可见视锥体的摄像机
		 */
		public function get camera():Camera3D
		{
			return _camera;
		}

		public function set camera(value:Camera3D):void
		{
			_camera = value;
			_entryPoint = _camera.scenePosition;
			_cameraForward = Matrix3DUtils.getForward(_camera.transform, _cameraForward);
			_cullPlanes = _camera.frustumPlanes;
		}

		/**
		 * 视椎面
		 */
		public function get cullPlanes():Vector.<Plane3D>
		{
			return _customCullPlanes;
		}

		public function set cullPlanes(value:Vector.<Plane3D>):void
		{
			_customCullPlanes = value;
		}

		/**
		 * 天空盒对象
		 */
		public function get skyBox():SkyBox
		{
			return _skyBox;
		}

		/**
		 * 不透明渲染对象链表头
		 */
		public function get opaqueRenderableHead():RenderableListItem
		{
			return _opaqueRenderableHead;
		}

		public function set opaqueRenderableHead(value:RenderableListItem):void
		{
			_opaqueRenderableHead = value;
		}

		/**
		 * 透明渲染对象链表头
		 */
		public function get blendedRenderableHead():RenderableListItem
		{
			return _blendedRenderableHead;
		}

		public function set blendedRenderableHead(value:RenderableListItem):void
		{
			_blendedRenderableHead = value;
		}

		/**
		 * 添加渲染对象到潜在显示对象中
		 * @param renderable	可渲染对象
		 */
		override public function applyRenderable(renderable:IRenderable):void
		{
			var material:MaterialBase;
			var entity:Entity = renderable.sourceEntity;
			if (renderable.mouseEnabled)
				++_numMouseEnableds;
			_numTriangles += renderable.numTriangles;

			material = renderable.material;
			if (material)
			{
				var item:RenderableListItem = _renderableListItemPool.getItem();
				item.renderable = renderable;
				item.materialId = material._uniqueId;
				item.renderOrderId = material._renderOrderId;
				var entityScenePos:Vector3D = entity.scenePosition;
				var dx:Number = _entryPoint.x - entityScenePos.x;
				var dy:Number = _entryPoint.y - entityScenePos.y;
				var dz:Number = _entryPoint.z - entityScenePos.z;
				// project onto camera's z-axis
				item.zIndex = dx * _cameraForward.x + dy * _cameraForward.y + dz * _cameraForward.z + entity.zOffset;
				item.renderSceneTransform = renderable.sourceEntity.getRenderSceneTransform(camera);
				if (material.requiresBlending)
				{
					item.next = _blendedRenderableHead;
					_blendedRenderableHead = item;
				}
				else
				{
					item.next = _opaqueRenderableHead;
					_opaqueRenderableHead = item;
				}
			}
		}

		/**
		 * 判断节点是否出现在视锥体中
		 * @param node 用于测试的节点
		 */
		override public function enterNode(node:NodeBase):Boolean
		{
			var enter:Boolean = _collectionMark != node._collectionMark && node.isInFrustum(_cullPlanes, _numCullPlanes);
			node._collectionMark = _collectionMark;
			return enter;
		}

		/**
		 * @inheritDoc
		 */
		override public function applySkyBox(skyBox:SkyBox):void
		{
			_skyBox = skyBox;
		}

		/**
		 * @inheritDoc
		 */
		override public function applyDirectionalLight(light:DirectionalLight):void
		{
			_lights[_numLights++] = light;
			_directionalLights[_numDirectionalLights++] = light;
		}

		/**
		 * @inheritDoc
		 */
		override public function applyPointLight(light:PointLight):void
		{
			_lights[_numLights++] = light;
			_pointLights[_numPointLights++] = light;
		}

		/**
		 * 方向光列表
		 */
		public function get directionalLights():Vector.<DirectionalLight>
		{
			return _directionalLights;
		}
	}
}
