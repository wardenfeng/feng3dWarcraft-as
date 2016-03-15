package me.feng3d.fagal.fragment
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterArray;
	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagal.params.WarcraftShaderParams;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 魔兽争霸3地形片段渲染程序
	 * @author warden_feng 2014-12-11
	 */
	public class F_War3Terrain extends FagalMethod
	{
		public function F_War3Terrain()
		{
			_shaderType = Context3DProgramType.FRAGMENT;
		}

		override public function runFunc():void
		{
			var _:* = FagalRE.instance.space;

			var warcraftShaderParams:WarcraftShaderParams = shaderParams.getOrCreateComponentByClass(WarcraftShaderParams);

			//土壤纹理个数
			var numSplattingLayers:int = warcraftShaderParams.splatNum_war3Terrain;

			//war3地形贴图u坐标变量数据
			var uVarying:Register = _.war3TerrainU_v;
			//war3地形贴图v坐标变量数据
			var vVarying:Register = _.war3TerrainV_v;
			//war3地形纹理列表
			var splatFsarr:RegisterArray = _.war3TerrainTexture_fs_array;
			//颜色输出寄存器
			var out:Register = _._oc;

			var targetReg:Register = _.getFreeTemp("目标寄存器，用于计算最终颜色值");
			//缩放后的uv坐标、uv计算后的颜色值
			var uvTemp:Register = _.getFreeTemp("缩放后的uv坐标");
			//纹理混合比率
			var blendingReg:Register = _.getFreeTemp("纹理混合比率");

			_.mov(uvTemp, uVarying);
			_.mov(blendingReg, uVarying);

			var i:int;
			for (i = 0; i < numSplattingLayers; ++i)
			{
				_.mov(uvTemp.c(0), uVarying.c(i)); //获取第i个贴图u值
				_.mov(uvTemp.c(1), vVarying.c(i)); //获取第i个贴图v值
				//				code += "tex " + uvTemp + ", " + uvTemp + ", fs[" + tindexVarying.c(i) + "] <2d,linear,miplinear,wrap>\n"; // 使用第i个贴图
				//				code += "tex " + uvTemp + ", " + uvTemp + ", fs" + i + " <2d,linear,miplinear,wrap>\n"; // 使用第i个贴图
				_.tex(uvTemp, uvTemp, splatFsarr.getReg(i)); // 使用第i个贴图

				if (i == 0)
				{
					//初始化第一个贴图值
					_.mov(targetReg, uvTemp);
				}
				else
				{
					_.mov(blendingReg.c(i), uvTemp.w);

					//混合操作
					_.sub(uvTemp, uvTemp, targetReg); // uvtemp(保存的纹理值) = uvtemp - targetreg; --------------1
					_.mul(uvTemp, uvTemp, blendingReg.c(i)); // uvtemp = uvtemp * blendtemp; ----------2  (0 <= blendtemp <= 1)
					_.add(targetReg, targetReg, uvTemp); // 添加到默认颜色值上  targetreg = targetreg + uvtemp; ------------3
						//由 1代入2得		uvtemp = (uvtemp - targetreg) * blendtemp; ----------------4
						//由 4代入3得		targetreg = targetreg + (uvtemp - targetreg) * blendtemp; -------------------5
						//整理5得			targetreg = targetreg * (1 - blendtemp) + uvtemp * blendtemp; (0 <= blendtemp <= 1) -----------------6 
						//公式6很容易看出是平分公式，由此得 引用1、2、3的渲染代码是为了节约变量与计算次数的平分运算。(至少节约1个变量与一次运算)
				}
			}
			_.mov(out, targetReg);
		}
	}
}


