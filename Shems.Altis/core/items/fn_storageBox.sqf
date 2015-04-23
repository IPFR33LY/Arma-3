private["_boxType","_house","_positions","_containers","_pos","_houseCfg"];
_boxType = _this select 0;

_house = nearestBuilding (getPosATL player);
if(!(_house in life_vehicles)) exitWith {hint "You need to be inside your house to place this."};
_containers = _house getVariable["containers",[]];
_houseCfg = [(typeOf _house)] call life_fnc_houseConfig;
if(count _houseCfg == 0) exitWith {};
if(count _containers >= (_houseCfg select 1)) exitWith {hint "You cannot place any more storage containers in your house."};

_slots = _house getVariable ["slots",[]];
_positions = [_house] call life_fnc_getBuildingPositions;
_pos = [0,0,0];
{
	_slots = _house getVariable ["slots",[]];
	if(!(_forEachIndex in _slots)) exitWith 
	{
		_slots pushBack _forEachIndex;
		_house setVariable["slots",_slots,true];
		_pos = _x;
	};
} foreach _positions;
if(_pos isEqualTo [0,0,0]) exitWith {hint "No more free storage spaces in your house."};
if(!([false,_boxType,1] call life_fnc_handleInv)) exitWith {};
switch (_boxType) do 
{
	case "storagesmall": 
	{
		_container = "Box_IND_Grenades_F" createVehicle [0,0,0];
		_container setPosATL _pos;
		_containers pushBack _container;
		_house setVariable["containers",_containers,true];
		[[_house],"TON_fnc_updateHouseContainers",false,false] spawn life_fnc_MP;
		clearWeaponCargoGlobal _container;
		clearMagazineCargoGlobal _container;
		clearItemCargoGlobal _container;
		clearBackpackCargoGlobal _container;
	};
	
	case "storagebig": 
	{
		_container = "B_supplyCrate_F" createVehicle [0,0,0];
		_container setPosATL _pos;
		_containers pushBack _container;
		_house setVariable["containers",_containers,true];
		[[_house],"TON_fnc_updateHouseContainers",false,false] spawn life_fnc_MP;
		clearWeaponCargoGlobal _container;
		clearMagazineCargoGlobal _container;
		clearItemCargoGlobal _container;
		clearBackpackCargoGlobal _container;
	};
};