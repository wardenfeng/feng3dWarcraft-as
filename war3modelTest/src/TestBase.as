package
{
	import flash.display.Sprite;
	
	
	/**
	 * 
	 * @author warden_feng 2014-4-9
	 */
	public class TestBase extends Sprite
	{
		public function TestBase()
		{
			MyCC.initFlashConsole(this);
			new ConsoleExtension();
		}
	}
}