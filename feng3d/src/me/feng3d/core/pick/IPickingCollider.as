package me.feng3d.core.pick
{
	import me.feng3d.core.base.submesh.SubMesh;
	import me.feng3d.core.math.Ray3D;

	/**
	 *
	 * @author feng 2014-4-30
	 */
	public interface IPickingCollider
	{
		/**
		 * 设置本地射线
		 * @param ray3D		射线
		 */
		function setLocalRay(ray3D:Ray3D):void;

		/**
		 * 测试几何体的碰撞
		 * @param subMesh 						被检测网格
		 * @param pickingCollisionVO 			碰撞数据
		 * @param shortestCollisionDistance 	最短碰撞距离
		 * @param bothSides 					是否三角形双面判定
		 * @return 								是否碰撞
		 */
		function testSubMeshCollision(subMesh:SubMesh, pickingCollisionVO:PickingCollisionVO, shortestCollisionDistance:Number, bothSides:Boolean = true):Boolean;
	}
}
