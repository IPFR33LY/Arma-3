private["_uid","_query"];
_uid = [_this,0,"",[""]] call BIS_fnc_param;
if(_uid == "") exitWith {};

_query = format["UPDATE wanted SET active = 0, wantedCrimes = '[]', wantedBounty = 0 WHERE wantedID='%1'",_uid];
waitUntil{!DB_Async_Active};
[_query,2] call DB_fnc_asyncCall;