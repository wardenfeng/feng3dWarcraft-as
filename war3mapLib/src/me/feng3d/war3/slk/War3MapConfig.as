package me.feng3d.war3.slk
{
	import flash.utils.Dictionary;

	/**
	 * war3地图配置数据
	 * @author warden_feng 2014-7-20
	 */
	public class War3MapConfig
	{
		private var _terrainslkList:Vector.<TerrainSlkItem>;
		private var _terrainslkDic:Dictionary;

		private var _cliffTypesslkList:Vector.<CliffTypesSlkItem>;
		private var _cliffTypesslkDic:Dictionary;

		public function get terrainslkDic():Dictionary
		{
			if (_terrainslkDic == null)
			{
				_terrainslkDic = new Dictionary();

				for (var i:int = 0; i < terrainslkList.length; i++)
				{
					_terrainslkDic[terrainslkList[i].tileID] = terrainslkList[i];
				}
			}
			return _terrainslkDic;
		}

		public function get terrainslkList():Vector.<TerrainSlkItem>
		{
			if (_terrainslkList == null)
			{
				_terrainslkList = new Vector.<TerrainSlkItem>();

				getslkData(terrain_slkStr, TerrainSlkItem, _terrainslkList);
			}
			return _terrainslkList;
		}

		private function getslkData(slkStr:String, cla:Class, list:*):*
		{
			var lines:Array = slkStr.split("\n");

			var titleArr:Array = lines[0].split("\t");

			for (var i:int = 1; i < lines.length; i++)
			{
				var valueArr:Array = lines[i].split("\t");
				if (valueArr.length == titleArr.length)
				{
					var terrainSlkItem:Object = new cla();
					for (var j:int = 0; j < valueArr.length; j++)
					{
						if (valueArr[j].length > 0)
							terrainSlkItem[titleArr[j]] = valueArr[j];
					}
					list.push(terrainSlkItem);
				}
			}

			return list;
		}

		public function get cliffTypesslkList():Vector.<CliffTypesSlkItem>
		{
			if (_cliffTypesslkList == null)
			{
				_cliffTypesslkList = new Vector.<CliffTypesSlkItem>();
				getslkData(cliffTypes_slkStr, CliffTypesSlkItem, _cliffTypesslkList);
			}
			return _cliffTypesslkList;
		}

		public function War3MapConfig()
		{
			if (_instance)
				throw new Error();

			initslkData();
		}

		private static var _instance:War3MapConfig;

		public static function get instance():War3MapConfig
		{
			if (_instance == null)
				_instance = new War3MapConfig();
			return _instance;
		}

		/** Terrain.slk */
		private var terrain_slkStr:String;
		/** CliffTypes.slk */
		private var cliffTypes_slkStr:String;

		private function initslkData():void
		{
			terrain_slkStr = //
				"	tileID	dir	file	comment	name	buildable	footprints	walkable	flyable	blightPri	convertTo	InBeta	\n" + //
				"	Ldrt	TerrainArt/LordaeronSummer	Lords_Dirt	Dirt	WESTRING_TILE_DIRT	1	1	1	1	2	Fdrt,Wdrt,Bdsr,Adrt,Cdrt,Ndrt,Ydrt,Vdrt,Qdrt,Xdrt,Ddrt,Gdrt	1	\n" + //
				"	Ldro	TerrainArt/LordaeronSummer	Lords_DirtRough	Rough Dirt	WESTRING_TILE_ROUGH_DIRT	1	1	1	1	1	Fdro,Wdro,Bdsd,Adrd,Cdrd,Ndrd,Ydtr,Vdrr,Qdrr,Xdtr,Dbrk,Gbrk	1	\n" + //
				"	Ldrg	TerrainArt/LordaeronSummer	Lords_DirtGrass	Grassy Dirt	WESTRING_TILE_GRASSY_DIRT	1	1	1	1	3	Fdrg,Wsng,Bdrr,Cpos,Ngrs,Ygsb,Vgrs,Qgrs,Xgsb,Dgrs,Ggrs	1	\n" + //
				"	Lrok	TerrainArt/LordaeronSummer	Lords_Rock	Rock	WESTRING_TILE_ROCK	0	0	1	1	6	Frok,Wrok,Bflr,Arck,Crck,Nrck,Ybtl,Vrck,Qrck,Xbtl,Ddkr.Gdkr	1	\n" + //
				"	Lgrs	TerrainArt/LordaeronSummer	Lords_Grass	Grass	WESTRING_TILE_GRASS	1	1	1	1	4	Fgrs,Wgrs,Bgrr,Agrs,Cgrs,Nsnw,Ygsb,Vgrs,Qgrs,Xhdg,Dsqd,Gsqd	1	\n" + //
				"	Lgrd	TerrainArt/LordaeronSummer	Lords_GrassDark	Dark Grass	WESTRING_TILE_DARK_GRASS	1	1	1	1	5	Fgrd,Wsnw,Bdrg,Agrd,Clvg,Nice,Ygsb,Vgrt,Qgrt,Xgsb,Dlav,Glav	1	\n" + //
				"	Fdrt	TerrainArt/LordaeronFall	Lordf_Dirt	Dirt	WESTRING_TILE_DIRT	1	1	1	1	2	Ldrt,Wdrt,Bdsr,Adrt,Cdrt,Ndrt,Ydrt,Vdrt,Qdrt,Xdrt,Ddrt,Gdrt	1	\n" + //
				"	Fdro	TerrainArt/LordaeronFall	Lordf_DirtRough	Rough Dirt	WESTRING_TILE_ROUGH_DIRT	1	1	1	1	1	Ldro,Wdro,Bdsd,Adrd,Cdrd,Ndrd,Ydtr,Vdrr,Qdrr,Xdtr,Dbrk,Gbrk	1	\n" + //
				"	Fdrg	TerrainArt/LordaeronFall	Lordf_DirtGrass	Grassy Dirt	WESTRING_TILE_GRASSY_DIRT	1	1	1	1	3	Ldrg,Wsng,Bdrr,Cpos,Ngrs,Ygsb,Vgrs,Qgrs,Xgsb,Dgrs,Ggrs	1	\n" + //
				"	Frok	TerrainArt/LordaeronFall	Lordf_Rock	Rock	WESTRING_TILE_ROCK	0	0	1	1	6	Lrok,Wrok,Bflr,Arck,Crck,Nrck,Ybtl,Vrck,Qrck,Xbtl,Ddkr,Gdkr	1	\n" + //
				"	Fgrs	TerrainArt/LordaeronFall	Lordf_Grass	Grass	WESTRING_TILE_GRASS	1	1	1	1	4	Lgrs,Wgrs,Bgrr,Agrs,Cgrs,Nsnw,Ygsb,Vgrs,Qgrs,Xhdg,Dsqd,Gsqd	1	\n" + //
				"	Fgrd	TerrainArt/LordaeronFall	Lordf_GrassDark	Dark Grass	WESTRING_TILE_DARK_GRASS	1	1	1	1	5	Lgrd,Wsnw,Bdrg,Agrd,Clvg,Nice,Ygsb,Vgrt,Qgrt,Xgsb,Dlav,Glav	1	\n" + //
				"	Wdrt	TerrainArt/LordaeronWinter	Lordw_Dirt	Dirt	WESTRING_TILE_DIRT	1	1	1	1	2	Ldrt,Fdrt,Bdsr,Adrt,Cdrt,Ndrt,Ydrt,Vdrt,Qdrt,Xdrt,Ddrt,Gdrt	1	\n" + //
				"	Wdro	TerrainArt/LordaeronWinter	Lordw_DirtRough	Rough Dirt	WESTRING_TILE_ROUGH_DIRT	1	1	1	1	1	Ldro,Fdro,Bdsd,Adrd,Cdrd,Ndrd,Ydtr,Vdrr,Qdrr,Xdtr,Dbrk,Gbrk	1	\n" + //
				"	Wsng	TerrainArt/LordaeronWinter	Lordw_SnowGrass	Grassy Snow	WESTRING_TILE_GRASSY_SNOW	1	1	1	1	4	Ldrg,Fdrg,Bdrr,Cpos,Ngrs,Ygsb,Vgrs,Qgrs,Xgsb,Dgrs,Ggrs	1	\n" + //
				"	Wrok	TerrainArt/LordaeronWinter	Lordw_Rock	Rock	WESTRING_TILE_ROCK	0	0	1	1	6	Lrok,Frok,Bflr,Arck,Crck,Nrck,Ybtl,Vrck,Qrck,Xbtl,Ddkr,Gdkr	1	\n" + //
				"	Wgrs	TerrainArt/LordaeronWinter	Lordw_Grass	Grass	WESTRING_TILE_GRASS	1	1	1	1	3	Lgrs,Fgrs,Bgrr,Agrs,Cgrs,Nsnw,Ygsb,Vgrs,Qgrs,Xhdg,Dsqd,Gsqd	1	\n" + //
				"	Wsnw	TerrainArt/LordaeronWinter	Lordw_Snow	Snow	WESTRING_TILE_SNOW	1	1	1	1	5	Lgrd,Fgrd,Bdrg,Agrd,Clvg,Nice,Ygsb,Vgrt,Qgrt,Xgsb,Dlav,Glav	1	\n" + //
				"	Bdrt	TerrainArt/Barrens	Barrens_Dirt	Dirt	WESTRING_TILE_DIRT	1	0	1	1	2	Ldrt,Fdrt,Wdrt,Adrt,Cdrt,Ndrt,Ydrt,Vdrt,Qdrt,Xdrt,Ddrt,Gdrt	0	\n" + //
				"	Bdrh	TerrainArt/Barrens	Barrens_DirtRough	Rough Dirt	WESTRING_TILE_ROUGH_DIRT	1	0	1	1	1	Ldro,Fdro,Wdro,Adrd,Cdrd,Ndrd,Ydtr,Vdrr,Qdrr,Xdtr,Dbrk,Gbrk	0	\n" + //
				"	Bdrr	TerrainArt/Barrens	Barrens_Pebbles	Pebbles	WESTRING_TILE_PEBBLES	0	0	1	1	6	Lrok,Frok,Wrok,Avin,Cvin,Nsnr,Ybtl,Vcbp,Qcbp,Xbtl,Drds,Grds	0	\n" + //
				"	Bdrg	TerrainArt/Barrens	Barrens_DirtGrass	Grassy Dirt	WESTRING_TILE_GRASSY_DIRT	1	1	1	1	8	Ldrg,Fdrg,Wsng,Adrg,Clvg,Nice,Ygsb,Vgrt,Qgrt,Xgsb,Dgrs,Ggrs	0	\n" + //
				"	Bdsr	TerrainArt/Barrens	Barrens_Desert	Desert	WESTRING_TILE_DESERT	1	1	1	1	3	Ldrt,Fdrt,Wdrt,Adrt,Cdrt,Ndrt,Ydrt,Vdrt,Qdrt,Xdrt,Ddrt,Gdrt	0	\n" + //
				"	Bdsd	TerrainArt/Barrens	Barrens_DesertDark	Dark Desert	WESTRING_TILE_DARK_DESERT	1	1	1	1	4	Ldro,Fdro,Wdro,Adrd,Cdrd,Ndrd,Ydtr,Vdrr,Qdrr,Xdtr,Dlav,Glav	0	\n" + //
				"	Bflr	TerrainArt/Barrens	Barrens_Rock	Rock	WESTRING_TILE_ROCK	0	0	1	1	7	Lrok,Frok,Wrok,Arck,Crck,Nrck,Ywmb,Vrck,Qrck,Xwmb,Ddkr,Gdkr	0	\n" + //
				"	Bgrr	TerrainArt/Barrens	Barrens_Grass	Grass	WESTRING_TILE_GRASS	1	1	1	1	5	Lgrs,Fgrs,Wgrs,Agrs,Cgrs,Ngrs,Yhdg,Vgrs,Qgrs,Xhdg,Dlvc,Glvc	0	\n" + //
				"	Adrt	TerrainArt/Ashenvale	Ashen_Dirt	Dirt	WESTRING_TILE_DIRT	1	1	1	1	1	Ldrt,Fdrt,Wdrt,Bdsr,Cdrt,Ndrt,Ydrt,Vdrt,Qdrt,Xdrt,Ddrt,Gdrt	0	\n" + //
				"	Adrd	TerrainArt/Ashenvale	Ashen_DirtRough	Rough Dirt	WESTRING_TILE_ROUGH_DIRT	1	1	1	1	2	Ldro,Fdro,Wdro,Bdsd,Cdrd,Ndrd,Ydtr,Vdrr,Qdrr,Xdtr,Dbrk,Gbrk	0	\n" + //
				"	Agrs	TerrainArt/Ashenvale	Ashen_Grass	Grass	WESTRING_TILE_GRASS	1	1	1	1	4	Lgrs,Fgrs,Wgrs,Bgrr,Cgrs,Ngrs,Yhdg,Vgrs,Qgrs,Xhdg,Dbrk,Gbrk	0	\n" + //
				"	Arck	TerrainArt/Ashenvale	Ashen_Rock	Rock	WESTRING_TILE_ROCK	0	0	1	1	5	Lrok,Frok,Wrok,Bflr,Crck,Nrck,Ybtl,Vrck,Qrck,Xbtl,Ddkr,Gdkr	0	\n" + //
				"	Agrd	TerrainArt/Ashenvale	Ashen_GrassLumpy	Lumpy Grass	WESTRING_TILE_LUMPY_GRASS	1	1	1	1	6	Lgrd,Fgrd,Wsnw,Bdrg,Cpos,Ngrs,Ygsb,Vgrs,Qgrs,Xgsb,Dgrs,Ggrs	0	\n" + //
				"	Avin	TerrainArt/Ashenvale	Ashen_Vines	Vines	WESTRING_TILE_VINES	0	1	1	1	3	Lrok,Frok,Wrok,Bdrr,Cvin,Nsnr,Yrtl,Vcrp,Qcrp,Xrtl,Dlav,Glav	0	\n" + //
				"	Adrg	TerrainArt/Ashenvale	Ashen_DirtGrass	Grassy  Dirt	WESTRING_TILE_GRASSY_DIRT	1	1	1	1	8	Ldrg,Fdrg,Wsng,Bdrg,Cpos,Nice,Ygsb,Vgrt,Qgrt,Xgsb,Drds,Grds	0	\n" + //
				"	Alvd	TerrainArt/Ashenvale	Ashen_leaves	Leaves	WESTRING_TILE_LEAVES	1	1	1	1	7	Lgrd,Fgrd,Wsnw,Bdrg,Clvg,Nice,Ygsb,Vgrt,Qgrt,Xgsb,Dlvc,Glvc	0	\n" + //
				"	Cdrt	TerrainArt/Felwood	Felwood_Dirt	Dirt	WESTRING_TILE_DIRT	1	1	1	1	2	Ldrt,Fdrt,Wdrt,Bdsr,Adrt,Ndrt,Ydrt,Vdrt,Qdrt,Xdrt,Ddrt,Gdrt	0	\n" + //
				"	Cdrd	TerrainArt/Felwood	Felwood_DirtRough	Rough Dirt	WESTRING_TILE_ROUGH_DIRT	1	1	1	1	1	Ldro,Fdro,Wdro,Bdsd,Adrd,Ndrd,Ydtr,Vdrr,Qdrr,Xdtr,Dbrk,Gbrk	0	\n" + //
				"	Cpos	TerrainArt/Felwood	Felwood_Poison	Poison	WESTRING_TILE_POISON	1	1	1	1	6	Ldrg,Fdrg,Wsng,Bdrg,Adrg,Nice,Ygsb,Vgrt,Qgrt,Xgsb,Drds,Grds	0	\n" + //
				"	Crck	TerrainArt/Felwood	Felwood_Rock	Rock	WESTRING_TILE_ROCK	0	0	1	1	5	Lrok,Frok,Wrok,Bflr,Arck,Nrck,Ybtl,Vrck,Qrck,Xbtl,Ddkr,Gdkr	0	\n" + //
				"	Cvin	TerrainArt/Felwood	Felwood_Vines	Vines	WESTRING_TILE_VINES	0	1	1	1	3	Lrok,Frok,Wrok,Bdrr,Avin,Nsnr,Yrtl,Vcrp,Qcrp,Xrtl,Dlav,Glav	0	\n" + //
				"	Cgrs	TerrainArt/Felwood	Felwood_Grass	Grass	WESTRING_TILE_GRASS	1	1	1	1	4	Lgrs,Fgrs,Wgrs,Bgrr,Agrs,Ngrs,Yhdg,Vgrs,Qgrs,Xhdg,Dgrs,Ggrs	0	\n" + //
				"	Clvg	TerrainArt/Felwood	Felwood_Leaves	Leaves	WESTRING_TILE_LEAVES	1	1	1	1	7	Lgrd,Fgrd,Wsnw,Bdrg,Alvd,Nsnw,Ygsb,Vgrt,Qgrt,Xgsb,Dlvc,Glvc	0	\n" + //
				"	Ndrt	TerrainArt/Northrend	North_dirt	Dirt	WESTRING_TILE_DIRT	1	1	1	1	2	Ldrt,Fdrt,Wdrt,Bdsr,Adrt,Cdrt,Ydrt,Vdrt,Qdrt,Xdrt,Ddrt,Gdrt	0	\n" + //
				"	Ndrd	TerrainArt/Northrend	North_dirtdark	Dark Dirt	WESTRING_TILE_DARK_DIRT	1	1	1	1	1	Ldro,Fdro,Wdro,Bdsd,Adrd,Cdrd,Ydtr,Vdrr,Qdrr,Xdtr,Dbrk,Gbrk	0	\n" + //
				"	Nrck	TerrainArt/Northrend	North_rock	Rock	WESTRING_TILE_ROCK	0	0	1	1	6	Lrok,Frok,Wrok,Bflr,Arck,Crck,Ybtl,Vrck,Qrck,Xbtl,Ddkr,Gdkr	0	\n" + //
				"	Ngrs	TerrainArt/Northrend	North_Grass	Grass	WESTRING_TILE_GRASS	1	1	1	1	5	Lgrs,Fgrs,Wgrs,Bgrr,Agrs,Cgrs,Yhdg,Vgrs,Qgrs,Xhdg,Dbrk,Gbrk	0	\n" + //
				"	Nice	TerrainArt/Northrend	North_ice	Ice	WESTRING_TILE_ICE	1	1	1	1	3	Lgrd,Fgrd,Wsnw,Bdrg,Agrd,Cpos,Ygsb,Vgrs,Qgrs,Xgsb,Dgrs,Ggrs	0	\n" + //
				"	Nsnw	TerrainArt/Northrend	North_Snow	Snow	WESTRING_TILE_SNOW	1	1	1	1	4	Lgrs,Fgrs,Wgrs,Bgrr,Agrs,Clvg,Yhdg,Vgrt,Qgrt,Xhdg,Dlav,Glav	0	\n" + //
				"	Nsnr	TerrainArt/Northrend	North_SnowRock	Rocky Snow	WESTRING_TILE_ROCKY_SNOW	0	1	1	1	7	Lrok,Frok,Wrok,Bdrr,Avin,Cvin,Ysqd,Vstp,Qstp,Xsqd,Dlvc,Glvc	0	\n" + //
				"	Ydrt	TerrainArt/Cityscape	City_Dirt	Dirt	WESTRING_TILE_DIRT	1	1	1	1	1	Ldrt,Fdrt,Wdrt,Bdsr,Adrt,Cdrt,Ndrt,Vdrt,Qdrt,Xdrt,Ddrt,Gdrt	0	\n" + //
				"	Ydtr	TerrainArt/Cityscape	City_DirtRough	Rough Dirt	WESTRING_TILE_ROUGH_DIRT	1	1	1	1	2	Ldro,Fdro,Wdro,Bdsd,Adrd,Cdrd,Ndrd,Vdrr,Qdrr,Xdtr,Dbrk,Gbrk	0	\n" + //
				"	Yblm	TerrainArt/Cityscape	City_BlackMarble	Black Marble	WESTRING_TILE_BLACK_MARBLE	0	0	1	1	8	Lrok,Frok,Wrok,Bdrr,Avin,Cvin,Nrck,Vstp,Qstp,Xblm,Drds,Grds	0	\n" + //
				"	Ybtl	TerrainArt/Cityscape	City_BrickTiles	Brick	WESTRING_TILE_BRICK	0	0	1	1	5	Lrok,Frok,Wrok,Bflr,Arck,Crck,Nrck,Vrck,Qrck,Xbtl,Dbrk,Gbrk	0	\n" + //
				"	Ysqd	TerrainArt/Cityscape	City_SquareTiles	Square Tiles	WESTRING_TILE_SQUARE_TILES	0	0	1	1	6	Ldrt,Fdrt,Wdrt,Bdsr,Adrt,Cdrt,Nsnr,Vdrt,Qdrt,Xsqd,Dsqd,Gsqd	1	\n" + //
				"	Yrtl	TerrainArt/Cityscape	City_RoundTiles	Round Tiles	WESTRING_TILE_ROUND_TILES	0	0	1	1	7	Lrok,Frok,Wrok,Bflr,Arck,Crck,Nrck,Vrck,Qrck,Xrtl,Dsqd,Gsqd	1	\n" + //
				"	Ygsb	TerrainArt/Cityscape	City_Grass	Grass	WESTRING_TILE_GRASS	1	1	1	1	3	Lgrs,Fgrs,Wgrs,Bgrr,Agrs,Ngrs,Cgrs,Vgrs,Qgrs,Xgsb,Dbrk,Gbrk	0	\n" + //
				"	Yhdg	TerrainArt/Cityscape	City_GrassTrim	Grass Trim	WESTRING_TILE_GRASS_TRIM	1	1	1	1	4	Lgrs,Fgrs,Wgrs,Bgrr,Agrs,Ngrs,Cgrs,Vgrs,Qgrs,Xhdg,Dbrk,Gbrk	1	\n" + //
				"	Ywmb	TerrainArt/Cityscape	City_WhiteMarble	White Marble	WESTRING_TILE_WHITE_MARBLE	0	0	1	1	9	Lrok,Frok,Wrok,Bflr,Arck,Crck,Nrck,Vrck,Qrck,Xwmb,Dgrs,Ggrs	0	\n" + //
				"	Vdrt	TerrainArt/Village	Village_Dirt	Dirt	WESTRING_TILE_DIRT	1	1	1	1	2	Ldrt,Fdrt,Wdrt,Bdsr,Adrt,Cdrt,Ndrt,Ydrt,Qdrt,Xdrt,Ddrt,Gdrt	0	\n" + //
				"	Vdrr	TerrainArt/Village	Village_DirtRough	Rough Dirt	WESTRING_TILE_ROUGH_DIRT	1	1	1	1	1	Ldro,Fdro,Wdro,Bdsd,Adrd,Cdrd,Ndrd,Ydtr,Qdrr,Xdtr,Dbrk,Gbrk	0	\n" + //
				"	Vcrp	TerrainArt/Village	Village_Crops	Crops	WESTRING_TILE_CROPS	0	1	1	1	6	Ldrg,Fdrg,Wsng,Bdrr,Adrg,Cvin,Nrck,Yhdg,Qcrp,Xhdg,Dlvc,Glvc	0	\n" + //
				"	Vcbp	TerrainArt/Village	Village_CobblePath	Cobble Path	WESTRING_TILE_COBBLE_PATH	0	0	1	1	5	Ldro,Fdro,Wdro,Bdsd,Adrd,Cdrd,Ndrd,Ydtr,Qcbp,Xdtr,Dbrk,Gbrk	0	\n" + //
				"	Vstp	TerrainArt/Village	Village_StonePath	Stone Path	WESTRING_TILE_STONE_PATH	0	0	1	1	4	Lrok,Frok,Wrok,Bflr,Arck,Crck,Nsnw,Ywmb,Qstp,Xwmb,Drds,Grds	0	\n" + //
				"	Vgrs	TerrainArt/Village	Village_GrassShort	Short Grass	WESTRING_TILE_SHORT_GRASS	1	1	1	1	3	Lgrs,Fgrs,Wgrs,Bgrr,Agrs,Ngrs,Cgrs,Vgrs,Qgrs,Xhdg,Dbrk,Gbrk	0	\n" + //
				"	Vrck	TerrainArt/Village	Village_Rocks	Rocks	WESTRING_TILE_ROCKS	0	0	1	1	7	Lrok,Frok,Wrok,Bflr,Arck,Crck,Nrck,Ybtl,Qrck,Xbtl,Ddkr,Gdkr	0	\n" + //
				"	Vgrt	TerrainArt/Village	Village_GrassThick	Thick Grass	WESTRING_TILE_THICK_GRASS	1	1	1	1	8	Lgrd,Fgrd,Wsnw,Bdrg,Agrd,Clvg,Nice,Ygsb,Qgrt,Xgsb,Dlav,Glav	0	\n" + //
				"	Qdrt	TerrainArt/VillageFall	VillageFall_Dirt	Dirt	WESTRING_TILE_DIRT	1	1	1	1	2	Ldrt,Fdrt,Wdrt,Bdsr,Adrt,Cdrt,Ndrt,Ydrt,Vdrt,Xdrt,Ddrt,Gdrt	0	\n" + //
				"	Qdrr	TerrainArt/VillageFall	VillageFall_DirtRough	Rough Dirt	WESTRING_TILE_ROUGH_DIRT	1	1	1	1	1	Ldro,Fdro,Wdro,Bdsd,Adrd,Cdrd,Ndrd,Ydtr,Vdrr,Xdtr,Dbrk,Gbrk	0	\n" + //
				"	Qcrp	TerrainArt/VillageFall	VillageFall_Crops	Crops	WESTRING_TILE_CROPS	0	1	1	1	6	Ldrg,Fdrg,Wsng,Bdrr,Adrg,Cvin,Nsnw,Yhdg,Vcrp,Xhdg,Dlvc,Glvc	0	\n" + //
				"	Qcbp	TerrainArt/VillageFall	VillageFall_CobblePath	Cobble Path	WESTRING_TILE_COBBLE_PATH	0	0	1	1	5	Ldro,Fdro,Wdro,Bdsd,Adrd,Cdrd,Ndrd,Ydtr,Vcbp,Xdtr,Dbrk,Gbrk	0	\n" + //
				"	Qstp	TerrainArt/VillageFall	VillageFall_StonePath	Stone Path	WESTRING_TILE_STONE_PATH	0	0	1	1	4	Lrok,Frok,Wrok,Bflr,Arck,Crck,Nsnr,Ywmb,Vstp,Xwmb,Drds,Grds	0	\n" + //
				"	Qgrs	TerrainArt/VillageFall	VillageFall_GrassShort	Short Grass	WESTRING_TILE_SHORT_GRASS	1	1	1	1	3	Lgrs,Fgrs,Wgrs,Bgrr,Agrs,Ngrs,Cgrs,Vgrs,Vgrs,Xhdg,Dbrk,Gbrk	0	\n" + //
				"	Qrck	TerrainArt/VillageFall	VillageFall_Rocks	Rocks	WESTRING_TILE_ROCKS	0	0	1	1	7	Lrok,Frok,Wrok,Bflr,Arck,Crck,Nrck,Ybtl,Vrck,Xbtl,Ddkr,Gdkr	0	\n" + //
				"	Qgrt	TerrainArt/VillageFall	VillageFall_GrassThick	Thick Grass	WESTRING_TILE_THICK_GRASS	1	1	1	1	8	Lgrd,Fgrd,Wsnw,Bdrg,Agrd,Clvg,Nice,Ygsb,Vgrt,Xgsb,Dlav,Glav	0	\n" + //
				"	Xdrt	TerrainArt/Dalaran	Dalaran_Dirt	Dirt	WESTRING_TILE_DIRT	1	1	1	1	1	Ldrt,Fdrt,Wdrt,Bdsr,Adrt,Cdrt,Ndrt,Vdrt,Qdrt,Ydrt,Ddrt,Gdrt	0	\n" + //
				"	Xdtr	TerrainArt/Dalaran	Dalaran_DirtRough	Rough Dirt	WESTRING_TILE_ROUGH_DIRT	1	1	1	1	2	Ldro,Fdro,Wdro,Bdsd,Adrd,Cdrd,Ndrd,Vdrr,Qdrr,Ydtr,Dbrk,Gbrk	0	\n" + //
				"	Xblm	TerrainArt/Dalaran	Dalaran_BlackMarble	Black Marble	WESTRING_TILE_BLACK_MARBLE	0	0	1	1	8	Lrok,Frok,Wrok,Bdrr,Avin,Cvin,Nrck,Vstp,Qstp,Yblm,Drds,Grds	0	\n" + //
				"	Xbtl	TerrainArt/Dalaran	Dalaran_BrickTiles	Brick	WESTRING_TILE_BRICK	0	0	1	1	5	Lrok,Frok,Wrok,Bflr,Arck,Crck,Nrck,Vrck,Qrck,Ybtl,Dbrk,Gbrk	0	\n" + //
				"	Xsqd	TerrainArt/Dalaran	Dalaran_SquareTiles	Square Tiles	WESTRING_TILE_SQUARE_TILES	0	0	1	1	6	Ldrt,Fdrt,Wdrt,Bdsr,Adrt,Cdrt,Nsnr,Vdrt,Qdrt,Ysqd,Dsqd,Gsqd	0	\n" + //
				"	Xrtl	TerrainArt/Dalaran	Dalaran_RoundTiles	Round Tiles	WESTRING_TILE_ROUND_TILES	0	0	1	1	7	Lrok,Frok,Wrok,Bflr,Arck,Crck,Nrck,Vrck,Qrck,Yrtl,Dsqd,Gsqd	0	\n" + //
				"	Xgsb	TerrainArt/Dalaran	Dalaran_Grass	Grass	WESTRING_TILE_GRASS	1	1	1	1	3	Lgrs,Fgrs,Wgrs,Bgrr,Agrs,Nsnw,Cgrs,Vgrs,Qgrs,Ygsb,Dbrk,Gbrk	0	\n" + //
				"	Xhdg	TerrainArt/Dalaran	Dalaran_GrassTrim	Grass Trim	WESTRING_TILE_GRASS_TRIM	1	1	1	1	4	Lgrs,Fgrs,Wgrs,Bgrr,Agrs,Nice,Cgrs,Vgrs,Qgrs,Yhdg,Dbrk,Gbrk	0	\n" + //
				"	Xwmb	TerrainArt/Dalaran	Dalaran_WhiteMarble	White Marble	WESTRING_TILE_WHITE_MARBLE	0	0	1	1	9	Lrok,Frok,Wrok,Bflr,Arck,Crck,Nrck,Vrck,Qrck,Ywmb,Dgrs,Ggrs	0	\n" + //
				"	Ddrt	TerrainArt/Dungeon	Cave_Dirt	Dirt	WESTRING_TILE_DIRT	1	1	1	1	1	Ldrt,Fdrt,Wdrt,Bdsr,Adrt,Cdrt,Ndrt,Vdrt,Qdrt,Ydrt,Xdrt,Gdrt	0	\n" + //
				"	Dbrk	TerrainArt/Dungeon	Cave_Brick	Brick	WESTRING_TILE_BRICK	0	1	1	1	5	Ldro,Fdro,Wdro,Bdsd,Adrd,Cdrd,Ndrd,Vdrr,Ydtr,Qdrr,Xdtr,Gbrk	0	\n" + //
				"	Drds	TerrainArt/Dungeon	Cave_RedStones	Red Stone	WESTRING_TILE_RED_STONE	0	1	1	1	8	Ldro,Fdro,Wdro,Bdrr,Adrd,Cdrd,Ndrd,Ydtr,Vcbp,Qcbp,Xdtr,Grds	0	\n" + //
				"	Dlvc	TerrainArt/Dungeon	Cave_LavaCracks	Lava Cracks	WESTRING_TILE_LAVA_CRACKS	0	1	1	1	3	Lrok,Frok,Wrok,Bgrr,Alvd,Clvg,Nrck,Yhdg,Vcrp,Qcrp,Xhdg,Glvc	0	\n" + //
				"	Dlav	TerrainArt/Dungeon	Cave_Lava	Lava	WESTRING_TILE_LAVA	0	1	1	1	2	Lrok,Frok,Wrok,Bdsd,Avin,Cvin,Nrck,Yhdg,Vcrp,Qcrp,Xhdg,Glav	0	\n" + //
				"	Ddkr	TerrainArt/Dungeon	Cave_DarkRocks	Dark Rock	WESTRING_TILE_DARK_ROCK	0	1	1	1	4	Lrok,Frok,Wrok,Bflr,Arck,Crck,Nrck,Ybtl,Vrck,Xbtl,Qrck,Gdkr	0	\n" + //
				"	Dgrs	TerrainArt/Dungeon	Cave_GreyStones	Grey Stones	WESTRING_TILE_GREY_STONES	0	1	1	1	7	Lrok,Frok,Wrok,Bflr,Arck,Cgrs,Nrck,Vrck,Qrck,Ywmb,Xwmb,Ggrs	0	\n" + //
				"	Dsqd	TerrainArt/Dungeon	Cave_SquareTiles	Square Tiles	WESTRING_TILE_SQUARE_TILES	0	1	1	1	6	Ldrt,Fdrt,Wdrt,Bdsr,Adrt,Cdrt,Ndrt,Vdrt,Qdrt,Ysqd,Xsqd,Gsqd	0	\n" + //
				"	Gdrt	TerrainArt/Dungeon2	GDirt	Dirt	WESTRING_TILE_DIRT	1	1	1	1	1	Ldrt,Fdrt,Wdrt,Bdsr,Adrt,Cdrt,Ndrt,Vdrt,Qdrt,Ydrt,Xdrt,Ddrt	0	\n" + //
				"	Gbrk	TerrainArt/Dungeon2	GBrick	Brick	WESTRING_TILE_BRICK	0	1	1	1	5	Ldro,Fdro,Wdro,Bdsd,Adrd,Cdrd,Ndrd,Vdrr,Ydtr,Qdrr,Xdtr,Dbrk	0	\n" + //
				"	Grds	TerrainArt/Dungeon2	GRedStones	Red Stone	WESTRING_TILE_RED_STONE	0	1	1	1	8	Ldro,Fdro,Wdro,Bdrr,Adrd,Cdrd,Ndrd,Ydtr,Vcbp,Qcbp,Xdtr,Drds	0	\n" + //
				"	Glvc	TerrainArt/Dungeon2	GLavaCracks	Lava Cracks	WESTRING_TILE_LAVA_CRACKS	0	1	1	1	3	Lrok,Frok,Wrok,Bgrr,Alvd,Clvg,Nrck,Yhdg,Vcrp,Qcrp,Xhdg,Dlvc	0	\n" + //
				"	Glav	TerrainArt/Dungeon2	GLava	Lava	WESTRING_TILE_LAVA	0	1	1	1	2	Lrok,Frok,Wrok,Bdsd,Avin,Cvin,Nrck,Yhdg,Vcrp,Qcrp,Xhdg,Dlav	0	\n" + //
				"	Gdkr	TerrainArt/Dungeon2	GDarkRocks	Dark Rock	WESTRING_TILE_DARK_ROCK	0	1	1	1	4	Lrok,Frok,Wrok,Bflr,Arck,Crck,Nrck,Ybtl,Vrck,Xbtl,Qrck,Ddkr	0	\n" + //
				"	Ggrs	TerrainArt/Dungeon2	GGreyStones	Grey Stones	WESTRING_TILE_GREY_STONES	0	1	1	1	7	Lrok,Frok,Wrok,Bflr,Arck,Cgrs,Nrck,Vrck,Qrck,Ywmb,Xwmb,Dgrs	0	\n" + //
				"	Gsqd	TerrainArt/Dungeon2	GSquareTiles	Square Tiles	WESTRING_TILE_SQUARE_TILES	0	1	1	1	6	Ldrt,Fdrt,Wdrt,Bdsr,Adrt,Cdrt,Ndrt,Vdrt,Qdrt,Ysqd,Xsqd,Dsqd	0	\n" + //
				"";
			cliffTypes_slkStr = //
				"	cliffID	cliffModelDir	rampModelDir	texDir	texFile	name	groundTile	upperTile	cliffClass	oldID	\n" + //
				"	CLdi	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff0	WESTRING_CLIFF_CLdi	Ldrt	_	c2	0	\n" + //
				"	CLgr	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff1	WESTRING_CLIFF_CLgr	Lgrs	_	c1	1	\n" + //
				"	CFdi	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff0	WESTRING_CLIFF_CFdi	Fdrt	_	c2	2	\n" + //
				"	CFgr	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff1	WESTRING_CLIFF_CFgr	Fgrs	_	c1	3	\n" + //
				"	CWgr	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff0	WESTRING_CLIFF_CWgr	Wgrs	_	c2	5	\n" + //
				"	CWsn	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff1	WESTRING_CLIFF_CWsn	Wsnw	_	c1	4	\n" + //
				"	CBde	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff0	WESTRING_CLIFF_CBde	Bdsr	_	c2	6	\n" + //
				"	CBgr	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff1	WESTRING_CLIFF_CBgr	Bgrr	_	c1	7	\n" + //
				"	CNdi	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff0	WESTRING_CLIFF_CNdi	Ndrt	_	c2	8	\n" + //
				"	CNsn	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff1	WESTRING_CLIFF_CNsn	Nsnw	_	c1	9	\n" + //
				"	CAgr	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff1	WESTRING_CLIFF_CAgr	Agrs	_	c1	10	\n" + //
				"	CAdi	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff0	WESTRING_CLIFF_CAdi	Adrt	_	c2	11	\n" + //
				"	CCgr	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff1	WESTRING_CLIFF_CCgr	Cgrs	_	c1	12	\n" + //
				"	CCdi	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff0	WESTRING_CLIFF_CCdi	Cdrt	_	c2	13	\n" + //
				"	CYdi	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff0	WESTRING_CLIFF_CYdi	Ydrt	_	c2	14	\n" + //
				"	CYsq	CityCliffs	CityCliffTrans	ReplaceableTextures/Cliff	Cliff1	WESTRING_CLIFF_CYsq	Ysqd	_	c1	15	\n" + //
				"	CVdi	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff0	WESTRING_CLIFF_CVdi	Vdrt	_	c2	17	\n" + //
				"	CVgr	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff1	WESTRING_CLIFF_CVgr	Vgrt	_	c1	18	\n" + //
				"	CXdi	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff0	WESTRING_CLIFF_CXdi	Xdrt	_	c2	19	\n" + //
				"	CXsq	CityCliffs	CityCliffTrans	ReplaceableTextures/Cliff	Cliff1	WESTRING_CLIFF_CXsq	Xsqd	_	c1	20	\n" + //
				"	CDdi	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff0	WESTRING_CLIFF_CDdi	Ddrt	_	c2	21	\n" + //
				"	CDsq	CityCliffs	CityCliffTrans	ReplaceableTextures/Cliff	Cliff1	WESTRING_CLIFF_CDsq	Dsqd	_	c1	22	\n" + //
				"	CQdi	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff0	WESTRING_CLIFF_CVdi	Qdrt	_	c2	23	\n" + //
				"	CQgr	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff1	WESTRING_CLIFF_CVgr	Qgrt	_	c1	24	\n" + //
				"	CGdi	Cliffs	CliffTrans	ReplaceableTextures/Cliff	Cliff0	WESTRING_CLIFF_CDdi	Gdrt	_	c2	21	\n" + //
				"	CGsq	CityCliffs	CityCliffTrans	ReplaceableTextures/Cliff	Cliff1	WESTRING_CLIFF_CDsq	Gsqd	_	c1	22	\n" + //
				"";
		}
	}
}
