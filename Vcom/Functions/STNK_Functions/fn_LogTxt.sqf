
params ["_unit", "_txt"];

if (!isNull player) then 
{
	if ((side _unit) == (side player)) then 
	{
		if (isServer and isMultiplayer) then 
		{
			missionNamespace setVariable ["msg", _txt];
			publicVariable "msg";
		}
		else 
		{
		  _unit commandChat _txt;
		};
	};
};