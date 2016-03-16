package me.feng3d.fagal.vertex
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterMatrix;
	import me.feng3d.fagal.RegisterComponent;
	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 魔兽争霸3地形顶点渲染程序
	 * @author warden_feng 2014-12-11
	 */
	public class V_War3Terrain1 extends FagalMethod
	{
		public function V_War3Terrain1()
		{
			_shaderType = Context3DProgramType.VERTEX;
		}

		override public function runFunc():void
		{
			var _:* = FagalRE.instance.space;

			//顶点坐标数据
			var position:Register = _.position_va_3;
			//顶点程序投影矩阵静态数据
			var projection:RegisterMatrix = _.projection_vc_matrix;
			//位置输出寄存器
			var out:Register = _._op;

			_.m44(out, position, projection);

			var uvIndices:Register = _.war3TerrainUVIndices_va_4;
			var temp:Register = _.getFreeTemp("uv值");

			//处理第0个uv索引
			uvIndexToValue(temp,uvIndices.c(0));
			_.mov(_.war3TerrainUV0_v,temp);
			//处理第1个uv索引
			uvIndexToValue(temp,uvIndices.c(1));
			_.mov(_.war3TerrainUV1_v,temp);

			//处理第3个uv索引
			uvIndexToValue(temp,uvIndices.c(2));
			_.mov(_.war3TerrainUV2_v,temp);
			//处理第4个uv索引
			uvIndexToValue(temp,uvIndices.c(3));
			_.mov(_.war3TerrainUV3_v,temp);

			_.mov(_.war3TerrainUVWeights_v,_.war3TerrainUVWeights_va_4);
		}

		private function uvIndexToValue(temp:Register,uvIndex:RegisterComponent):void
		{
			//令(uvIndex = 20),一排的数量=16,temp=(0,0,0,0)

			var _:* = FagalRE.instance.space;

			var war3TerrainVC:Register = _.war3Terrain_vc_vector;
			_.mul(temp.x,uvIndex,war3TerrainVC.y);//索引 x (1/一排的数量 )				->	temp=(20/16,0,0,0)
			_.frc(temp.z,temp.x);//取小数部分											->	temp=(20/16,0,4/16,0)
			_.sub(temp.w,temp.x,temp.z);//取整数部分									->	temp=(20/16,0,4/16,1)

			_.mov(temp.x,temp.z);//小数部分 即为U值										->	temp=(4/16,0,4/16,1)
			_.mul(temp.y,temp.w,war3TerrainVC.y);//整数部分 乘以 (1/一排的数量 ) = V值		->	temp=(4/16,1/16,4/16,1)

			_.mov(temp.zw,war3TerrainVC.zw);
		}
	}
}


