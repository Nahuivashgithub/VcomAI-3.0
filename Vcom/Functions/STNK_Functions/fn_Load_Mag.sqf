// Loads a round into cannon
// Params:
// 0: our tank object
// 1: magazine name to load

params ["_unit", "_mag"];
private _all_mags = magazinesAmmo _unit;
private _mag_ammo = [_unit, _mag] call AL9K_fnc_Has_Ammo;
{
	_unit removeMagazine (_x select 0);
} foreach _all_mags;
_unit addMagazine [_mag, _mag_ammo];
_all_mags = _all_mags - [[_mag, _mag_ammo]];
{
	_unit addMagazine _x;
} foreach _all_mags;