package me.feng3d.fagal.fragment
{
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 光泽图取样函数
	 * @author feng 2014-10-23
	 */
	public function F_SpecularSample():void
	{
		var _:* = FagalRE.instance.space;

		//获取纹理数据
		_.tex(_.specularTexData_ft_4, _.uv_v, _.specularTexture_fs);
	}
}
