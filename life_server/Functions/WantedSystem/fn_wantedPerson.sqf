private["_unit","_index","_queryResult","_result"];
_unit = [_this,0,ObjNull,[ObjNull]] call BIS_fnc_param;
if(isNull _unit) exitWith {[]};
_uid = getPlayerUID player;
_result = format["SELECT wantedID, wantedName, wantedBounty FROM wanted WHERE wantedID='%1' AND active='1'",_uid];
waitUntil{!DB_Async_Active};
_queryResult = [_result,2] call DB_fnc_asyncCall;
if(count _queryResult == 0) exitWith {[]};
_queryResult;