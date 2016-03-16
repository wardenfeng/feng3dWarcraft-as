package me.feng3d.fagal.fragment
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagal.params.WarcraftShaderParams;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 魔兽争霸3地形片段渲染程序
	 * @author warden_feng 2014-12-11
	 */
	public class F_War3Terrain1 extends FagalMethod
	{
		public function F_War3Terrain1()
		{
			_shaderType = Context3DProgramType.FRAGMENT;
		}

		override public function runFunc():void
		{
			var _:* = FagalRE.instance.space;

			//war3地形贴图u坐标变量数据
			var uVarying:Register = _.war3TerrainU_v;
			//war3地形贴图v坐标变量数据
			var vVarying:Register = _.war3TerrainV_v;
			//war3地形uv权重变量数据
			var uvWeightVarying:Register = _.war3TerrainUVWeights_v;
			//war3地形纹理
			var texturefs:Register = _.war3TerrainTexture_fs;

			//颜色输出寄存器
			var out:Register = _._oc;

			var targetReg:Register = _.getFreeTemp("目标寄存器，用于计算最终颜色值");
			//缩放后的uv坐标、uv计算后的颜色值
			var uvTemp:Register = _.getFreeTemp("缩放后的uv坐标");
			//纹理混合比率
			var blendingReg:Register = _.getFreeTemp("纹理混合比率");
			var tempColor:Register = _.getFreeTemp("临时Color");

			_.mov(uvTemp, uVarying);
			_.mov(blendingReg, uvWeightVarying);

			var i:int;
			for (i = 0; i < 4; ++i)
			{
				_.mov(uvTemp.c(0), uVarying.c(i)); //获取第i个贴图u值
				_.mov(uvTemp.c(1), vVarying.c(i)); //获取第i个贴图v值
				//				code += "tex " + uvTemp + ", " + uvTemp + ", fs[" + tindexVarying.c(i) + "] <2d,linear,miplinear,wrap>\n"; // 使用第i个贴图
				//				code += "tex " + uvTemp + ", " + uvTemp + ", fs" + i + " <2d,linear,miplinear,wrap>\n"; // 使用第i个贴图
				_.tex(tempColor, uvTemp, texturefs); // 使用混合地形贴图

				_.mul(tempColor,tempColor,blendingReg.c(i));

				if (i == 0)
				{
					//初始化第一个贴图值
					_.mov(targetReg, tempColor);
				}
				else
				{
					_.add(targetReg,targetReg,tempColor);
				}
			}
			_.mov(out, targetReg);
		}
	}
}



