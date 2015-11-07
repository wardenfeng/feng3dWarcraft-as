package me.feng3d.entities
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import me.feng3d.arcane;
	import me.feng3d.core.base.subgeometry.War3TerrainSubGeometry;
	import me.feng3d.materials.War3TerrainMaterial;
	import me.feng3d.war3.map.w3e.W3eTilePoint;

	use namespace arcane;

	/**
	 *
	 * @author warden_feng 2014-8-4
	 */
	public class War3TerrainTile extends Mesh
	{
		public static var stage:Stage;

		private static const TILE_SIZE:int = 128;

		/**
		 * 数据缓冲
		 */
		private var _subGeometry:War3TerrainSubGeometry;
		public var buttonLeft:W3eTilePoint;
		public var topLeft:W3eTilePoint;
		public var topRight:W3eTilePoint;
		public var buttonRight:W3eTilePoint;

		private var _war3Textureuvs:Vector.<Rectangle>;
		public var tileX:uint;
		public var tileZ:uint;
		public var tileTextures:Array;

		public function War3TerrainTile()
		{
			super();
			_subGeometry = new War3TerrainSubGeometry();
			geometry.addSubGeometry(_subGeometry);
		}

		public function buildGeometry():void
		{
			buildVertices();
			buildIndices();

			//贴图u坐标
			var us:Vector.<Number> = new Vector.<Number>(16);
			//贴图v坐标
			var vs:Vector.<Number> = new Vector.<Number>(16);

			var valueDic:Dictionary = new Dictionary();
			//计算4个顶点对于每个贴图的u值(4*4)

			//计算4个贴图的索引块
			if (int(valueDic[buttonLeft.texturetype]) == 0)
			{
				valueDic[buttonLeft.texturetype] = 0;
			}
			valueDic[buttonLeft.texturetype] += 8;

			if (int(valueDic[topLeft.texturetype]) == 0)
			{
				valueDic[topLeft.texturetype] = 0;
			}
			valueDic[topLeft.texturetype] += 2;

			if (int(valueDic[topRight.texturetype]) == 0)
			{
				valueDic[topRight.texturetype] = 0;
			}
			valueDic[topRight.texturetype] += 1;

			if (int(valueDic[buttonRight.texturetype]) == 0)
			{
				valueDic[buttonRight.texturetype] = 0;
			}
			valueDic[buttonRight.texturetype] += 4;

			var textureIndex:int = 0;
			var usedTextures:Array = [];
			for (var texturetype:String in valueDic)
			{
				var uvIndex:int = valueDic[texturetype];
				var rct:Rectangle = war3Textureuvs[uvIndex];

				us[textureIndex] = rct.left;
				us[4 + textureIndex] = rct.left;
				us[8 + textureIndex] = rct.right;
				us[12 + textureIndex] = rct.right;

				vs[textureIndex] = rct.bottom;
				vs[4 + textureIndex] = rct.top;
				vs[8 + textureIndex] = rct.top;
				vs[12 + textureIndex] = rct.bottom;

				usedTextures[textureIndex] = tileTextures[texturetype];
				textureIndex++;
			}

			material = new War3TerrainMaterial(usedTextures);

			_subGeometry.updateUData(us);
			_subGeometry.updateVData(vs);

//			testBitmap(usedTextures);
		}

		private function testBitmap(usedTextures:Array):void
		{
			bitmap.bitmapData = usedTextures[0].bitmapData;
			stage.addChild(bitmap);

			bitmap1.bitmapData = usedTextures[1].bitmapData;
			bitmap1.x = bitmap.width + 10;
			stage.addChild(bitmap1);

			bitmap2.y = bitmap.height + 10;
			stage.addChild(bitmap2);

			var uData:Vector.<Number> = _subGeometry.uData;
			var vData:Vector.<Number> = _subGeometry.vData;

			var mat:Matrix = new Matrix();
			var bitmapData1:BitmapData = new BitmapData(bitmap.width, bitmap.height, true, 0x0);
			mat.translate(-uData[0] * bitmap1.width, -vData[0] * bitmap1.height);
			mat.scale(4, 4);
			bitmapData1.draw(bitmap.bitmapData, mat, null, null, null, false);

			var bitmapData2:BitmapData = new BitmapData(bitmap.width, bitmap.height, true, 0x0);
			mat = new Matrix();
			mat.translate(-uData[1] * bitmap1.width, -vData[1] * bitmap1.height);
			mat.scale(4, 4);
			bitmapData2.draw(bitmap1.bitmapData, mat, null, null, null, false);

			for (var i:int = 0; i < bitmapData2.width; i++)
			{
				for (var j:int = 0; j < bitmapData2.height; j++)
				{
					var color1:uint = bitmapData1.getPixel32(i, j);
					var color2:uint = bitmapData2.getPixel32(i, j);
					if (color2 == 0)
					{
						bitmapData2.setPixel32(i, j, color1);
					}
				}
			}

			bitmap2.bitmapData = bitmapData2;
		}

		private var bitmap:Bitmap = new Bitmap();
		private var bitmap1:Bitmap = new Bitmap();
		private var bitmap2:Bitmap = new Bitmap();

		private function buildIndices():void
		{
			var indices:Vector.<uint> = new Vector.<uint>(6, true);
			//两个三角形（6个索引）
			indices[0] = 0; //
			indices[1] = 1; //
			indices[2] = 2; //
			indices[3] = 2; //
			indices[4] = 3; //
			indices[5] = 0; //
			_subGeometry.updateIndexData(indices);
		}

		private function buildVertices():void
		{
			var s:Number = 0.1;

			var vertices:Vector.<Number> = new Vector.<Number>(12, true);
			//4个顶点坐标（12个number）
			vertices[0] = 0; //
			vertices[1] = buttonLeft.height * s; //
			vertices[2] = 0; //

			vertices[3] = 0; //
			vertices[4] = topLeft.height * s; //
			vertices[5] = TILE_SIZE; //

			vertices[6] = TILE_SIZE; //
			vertices[7] = topRight.height * s; //
			vertices[8] = TILE_SIZE; //

			vertices[9] = TILE_SIZE; //
			vertices[10] = buttonRight.height * s; //
			vertices[11] = 0; //

			_subGeometry.numVertices = vertices.length / 3;
			_subGeometry.updateVertexPositionData(vertices);
		}

		public function get war3Textureuvs():Vector.<Rectangle>
		{
			if (_war3Textureuvs == null)
			{
				_war3Textureuvs = new Vector.<Rectangle>(32);
				//8列
				for (var i:int = 0; i < 4; i++)
				{
					//4行
					for (var j:int = 0; j < 4; j++)
					{
						_war3Textureuvs[i * 4 + j] = new Rectangle(i / 4, j / 4, 1 / 4, 1 / 4);
					}
				}
			}
			return _war3Textureuvs;
		}
	}
}
