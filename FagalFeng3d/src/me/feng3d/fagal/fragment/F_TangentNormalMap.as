package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterArray;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 编译切线法线贴图片段程序
	 * @author feng 2014-11-7
	 */
	public function F_TangentNormalMap():void
	{
		var _:* = FagalRE.instance.space;

		//此处必须三个寄存器申请为寄存器数组来确保三个临时寄存器连续与同时销毁
		var normalMxt3:RegisterArray = _.getFreeTemps("动画后顶点法线空间寄存器向量，(切线，双切线，法线)", 3);

		var t:Register = normalMxt3.getReg(0);
		var b:Register = normalMxt3.getReg(1);
		var n:Register = normalMxt3.getReg(2);

		//标准化切线
		_.nrm(t.xyz, _.tangent_v);
		//保存w不变
		_.mov(t.w, _.tangent_v.w);
		//标准化双切线
		_.nrm(b.xyz, _.bitangent_v);
		//标准化法线
		_.nrm(n.xyz, _.normal_v);

		F_NormalSample();

		//标准化法线纹理数据
		_.m33(_.normal_ft_4.xyz, _.normalTexData_ft_4, t);
		//保存w不变
		_.mov(_.normal_ft_4.w, _.normal_v.w);
	}
}
