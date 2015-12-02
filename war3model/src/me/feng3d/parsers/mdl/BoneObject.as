package me.feng3d.parsers.mdl
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import me.feng3d.mathlib.Quaternion;
	import me.feng3d.utils.War3Utils;

	/**
	 * 骨骼信息(包含骨骼，helper等其他对象)
	 * @author warden_feng 2014-6-26
	 */
	public class BoneObject
	{
		/** 骨骼类型 */
		public var type:String;
		/** 骨骼名称 */
		public var name:String;
		/** 对象编号 */
		public var ObjectId:int;
		/** 父对象 */
		public var Parent:int = -1;
		/** 几何体编号 */
		public var GeosetId:String;
		/** 几何体动画 */
		public var GeosetAnimId:String;
		/** 是否为广告牌 */
		public var Billboarded:Boolean;
		/** 骨骼位移动画 */
		public var Translation:BoneTranslation = new BoneTranslation();
		/** 骨骼缩放动画 */
		public var Scaling:BoneScaling = new BoneScaling();
		/** 骨骼角度动画 */
		public var Rotation:BoneRotation = new BoneRotation();
		/** 中心位置 */
		public var pivotPoint:Vector3D;



		/** 当前对象变换矩阵 */
		public var c_transformation:Matrix3D;

		/** 当前全局变换矩阵 */
		public var c_globalTransformation:Matrix3D;

		public function calculateTransformation(keyFrameTime:int):void
		{
			var pScalingCenter:Vector3D = pivotPoint;
			var pScalingRotation:Quaternion = null;
			var pScaling:Vector3D = Scaling.getScaling(keyFrameTime);
			var pRotationCenter:Vector3D = pivotPoint;
			var pRotation:Quaternion = Rotation.getRotation(keyFrameTime);
			var pTranslation:Vector3D = Translation.getTranslation(keyFrameTime);

			c_transformation = War3Utils.D3DXMatrixTransformation(pScalingCenter, pScalingRotation, pScaling, pRotationCenter, pRotation, pTranslation);
		}
	}
}


