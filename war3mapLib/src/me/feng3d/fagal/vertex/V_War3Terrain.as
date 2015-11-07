package me.feng3d.fagal.vertex
{
	import flash.display3D.Context3DProgramType;
	
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterMatrix;
	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 魔兽争霸3地形顶点渲染程序
	 * @author warden_feng 2014-12-11
	 */
	public class V_War3Terrain extends FagalMethod
	{
		public function V_War3Terrain()
		{
			_shaderType = Context3DProgramType.VERTEX;
		}

		override public function runFunc():void
		{
			var _:* = FagalRE.instance.space;
			
			//顶点坐标数据
			var position:Register = _.position_va_3;
			//war3地形贴图u坐标数据
			var uReg:Register = _.war3TerrainU_va_4;
			//war3地形贴图v坐标数据
			var vReg:Register = _.war3TerrainV_va_4;
			//顶点程序投影矩阵静态数据
			var projection:RegisterMatrix = _.projection_vc_matrix;
			//war3地形贴图u坐标变量数据
			var uVarying:Register = _.war3TerrainU_v;
			//war3地形贴图v坐标变量数据
			var vVarying:Register = _.war3TerrainV_v;
			//位置输出寄存器
			var out:Register = _._op;

			_.m44(out, position, projection);
			_.mov(uVarying, uReg);
			_.mov(vVarying, vReg);
		}

	}
}
