package me.feng3d.parsers.mdl
{
	import flash.utils.Dictionary;

	import me.feng3d.mathlib.Quaternion;

	/**
	 * 骨骼的角度信息
	 */
	public class BoneRotation
	{
		/** 类型 */
		public var type:String;
		/** */
		public var GlobalSeqId:int;

		public var rotations:Vector.<Rotation> = new Vector.<Rotation>();

		public var rotationDic:Dictionary = new Dictionary();

		public function getRotation(keyFrameTime:int):Quaternion
		{
			var RotationQuaternion:Quaternion;
			if (rotations.length == 0 || keyFrameTime < rotations[0].time || keyFrameTime > rotations[rotations.length - 1].time)
				return new Quaternion();

			var key1:Rotation = rotations[0];
			var key2:Rotation;

			for (var i:int = 0; i < rotations.length; i++)
			{
				key2 = rotations[i];
				if (key2.time > keyFrameTime)
				{
					break;
				}
				key1 = key2;
			}

			if (key1 == key2)
			{
				RotationQuaternion = key1.value.clone();
				return RotationQuaternion;
			}

			var Factor:Number = (keyFrameTime - key1.time) / (key2.time - key1.time);
			var InverseFactor:Number = 1.0 - Factor;

			var tempVec:Quaternion;
			var Factor1:Number;
			var Factor2:Number;
			var Factor3:Number;
			var Factor4:Number;
			var FactorTimesTwo:Number;
			var InverseFactorTimesTwo:Number;

			var q:Quaternion;
			var q1:Quaternion;
			var q2:Quaternion;

			switch (type)
			{
				case "DontInterp":
					RotationQuaternion = key1.value.clone();
					RotationQuaternion.fromEulerAngles(key1.value.x, key1.value.y, key1.value.z);
					break;
				case "Linear":
					RotationQuaternion = new Quaternion();

					q1 = key1.value.clone();
					q2 = key2.value.clone();

					RotationQuaternion.slerp(q1, q2, Factor);
					break;
				case "Hermite":
				case "Bezier":
					RotationQuaternion = new Quaternion();

					q1 = key1.value.clone();
					q2 = key2.value.clone();

					RotationQuaternion.slerp(q1, q2, Factor);
					break;
			}

			return RotationQuaternion;
		}
	}
}


