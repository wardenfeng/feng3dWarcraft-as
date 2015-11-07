package
{
	import flash.display.Sprite;
	
	import me.feng3d.war3.slk.War3MapConfig;


	/**
	 *
	 * @author warden_feng 2014-7-20
	 */
	public class SlkTest extends Sprite
	{
		private var terrain_slkStr:String;

		public function SlkTest()
		{
			var war3MapData:War3MapConfig = War3MapConfig.instance;

//			trace(JSON.stringify(war3MapData.terrainslkList));
			trace(JSON.stringify(war3MapData.cliffTypesslkList));

//			printTitles();
		}

		public function printTitles():void
		{
			var titlestr:String;
			titlestr = "cliffID	cliffModelDir	rampModelDir	texDir	texFile	name	groundTile	upperTile	cliffClass	oldID";
			var titleArr:Array = titlestr.split("\t");
			for (var i:int = 0; i < titleArr.length; i++)
			{
				trace("public var " + titleArr[i] + ":String;");
			}
		}
	}
}
