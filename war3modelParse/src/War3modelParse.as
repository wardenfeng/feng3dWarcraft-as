package
{

	import com.adobe.utils.AGALMiniAssembler;
	import com.adobe.utils.PerspectiveMatrix3D;
	import com.bit101.components.CheckBox;
	import com.bit101.components.ComboBox;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	import me.feng3d.parsers.MdlParser;
	import me.feng3d.parsers.mdl.AnimInfo;
	import me.feng3d.parsers.mdl.War3Model;

	[SWF(width = "640", height = "480", frameRate = "60", backgroundColor = "#FFFFFF")]

	public class War3modelParse extends Sprite
	{
		// constants used during inits
		private const swfWidth:int = 640;

		private const swfHeight:int = 480;

		// the 3d graphics window on the stage
		private var context3D:Context3D;

		// the compiled shaders used to render our mesh
		private var shaderProgram1:Program3D;

		// matrices that affect the mesh location and camera angles
		private var projectionmatrix:PerspectiveMatrix3D = new PerspectiveMatrix3D();

		private var modelmatrix:Matrix3D = new Matrix3D();

		private var viewmatrix:Matrix3D = new Matrix3D();

		private var modelViewProjection:Matrix3D = new Matrix3D();

//		[Embed(source = "../war3/Owl.mdl", mimeType = "application/octet-stream")]
//		[Embed(source = "../war3/Arthas.mdl", mimeType = "application/octet-stream")]
		[Embed(source = "../war3/WoWDryad.mdl", mimeType = "application/octet-stream")]
//		[Embed(source = "../war3/ArthaswithSword.mdl", mimeType = "application/octet-stream")]
//		[Embed(source = "../war3/DragonRed.mdl", mimeType = "application/octet-stream")]
//		[Embed(source = "../war3/HeroBladeMaster.mdl", mimeType = "application/octet-stream")]
//		[Embed(source = "../war3/HeroBladeMaster1.mdl", mimeType = "application/octet-stream")]
		private var myObjData:Class;

		private var myParser:MdlParser;
		private var war3Model:War3Model;

		/** 动画下拉框 */
		private var actionCB:ComboBox

		/** 网眼显示框 */
		private var meshPanel:Panel;

		private var meshShowCBList:Array = [];
		
		public function War3modelParse()
		{
			if (stage != null)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void
		{
			if (hasEventListener(Event.ADDED_TO_STAGE))
				removeEventListener(Event.ADDED_TO_STAGE, init);

			stage.frameRate = 60;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			// and request a context3D from Stage3d
			stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreate);
			stage.stage3Ds[0].requestContext3D();

			initUI();
		}

		private function initUI():void
		{
			meshPanel = new Panel(this);
			actionCB = new ComboBox(this, meshPanel.width);
			new Label(meshPanel,0,0,"show mesh");
		}

		private function onContext3DCreate(event:Event):void
		{
			// Remove existing frame handler. Note that a context
			// loss can occur at any time which will force you
			// to recreate all objects we create here.
			// A context loss occurs for instance if you hit
			// CTRL-ALT-DELETE on Windows.			
			// It takes a while before a new context is available
			// hence removing the enterFrame handler is important!

			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME, enterFrame);

			// Obtain the current context
			var t:Stage3D = event.target as Stage3D;
			context3D = t.context3D;

			if (context3D == null)
			{
				// Currently no 3d context is available (error!)
				return;
			}

			// Disabling error checking will drastically improve performance.
			// If set to true, Flash sends helpful error messages regarding
			// AGAL compilation errors, uninitialized program constants, etc.
			context3D.enableErrorChecking = true;

			// Initialize our mesh data
			initData();

			// The 3d back buffer size is in pixels (2=antialiased)
			context3D.configureBackBuffer(swfWidth, swfHeight, 2, true);

			// assemble all the shaders we need
			initShaders();

			// create projection matrix for our 3D scene
			projectionmatrix.identity();
			// 45 degrees FOV, 640/480 aspect ratio, 0.1=near, 100=far
			projectionmatrix.perspectiveFieldOfViewRH(45.0, swfWidth / swfHeight, 0.01, 5000.0);

			// create a matrix that defines the camera location
			viewmatrix.identity();
			// move the camera back a little so we can see the mesh
			viewmatrix.appendTranslation(0, 300, -300);
			viewmatrix.appendRotation(-45, new Vector3D(1, 0, 0));

			// start the render loop!
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}

		// create four different shaders
		private function initShaders():void
		{
			// A simple vertex shader which does a 3D transformation
			// for simplicity, it is used by all four shaders
			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble(Context3DProgramType.VERTEX,
				// 4x4 matrix multiply to get camera angle	
				"m44 op, va0, vc0\n" +
				// tell fragment shader about XYZ
				"mov v0, va0\n" +
				// tell fragment shader about UV
				"mov v1, va1\n");

			// textured using UV coordinates
			var fragmentShaderAssembler1:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentShaderAssembler1.assemble(Context3DProgramType.FRAGMENT,
				// grab the texture color from texture 0 
				// and uv coordinates from varying register 1
				// and store the interpolated value in ft0
				"tex ft0, v1, fs0 <2d,linear,repeat,miplinear>\n" +
				// move this value to the output color
				"mov oc, ft0\n");

			// combine shaders into a program which we then upload to the GPU
			shaderProgram1 = context3D.createProgram();
			shaderProgram1.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler1.agalcode);
		}

		private function initData():void
		{
			myParser = new MdlParser(myObjData);
			war3Model = myParser.parse();

			var items:Array = [];
			for each (var animInfo:AnimInfo in war3Model.sequences)
			{
				items.push({label: animInfo.name, start: animInfo.interval.start, end: animInfo.interval.end});
			}

			actionCB.items = items;
			actionCB.selectedIndex = 0;

			war3Model.geosets[0];

			for (var i:int = 0; i < war3Model.geosets.length; i++)
			{
				var cb:CheckBox = new CheckBox(meshPanel, 5, 15 * i + 20, "mesh "+i);
				cb.selected = true;
				meshShowCBList[i] = cb;
			}

			war3Model.context3D = context3D;
		}

		private function enterFrame(e:Event):void
		{
			// clear scene before rendering is mandatory
			context3D.clear(0, 0, 0);
			// move or rotate more each frame
			// how far apart each of the 4 spaceships is
			// clear the transformation matrix to 0,0,0
			modelmatrix.identity();
			modelmatrix.appendScale(1, 1, 1);

			context3D.setProgram(shaderProgram1);

			// clear the matrix and append new angles
			modelViewProjection.identity();
			modelViewProjection.append(modelmatrix);
			modelViewProjection.append(viewmatrix);
			modelViewProjection.append(projectionmatrix);

			// pass our matrix data to the shader program
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, modelViewProjection, true);

			var time:int = getTimer();

			var item:Object = actionCB.selectedItem;

			var meshtime:int = (time % (item.end - item.start)) + item.start;
			var meshs:Vector.<Mesh> = war3Model.getMesh(meshtime);

			for (var i:int = 0; i < meshs.length; i++)
			{
				var cb:CheckBox = meshShowCBList[i];
				if(!cb.selected)
					continue;
				
				var myMesh:Mesh = meshs[i];

				var myTexture:Texture = myMesh.getTexture();
				context3D.setTextureAt(0, myTexture);

				// draw a spaceship mesh
				// position
				context3D.setVertexBufferAt(0, myMesh.positionsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				// tex coord
				context3D.setVertexBufferAt(1, myMesh.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
				// render it
				context3D.drawTriangles(myMesh.indexBuffer, 0, myMesh.indexBufferCount);
			}

			// present/flip back buffer
			// now that all meshes have been drawn
			context3D.present();
		}

	} // end of class
} // end of package
