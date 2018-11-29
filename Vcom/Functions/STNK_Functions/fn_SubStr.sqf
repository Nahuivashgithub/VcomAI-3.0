// Due to the lack of substr function in ARMA here is the custom one
// Params:
// 0: string to find
// 1: string to look in

//Deprecated

params ["_find", "_inputStr"];

private _string = toArray (_inputStr);
private _find_len = count toArray _find;
private _str = [] + _string;
_str resize _find_len;
private _found = false;
private _pos = 0;
for "_i" from _find_len to count _string do 
{
	if (toString _str == _find) exitWith {_found = true};
	_str set [_find_len, _string select _i];
	_str set [0, "x"];
	_str = _str - ["x"];
	_pos = _pos + 1;
};
if (!_found) then 
{
	_pos = -1;
};
_pos