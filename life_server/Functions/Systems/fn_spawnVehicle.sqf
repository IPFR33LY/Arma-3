private["_vid","_sp","_pid","_query","_sql","_vehicle","_nearVehicles","_name","_side","_tickTime","_dir","_queryResult"];
_vid = [_this,0,-1,[0]] call BIS_fnc_param;
_pid = [_this,1,"",[""]] call BIS_fnc_param;
_sp = [_this,2,[],[[],""]] call BIS_fnc_param;
_unit = [_this,3,ObjNull,[ObjNull]] call BIS_fnc_param;
_price = [_this,4,0,[0]] call BIS_fnc_param;
_dir = [_this,5,0,[0]] call BIS_fnc_param;
_unit_return = _unit;
_name = name _unit;
_side = side _unit;
_unit = owner _unit;

if(_vid == -1 OR _pid == "") exitWith {};
if(_vid in serv_sv_use) exitWith {};
serv_sv_use pushBack _vid;

_query = format["SELECT id, side, classname, type, pid, alive, active, plate, color, inventory, gear, insure FROM vehicles WHERE id='%1' AND pid='%2'",_vid,_pid];

waitUntil{sleep (random 0.3); !DB_Async_Active};
_tickTime = diag_tickTime;
_queryResult = [_query,2] call DB_fnc_asyncCall;

diag_log "------------- Client Query Request -------------";
diag_log format["QUERY: %1",_query];
diag_log format["Temps à completer: %1 seconde(s)",(diag_tickTime - _tickTime)];
diag_log format["Résultat: %1",_queryResult];
diag_log "------------------------------------------------";

if(typeName _queryResult == "STRING") exitWith {};

_vInfo = _queryResult;
if(isNil "_vInfo") exitWith {serv_sv_use = serv_sv_use - [_vid];};
if(count _vInfo == 0) exitWith {serv_sv_use = serv_sv_use - [_vid];};

if((_vInfo select 5) == 0) exitWith
{
	serv_sv_use = serv_sv_use - [_vid];
	[[1,format["1 a été classé comme un véhicule détruit et a été envoyé à la fourrière.",_vInfo select 2]],"life_fnc_broadcast",_unit,false] spawn life_fnc_MP;
};

if((_vInfo select 6) == 1) exitWith
{
	serv_sv_use = serv_sv_use - [_vid];
	[[1,format["votre %1 à déjà été sortit du garage",_vInfo select 2]],"life_fnc_broadcast",_unit,false] spawn life_fnc_MP;
};

if(typeName _sp != "STRING") then 
{
	_nearVehicles = nearestObjects[_sp,["Car","Air","Ship"],10];
} else {
	_nearVehicles = [];
};
if(count _nearVehicles > 0) exitWith
{
	serv_sv_use = serv_sv_use - [_vid];
	[[_price,_unit_return],"life_fnc_garageRefund",_unit,false] spawn life_fnc_MP;
	[[1,"Il existe déjà un véhicule sur le point de spawn."],"life_fnc_broadcast",_unit,false] spawn life_fnc_MP;
};

_query = format["UPDATE vehicles SET active='1' WHERE pid='%1' AND id='%2'",_pid,_vid];

waitUntil {!DB_Async_Active};
[_query,false] spawn DB_fnc_asyncCall;

if(typeName _sp == "STRING") then 
{
	_vehicle = createVehicle[(_vInfo select 2),[0,0,999],[],0,"NONE"];
	waitUntil {!isNil "_vehicle" && {!isNull _vehicle}};
	_vehicle allowDamage false;
	_hs = nearestObjects[getMarkerPos _sp,["Land_Hospital_side2_F"],50] select 0;
	_vehicle setPosATL (_hs modelToWorld [-0.4,-4,12.65]);
	sleep 0.6;
} else {
	_vehicle = createVehicle [(_vInfo select 2),_sp,[],0,"NONE"];
	waitUntil {!isNil "_vehicle" && {!isNull _vehicle}};
	_vehicle allowDamage false;
	_vehicle setPos _sp;
	_vehicle setVectorUp (surfaceNormal _sp);
	_vehicle setDir _dir;
};
_vehicle allowDamage true;

[[_vehicle],"life_fnc_addVehicle2Chain",_unit,false] spawn life_fnc_MP;
[_pid,_side,_vehicle,1] call TON_fnc_keyManagement;
_vehicle lock 2;
[[_vehicle,_vInfo select 8],"life_fnc_colorVehicle",nil,false] spawn life_fnc_MP;
_vehicle setVariable["vehicle_info_owners",[[_pid,_name]],true];
_vehicle setVariable["dbInfo",[(_vInfo select 4),(_vInfo select 7),(_vInfo select 9)]];

_trunk = [_vInfo select 9] call DB_fnc_mresToArray;
if(typeName _trunk == "STRING") then {_trunk = call compile format["%1", _trunk];};
_gear = [_vInfo select 10] call DB_fnc_mresToArray;
if(typeName _gear == "STRING") then {_gear = call compile format["%1", _gear];};
_vehicle setVariable["Trunk",_trunk,true];

[_vehicle] call life_fnc_clearVehicleAmmo;

if (isNil "_gear") exitWith {};
_items = _gear select 0;
_mags = _gear select 1;
_weapons = _gear select 2;
_backpacks = _gear select 3;

for "_i" from 0 to ((count (_items select 0)) - 1) do
{
	_vehicle addItemCargoGlobal [((_items select 0) select _i), ((_items select 1) select _i)];
};
for "_i" from 0 to ((count (_mags select 0)) - 1) do
{
	_vehicle addMagazineCargoGlobal [((_mags select 0) select _i), ((_mags select 1) select _i)];
};
for "_i" from 0 to ((count (_weapons select 0)) - 1) do
{
	_vehicle addWeaponCargoGlobal [((_weapons select 0) select _i), ((_weapons select 1) select _i)];
};
for "_i" from 0 to ((count (_backpacks select 0)) - 1) do
{
	_vehicle addBackpackCargoGlobal [((_backpacks select 0) select _i), ((_backpacks select 1) select _i)];
};

if((_vInfo select 1) == "civ" && (_vInfo select 2) == "B_Heli_Light_01_F" && _vInfo select 8 != 13) then
{
	[[_vehicle,"civ_littlebird",true],"life_fnc_vehicleAnimate",_unit,false] spawn life_fnc_MP;
};

if((_vInfo select 1) == "cop" && (_vInfo select 2) in ["C_Offroad_01_F","B_MRAP_01_F","C_SUV_01_F"]) then
{
	[[_vehicle,"cop_offroad",true],"life_fnc_vehicleAnimate",_unit,false] spawn life_fnc_MP;
};

if((_vInfo select 1) == "med" && (_vInfo select 2) == "C_Offroad_01_F") then
{
	[[_vehicle,"med_offroad",true],"life_fnc_vehicleAnimate",_unit,false] spawn life_fnc_MP;
};

if((_vInfo select 9) == 1) then
{
  [[1,"Votre véhicule est prêt et l'assurance est active."],"life_fnc_broadcast",_unit,false] spawn life_fnc_MP;
} else {
  [[1,"Votre véhicule est prêt."],"life_fnc_broadcast",_unit,false] spawn life_fnc_MP;
};

serv_sv_use = serv_sv_use - [_vid];