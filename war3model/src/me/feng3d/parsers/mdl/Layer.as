package me.feng3d.parsers.mdl
{
	
	/**
	 * 材质层
	 * @author warden_feng 2014-6-26
	 */
	public class Layer
	{
		/** 过滤模式 */
		public var FilterMode:String;
		/** 贴图ID */
		public var TextureID:int;
		/** 透明度 */
		public var Alpha:Number;
		/** 是否有阴影 */
		public var Unshaded:Boolean;
		/** 是否无雾化 */
		public var Unfogged:Boolean;
		/** 是否双面 */
		public var TwoSided:Boolean;
		/** 是否开启地图环境范围 */
		public var SphereEnvMap:Boolean;
		/** 是否无深度测试 */
		public var NoDepthTest:Boolean;
		/** 是否无深度设置 */
		public var NoDepthSet:Boolean;
	}
}