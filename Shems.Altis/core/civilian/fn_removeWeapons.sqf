private "_cop";

_cop = [_this,0,objNull,[objNull]] call BIS_fnc_param;
if(_cop == player) then {};

if(isNull _cop OR !(player getVariable["Restrained",false])) exitWith {};

removeAllWeapons player;
{
	player removeMagazine _x
} foreach (magazines player);

[[0,format["L'arme de %1 a été retiré par %2.", name player, name _cop]],"life_fnc_broadcast",true,false] spawn life_fnc_MP;