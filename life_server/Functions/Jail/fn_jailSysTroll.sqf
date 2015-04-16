private["_unit","_bad","_id","_ret","_time"];

_unit = [_this,0,Objnull,[Objnull]] call BIS_fnc_param;
if(isNull _unit) exitWith {};
_bad = [_this,1,false,[false]] call BIS_fnc_param;
_time = [_this,2,15,[0]] call BIS_fnc_param;


if(_bad) then
{
	diag_log "**TIMEJAIL** Chargement du temps de prison depuis la DB";

	_query = format["SELECT jail_time FROM players WHERE playerid='%2'", _time, getPlayerUID _unit];
	waitUntil{!DB_Async_Active};
	_result = [_query,2] call DB_fnc_asyncCall;
	_result = (_result select 0);
	
	diag_log format["**TIMEJAIL** ... returned %1", _result];
	
	_time = _result;
} else {
	diag_log "**TIMEJAIL** Envoie d'une requête à la DB";
	_query = format["UPDATE players SET jail_time='%1' WHERE playerid='%2'", _time, getPlayerUID _unit];
	waitUntil{!DB_Async_Active};
	_result = [_query,1] call DB_fnc_asyncCall;
};

diag_log format["**TIMEJAIL** Le temps de prison pour le joueur %1 est de %2",name _unit , _time];

_id = owner _unit;

_ret = [_unit] call life_fnc_wantedPerson;
[[_ret,_bad,_time],"life_fnc_jailMeTroll",_id,false] call life_fnc_MP;