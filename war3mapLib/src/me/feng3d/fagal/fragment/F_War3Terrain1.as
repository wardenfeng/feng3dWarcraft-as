package me.feng3d.fagal.fragment
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.RegisterComponent;
	import me.feng3d.fagal.methods.FagalMethod;
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

			//颜色输出寄存器
			var out:Register = _._oc;

			var totalColor:Register = _.getFreeTemp("总Color值");
			var tempColor:Register = _.getFreeTemp("临时Color");

			war3Blend(tempColor,_.war3TerrainUV0_v,_.war3TerrainUVWeights_v.c(0));
			_.mov(totalColor,tempColor);
			war3Blend(tempColor,_.war3TerrainUV1_v,_.war3TerrainUVWeights_v.c(1));
			_.add(totalColor,totalColor,tempColor);
			war3Blend(tempColor,_.war3TerrainUV2_v,_.war3TerrainUVWeights_v.c(2));
			_.add(totalColor,totalColor,tempColor);
			war3Blend(tempColor,_.war3TerrainUV3_v,_.war3TerrainUVWeights_v.c(3));
			_.add(totalColor,totalColor,tempColor);

			_.mov(_._oc, totalColor);
//			_.mov(_._oc, _.war3TerrainUV0_v);
		}

		private function war3Blend(tempColor:Register,uv:Register,uvWeightComponent:RegisterComponent):void{

			var _:* = FagalRE.instance.space;

//			var tempUV:Register = _.getFreeTemp("临时uv");

//			_.mov(tempUV,uvSelection);
			_.tex(tempColor, uv, _.war3TerrainTexture_fs);
			_.mul(tempColor,tempColor,uvWeightComponent);
		}
	}
}


