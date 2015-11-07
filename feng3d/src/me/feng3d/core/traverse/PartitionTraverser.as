package me.feng3d.core.traverse
{
	import flash.geom.Vector3D;

	import me.feng.error.AbstractMethodError;
	import me.feng3d.arcane;
	import me.feng3d.containers.Scene3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.partition.node.NodeBase;
	import me.feng3d.entities.SkyBox;
	import me.feng3d.lights.DirectionalLight;
	import me.feng3d.lights.PointLight;

	use namespace arcane;

	/**
	 * 分区横越者
	 * @author feng 2015-3-1
	 */
	public class PartitionTraverser
	{
		/**
		 * 3D场景
		 */
		public var scene:Scene3D;

		/**
		 * 进入点
		 */
		arcane var _entryPoint:Vector3D;

		/**
		 * 碰撞标记，避免多次检测
		 */
		arcane static var _collectionMark:uint;

		/**
		 * 构建一个分区横越者
		 */
		public function PartitionTraverser()
		{
		}

		/**
		 * 进入节点
		 * <p>正在穿过节点，或者正在与该节点进行检测</p>
		 * @param node 		被进入的节点
		 * @return			true：需要进一步检测子节点
		 */
		public function enterNode(node:NodeBase):Boolean
		{
			node = node;
			return true;
		}

		/**
		 * 应用天空盒
		 * @param skyBox		天空盒
		 */
		public function applySkyBox(skyBox:SkyBox):void
		{
			throw new AbstractMethodError();
		}

		/**
		 * 应用渲染对象
		 * @param renderable		被横越者通过的可渲染对象
		 */
		public function applyRenderable(renderable:IRenderable):void
		{
			throw new AbstractMethodError();
		}

		/**
		 * 应用方向光源
		 * @param light		被横越者通过的方向光源
		 */
		public function applyDirectionalLight(light:DirectionalLight):void
		{
			throw new AbstractMethodError();
		}

		/**
		 * 应用点光源
		 * @param light		被横越者通过的点光源
		 */
		public function applyPointLight(light:PointLight):void
		{
			throw new AbstractMethodError();
		}
	}
}
