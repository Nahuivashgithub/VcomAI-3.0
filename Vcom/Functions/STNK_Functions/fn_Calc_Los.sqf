// Returns True if there is a line of sight between unit and target
// Input params:
// 0: target array:
//		0: perceived position
//		1: perceived type as recognized
//		2: perceived side
//		3: subjective cost
//		4: object itself
//		5: position accuracy
// 1: our tank object

private ["_has_los", "_eyePos_tank", "_tlos", "_olos", "_known_pos", "_shift", "_los_pos", "_tank", "_target"];

_has_los = False;

_target = _this select 0 select 4;
_tank = _this select 1;
_eyePos_tank = eyePos _tank;
_known_pos = ATLtoASL (_this select 0 select 0); // nearTargets gives perceived position ATL
_actual_pos = getPosASL _target;
_shift = [(_known_pos select 0) - (getPosASL _target select 0), (_known_pos select 1) - 
(getPosASL _target select 1), (_known_pos select 2) - (getPosASL _target select 2)];

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Percevied position can be different from actual one, and calculations using perceived position can result in no LoS when the target 
// is actually visible. For this purpose if the perceived position is not further away than 10 meters from actual, we calculate LOS 
// from actual position, because we assume that we still can see the target. We cannot always use actual position for LoS calculation, 
// because we may know that the target exists, but may not know its exact location. We want to avoid magically learning that we have 
// a LoS of a target that no one is looking at.
// Perceived position Z coordinate equals (if zero judgment error) eyePos Z coordinate for all vehicles, air and static weapons. For 
// soldiers perceived position Z coordinate is lower than eyePos Z coordinate by: 40 cm if standing, 30 cm if kneeling, 20 cm if prone.
// Perceived position Z coordinate usually has a very small error, so we can use it as Z coordinate of actual position. We need that 
// because all getPos commands return the point 0 m above the ground.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if (((_shift select 0) ^ 2 + (_shift select 1) ^ 2 + (_shift select 2) ^ 2) < 100) then 
{
	_los_pos = [_actual_pos select 0, _actual_pos select 1, _known_pos select 2];
}
else 
{
	_los_pos = _known_pos;
};
_olos = lineIntersects [_los_pos, _eyePos_tank, _target, _tank];
// Looks like terrainIntersectASL takes the grass into account too.
// You may have a 'clear' line of sight and 'Ready to fire' report
// but still have terrainIntersectASL true.
// Fixed by adding extra 0.2m to Z coordinate.
_tlos = terrainIntersectASL [[_los_pos select 0, _los_pos select 1,
(_los_pos select 2) + 0.2], _eyePos_tank];
if (!_olos and !_tlos) then 
{
	_has_los = True;
};

_has_los