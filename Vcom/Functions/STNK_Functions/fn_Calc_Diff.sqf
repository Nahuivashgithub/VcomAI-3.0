// Returns difference in degrees [-180; 180] between arbitrary direction and the direction the unit is facing

params ["_tank", "_face"];
private _tank_dir = getDir _tank;

//_diff negative -- turn left, _diff positive -- turn right
private _diff = _face - _tank_dir;
if (_diff > 180) then {
	_diff = _diff - 360;
};
if (_diff < -180) then {
	_diff = _diff + 360;
};
_diff