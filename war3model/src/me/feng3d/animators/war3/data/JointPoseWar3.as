package me.feng3d.animators.war3.data
{
	import flash.geom.Matrix3D;
	
	import me.feng3d.animators.skeleton.data.JointPose;

	/**
	 * war3关节pose
	 * @author warden_feng 2014-6-28
	 */
	public class JointPoseWar3 extends JointPose
	{
		public var transformation:Matrix3D;

		public function JointPoseWar3()
		{
			super();
		}
	}
}
