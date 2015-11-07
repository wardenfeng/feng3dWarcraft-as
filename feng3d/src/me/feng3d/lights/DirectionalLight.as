package me.feng3d.lights
{
	import flash.geom.Vector3D;

	import me.feng3d.bounds.BoundingVolumeBase;
	import me.feng3d.bounds.NullBounds;
	import me.feng3d.core.partition.node.DirectionalLightNode;
	import me.feng3d.core.partition.node.EntityNode;
	import me.feng3d.lights.shadowmaps.DirectionalShadowMapper;
	import me.feng3d.lights.shadowmaps.ShadowMapperBase;

	/**
	 * 方向灯光
	 * @author feng 2014-9-11
	 */
	public class DirectionalLight extends LightBase
	{
		private var _direction:Vector3D;
		private var _tmpLookAt:Vector3D;
		private var _sceneDirection:Vector3D;

		/**
		 * 创建一个方向灯光
		 * @param xDir		方向X值
		 * @param yDir		方向Y值
		 * @param zDir		方向Z值
		 */
		public function DirectionalLight(xDir:Number = 0, yDir:Number = -1, zDir:Number = 1)
		{
			super();

			direction = new Vector3D(xDir, yDir, zDir);
			_sceneDirection = new Vector3D();
		}

		/**
		 * 灯光方向
		 */
		public function get direction():Vector3D
		{
			return _direction;
		}

		public function set direction(value:Vector3D):void
		{
			_direction = value;
			//lookAt(new Vector3D(x + _direction.x, y + _direction.y, z + _direction.z));
			if (!_tmpLookAt)
				_tmpLookAt = new Vector3D();
			_tmpLookAt.x = x + _direction.x;
			_tmpLookAt.y = y + _direction.y;
			_tmpLookAt.z = z + _direction.z;

			lookAt(_tmpLookAt);
		}

		/**
		 * 灯光场景方向
		 */
		public function get sceneDirection():Vector3D
		{
			if (_sceneTransformDirty)
				updateSceneTransform();
			return _sceneDirection;
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateSceneTransform():void
		{
			super.updateSceneTransform();
			sceneTransform.copyColumnTo(2, _sceneDirection);
			_sceneDirection.normalize();
		}

		/**
		 * @inheritDoc
		 */
		override protected function createEntityPartitionNode():EntityNode
		{
			return new DirectionalLightNode(this);
		}

		/**
		 * @inheritDoc
		 */
		override protected function getDefaultBoundingVolume():BoundingVolumeBase
		{
			// 方向光源并没有坐标，因此永远在3D场景中
			return new NullBounds();
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateBounds():void
		{
		}

		override protected function createShadowMapper():ShadowMapperBase
		{
			return new DirectionalShadowMapper();
		}
	}
}
