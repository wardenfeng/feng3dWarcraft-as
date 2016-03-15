package me.feng3d.materials
{
	import me.feng3d.passes.War3TerrainPass1;
	import me.feng3d.textures.War3BitmapTexture;

	/**
	 *
	 * @author feng 2016-3-15
	 */
	public class War3TerrainMaterial1 extends MaterialBase
	{
		private var _screenPass:War3TerrainPass1;

		public function War3TerrainMaterial1(war3BitmapTexture:War3BitmapTexture)
		{
			super();
			bothSides = true;
			addPass(_screenPass = new War3TerrainPass1());
//			_screenPass.splats = war3BitmapTexture;
		}
	}
}


