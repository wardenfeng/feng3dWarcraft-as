package me.feng3d.library.assets
{

	public interface IAsset
	{
		/**
		 * 名称
		 */
		function get name():String;

		function set name(val:String):void;

		/** 资源类型 */
		function get assetType():String;
	}
}
