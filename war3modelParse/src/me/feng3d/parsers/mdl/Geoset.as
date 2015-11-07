package me.feng3d.parsers.mdl
{
	import flash.geom.Vector3D;
	
	/**
	 * 几何设置
	 * @author warden_feng 2014-6-26
	 */
	public class Geoset
	{
		/** 顶点 */
		public var Vertices:Vector.<Number>;
		/** 法线 */
		public var Normals:Vector.<Number>;
		/** 纹理坐标 */
		public var TVertices:Vector.<Number>;
		/** 顶点分组 */
		public var VertexGroup:Vector.<int>;
		/** 面（索引） */
		public var Faces:Vector.<uint>;
		/** 顶点分组 */
		public var Groups:Vector.<Vector.<int>>;
		/** 最小范围 */
		public var MinimumExtent:Vector3D;
		/** 最大范围 */
		public var MaximumExtent:Vector3D;
		/** 半径范围 */
		public var BoundsRadius:Number;
		/** 动作信息 */
		public var Anims:Vector.<AnimInfo1> = new Vector.<AnimInfo1>();
		/** 材质编号 */
		public var MaterialID:int;
		/**  */
		public var SelectionGroup:int;
		/** 是否不可选 */
		public var Unselectable:Boolean;
		
		/** 顶点对应的关节索引 */
		public var jointIndices:Vector.<Number>;
		/** 顶点对应的关节权重 */
		public var jointWeights:Vector.<Number>;
	}
}