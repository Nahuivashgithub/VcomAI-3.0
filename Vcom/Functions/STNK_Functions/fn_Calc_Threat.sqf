// Returns target's relative threat
// Threat < 100 is calculated from Subjective value / 1000000 and means regular units, not dangerous to armor.
// Threat > 500 means immediate threat and must be destroyed ASAP. The tank will stop, even if was executing a
// move order, rotate the hull to the target and fire. After destroying the immediate threat the tank will
// resume moving to it's previous destination.
// Input params:
// 0: target array:
//		0: perceived position
//		1: perceived type as recognized
//		2: perceived side
//		3: subjective cost
//		4: object itself
//		5: position accuracy
// 1: our tank object

private ["_threat", "_distance", "_unit_pos", "_known_pos",
"_type", "_can_fire", "_unit", "_soft", "_target_wep", "_unit_wep",
"_wep_threat", "_y", "_i", "_j", "_ranges", "_t", "_classes", "_can_dmg", 
"_softness"];

_threat = 0;
_can_fire = false;
// is the target a lightly armored / unarmored target (MRAP, static AT)?
// if yes, we might want to switch to HEAT round
// 0: doesn't matter
// 1: soft target (cars, static weapons)
// 2: heavily armrored (tanks)
_soft = 0;

_unit = _this select 1;
_unit_pos = getPosATL _unit;
_known_pos = _this select 0 select 0; // perceived position of the target
_type = _this select 0 select 1; // perceived type of the target
_distance = _unit_pos distance _known_pos; // distance to target

_target_wep = [_this select 0 select 4] call AL9K_fnc_List_Weapons;
_unit_wep = [_unit] call AL9K_fnc_List_Weapons;

_threat = 0;

// value positions correspond to AL9K_fnc_List_Weapons return array
_wep_threat = [
	// 0: cannons
	[400, 425, 450, 500, 600],
	// 1: autocannons
	[0, 200, 250, 470, 600],
	// 2: light MGs
	[0, 0, 0, 0, 0],
	// 3: AT rockets
	[0, 400, 450, 500, 570],
	// 4: HE rocket
	[0, 300, 350, 400, 470],
	// 5: GMG
	[0, 0, 130, 150, 200],
	// 6: HMG
	[0, 0, 0, 140, 190],
	// 7: autocannon AA
	[0, 0, 0, 130, 180],
	// 8: AA rockets
	[0, 0, 0, 0, 0]
];

_ranges = [2000, 1500, 1000, 750, 500];

_classes = [
	"CAManBase",
	"Car",
	"Tank",
	"Helicopter",
	"Ship",
	"Plane",
	"StaticWeapon"
];

_softness = [
	0, // Men
	1, // Car
	2, // Tank
	0, // Heli
	1, // Ship
	0, // Plane
	0  // Static
];
// value positions correspond to AL9K_fnc_List_Weapons return array
_can_dmg = [
	//cnn, acnn, lmgs, atrck, herck, gmgs, hmgs, acaa, aarck
	// CAManBase
	[true, true, true, false, true, true, true, true, false],
	// Car
	[true, true, false, true, true, true, true, true, false],
	// Tank
	[true, true, false, true, false, false, false, false, false],
	// Helicopter
	[true, true, false, false, false, false, true, true, true],
	// Ship
	[true, true, false, true, true, true, true, true, false],
	// Plane
	[false, true, false, false, false, false, true, true, true],
	// Static
	[true, true, true, true, true, true, true, true, false]
];


// target's threat base on its weapons
_i = 0;
{
	_y = _x;
	if (_y) then 
	{
		_t = 0;
		_j = 0;
		{
			if (_distance < _ranges select _j) then 
			{
				_t = _x - _distance / 100;
			};
			_j = _j + 1;
		} foreach (_wep_threat select _i);

		if (_t > _threat) then 
		{
			_threat = _t;
		};
	};
	_i = _i + 1;
} foreach _target_wep;

// can we fire at it?
_i = 0;
{
	if (_can_fire) exitWith {};
	_y = _x;
	if (_type isKindOf _y) then {
		_soft = _softness select _i;
		_j = 0;
		{
			if (_x AND _unit_wep select _j) exitWith 
			{
				_can_fire = true;
			};
			_j = _j + 1;
		} foreach (_can_dmg select _i);
	};
	_i = _i + 1;
} foreach _classes;

// Exception for wheeled APCs, that have stronger armor than other 'cars'
if (_type isKindOf "Wheeled_APC_F") then {
	_soft = 2;
};

if (_threat == 0) then {
	_threat = (_this select 0 select 3) / 1000000;
	_can_fire = true;
};
//hint format ["t: %1\nt: %2\nf: %3\ns: %4\nd: %5",
//_this select 0 select 4, _threat, _can_fire, _soft, _distance];
[_threat, _can_fire, _soft, _distance]