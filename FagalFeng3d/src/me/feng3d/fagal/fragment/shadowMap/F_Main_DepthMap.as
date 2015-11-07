package me.feng3d.fagal.fragment.shadowMap
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 深度图片段主程序
	 * @author feng 2015-5-30
	 */
	public class F_Main_DepthMap extends FagalMethod
	{
		/**
		 * 创建深度图片段主程序
		 */
		public function F_Main_DepthMap()
		{
			_shaderType = Context3DProgramType.FRAGMENT;
		}

		/**
		 * @inheritDoc
		 */
		override public function runFunc():void
		{
			var _:* = FagalRE.instance.space;

			var positionReg:Register = _.getFreeTemp("坐标"); //ft2
			//深度的（乘以1,255,255*255,255*255*255后）不同值
			var depthValueReg:Register = _.getFreeTemp("深度值");

			var ft1:Register = _.getFreeTemp("");

			//计算深度值depth属于（0,1）,该范围外的将会被frc处理为0或1
			_.div(positionReg, _.positionProjected_v, _.positionProjected_v.w);
			//深度值保存为颜色值
			_.mul(depthValueReg, _.depthCommonData0_fc_vector, positionReg.z);
			//和上行代码配合，保存了深度的1/255/255/255的精度的值
			_.frc(depthValueReg, depthValueReg);
			//计算多余的值
			_.mul(ft1, depthValueReg.yzww, _.depthCommonData1_fc_vector);
			//真正的深度值 = 减去多余的(1/255)值  （精度在1/255/255/255）
			_.sub(_.depthMap_oc, depthValueReg, ft1);


		/*
片段着色器计算貌似有些高深。。,
其目的是使用rgba高精度方式保存深度值，并且可以从rgba中获取深度值。
此处应把深度看为255进制数据，rgba分别保存4个位(1，1/255，1/255/255,1/255/255/255)的值。
此处使用rgba分别保存（1，1/255,1/255/255,1/255/255/255）这4个不同精度的值
depth = r*1 + g/255 + b/255/255 + a/255/255/255 + x；此处有depth,r,g,b,a属于(0,1)范围;地处x<1/255/255/255,x可忽略不计

正常计算rgba的方法
r=frc(depth)-frc(depth*255)/255;
g=frc(depth*255)-frc(depth*255*255)/255;
b=frc(depth*255*255)-frc(depth*255*255)/255;
a=frc(depth*255*255*255)-frc(depth*255*255*255*255)/255;
由于无法生成depth*255*255*255*255的值，精度就定在1/255/255/255，精度只会在1/255/255/255出有损失
因此 a= frc(depth*255*255*255)


通过渲染程序推倒
mul ft0, fc0, ft2.z 		=> depth*(1,255,255*255,255*255*255)=(depth,depth*255,depth*255*255,depth*255*255*255)
frc ft0, ft0				=> (frc(depth),frc(depth*255),frc(depth*255*255),frc(depth*255*255*255))
mul ft1, ft0.yzww, fc1		=>	(frc(depth*255)/255,frc(depth*255*255)/255,frc(depth*255*255*255)/255,0)
sub oc, ft0, ft1			=>	(frc(depth)-frc(depth*255)/255,frc(depth*255)-frc(depth*255*255)/255,frc(depth*255*255)-frc(depth*255*255*255)/255,frc(depth*255*255*255))
=>	(r,g,b,a)
*/
		}
	}
}
