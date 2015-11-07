package me.feng3d.bounds
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import me.feng.error.AbstractClassError;
	import me.feng.error.AbstractMethodError;
	import me.feng3d.core.base.Geometry;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.core.math.Plane3D;
	import me.feng3d.core.math.Ray3D;
	import me.feng3d.primitives.WireframePrimitiveBase;

	/**
	 * 包围盒基类
	 * @author feng 2014-4-27
	 */
	public class BoundingVolumeBase
	{
		/** 最小坐标 */
		protected var _min:Vector3D;
		/** 最大坐标 */
		protected var _max:Vector3D;

		protected var _aabbPointsDirty:Boolean = true;
		protected var _boundingRenderable:WireframePrimitiveBase;

		/**
		 * 创建包围盒
		 */
		public function BoundingVolumeBase()
		{
			_min = new Vector3D();
			_max = new Vector3D();

			AbstractClassError.check(this);
		}

		/**
		 * 渲染实体
		 */
		public function get boundingRenderable():WireframePrimitiveBase
		{
			if (!_boundingRenderable)
			{
				_boundingRenderable = createBoundingRenderable();
				updateBoundingRenderable();
			}

			return _boundingRenderable;
		}

		/**
		 * 销毁渲染实体
		 */
		public function disposeRenderable():void
		{
			_boundingRenderable = null;
		}

		/**
		 * 更新边界渲染实体
		 */
		protected function updateBoundingRenderable():void
		{
			throw new AbstractMethodError();
		}

		/**
		 * 创建渲染边界
		 */
		protected function createBoundingRenderable():WireframePrimitiveBase
		{
			throw new AbstractMethodError();
		}

		/**
		 * 根据几何结构更新边界
		 */
		public function fromGeometry(geometry:Geometry):void
		{
			var subGeoms:Vector.<SubGeometry> = geometry.subGeometries;
			var numSubGeoms:uint = subGeoms.length;
			var minX:Number, minY:Number, minZ:Number;
			var maxX:Number, maxY:Number, maxZ:Number;

			if (numSubGeoms > 0)
			{
				var subGeom:SubGeometry = subGeoms[0];
				var vertices:Vector.<Number> = subGeom.vertexPositionData;
				var i:uint = 0;
				minX = maxX = vertices[i];
				minY = maxY = vertices[i + 1];
				minZ = maxZ = vertices[i + 2];

				var j:uint = 0;
				while (j < numSubGeoms)
				{
					subGeom = subGeoms[j++];
					vertices = subGeom.vertexPositionData;
					var vertexDataLen:uint = vertices.length;
					i = 0;
					var stride:uint = subGeom.vertexPositionStride;

					while (i < vertexDataLen)
					{
						var v:Number = vertices[i];
						if (v < minX)
							minX = v;
						else if (v > maxX)
							maxX = v;
						v = vertices[i + 1];
						if (v < minY)
							minY = v;
						else if (v > maxY)
							maxY = v;
						v = vertices[i + 2];
						if (v < minZ)
							minZ = v;
						else if (v > maxZ)
							maxZ = v;
						i += stride;
					}
				}

				fromExtremes(minX, minY, minZ, maxX, maxY, maxZ);
			}
			else
				fromExtremes(0, 0, 0, 0, 0, 0);
		}

		/**
		 * 根据所给极值设置边界
		 * @param minX 边界最小X坐标
		 * @param minY 边界最小Y坐标
		 * @param minZ 边界最小Z坐标
		 * @param maxX 边界最大X坐标
		 * @param maxY 边界最大Y坐标
		 * @param maxZ 边界最大Z坐标
		 */
		public function fromExtremes(minX:Number, minY:Number, minZ:Number, maxX:Number, maxY:Number, maxZ:Number):void
		{
			_min.x = minX;
			_min.y = minY;
			_min.z = minZ;
			_max.x = maxX;
			_max.y = maxY;
			_max.z = maxZ;
			if (_boundingRenderable)
				updateBoundingRenderable();
		}

		/**
		 * 检测射线是否与边界交叉
		 * @param ray3D						射线
		 * @param targetNormal				交叉点法线值
		 * @return							射线起点到交点距离
		 */
		public function rayIntersection(ray3D:Ray3D, targetNormal:Vector3D):Number
		{
			return -1;
		}

		/**
		 * 检测是否包含指定点
		 * @param position 		被检测点
		 * @return				true：包含指定点
		 */
		public function containsPoint(position:Vector3D):Boolean
		{
			return false;
		}

		/**
		 * 测试是否出现在摄像机视锥体内
		 * @param planes 		视锥体面向量
		 * @param numPlanes		面数
		 * @return 				true：出现在视锥体内
		 */
		public function isInFrustum(planes:Vector.<Plane3D>, numPlanes:int):Boolean
		{
			throw new AbstractMethodError();
		}

		/**
		 * 对包围盒进行变换
		 * @param bounds		包围盒
		 * @param matrix		变换矩阵
		 */
		public function transformFrom(bounds:BoundingVolumeBase, matrix:Matrix3D):void
		{
			throw new AbstractMethodError();
		}

		/**
		 * 从给出的球体设置边界
		 * @param center 		球心坐标
		 * @param radius 		球体半径
		 */
		public function fromSphere(center:Vector3D, radius:Number):void
		{
			fromExtremes(center.x - radius, center.y - radius, center.z - radius, center.x + radius, center.y + radius, center.z + radius);
		}
	}
}
