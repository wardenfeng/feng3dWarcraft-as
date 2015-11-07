package me.feng3d.core.buffer.context3d
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Matrix3D;

	import me.feng3d.arcanefagal;

	use namespace arcanefagal;

	/**
	 * Context3D 片段矩阵常量数据缓存
	 * @author feng 2014-8-20
	 */
	public class FCMatrixBuffer extends ConstantsBuffer
	{
		/** 静态矩阵数据 */
		arcanefagal var matrix:Matrix3D;

		/** transposedMatrix 如果为 true，则将按颠倒顺序将矩阵条目复制到寄存器中。默认值为 false。 */
		arcanefagal var transposedMatrix:Boolean;

		/**
		 * 创建片段矩阵常量数据缓存
		 * @param dataTypeId 		数据编号
		 * @param updateFunc 		数据更新回调函数
		 */
		public function FCMatrixBuffer(dataTypeId:String, updateFunc:Function)
		{
			super(dataTypeId, updateFunc);
		}

		/**
		 * @inheritDoc
		 */
		override arcanefagal function doBuffer(context3D:Context3D):void
		{
			doUpdateFunc();

			context3D.setProgramConstantsFromMatrix(Context3DProgramType.FRAGMENT, firstRegister, matrix, false);
		}

		/**
		 * 更新
		 * @param matrix
		 * @param transposedMatrix
		 */
		public function update(matrix:Matrix3D, transposedMatrix:Boolean = false):void
		{
			this.matrix = matrix;
			this.transposedMatrix = transposedMatrix;
		}
	}
}
