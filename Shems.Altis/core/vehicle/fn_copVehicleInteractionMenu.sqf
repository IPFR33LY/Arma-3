#define Btn1 37450
#define Btn2 37451
#define Btn3 37452
#define Btn4 37453
#define Btn5 37454
#define Btn6 37455
#define Btn7 37456
#define Btn8 37457
#define Btn9 37458
#define Btn10 37459
#define Title 37401

private["_display","_curTarget","_Btn1","_Btn2","_Btn3","_Btn4","_Btn5","_Btn6","_Btn7","_Btn8","_Btn9","_Btn10"];
if(!dialog) then 
{
	createDialog "vInteraction_Menu";
};
disableSerialization;
_curTarget = [_this,0,ObjNull,[ObjNull]] call BIS_fnc_param;
if(isNull _curTarget) exitWith {closeDialog 0;};
_isVehicle = if((_curTarget isKindOf "landVehicle") OR (_curTarget isKindOf "Ship") OR (_curTarget isKindOf "Air")) then {true} else {false};
if(!_isVehicle) exitWith {closeDialog 0;};
_display = findDisplay 37400;
_Btn1 = _display displayCtrl Btn1;
_Btn2 = _display displayCtrl Btn2;
_Btn3 = _display displayCtrl Btn3;
_Btn4 = _display displayCtrl Btn4;
_Btn5 = _display displayCtrl Btn5;
_Btn6 = _display displayCtrl Btn6;
_Btn7 = _display displayCtrl Btn7;
_Btn8 = _display displayCtrl Btn8;
_Btn9 = _display displayCtrl Btn9;
_Btn10 = _display displayCtrl Btn10;
life_vInact_curTarget = _curTarget;

_Btn1 ctrlSetText "Réparer";
_Btn1 buttonSetAction "[life_vInact_curTarget] spawn life_fnc_repairTruck;";

if("ToolKit" in (items player) && (damage _curTarget < 1)) then 
{
	_Btn1 ctrlEnable true;
} else {
	_Btn1 ctrlEnable false;
};

_Btn2 ctrlSetText "Propriétaire";
_Btn2 buttonSetAction "[life_vInact_curTarget] spawn life_fnc_searchVehAction;";
	
_Btn3 ctrlSetText "Fouiller";
_Btn3 buttonSetAction "[life_vInact_curTarget] spawn life_fnc_vehInvSearch;";
	
_Btn4 ctrlSetText "Sortir joueur";
_Btn4 buttonSetAction "[life_vInact_curTarget] spawn life_fnc_pullOutAction;";
if(count crew _curTarget == 0) then {_Btn4 ctrlEnable false;};
	
_Btn5 ctrlSetText "Fourrière";
_Btn5 buttonSetAction "[life_vInact_curTarget] spawn life_fnc_impoundAction;";
	
if(_curTarget isKindOf "Ship") then 
{
	_Btn6 ctrlSetText "Pousser";
	_Btn6 buttonSetAction "[] spawn life_fnc_pushObject; closeDialog 0;";
	if(_curTarget isKindOf "Ship" && {local _curTarget} && {count crew _curTarget == 0}) then 
	{ 
		_Btn6 ctrlEnable true;
	} else {
		_Btn6 ctrlEnable false
	};
} else {
	if(typeOf (_curTarget) in 
	[
		"C_Kart_01_Blu_F",
		"C_Kart_01_Red_F",
		"C_Kart_01_Fuel_F",
		"C_Kart_01_Vrana_F",
		"B_Heli_Transport_03_F",
		"B_Heli_Transport_03_unarmed_F",
		"O_Heli_Transport_04_F",
		"O_Heli_Transport_04_ammo_F",
		"O_Heli_Transport_04_bench_F",
		"O_Heli_Transport_04_box_F",
		"O_Heli_Transport_04_covered_F",
		"O_Heli_Transport_04_fuel_F",
		"O_Heli_Transport_04_medevac_F",
		"O_Heli_Transport_04_repair_F"
	]) then 
	{
		_Btn6 ctrlSetText "Conducteur";
		_Btn6 buttonSetAction "player moveInDriver life_vInact_curTarget; closeDialog 0;";
		if(count crew _curTarget == 0 && {canMove _curTarget} && {locked _curTarget == 0}) then 
		{
			_Btn6 ctrlEnable true;
		} else {
			_Btn6 ctrlEnable false
		};
	} else {
		_Btn6 ctrlSetText "Debuguer";
		_Btn6 buttonSetAction "life_vInact_curTarget setPos [getPos life_vInact_curTarget select 0, getPos life_vInact_curTarget select 1, (getPos life_vInact_curTarget select 2)+0.5]; closeDialog 0;";
		if(count crew _curTarget == 0 && {canMove _curTarget}) then 
		{ 
			_Btn6 ctrlEnable false;
		} else {
			_Btn6 ctrlEnable true;
		};
	};
	if((_curTarget isKindOf "Car") && !life_istazed) then 
	{
		_Btn7 ctrlSetText "Placer charge";
		_Btn7 buttonSetAction "[life_vInact_curTarget] spawn life_fnc_demolitionCharge;";
	} else {
		_Btn7 ctrlShow false;
	};
	_Btn8 ctrlShow false;
	_Btn9 ctrlShow false;
	_Btn10 ctrlShow false;
};