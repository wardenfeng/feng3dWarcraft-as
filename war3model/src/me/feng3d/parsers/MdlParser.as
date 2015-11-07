package me.feng3d.parsers
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import me.feng3d.core.math.Quaternion;
	import me.feng3d.parsers.mdl.AnimInfo;
	import me.feng3d.parsers.mdl.AnimInfo1;
	import me.feng3d.parsers.mdl.BoneObject;
	import me.feng3d.parsers.mdl.BoneRotation;
	import me.feng3d.parsers.mdl.BoneScaling;
	import me.feng3d.parsers.mdl.BoneTranslation;
	import me.feng3d.parsers.mdl.FBitmap;
	import me.feng3d.parsers.mdl.Geoset;
	import me.feng3d.parsers.mdl.GeosetAnim;
	import me.feng3d.parsers.mdl.Globalsequences;
	import me.feng3d.parsers.mdl.Interval;
	import me.feng3d.parsers.mdl.Layer;
	import me.feng3d.parsers.mdl.Material;
	import me.feng3d.parsers.mdl.Model;
	import me.feng3d.parsers.mdl.Rotation;
	import me.feng3d.parsers.mdl.Scaling;
	import me.feng3d.parsers.mdl.Translation;
	import me.feng3d.parsers.mdl.War3Model;

	/**
	 * war3的mdl文件解析
	 * @author warden_feng 2014-6-14
	 */
	public class MdlParser extends ParserBase
	{
		/** 字符串数据 */
		private var _textData:String;
		/** 是否开始了解析 */
		private var _startedParsing:Boolean;

		private static const VERSION_TOKEN:String = "Version";
		private static const COMMENT_TOKEN:String = "//";
		private static const MODEL:String = "Model";
		private static const SEQUENCES:String = "Sequences";
		private static const GLOBALSEQUENCES:String = "GlobalSequences";
		private static const TEXTURES:String = "Textures";
		private static const MATERIALS:String = "Materials";
		private static const GEOSET:String = "Geoset";
		private static const GEOSETANIM:String = "GeosetAnim";
		private static const BONE:String = "Bone";
		private static const HELPER:String = "Helper";

		/** 当前解析位置 */
		private var _parseIndex:int;
		/** 是否文件尾 */
		private var _reachedEOF:Boolean;
		/** 当前解析行号 */
		private var _line:int;
		/** 当前行的字符位置 */
		private var _charLineIndex:int;

		private var _war3Model:War3Model;

		public function MdlParser()
		{
			super(ParserDataFormat.PLAIN_TEXT);

			war3Model = new War3Model();
		}

		protected override function proceedParsing():Boolean
		{
			var token:String;

			//标记开始解析
			if (!_startedParsing)
			{
				_textData = getTextData();
				_startedParsing = true;
			}

			var bone:BoneObject;
			var geoset:Geoset

			var junpStr:String;

			while (hasTime())
			{
				//获取关键字
				token = getNextToken();
				switch (token)
				{
					case COMMENT_TOKEN:
						ignoreLine();
						break;
					case VERSION_TOKEN:
						parseVersion();
						break;
					case MODEL:
						war3Model.model = parseModel();
						break;
					case SEQUENCES:
						war3Model.sequences = parseSequences();
						break;
					case GLOBALSEQUENCES:
						war3Model.globalsequences = parseGlobalsequences();
						break;
					case TEXTURES:
						war3Model.textures = parseTextures();
						break;
					case MATERIALS:
						war3Model.materials = parseMaterials();
						break;
					case GEOSET:
						geoset = parseGeoset();
						war3Model.geosets.push(geoset);
						break;
					case GEOSETANIM:
						parseGeosetanim();
						break;
					case BONE:
						bone = parseBone();
						war3Model.bones[bone.ObjectId] = bone;
						break;
					case HELPER:
						bone = parseHelper();
						war3Model.bones[bone.ObjectId] = bone;
						break;
					case "PivotPoints":
						war3Model.pivotPoints = parsePivotPoints();
						break;
					case "ParticleEmitter2":
						parseLiteralString();
						junpStr = jumpChunk();
						break;
					case "EventObject":
						parseLiteralString();
						junpStr = jumpChunk();
						break;
					case "Attachment":
						parseLiteralString();
						junpStr = jumpChunk();
						break;
					case "RibbonEmitter":
						parseLiteralString();
						junpStr = jumpChunk();
						break;
					case "CollisionShape":
						parseLiteralString();
						junpStr = jumpChunk();
						break;
					case "Camera":
						parseLiteralString();
						junpStr = jumpChunk();
						break;
					case "Light":
						parseLiteralString();
						junpStr = jumpChunk();
						break;
					default:
						if (!_reachedEOF)
							sendUnknownKeywordError(token);
				}

				//解析结束后 生成引擎相关对象
				if (_reachedEOF)
				{
					return ParserBase.PARSING_DONE;
				}
			}

			return ParserBase.MORE_TO_PARSE;
		}

		/**
		 * 获取骨骼深度
		 * @param bone
		 * @param bones
		 * @return
		 */
		private function getBoneDepth(bone:BoneObject, bones:Vector.<BoneObject>):int
		{
			if (bone.Parent == -1)
				return 0;
			return getBoneDepth(bones[bone.Parent], bones) + 1;
		}

		/**
		 * 解析版本号
		 */
		private function parseVersion():void
		{
			var token:String = getNextToken();

			if (token != "{")
				sendParseError(token);

			token = getNextToken();
			if (token != "FormatVersion")
				sendUnknownKeywordError(token);

			war3Model._version = getNextInt();

			token = getNextToken();

			if (token != "}")
				sendParseError(token);
		}

		/**
		 * 解析模型数据统计结果
		 */
		private function parseModel():Model
		{
			var model:Model = new Model();

			model.name = parseLiteralString();

			var token:String = getNextToken();

			if (token != "{")
				sendParseError(token);

			var ch:String;
			while (ch != "}")
			{
				ch = getNextToken();
				switch (ch)
				{
					case COMMENT_TOKEN:
						ignoreLine();
						break;
					case "BlendTime":
						model.BlendTime = getNextInt();
						break;
					case "MinimumExtent":
						model.MinimumExtent = parseVector3D();
						break;
					case "MaximumExtent":
						model.MaximumExtent = parseVector3D();
						break;
					case "}":
						break;
					default:
						ignoreLine();
						break;
				}
			}
			return model;
		}

		/**
		 * 解析动作序列
		 */
		private function parseSequences():Vector.<AnimInfo>
		{
			//跳过动作个数
			getNextInt();
			var sequences:Vector.<AnimInfo> = new Vector.<AnimInfo>();

			var token:String = getNextToken();

			if (token != "{")
				sendParseError(token);

			var ch:String;
			while (ch != "}")
			{
				ch = getNextToken();
				switch (ch)
				{
					case COMMENT_TOKEN:
						ignoreLine();
						break;
					case "Anim":
						var anim:AnimInfo = parseAnim();
						sequences.push(anim);
						break;
					case "}":
						break;
					default:
						sendUnknownKeywordError(ch);
						break;
				}
			}
			return sequences;
		}

		/**
		 * 解析全局序列
		 */
		private function parseGlobalsequences():Globalsequences
		{
			var globalsequences:Globalsequences = new Globalsequences();

			globalsequences.id = getNextInt();

			var token:String = getNextToken();

			if (token != "{")
				sendParseError(token);

			var ch:String;
			while (ch != "}")
			{
				ch = getNextToken();
				switch (ch)
				{
					case COMMENT_TOKEN:
						ignoreLine();
						break;
					case "Duration":
						var duration:int = getNextInt();
						globalsequences.durations.push(duration);
						break;
					case "}":
						break;
					default:
						sendUnknownKeywordError(ch);
						break;
				}
			}
			return globalsequences;
		}

		/**
		 * 解析纹理列表
		 */
		private function parseTextures():Vector.<FBitmap>
		{
			//跳过纹理个数
			getNextInt();
			var bitmaps:Vector.<FBitmap> = new Vector.<FBitmap>();

			var token:String = getNextToken();

			if (token != "{")
				sendParseError(token);

			var ch:String;
			while (ch != "}")
			{
				ch = getNextToken();
				switch (ch)
				{
					case COMMENT_TOKEN:
						ignoreLine();
						break;
					case "Bitmap":
						var bitmap:FBitmap = parseBitmap();
						bitmaps.push(bitmap);
						break;
					case "}":
						break;
					default:
						sendUnknownKeywordError(ch);
						break;
				}
			}
			return bitmaps;
		}

		/**
		 * 解析材质
		 */
		private function parseMaterials():Vector.<Material>
		{
			//跳过纹理个数
			getNextInt();
			var materials:Vector.<Material> = new Vector.<Material>();

			var token:String = getNextToken();

			if (token != "{")
				sendParseError(token);

			var ch:String;
			while (ch != "}")
			{
				ch = getNextToken();
				switch (ch)
				{
					case COMMENT_TOKEN:
						ignoreLine();
						break;
					case "Material":
						var material:Material = parseMaterial();
						materials.push(material);
						break;
					case "}":
						break;
					default:
						sendUnknownKeywordError(ch);
						break;
				}
			}
			return materials;
		}

		private function parseGeoset():Geoset
		{
			var geoset:Geoset = new Geoset();

			var token:String = getNextToken();

			if (token != "{")
				sendParseError(token);

			var ch:String;
			while (ch != "}")
			{
				ch = getNextToken();
				switch (ch)
				{
					case COMMENT_TOKEN:
						ignoreLine();
						break;
					case "Vertices":
						geoset.Vertices = parseVertices();
						break;
					case "Normals":
						geoset.Normals = parseNormals();
						break;
					case "TVertices":
						geoset.TVertices = parseTVertices();
						break;
					case "VertexGroup":
						geoset.VertexGroup = parseVertexGroup();
						break;
					case "Faces":
						geoset.Faces = parseFaces();
						break;
					case "Groups":
						geoset.Groups = parseGroups();
						break;
					case "MinimumExtent":
						geoset.MinimumExtent = parseVector3D();
						break;
					case "MaximumExtent":
						geoset.MaximumExtent = parseVector3D();
						break;
					case "BoundsRadius":
						geoset.BoundsRadius = getNextNumber();
						break;
					case "Anim":
						var anim:AnimInfo1 = parseAnim1();
						geoset.Anims.push(anim);
						break;
					case "MaterialID":
						geoset.MaterialID = getNextInt();
						break;
					case "SelectionGroup":
						geoset.SelectionGroup = getNextInt();
						break;
					case "Unselectable":
						geoset.Unselectable = true;
						break;
					case "}":
						break;
					default:
						sendUnknownKeywordError(ch);
						break;
				}
			}
			return geoset;
		}

		/**
		 * 解析骨骼动画
		 */
		private function parseBone():BoneObject
		{
			var bone:BoneObject = new BoneObject();
			bone.type = "bone";

			bone.name = parseLiteralString();

			var token:String = getNextToken();

			if (token != "{")
				sendParseError(token);

			var ch:String;
			while (ch != "}")
			{
				ch = getNextToken();
				switch (ch)
				{
					case COMMENT_TOKEN:
						ignoreLine();
						break;
					case "ObjectId":
						bone.ObjectId = getNextInt();
						break;
					case "Parent":
						bone.Parent = getNextInt();
						break;
					case "GeosetId":
						bone.GeosetId = getNextToken();
						break;
					case "GeosetAnimId":
						bone.GeosetAnimId = getNextToken();
						break;
					case "Billboarded":
						bone.Billboarded = true;
						break;
					case "Translation":
						parseBoneTranslation(bone.Translation);
						break;
					case "Scaling":
						parseBoneScaling(bone.Scaling);
						break;
					case "Rotation":
						parseBoneRotation(bone.Rotation);
						break;
					case "BillboardedLockZ":
						break;
					case "BillboardedLockY":
						break;
					case "BillboardedLockX":
						break;
					case "}":
						break;
					default:
						sendUnknownKeywordError(ch);
						break;
				}
			}
			return bone;
		}

		/**
		 * 解析骨骼动画
		 */
		private function parseHelper():BoneObject
		{
			var bone:BoneObject = new BoneObject();
			bone.type = "helper";

			bone.name = parseLiteralString();

			var token:String = getNextToken();

			if (token != "{")
				sendParseError(token);

			var ch:String;
			while (ch != "}")
			{
				ch = getNextToken();
				switch (ch)
				{
					case COMMENT_TOKEN:
						ignoreLine();
						break;
					case "ObjectId":
						bone.ObjectId = getNextInt();
						break;
					case "Parent":
						bone.Parent = getNextInt();
						break;
					case "GeosetId":
						bone.GeosetId = getNextToken();
						break;
					case "GeosetAnimId":
						bone.GeosetAnimId = getNextToken();
						break;
					case "Billboarded":
						bone.Billboarded = true;
						break;
					case "Translation":
						parseBoneTranslation(bone.Translation);
						break;
					case "Scaling":
						parseBoneScaling(bone.Scaling);
						break;
					case "Rotation":
						parseBoneRotation(bone.Rotation);
						break;
					case "BillboardedLockX":
						break;
					case "BillboardedLockY":
						break;
					case "BillboardedLockZ":
						break;
					case "DontInherit":
						jumpChunk();
						break;
					case "}":
						break;
					default:
						sendUnknownKeywordError(ch);
						break;
				}
			}
			return bone;
		}

		/**
		 * 解析骨骼角度
		 */
		private function parseBoneScaling(boneScaling:BoneScaling):void
		{
			//跳过长度
			var len:int = getNextInt();

			check("{");
			boneScaling.type = getNextToken();

			var currentIndex:int = _parseIndex;
			var token:String = getNextToken();
			if (token == "GlobalSeqId")
			{
				boneScaling.GlobalSeqId = getNextInt();
			}
			else
			{
				_parseIndex = currentIndex;
			}

			var i:int = 0;
			var scaling:Scaling;
			switch (boneScaling.type)
			{
				case "Hermite":
				case "Bezier":
					for (i = 0; i < len; i++)
					{
						scaling = new Scaling();
						scaling.time = getNextInt();
						scaling.value = parseVector3D();
						scaling[getNextToken()] = parseVector3D();
						scaling[getNextToken()] = parseVector3D();
						boneScaling.scalings.push(scaling);
					}
					break;
				case "Linear":
					for (i = 0; i < len; i++)
					{
						scaling = new Scaling();
						scaling.time = getNextInt();
						scaling.value = parseVector3D();
						boneScaling.scalings.push(scaling);
					}
					break;
				case "DontInterp":
					for (i = 0; i < len; i++)
					{
						scaling = new Scaling();
						scaling.time = getNextInt();
						scaling.value = parseVector3D();
						boneScaling.scalings.push(scaling);
					}
					break;
				default:
					throw new Error("未处理" + boneScaling.type + "类型角度");
			}
			check("}");

		}

		/**
		 * 解析骨骼角度
		 */
		private function parseBoneTranslation(boneTranslation:BoneTranslation):void
		{
			//跳过长度
			var len:int = getNextInt();

			check("{");
			boneTranslation.type = getNextToken();

			var currentIndex:int = _parseIndex;
			var token:String = getNextToken();
			if (token == "GlobalSeqId")
			{
				boneTranslation.GlobalSeqId = getNextInt();
			}
			else
			{
				_parseIndex = currentIndex;
			}

			var i:int = 0;
			var translation:Translation;
			switch (boneTranslation.type)
			{
				case "Hermite":
				case "Bezier":
					for (i = 0; i < len; i++)
					{
						translation = new Translation();
						translation.time = getNextInt();
						translation.value = parseVector3D();
						translation[getNextToken()] = parseVector3D();
						translation[getNextToken()] = parseVector3D();
						boneTranslation.translations.push(translation);
					}
					break;
				case "Linear":
					for (i = 0; i < len; i++)
					{
						translation = new Translation();
						translation.time = getNextInt();
						translation.value = parseVector3D();
						boneTranslation.translations.push(translation);
					}
					break;
				case "DontInterp":
					for (i = 0; i < len; i++)
					{
						translation = new Translation();
						translation.time = getNextInt();
						translation.value = parseVector3D();
						boneTranslation.translations.push(translation);
					}
					break;
				default:
					throw new Error("未处理" + boneTranslation.type + "类型角度");
			}
			check("}");

		}

		/**
		 * 解析骨骼角度
		 */
		private function parseBoneRotation(boneRotation:BoneRotation):void
		{
			var len:int = getNextInt();

			check("{");
			boneRotation.type = getNextToken();

			var currentIndex:int = _parseIndex;
			var token:String = getNextToken();
			if (token == "GlobalSeqId")
			{
				boneRotation.GlobalSeqId = getNextInt();
			}
			else
			{
				_parseIndex = currentIndex;
			}

			var i:int = 0;
			var rotation:Rotation;
			switch (boneRotation.type)
			{
				case "Hermite":
				case "Bezier":
					for (i = 0; i < len; i++)
					{
						rotation = new Rotation();
						rotation.time = getNextInt();
						rotation.value = parseVector3D4();
						rotation[getNextToken()] = parseVector3D4();
						rotation[getNextToken()] = parseVector3D4();
						boneRotation.rotations.push(rotation);
					}
					break;
				case "Linear":
					for (i = 0; i < len; i++)
					{
						rotation = new Rotation();
						rotation.time = getNextInt();
						rotation.value = parseVector3D4();
						boneRotation.rotations.push(rotation);
					}
					break;
				case "DontInterp":
					for (i = 0; i < len; i++)
					{
						rotation = new Rotation();
						rotation.time = getNextInt();
						rotation.value = parseVector3D4();
						boneRotation.rotations.push(rotation);
					}
					break;
				default:
					throw new Error("未处理" + boneRotation.type + "类型角度");
			}
			check("}");

		}

		/**
		 * 解析多边形动画
		 */
		private function parseGeosetanim():GeosetAnim
		{
			var jumpStr:String = jumpChunk();

			return null;

			if (war3Model.geosetAnims == null)
				war3Model.geosetAnims = new Vector.<GeosetAnim>;
			var geosetAnim:GeosetAnim = new GeosetAnim();
			war3Model.geosetAnims.push(geosetAnim);

			var token:String = getNextToken();

			if (token != "{")
				sendParseError(token);

			var ch:String;
			while (ch != "}")
			{
				ch = getNextToken();
				switch (ch)
				{
					case COMMENT_TOKEN:
						ignoreLine();
						break;
					case "Alpha":
//						parseAnimAlpha();
						break;
					case "}":
						break;
					default:
						sendUnknownKeywordError(ch);
						break;
				}
			}
			return geosetAnim;
		}

		/**
		 * 解析顶点
		 */
		private function parseVertices():Vector.<Number>
		{
			var vertices:Vector.<Number> = new Vector.<Number>();

			//跳过长度
			var len:int = getNextInt();
			var token:String = getNextToken();

			if (token != "{")
				sendParseError(token);

			var vertex:Vector3D;
			for (var i:int = 0; i < len; i++)
			{
				vertex = parseVector3D();
				vertices.push(vertex.x, vertex.y, vertex.z);
			}

			token = getNextToken();
			if (token != "}")
				sendParseError(token);

			return vertices;
		}

		/**
		 * 解析法线
		 */
		private function parseNormals():Vector.<Number>
		{
			var normals:Vector.<Number> = new Vector.<Number>();

			//跳过长度
			var len:int = getNextInt();
			var token:String = getNextToken();

			if (token != "{")
				sendParseError(token);

			var vertex:Vector3D;
			for (var i:int = 0; i < len; i++)
			{
				vertex = parseVector3D();
				normals.push(vertex.x, vertex.y, vertex.z);
			}

			token = getNextToken();
			if (token != "}")
				sendParseError(token);

			return normals;
		}

		/**
		 * 解析纹理坐标
		 */
		private function parseTVertices():Vector.<Number>
		{
			var tVertices:Vector.<Number> = new Vector.<Number>();

			//跳过长度
			var len:int = getNextInt();
			var token:String = getNextToken();

			if (token != "{")
				sendParseError(token);

			var uv:Point;
			for (var i:int = 0; i < len; i++)
			{
				uv = parsePoint();
				tVertices.push(uv.x, uv.y);
			}

			token = getNextToken();
			if (token != "}")
				sendParseError(token);

			return tVertices;
		}

		/**
		 * 解析顶点分组
		 */
		private function parseVertexGroup():Vector.<int>
		{
			var vertexGroup:Vector.<int> = new Vector.<int>();

			var token:String = getNextToken();

			if (token != "{")
				sendParseError(token);

			token = getNextToken();
			while (token != "}")
			{
				vertexGroup.push(token);
				token = getNextToken();
			}

			return vertexGroup;
		}

		/**
		 * 解析面
		 */
		private function parseFaces():Vector.<uint>
		{
			var faces:Vector.<uint> = new Vector.<uint>();

			var faceNum:int = getNextInt();
			var indexNum:int = getNextInt();

			var token:String;

			check("{");
			check("Triangles");
			check("{");
			check("{");

			token = getNextToken();
			while (token != "}")
			{
				faces.push(token);
				token = getNextToken();
			}

			check("}");
			check("}");

			return faces;
		}

		/**
		 * 解顶点分组
		 */
		private function parseGroups():Vector.<Vector.<int>>
		{
			var groups:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();

			var groupNum:int = getNextInt();
			var valueNum:int = getNextInt();

			var token:String;

			check("{");

			token = getNextToken();
			while (token != "}")
			{
				if (token == "Matrices")
				{
					check("{");
					token = getNextToken();
					var Matrices:Vector.<int> = new Vector.<int>();
					while (token != "}")
					{
						Matrices.push(token);
						token = getNextToken();
					}
					groups.push(Matrices);
				}
				token = getNextToken();
			}
			return groups;
		}

		/**
		 * 解析纹理
		 */
		private function parseBitmap():FBitmap
		{
			var bitmap:FBitmap = new FBitmap();

			var token:String = getNextToken();

			if (token != "{")
				sendParseError(token);

			var ch:String;
			while (ch != "}")
			{
				ch = getNextToken();
				switch (ch)
				{
					case COMMENT_TOKEN:
						ignoreLine();
						break;
					case "Image":
						bitmap.image = parseLiteralString();
						break;
					case "ReplaceableId":
						bitmap.ReplaceableId = getNextInt();
						break;
					case "WrapWidth":
						break;
					case "WrapHeight":
						break;
					case "}":
						break;
					default:
						sendUnknownKeywordError(ch);
						break;
				}
			}
			return bitmap;
		}

		/**
		 * 解析材质
		 */
		private function parseMaterial():Material
		{
			var material:Material = new Material();

			var token:String = getNextToken();

			if (token != "{")
				sendParseError(token);

			var ch:String;
			while (ch != "}")
			{
				ch = getNextToken();
				switch (ch)
				{
					case COMMENT_TOKEN:
						ignoreLine();
						break;
					case "Layer":
						var layer:Layer = parseLayer();
						material.layers.push(layer);
						break;
					case "SortPrimsFarZ":
						break;
					case "ConstantColor":
						break;
					case "}":
						break;
					default:
						sendUnknownKeywordError(ch);
						break;
				}
			}
			return material;
		}

		/**
		 * 解析材质层
		 */
		private function parseLayer():Layer
		{
			var layer:Layer = new Layer();

			var token:String = getNextToken();

			if (token != "{")
				sendParseError(token);

			var staticSigned:Boolean = false;
			var ch:String;
			while (ch != "}")
			{
				ch = getNextToken();
				switch (ch)
				{
					case COMMENT_TOKEN:
						ignoreLine();
						break;
					case "FilterMode":
						layer.FilterMode = getNextToken();
						break;
					case "static":
						staticSigned = true;
						break;
					case "TextureID":
						if (staticSigned)
						{
							layer.TextureID = getNextInt();
						}
						else
						{
							sendUnknownKeywordError(ch);
						}
						staticSigned = false;
						break;
					case "Alpha":
						if (staticSigned)
						{
							layer.Alpha = getNextNumber();
						}
						else
						{
							getNextInt();
							jumpChunk();

//							sendUnknownKeywordError(ch);
						}
						staticSigned = false;
						break;
					case "Unshaded":
						layer.Unshaded = true;
						break;
					case "Unfogged":
						layer.Unfogged = true;
						break;
					case "TwoSided":
						layer.TwoSided = true;
						break;
					case "SphereEnvMap":
						layer.SphereEnvMap = true;
						break;
					case "NoDepthTest":
						layer.NoDepthTest = true;
						break;
					case "NoDepthSet":
						layer.NoDepthSet = true;
						break;
					case "}":
						break;
					default:
						sendUnknownKeywordError(ch);
						break;
				}
			}
			return layer;
		}

		/**
		 * 解析动作信息
		 */
		private function parseAnim():AnimInfo
		{
			var anim:AnimInfo = new AnimInfo();

			anim.name = parseLiteralString();

			var token:String = getNextToken();

			if (token != "{")
				sendParseError(token);

			var ch:String;
			while (ch != "}")
			{
				ch = getNextToken();
				switch (ch)
				{
					case COMMENT_TOKEN:
						ignoreLine();
						break;
					case "Interval":
						anim.interval = parseInterval();
						break;
					case "MinimumExtent":
						anim.MinimumExtent = parseVector3D();
						break;
					case "MaximumExtent":
						anim.MaximumExtent = parseVector3D();
						break;
					case "BoundsRadius":
						anim.BoundsRadius = getNextNumber();
						break;
					case "Rarity":
						anim.Rarity = getNextNumber();
						break;
					case "NonLooping":
						anim.loop = false;
						break;
					case "MoveSpeed":
						anim.MoveSpeed = getNextNumber();
						break;
					case "}":
						break;
					default:
						sendUnknownKeywordError(ch);
						break;
				}
			}
			return anim;
		}

		/**
		 * 解析几何体动作信息
		 */
		private function parseAnim1():AnimInfo1
		{
			var anim:AnimInfo1 = new AnimInfo1();

			var token:String = getNextToken();

			if (token != "{")
				sendParseError(token);

			var ch:String;
			while (ch != "}")
			{
				ch = getNextToken();
				switch (ch)
				{
					case COMMENT_TOKEN:
						ignoreLine();
						break;
					case "MinimumExtent":
						anim.MinimumExtent = parseVector3D();
						break;
					case "MaximumExtent":
						anim.MaximumExtent = parseVector3D();
						break;
					case "BoundsRadius":
						anim.BoundsRadius = getNextNumber();
						break;
					case "}":
						break;
					default:
						sendUnknownKeywordError(ch);
						break;
				}
			}
			return anim;
		}

		/**
		 * 解析骨骼轴心坐标
		 */
		private function parsePivotPoints():Vector.<Vector3D>
		{
			var points:Vector.<Vector3D> = new Vector.<Vector3D>();

			var len:int = getNextInt();

			check("{");

			for (var i:int = 0; i < len; i++)
			{
				var point:Vector3D = parseVector3D();
				points.push(point);
			}

			check("}");

			return points;
		}

		/**
		 * 解析3d向量
		 */
		private function parseVector3D():Vector3D
		{
			var vec:Vector3D = new Vector3D();
			var ch:String = getNextToken();

			if (ch != "{")
				sendParseError("{");
			vec.x = getNextNumber();
			vec.y = getNextNumber();
			vec.z = getNextNumber();

			ch = getNextToken();
			if (!(ch == "}" || ch == "},"))
				sendParseError("}");

			return vec;
		}

		/**
		 * 解析四元素
		 */
		private function parseVector3D4():Quaternion
		{
			var vec:Quaternion = new Quaternion();
			var ch:String = getNextToken();

			if (ch != "{")
				sendParseError("{");
			vec.x = getNextNumber();
			vec.y = getNextNumber();
			vec.z = getNextNumber();
			vec.w = getNextNumber();

			ch = getNextToken();
			if (!(ch == "}" || ch == "},"))
				sendParseError("}");

			return vec;
		}

		/**
		 * 解析2d坐标
		 */
		private function parsePoint():Point
		{
			var point:Point = new Point();
			var ch:String = getNextToken();

			if (ch != "{")
				sendParseError("{");
			point.x = getNextNumber();
			point.y = getNextNumber();

			ch = getNextToken();
			if (!(ch == "}" || ch == "},"))
				sendParseError("}");

			return point;
		}

		/**
		 * 解析间隔
		 */
		private function parseInterval():Interval
		{
			var interval:Interval = new Interval();
			var ch:String = getNextToken();

			if (ch != "{")
				sendParseError("{");
			interval.start = getNextInt();
			interval.end = getNextInt();

			ch = getNextToken();
			if (!(ch == "}" || ch == "},"))
				sendParseError("}");

			return interval;
		}

		/**
		 * 解析带双引号的字符串
		 */
		private function parseLiteralString():String
		{
			skipWhiteSpace();

			var ch:String = getNextChar();
			var str:String = "";

			if (ch != "\"")
				sendParseError("\"");

			do
			{
				if (_reachedEOF)
					sendEOFError();
				ch = getNextChar();
				if (ch != "\"")
					str += ch;
			} while (ch != "\"");

			return str;
		}

		/**
		 * 读取下个Number
		 */
		private function getNextNumber():Number
		{
			var f:Number = parseFloat(getNextToken());
			if (isNaN(f))
				sendParseError("float type");
			return f;
		}

		/**
		 * 读取下个字符
		 */
		private function getNextChar():String
		{
			var ch:String = _textData.charAt(_parseIndex++);

			if (ch == "\n")
			{
				++_line;
				_charLineIndex = 0;
			}
			else if (ch != "\r")
				++_charLineIndex;

			if (_parseIndex >= _textData.length)
				_reachedEOF = true;

			return ch;
		}

		/**
		 * 读取下个int
		 */
		private function getNextInt():int
		{
			var i:Number = parseInt(getNextToken());
			if (isNaN(i))
				sendParseError("int type");
			return i;
		}

		/**
		 * 获取下个关键字
		 */
		private function getNextToken():String
		{
			var ch:String;
			var token:String = "";

			while (!_reachedEOF)
			{
				ch = getNextChar();
				if (ch == " " || ch == "\r" || ch == "\n" || ch == "\t" || ch == ",")
				{
					if (token != COMMENT_TOKEN)
						skipWhiteSpace();
					if (token != "")
						return token;
				}
				else
					token += ch;

				if (token == COMMENT_TOKEN)
					return token;
			}

			return token;
		}

		/**
		 * 跳过块
		 * @return 跳过的内容
		 */
		private function jumpChunk():String
		{
			var start:int = _parseIndex;

			check("{");
			var stack:Array = ["{"];

			var ch:String;

			while (!_reachedEOF)
			{
				ch = getNextChar();
				if (ch == "{")
				{
					stack.push("{");
				}
				if (ch == "}")
				{
					stack.pop();
					if (stack.length == 0)
					{
						return _textData.substring(start, _parseIndex);
					}
				}
			}

			return null;
		}

		/**
		 * 返回到上个字符位置
		 */
		private function putBack():void
		{
			_parseIndex--;
			_charLineIndex--;
			_reachedEOF = _parseIndex >= _textData.length;
		}

		/**
		 * 跳过空白
		 */
		private function skipWhiteSpace():void
		{
			var ch:String;

			do
				ch = getNextChar();
			while (ch == "\n" || ch == " " || ch == "\r" || ch == "\t");

			putBack();
		}

		/**
		 * 忽略该行
		 */
		private function ignoreLine():void
		{
			var ch:String;
			while (!_reachedEOF && ch != "\n")
				ch = getNextChar();
		}

		private function check(key:String):void
		{
			var token:String = getNextToken();
			if (token != key)
				sendParseError(token);
		}

		/**
		 * 抛出一个文件尾过早结束文件时遇到错误
		 */
		private function sendEOFError():void
		{
			throw new Error("Unexpected end of file");
		}

		/**
		 * 遇到了一个意想不到的令牌时将抛出一个错误。
		 * @param expected 发生错误的标记
		 */
		private function sendParseError(expected:String):void
		{
			throw new Error("Unexpected token at line " + (_line + 1) + ", character " + _charLineIndex + ". " + expected + " expected, but " + _textData.charAt(_parseIndex - 1) + " encountered");
		}

		/**
		 * 发生未知关键字错误
		 */
		private function sendUnknownKeywordError(keyword:String):void
		{
			throw new Error("Unknown keyword[" + keyword + "] at line " + (_line + 1) + ", character " + _charLineIndex + ". ");
		}

		/** war3模型数据 */
		public function get war3Model():War3Model
		{
			return _war3Model;
		}

		/**
		 * @private
		 */
		public function set war3Model(value:War3Model):void
		{
			_war3Model = value;
		}

	}
}

