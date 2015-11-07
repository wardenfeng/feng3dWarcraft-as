package me.feng3d.materials
{
	import me.feng3d.passes.War3TerrainPass;
	
	/**
	 * 
	 * @author warden_feng 2014-8-1
	 */
	public class War3TerrainMaterial extends MaterialBase
	{
		private var _screenPass:War3TerrainPass;
		
		public function War3TerrainMaterial(tileTextures:Array)
		{
			super();
			bothSides = true;
			addPass(_screenPass = new War3TerrainPass());
			_screenPass.splats = tileTextures;
		}
	}
}