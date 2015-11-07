package me.feng3d.fagal.vertex
{
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 顶点世界坐标渲染函数
	 * @author feng 2014-11-7
	 */
	public function V_WorldPosition():void
	{
		var _:* = FagalRE.instance.space;

		_.comment("场景坐标转换");
		_.m44(_.globalPosition_vt_4, _.animatedPosition_vt_4, _.sceneTransform_vc_matrix);
	}
}
