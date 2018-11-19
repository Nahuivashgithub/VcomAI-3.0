// How much ammo a magazine has
// Params:
// 0: our tank object
// 1: magazine name

params ["_unit", "_mag"];
private _ammo = 0;
{
	if (_mag == _x select 0) exitWith {_ammo = _x select 1};
} foreach (magazinesAmmo _unit);
_ammo