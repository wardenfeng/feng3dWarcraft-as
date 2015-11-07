package me.feng3d.primitives
{
	import flash.geom.Vector3D;

	import me.feng.error.AbstractClassError;
	import me.feng.error.AbstractMethodError;
	import me.feng3d.entities.SegmentSet;
	import me.feng3d.primitives.data.Segment;

	/**
	 * 线框基元基类
	 * @author feng 2014-4-27
	 */
	public class WireframePrimitiveBase extends SegmentSet
	{
		private var _color:uint = 0xffffff;
		private var _thickness:Number = 1;

		/**
		 * @param color 线框颜色
		 * @param thickness 线框厚度
		 */
		public function WireframePrimitiveBase(color:uint = 0xffffff, thickness:Number = 1)
		{
			if (thickness <= 0)
				thickness = 1;
			this.color = color;
			this.thickness = thickness;
			AbstractClassError.check(this);
		}

		/** 线框颜色 */
		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color = value;

			for each (var segment:Segment in segments)
			{
				segment.startColor = segment.endColor = value;
			}
			_segmentSubGeometry.invalid();
		}

		/** 线条粗细值 */
		public function get thickness():Number
		{
			return _thickness;
		}

		public function set thickness(value:Number):void
		{
			_thickness = value;

			for each (var segment:Segment in segments)
			{
				segment.thickness = segment.thickness = value;
			}
			_segmentSubGeometry.invalid();
		}

		/**
		 * 创建几何体
		 */
		protected function buildGeometry():void
		{
			throw new AbstractMethodError();
		}

		override protected function updateSegmentData():void
		{
			buildGeometry();

			super.updateSegmentData();
		}

		/**
		 * 更新线条
		 * @param index 线段编号
		 * @param v0 线段起点
		 * @param v1 线段终点
		 */
		protected function updateOrAddSegment(index:uint, v0:Vector3D, v1:Vector3D):void
		{
			var segment:Segment;
			if ((segment = getSegment(index)) != null)
			{
				segment.start = v0;
				segment.end = v1;
			}
			else
			{
				addSegment(new Segment(v0.clone(), v1.clone(), _color, _color, _thickness));
			}
			_segmentSubGeometry.invalid();
		}
	}
}
