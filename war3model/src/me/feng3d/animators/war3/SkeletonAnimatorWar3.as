package me.feng3d.animators.war3
{
	import flash.geom.Vector3D;
	
	import me.feng3d.arcane;
	import me.feng3d.animators.skeleton.SkeletonAnimationSet;
	import me.feng3d.animators.skeleton.SkeletonAnimator;
	import me.feng3d.animators.skeleton.data.JointPose;
	import me.feng3d.animators.skeleton.data.Skeleton;
	import me.feng3d.animators.skeleton.data.SkeletonJoint;
	import me.feng3d.animators.skeleton.data.SkeletonPose;
	import me.feng3d.core.math.Quaternion;

	use namespace arcane;

	/**
	 * 骨骼动画
	 * @author warden_feng 2014-5-27
	 */
	public class SkeletonAnimatorWar3 extends SkeletonAnimator
	{
		/**
		 * 创建一个骨骼动画类
		 * @param animationSet 动画集合
		 * @param skeleton 骨骼
		 * @param forceCPU 是否强行使用cpu
		 */
		public function SkeletonAnimatorWar3(animationSet:SkeletonAnimationSet, skeleton:Skeleton, forceCPU:Boolean = false)
		{
			super(animationSet, skeleton, forceCPU);
		}

		/**
		 * 本地转换到全局姿势
		 * @param sourcePose 原姿势
		 * @param targetPose 目标姿势
		 * @param skeleton 骨骼
		 */
		override protected function localToGlobalPose(sourcePose:SkeletonPose, targetPose:SkeletonPose, skeleton:Skeleton):void
		{
			var globalPoses:Vector.<JointPose> = targetPose.jointPoses;
			var globalJointPose:JointPose;
			var joints:Vector.<SkeletonJoint> = skeleton.joints;
			var len:uint = sourcePose.numJointPoses;
			var jointPoses:Vector.<JointPose> = sourcePose.jointPoses;
			var parentIndex:int;
			var joint:SkeletonJoint;
			var parentPose:JointPose;
			var pose:JointPose;
			var or:Quaternion;
			var tr:Vector3D;
			var gTra:Vector3D;
			var gOri:Quaternion;

			var x1:Number, y1:Number, z1:Number, w1:Number;
			var x2:Number, y2:Number, z2:Number, w2:Number;
			var x3:Number, y3:Number, z3:Number;

			//初始化全局骨骼姿势长度
			if (globalPoses.length != len)
				globalPoses.length = len;

			for (var i:uint = 0; i < len; ++i)
			{
				//初始化单个全局骨骼姿势
				globalJointPose = globalPoses[i] ||= new JointPose();
				joint = joints[i];
				parentIndex = joint.parentIndex;
				pose = jointPoses[i];

				//全局方向偏移
				gOri = globalJointPose.orientation;
				//全局位置偏移
				gTra = globalJointPose.translation;

				//计算全局骨骼的 方向偏移与位置偏移
				//处理跟骨骼(直接赋值)
				tr = pose.translation;
				or = pose.orientation;
				gOri.x = or.x;
				gOri.y = or.y;
				gOri.z = or.z;
				gOri.w = or.w;
				gTra.x = tr.x;
				gTra.y = tr.y;
				gTra.z = tr.z;
			}
		}
	}
}
