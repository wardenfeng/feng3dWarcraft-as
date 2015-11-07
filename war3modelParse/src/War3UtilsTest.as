package
{
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import me.feng3d.core.math.Quaternion;
	import me.feng3d.utils.War3Utils;


	/**
	 *
	 * @author warden_feng 2014-6-28
	 */
	public class War3UtilsTest extends Sprite
	{
		public function War3UtilsTest()
		{
			var pivotPoint:Vector3D = new Vector3D();
			var ScalingVector:Vector3D = new Vector3D();
			var RotationVector:Quaternion = new Quaternion();
			var TranslationVector:Vector3D = new Vector3D();
			
			pivotPoint.x=-4.59534;
			pivotPoint.y=-24.4854;
			pivotPoint.z=99.6824;
			
			TranslationVector.x=0;
			TranslationVector.y=0;
			TranslationVector.z=0;
			
			ScalingVector.x=1;
			ScalingVector.y=1;
			ScalingVector.z=1;
			
			RotationVector.x=0.194821;
			RotationVector.y=-0.391805;
			RotationVector.z=-0.282366;
			RotationVector.w=0.8537;

			var pScalingCenter:Vector3D = pivotPoint;
			var pScalingRotation:Quaternion = null;
			var pRotationCenter:Vector3D = pivotPoint;

			var c_transformation:Matrix3D = War3Utils.D3DXMatrixTransformation(pScalingCenter, pScalingRotation, ScalingVector, pRotationCenter, RotationVector, TranslationVector);

			var rawData:Vector.<Number> = c_transformation.rawData;

			var str:String = "";
			for (var i:int = 0; i < rawData.length; i++) 
			{
				if(i%4 == 0)
					str+="\n";
				var data:Number = rawData[i];
				data = int(data*1000000+0.5)/1000000;
				str+=data+",";
			}
			trace(str);
		}
	}
}
