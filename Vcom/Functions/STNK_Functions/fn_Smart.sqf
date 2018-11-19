// v.1.8
// If the vehicle is in the list, enable smart behaviour.
diag_log ("AL9K_fnc_Smart started, isServer: " + str isServer);

_vehicles = []; // all vehicles array
_active = []; // vehicles already running script
_inactive = []; // vehicles to be removed from array

if (!isServer) then {
	"msg" addPublicVariableEventHandler {
		player commandChat msg;
	};
};

while {true} do 
{
	_vehicles = vehicles;
	{
		if ((true in ([_x] call AL9K_fnc_List_Weapons)) && !(_x in _active) && alive _x) then 
		{
			if (local _x) then 
			{
			  [_x] spawn AL9K_fnc_Setup;
			}
			else 
			{
				_x addEventHandler ["Local", {
					if (_this select 1) then 
					{
						[_this select 0] spawn AL9K_fnc_Setup;
					};
				}];
			};
			_active = _active + [_x];
		}
	} foreach _vehicles;
	
	_inactive = [];
	{
		if (!(alive _x)) then 
		{
			_inactive = _inactive + [_x];
		}
	} foreach _active;
	_active = _active - _inactive;
	sleep 30;
}
