package me.feng3d.parsers.mdl
{
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	/**
	 * 骨骼的位移信息
	 */
	public class BoneScaling
	{
		/** 类型 */
		public var type:String;
		/**  */
		public var GlobalSeqId:int;
		public var scalings:Vector.<Scaling> = new Vector.<Scaling>();

		public var scalingDic:Dictionary = new Dictionary();

		public function getScaling(keyFrameTime:int):Vector3D
		{
			var scalingVector:Vector3D;
			if (scalings.length == 0 || keyFrameTime < scalings[0].time || keyFrameTime > scalings[scalings.length - 1].time)
				return new Vector3D(1, 1, 1);

			var key1:Scaling = scalings[0];
			var key2:Scaling;

			for (var i:int = 0; i < scalings.length; i++)
			{
				key2 = scalings[i];
				if (key2.time >= keyFrameTime)
				{
					break;
				}
				key1 = key2;
			}

			if (key1.time == key2.time)
			{
				scalingVector = key1.value.clone();
				return scalingVector;
			}

			var Factor:Number = (keyFrameTime - key1.time) / (key2.time - key1.time);
			var InverseFactor:Number = 1.0 - Factor;

			var tempVec:Vector3D;
			var Factor1:Number;
			var Factor2:Number;
			var Factor3:Number;
			var Factor4:Number;
			var FactorTimesTwo:Number;
			var InverseFactorTimesTwo:Number;

			switch (type)
			{
				case "DontInterp":
					scalingVector = key1.value.clone();
					break;
				case "Linear":
					scalingVector = new Vector3D();

					tempVec = key1.value.clone();
					tempVec.scaleBy(InverseFactor);
					scalingVector = scalingVector.add(tempVec);

					tempVec = key2.value.clone();
					tempVec.scaleBy(Factor);
					scalingVector = scalingVector.add(tempVec);
					break;
				case "Hermite":
					FactorTimesTwo = Factor * Factor;

					Factor1 = FactorTimesTwo * (2.0 * Factor - 3.0) + 1;
					Factor2 = FactorTimesTwo * (Factor - 2.0) + Factor;
					Factor3 = FactorTimesTwo * (Factor - 1.0);
					Factor4 = FactorTimesTwo * (3.0 - 2.0 * Factor);

					scalingVector = new Vector3D();

					tempVec = key1.value.clone();
					tempVec.scaleBy(Factor1);
					scalingVector = scalingVector.add(tempVec);

					tempVec = key1.OutTan.clone();
					tempVec.scaleBy(Factor2);
					scalingVector = scalingVector.add(tempVec);

					tempVec = key2.InTan.clone();
					tempVec.scaleBy(Factor3);
					scalingVector = scalingVector.add(tempVec);

					tempVec = key2.value.clone();
					tempVec.scaleBy(Factor4);
					scalingVector = scalingVector.add(tempVec);
					break;

				case "Bezier":
					FactorTimesTwo = Factor * Factor;
					InverseFactorTimesTwo = InverseFactor * InverseFactor;

					Factor1 = InverseFactorTimesTwo * InverseFactor;
					Factor2 = 3.0 * Factor * InverseFactorTimesTwo;
					Factor3 = 3.0 * FactorTimesTwo * InverseFactor;
					Factor4 = FactorTimesTwo * Factor;

					scalingVector = new Vector3D();

					tempVec = key1.value.clone();
					tempVec.scaleBy(Factor1);
					scalingVector = scalingVector.add(tempVec);

					tempVec = key1.OutTan.clone();
					tempVec.scaleBy(Factor2);
					scalingVector = scalingVector.add(tempVec);

					tempVec = key2.InTan.clone();
					tempVec.scaleBy(Factor3);
					scalingVector = scalingVector.add(tempVec);

					tempVec = key2.value.clone();
					tempVec.scaleBy(Factor4);
					scalingVector = scalingVector.add(tempVec);
					break;
			}

			return scalingVector;
		}
	}
}
