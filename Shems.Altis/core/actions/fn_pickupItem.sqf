private["_obj","_itemInfo","_itemName","_illegal","_diff"];

if((time - life_action_delay) < 1) exitWith {hint "Vous ne pouvez pas utiliser cette touche aussi rapidement..."};
_obj = [_this,0,ObjNull,[ObjNull]] call BIS_fnc_param;
if(isNull _obj OR isPlayer _obj) exitWith {};
if((_obj getVariable["PickedUp",false])) exitWith {deleteVehicle _obj;};
if(player distance _obj > 3) exitWith {};
_itemInfo = _obj getVariable "item";
_itemName = [([_itemInfo select 0,0] call life_fnc_varHandle)] call life_fnc_varToStr;
_illegal = [_itemInfo select 0,life_illegal_items] call fnc_index;

if(playerSide == west && _illegal != -1) exitWith
{
	titleText[format["%1 a été placé en évidence, vous avez reçu %2 € comme récompense.",_itemName,[(life_illegal_items select _illegal) select 1] call life_fnc_numberText],"PLAIN"];
	life_atmmoney = life_atmmoney + ((life_illegal_items select _illegal) select 1);
	deleteVehicle _obj;
	life_action_delay = time;
};

life_action_delay = time;
_diff = [_itemInfo select 0,_itemInfo select 1,life_carryWeight,life_maxWeight] call life_fnc_calWeightDiff;
if(_diff <= 0) exitWith {hint "Vous ne pouvez rien ramasser, vous ête plein."};
_obj setVariable["PickedUp",true,true];
if(_diff != _itemInfo select 1) then
{
	if(([true,_itemInfo select 0,_diff] call life_fnc_handleInv)) then
	{
		player playmove "AinvPknlMstpSlayWrflDnon";
		sleep 0.5;
		_obj setVariable["item",[_itemInfo select 0,((_itemInfo select 1) - _diff)],true];
		_obj setVariable["PickedUp",false,true];
		titleText[format["Vous avez trouvé %1 %2",_diff,_itemName],"PLAIN"];
	};
} else {
	if(([true,_itemInfo select 0,_itemInfo select 1] call life_fnc_handleInv)) then
	{
		deleteVehicle _obj;
		player playmove "AinvPknlMstpSlayWrflDnon";
		sleep 0.5;
		titleText[format["Vous avez trouvé %1 %2",_diff,_itemName],"PLAIN"];
	};
};