package
{
	import me.feng.load.Load;
	import me.feng.task.Task;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.containers.Scene3D;
	import me.feng3d.containers.View3D;
	import me.feng3d.entities.War3TerrainTile;
	import me.feng3d.test.TestBaseWar3Map;

	[SWF(backgroundColor = "#ffffff", frameRate = "60", quality = "LOW", width = "670", height = "380")]
	public class WarTerrainEditorTest extends TestBaseWar3Map
	{
		//engine variables
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;
		
		public function WarTerrainEditorTest()
		{
			War3TerrainTile.stage = this.stage;
			super();
		}
		
		public function init():void
		{			
			Task.init();
			Load.init();
		}
	}
}