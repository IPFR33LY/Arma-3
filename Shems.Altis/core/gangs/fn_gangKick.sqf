#include <macro.h>

private["_unit","_unitID","_members"];
disableSerialization;

if((lbCurSel 2621) == -1) exitWith {hint "You need to select a person to kick!"};
_unit = call compile format["%1",getSelData(2621)];
if(isNull _unit) exitWith {};
if(_unit == player) exitWith {hint "You cannot kick yourself!"};

_unitID = getPlayerUID _unit;
_members = grpPlayer getVariable "gang_members";
if(isNil "_members") exitWith {};
if(typeName _members != "ARRAY") exitWith {};
_members = _members - [_unitID];
grpPlayer setVariable["gang_members",_members,true];

[[_unit,grpPlayer],"clientGangKick",_unit,false] spawn life_fnc_MP;
[[4,grpPlayer],"TON_fnc_updateGang",false,false] spawn life_fnc_MP;
[] call life_fnc_gangMenu;