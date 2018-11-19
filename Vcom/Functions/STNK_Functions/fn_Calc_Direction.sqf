// Returns direction in degrees [0; 360] from _unit_pos to _position
// Params:
// 0: our position (array)
// 1: another position (array)

params ["_unit_pos", "_position"];

private _dirVector =  _position vectorDiff _unit_pos;
private _dir_x = _dirVector select 0;
private _dir_y = _dirVector select 1;
private _direction = 1000;
if (_dir_y == 0 and _dir_x == 0) then 
{
	// no valid direction, return 1000
}
else {
	if (_dir_x >= 0) then {
		_direction = acos(_dir_y / (sqrt(_dir_x ^ 2 + _dir_y ^ 2)));
	}
	else {
		_direction = 360 - acos(_dir_y / (sqrt(_dir_x ^ 2 + _dir_y ^ 2)));
	};
};
_direction