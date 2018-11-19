// Returns an array of weapons classes present on unit:
// [0: has_cannon, 1: has_autocannon, 2: has_mg, 3: has_at_rocket,
// 4: has_he_rocket, 5: has_gmg, 6: has_hmg, 7: has_autocannon_aa,
// 8: has_aa_rocket]
// Params:
// 0: unit

private["_cannon", "_autocannon", "_mg", "_at_rocket", "_he_rocket",
"_gmg", "_hmg", "_autocannon_aa", "_titan_rocket", "_aa_rocket_mag",
"_at_rocket_mag", "_aa_rocket", "_has_weapons", "_all_weapons", "_i", "_wep",
"_y"];

params ["_unit"];
_has_weapons = [false, false, false, false, false, false, false, false, false];
_i = 0;
_wep = [];

// Slammer, Slammer UP, Varsuk, Kuma
_cannon = ["cannon_120mm", "cannon_105mm", "cannon_125mm", "cannon_120mm_long"];

// Marshall, Kamysh, Mora, Gorgon, Wipeout
_autocannon = ["autocannon_40mm_CTWS", "autocannon_30mm_CTWS",
"autocannon_30mm"];

// present on tanks, APCs
_mg = ["LMG_M200", "LMG_coax"];

// Blackfoot, Kajman, Orca, PCML, Alamut, Titan compact, Wipeout, Buzzard
_at_rocket = ["missiles_DAGR", "missiles_SCALPEL", "launch_NLAW_F",
"launch_RPG32_F", "launch_Titan_short_F", "launch_B_Titan_short_F",
"launch_O_Titan_short_F", "launch_I_Titan_short_F", 
"Missile_AGM_02_Plane_CAS_01_F", "Rocket_04_AP_Plane_CAS_01_F", 
"Missile_AGM_01_Plane_CAS_02_F", "Rocket_03_AP_Plane_CAS_02_F"];

// Kajman, Hellcat, Pawnee
_he_rocket = ["rockets_Skyfire", "missiles_DAR", "Rocket_03_HE_Plane_CAS_02_F",
"Rocket_04_HE_Plane_CAS_01_F"];

// Panther, Marid, Hunter GMG, Ifrit GMG, Strider GMG, Static GMG, Blackfoot,
// Wipeout, Kajman, Buzzard, Neophrone
// gatling cannons added because of similar damage
_gmg = ["GMG_40mm", "GMG_20mm", "gatling_20mm", "Gatling_30mm_Plane_CAS_01_F",
"gatling_30mm", "Twin_Cannon_20mm", "Cannon_30mm_Plane_CAS_02_F"];

// Panther, Marid, Hunter HMG, Ifrit HMG, Strider HMG, Offroad armed
// Static HMG, Varsuk
_hmg = ["HMG_127_APC", "HMG_127", "HMG_M2", "HMG_01", "HMG_NSVT"];

// Cheetah, Tigris
_autocannon_aa = ["autocannon_35mm"];

// Cheetah, Tigris, Kamysh, Gorgon, Static AT, Static AA
// can be loaded with either AT or AA missiles, need to check available mag
_titan_rocket = ["missiles_titan", "missiles_titan_static"];
_aa_rocket_mag = ["1Rnd_GAA_missiles", "4Rnd_Titan_long_missiles"];
_at_rocket_mag = ["2Rnd_GAT_missiles", "1Rnd_GAT_missiles"];

// Titan MPRL, Buzzard
_aa_rocket = ["launch_Titan_F", "launch_B_Titan_F", "launch_O_Titan_F",
"launch_I_Titan_F", "Missile_AA_04_Plane_CAS_01_F", "missiles_ASRAAM", 
"missiles_Zephyr", "Missile_AA_03_Plane_CAS_02_F"];

_all_weapons = [_cannon, _autocannon, _mg, _at_rocket, _he_rocket, _gmg, _hmg,
_autocannon_aa, _aa_rocket];

_wep = _wep + (weapons _unit) + (_unit weaponsTurret [0,0]) +
(_unit weaponsTurret [-1]);

{
	_y = _x;
	{
		if (_x in _y) then 
		{
			_has_weapons set [_i, true];
		};
	} foreach _wep;
	_i = _i + 1;
} foreach _all_weapons;

{
	_y = _x;
	if (_y in _titan_rocket) then 
	{
		{
			if (_x in _aa_rocket_mag) then 
			{
				_has_weapons set [8, true];
			};
			if (_x in _at_rocket_mag) then 
			{
				_has_weapons set [3, true];
			};
		} foreach (magazines _unit);
	};
} foreach _wep;

_has_weapons