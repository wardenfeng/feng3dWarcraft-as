package me.feng3d.containers
{
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.manager.Mouse3DManager;
	import me.feng3d.core.manager.Stage3DManager;
	import me.feng3d.core.math.Ray3D;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.core.render.DefaultRenderer;
	import me.feng3d.core.render.RendererBase;
	import me.feng3d.core.traverse.EntityCollector;
	import me.feng3d.events.CameraEvent;
	import me.feng3d.events.Stage3DEvent;

	use namespace arcane;

	/**
	 * 3D视图
	 * @author feng 2014-3-17
	 */
	public class View3D extends Sprite
	{
		/**
		 * 射线坐标临时变量
		 */
		private static const tempRayPosition:Vector3D = new Vector3D();
		/**
		 * 射线方向临时变量
		 */
		private static const tempRayDirection:Vector3D = new Vector3D();

		private var _width:Number = 0;
		private var _height:Number = 0;

		/** 全局坐标脏标记 */
		private var _globalPosDirty:Boolean;

		private var _antiAlias:uint;

		protected var _backBufferInvalid:Boolean = true;

		private var _camera:Camera3D;

		private var _scene:Scene3D;

		protected var _entityCollector:EntityCollector;

		private var _stage3DProxy:Stage3DProxy;

		/** 渲染器 */
		protected var _renderer:RendererBase;
		/** 是否被添加到舞台 */
		private var _addedToStage:Boolean;
		/** 是否强行使用软件渲染 */
		private var _forceSoftware:Boolean;
		/** 指定 Flash Player 支持低级别 GPU 的范围 */
		private var _profile:String;

		private var _backgroundColor:uint = 0x000000;
		private var _backgroundAlpha:Number = 1;

		protected var _mouse3DManager:Mouse3DManager;

		/**
		 * 点击区域
		 */
		private var _hitField:Sprite;

		private var _scissorRectDirty:Boolean = true;
		private var _viewportDirty:Boolean = true;

		protected var _aspectRatio:Number;

		/**
		 * 创建一个3D视图
		 * @param scene 				场景
		 * @param camera 				摄像机
		 * @param renderer				渲染器
		 * @param forceSoftware			是否强行使用软件渲染
		 * @param profile				指定 Flash Player 支持低级别 GPU 的范围
		 */
		public function View3D(scene:Scene3D = null, camera:Camera3D = null, renderer:RendererBase = null, forceSoftware:Boolean = false, profile:String = Context3DProfile.STANDARD)
		{
			_scene = scene || new Scene3D();
			_camera = camera || new Camera3D();
			_renderer = renderer || new DefaultRenderer();

			_forceSoftware = forceSoftware;
			_profile = profile;

			_entityCollector = _renderer.createEntityCollector();
			_entityCollector.camera = _camera;

			initHitField();

			_mouse3DManager = new Mouse3DManager();
			_mouse3DManager.enableMouseListeners(this);

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromeStage, false, 0, true);

			_camera.partition = _scene.partition;
		}

		/**
		 * The amount of anti-aliasing to be used.
		 */
		public function get antiAlias():uint
		{
			return _antiAlias;
		}

		public function set antiAlias(value:uint):void
		{
			_antiAlias = value;

			_backBufferInvalid = true;
		}

		/**
		 * 摄像机
		 */
		public function get camera():Camera3D
		{
			return _camera;
		}

		public function set camera(value:Camera3D):void
		{
			_camera.removeEventListener(CameraEvent.LENS_CHANGED, onLensChanged);

			_camera = value;
			_entityCollector.camera = _camera;

			if (_scene)
				_camera.partition = _scene.partition;

			_camera.addEventListener(CameraEvent.LENS_CHANGED, onLensChanged);

			_scissorRectDirty = true;
			_viewportDirty = true;

		}

		/**
		 * 处理镜头改变事件
		 */
		private function onLensChanged(event:CameraEvent):void
		{
			_scissorRectDirty = true;
			_viewportDirty = true;
		}

		/**
		 * 处理添加到舞台事件
		 */
		private function onAddedToStage(event:Event):void
		{
			if (_addedToStage)
				return;

			_addedToStage = true;

			if (!_stage3DProxy)
			{
				_stage3DProxy = Stage3DManager.getInstance(stage).getFreeStage3DProxy(_forceSoftware, _profile);
//				_stage3DProxy.addEventListener(Stage3DEvent.VIEWPORT_UPDATED, onViewportUpdated);
				_stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_RECREATED, onContext3DRecreated);
			}

			_globalPosDirty = true;

			_stage3DProxy.addEventListener(Event.ENTER_FRAME, onEnterFrame);

			if (_width == 0)
				width = stage.stageWidth;

			if (_height == 0)
				height = stage.stageHeight;
		}

		/**
		 * 处理3D环境被重建事件
		 */
		private function onContext3DRecreated(event:Stage3DEvent):void
		{
//			_depthTextureInvalid = true;
		}

		/**
		 * 处理从舞台移除事件
		 */
		private function onRemoveFromeStage(event:Event):void
		{
			_stage3DProxy.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		/**
		 * 初始化点击区域
		 */
		private function initHitField():void
		{
			_hitField = new Sprite();
			_hitField.alpha = 0;
			_hitField.doubleClickEnabled = true;
			_hitField.graphics.beginFill(0x000000);
			_hitField.graphics.drawRect(0, 0, 100, 100);
			addChild(_hitField);
		}

		/**
		 * 处理进入帧事件
		 */
		private function onEnterFrame(e:Event):void
		{
			render();
		}

		/**
		 * 添加源码地址
		 * @param url
		 */
		public function addSourceURL(url:String):void
		{

		}

		/**
		 * 渲染3D视图
		 */
		public function render():void
		{
			//当3D环境被系统释放，不能进行渲染
			if (!stage3DProxy.recoverFromDisposal())
			{
				_backBufferInvalid = true;
				return;
			}

			//重置渲染设置
			if (_backBufferInvalid)
				updateBackBuffer();

			if (_globalPosDirty)
				updateGlobalPos();

			_entityCollector.clear();

			//收集渲染实体
			_scene.traversePartitions(_entityCollector);

			//渲染收集的实体对象
			_renderer.render(stage3DProxy, _entityCollector);

			//收集场景显示对象
			_scene.collectMouseCollisionEntitys();

			//获取鼠标射线
			var mouseRay3D:Ray3D = getMouseRay3D();
			//更新鼠标碰撞
			_mouse3DManager.fireMouseEvents(mouseRay3D, _scene.mouseCollisionEntitys);

			// register that a view has been rendered
			stage3DProxy.bufferClear = false;
		}

		/** 3d场景 */
		public function get scene():Scene3D
		{
			return _scene;
		}

		/**
		 * @private
		 */
		public function set scene(value:Scene3D):void
		{
			_scene = value;
		}

		/**
		 * 3D舞台代理
		 */
		public function get stage3DProxy():Stage3DProxy
		{
			return _stage3DProxy;
		}

		public function set stage3DProxy(value:Stage3DProxy):void
		{
			_stage3DProxy = value;

			if (_stage3DProxy)
			{
				_stage3DProxy.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}

			_stage3DProxy = stage3DProxy;

			_stage3DProxy.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		/**
		 * 宽度
		 */
		override public function get width():Number
		{
			return _width;
		}

		override public function set width(value:Number):void
		{
			//限制软件渲染时最大宽度
			if (_stage3DProxy && _stage3DProxy.usesSoftwareRendering && value > 2048)
				value = 2048;

			if (_width == value)
				return;

			_hitField.width = value;
			_width = value;

			_aspectRatio = _width / _height;
			_camera.lens.aspectRatio = _aspectRatio;

			_backBufferInvalid = true;
		}

		/**
		 * 高度
		 */
		override public function get height():Number
		{
			return _height;
		}

		override public function set height(value:Number):void
		{
			//限制软件渲染时最大高度
			if (_stage3DProxy && _stage3DProxy.usesSoftwareRendering && value > 2048)
				value = 2048;

			if (_height == value)
				return;

			_hitField.height = value;
			_height = value;

			_aspectRatio = _width / _height;
			_camera.lens.aspectRatio = _aspectRatio;

			_backBufferInvalid = true;
		}

		/**
		 * 渲染面数
		 */
		public function get renderedFacesCount():uint
		{
			return 0;
		}

		/**
		 * 更新背景缓冲大小
		 */
		protected function updateBackBuffer():void
		{
			if (_stage3DProxy.context3D)
			{
				if (_width && _height)
				{
					if (_stage3DProxy.usesSoftwareRendering)
					{
						if (_width > 2048)
							_width = 2048;
						if (_height > 2048)
							_height = 2048;
					}

					_stage3DProxy.configureBackBuffer(_width, _height, _antiAlias);
					_backBufferInvalid = false;
				}
				else
				{
					width = stage.stageWidth;
					height = stage.stageHeight;
				}
			}
		}

		/**
		 * 设置X坐标
		 */
		override public function set x(value:Number):void
		{
			if (x == value)
				return;
			super.x = value;

			_globalPosDirty = true;
		}

		/**
		 * 设置y坐标
		 */
		override public function set y(value:Number):void
		{
			if (y == value)
				return;
			super.y = value;

			_globalPosDirty = true;
		}

		/**
		 * 更新全局坐标
		 */
		protected function updateGlobalPos():void
		{
			if (!_stage3DProxy)
				return;

			_stage3DProxy.x = x;
			_stage3DProxy.y = y;

			_globalPosDirty = false;
		}

		/**
		 * 背景颜色
		 */
		public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
			_renderer.backgroundColor = _backgroundColor;
		}

		/**
		 * 投影坐标（世界坐标转换为3D视图坐标）
		 * @param point3d 世界坐标
		 * @return 屏幕的绝对坐标
		 */
		public function project(point3d:Vector3D):Vector3D
		{
			var v:Vector3D = _camera.project(point3d);

			v.x = (v.x + 1.0) * _width / 2.0;
			v.y = (v.y + 1.0) * _height / 2.0;

			return v;
		}

		/**
		 * 屏幕坐标投影到场景坐标
		 * @param nX 屏幕坐标X ([0-width])
		 * @param nY 屏幕坐标Y ([0-height])
		 * @param sZ 到屏幕的距离
		 * @param v 场景坐标（输出）
		 * @return 场景坐标
		 */
		public function unproject(sX:Number, sY:Number, sZ:Number, v:Vector3D = null):Vector3D
		{
			var gpuPos:Point = screenToGpuPosition(new Point(sX, sY));
			return _camera.unproject(gpuPos.x, gpuPos.y, sZ, v);
		}

		/**
		 * 屏幕坐标转GPU坐标
		 * @param screenPos 屏幕坐标 (x:[0-width],y:[0-height])
		 * @return GPU坐标 (x:[-1,1],y:[-1-1])
		 */
		public function screenToGpuPosition(screenPos:Point):Point
		{
			var gpuPos:Point = new Point();
			gpuPos.x = (screenPos.x * 2 - _width) / _stage3DProxy.width;
			gpuPos.y = (screenPos.y * 2 - _height) / _stage3DProxy.height;
			return gpuPos;
		}

		/**
		 * 获取鼠标射线（与鼠标重叠的摄像机射线）
		 */
		public function getMouseRay3D():Ray3D
		{
			return getRay3D(mouseX, mouseY);
		}

		/**
		 * 获取与坐标重叠的射线
		 * @param x view3D上的X坐标
		 * @param y view3D上的X坐标
		 * @return
		 */
		public function getRay3D(x:Number, y:Number):Ray3D
		{
			//摄像机坐标
			var rayPosition:Vector3D = unproject(x, y, 0, tempRayPosition);
			//摄像机前方1处坐标
			var rayDirection:Vector3D = unproject(x, y, 1, tempRayDirection);
			//射线方向
			rayDirection.x = rayDirection.x - rayPosition.x;
			rayDirection.y = rayDirection.y - rayPosition.y;
			rayDirection.z = rayDirection.z - rayPosition.z;
			rayDirection.normalize();
			//定义射线
			var ray3D:Ray3D = new Ray3D(rayPosition, rayDirection);
			return ray3D;
		}

		/**
		 * 渲染器
		 */
		public function get renderer():RendererBase
		{
			return _renderer;
		}

		public function set renderer(value:RendererBase):void
		{
			_renderer.dispose();
			_renderer = value;
			_entityCollector = _renderer.createEntityCollector();
			_entityCollector.camera = _camera;
			_renderer.backgroundColor = _backgroundColor;
			_renderer.backgroundAlpha = _backgroundAlpha;
			_renderer.viewWidth = _width;
			_renderer.viewHeight = _height;

			_backBufferInvalid = true;
		}

	}
}
