disableSerialization;
private["_list","_filter","_dialog","_inv","_mats","_filterBox","_item","_itemFilter"];
_dialog = findDisplay 666;
_inv = _dialog displayCtrl 669;
_mats = _dialog displayCtrl 672;
_filterBox = _dialog displayCtrl 673;
_itemFilter = lbData[673,(lbCurSel 673)];

lbClear _inv;
_struct = "";

_config = [_itemFilter] call life_fnc_craftCfg;
{
	if(_itemFilter == "item") then 
	{
		_str = [_x select 0] call life_fnc_varToStr;
		_inv lbAdd format["%1",_str];
		_inv lbSetData[(lbSize _inv)-1,_x select 0];
	} else {
		_itemInfo = [_x select 0] call life_fnc_fetchCfgDetails;
		_inv lbAdd format["%1",_itemInfo select 1];
		_inv lbSetData[(lbSize _inv)-1,_itemInfo select 0];
		_inv lbSetPicture[(lbSize _inv)-1,_itemInfo select 2];
	};
} foreach (_config select 1);

_inv lbSetCurSel 0;
_item = lbData[669,(lbCurSel 669)];
_config = [_itemFilter] call life_fnc_craftCfg;
{
	if(_item == _x select 0)then
	{
		_matsNeed = _x select 1;
		_invSize = count _matsNeed;
		for [{_i = 0},{_i < _invSize - 1},{_i = _i + 2}] do {
			_str = [_matsNeed select _i] call life_fnc_varToStr;
			_matsNum = _matsNeed select _i+1;
			_struct = _struct + format["%1x %2<br/>",_matsNum,_str];

		};
	};
} foreach (_config select 1);

_mats ctrlSetStructuredText parseText format["<t size='0.8px'>%1</t>",_struct];