package
{
	import flash.display3D.Context3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;

	import me.feng3d.parsers.mdl.FBitmap;

	/**
	 *
	 * @author warden_feng 2014-6-29
	 */
	public class Mesh
	{
		public var positionsBuffer:VertexBuffer3D;
		public var uvBuffer:VertexBuffer3D;
		public var colorsBuffer:VertexBuffer3D;
		public var indexBuffer:IndexBuffer3D;
		public var indexBufferCount:int;

		public var context3D:Context3D;
		private var _indexs:Vector.<uint>;
		private var _uvs:Vector.<Number>;
		private var _positions:Vector.<Number>;

		private var _fBitmap:FBitmap;

		public function Mesh()
		{
		}

		public function set indexs(value:Vector.<uint>):void
		{
			_indexs = value;
			indexBufferCount = _indexs.length / 3;
			if (!indexBuffer)
			{
				indexBuffer = context3D.createIndexBuffer(_indexs.length);
				indexBuffer.uploadFromVector(_indexs, 0, _indexs.length);
			}
		}

		public function set uvs(value:Vector.<Number>):void
		{
			_uvs = value;
			var uvsCount:uint = _uvs.length / 2;
			if (!uvBuffer)
			{
				uvBuffer = context3D.createVertexBuffer(uvsCount, 2);
			}
			uvBuffer.uploadFromVector(_uvs, 0, uvsCount);
		}

		public function set positions(value:Vector.<Number>):void
		{
			_positions = value;
			var vertexCount:uint = _positions.length / 3;
			if (!positionsBuffer)
			{
				positionsBuffer = context3D.createVertexBuffer(vertexCount, 3);
			}
			positionsBuffer.uploadFromVector(_positions, 0, vertexCount);
		}

		public function getTexture():Texture
		{
			var texture:Texture = TextureLib.getTexture(fBitmap, context3D);
			return texture;
		}

		public function get fBitmap():FBitmap
		{
			return _fBitmap;
		}

		public function set fBitmap(value:FBitmap):void
		{
			_fBitmap = value;
		}

	}
}
