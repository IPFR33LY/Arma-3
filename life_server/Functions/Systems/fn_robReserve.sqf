private["_vault","_unit"];
_vault = [_this,0,ObjNull,[ObjNull]] call BIS_fnc_param;
_unit = [_this,1,ObjNull,[ObjNull]] call BIS_fnc_param;

if(isNull _vault OR isNull _unit) exitWith {};
if(!alive _unit) exitWith {};
_unit = owner _unit;

if((_vault getVariable["fed_rob_ip",false])) exitWith
{
	[[1,"Ce coffre à déjà été pillé par quelqu'un d'autre"],"life_fnc_broadcast",_unit,false] spawn life_fnc_MP;
};

if((_vault getVariable["fed_locked",false])) exitWith
{
	[[1,"Ce coffre a déjà été pillé récemment"],"life_fnc_broadcast",_unit,false] spawn life_fnc_MP;
};

if(_unit < 1) exitWith {};
_vault setVariable["fed_rob_ip",true,true];
[[_vault,life_federal_funds],"life_fnc_robReserve",_unit,false] spawn life_fnc_MP;