package me.feng3d.war3.blp
{
	import flash.display.Bitmap;
	import flash.utils.ByteArray;

	/**
	 * blp贴图数据
	 * @author warden_feng 2014-7-20
	 */
	public class BlpData
	{
		/** 文件标记 */
		public var szTag:String;
		/** 是否压缩 */
		public var uCompress:uint;
		public var uNumMipMaps:uint;
		public var width:uint;
		public var height:uint;
		public var uPicType:uint;
		public var uPicSubType:uint;

		public var uMipmapOffset:Vector.<uint> = new Vector.<uint>(16);
		public var uMipmapSize:Vector.<uint> = new Vector.<uint>(16);

		public var jpegData:ByteArray;

		public var bitmap:Bitmap;

		public function BlpData()
		{
		}
	}
}
