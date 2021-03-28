//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_WOTC_AjjersBleedingRipjack.uc                                    
//
//	CREATED BY RustyDios
//           
//	File created	25/07/20    21:00
//	LAST UPDATED    07/08/20	18:00
//  
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_WOTC_AjjersBleedingRipjack extends X2DownloadableContentInfo config (GameData_SoldierSkills);
struct AddBleedingEffect
{
	var name TemplateName;
	var int NumTurns;
	var int DamagePerTick;
	var int PercentChance;

	structdefaultproperties
	{
		TemplateName = "";
		NumTurns = 1;
		DamagePerTick = 1;
		PercentChance = 100;
	}
};

var config array<AddBleedingEffect> AddBleedingEffectToAbilities;
var config bool bEnableLogging_AjjersRipjack;

/// Called on new campaign while this DLC / Mod is installed
static event InstallNewCampaign(XComGameState StartState){}		//empty_func

/// Called on first time load game if not already installed	
static event OnLoadedSavedGame(){}								//empty_func

// Called on load into a save game strategy layer
static event OnLoadedSavedGameToTactical(){}					//empty_func

// Called on load into a save game strategy layer
static event OnLoadedSavedGameToStrategy(){}					//empty_func

///////////////////////////////////////////////////////////////////////////////
//	OPTC
///////////////////////////////////////////////////////////////////////////////
static event OnPostTemplatesCreated()
{
	AddBleedToStuff();
}

static function AddBleedToStuff()
{
	local X2AbilityTemplateManager				AllAbilities;		//holder for all abilities
	local X2AbilityTemplate						CurrentAbility;		//current things to focus on

	local X2Effect_Persistent					BleedingEffect;		//Added to Deadeye
	local int i;

	AllAbilities		= class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	for (i = 0; i <= default.AddBleedingEffectToAbilities.length; i++)
	{
		CurrentAbility = AllAbilities.FindAbilityTemplate(default.AddBleedingEffectToAbilities[i].TemplateName);
		if (CurrentAbility != none)
		{
			//Bleeding Status effect (iNumTurns, iDamagePerTick)
			BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.AddBleedingEffectToAbilities[i].NumTurns,default.AddBleedingEffectToAbilities[i].DamagePerTick);
			BleedingEffect.ApplyChance = default.AddBleedingEffectToAbilities[i].PercentChance;
			BleedingEffect.bEffectForcesBleedout = false;
			CurrentAbility.AddTargetEffect(BleedingEffect);

			`LOG("Patched With Bleeding Effect:: " @default.AddBleedingEffectToAbilities[i].TemplateName @" :: NumTurns :: " $default.AddBleedingEffectToAbilities[i].NumTurns @" :: Damage :: " $default.AddBleedingEffectToAbilities[i].DamagePerTick @" :: Chance :: " $default.AddBleedingEffectToAbilities[i].PercentChance,default.bEnableLogging_AjjersRipjack,'WOTC_Ajjers_Ripjack');
		}
	}
}