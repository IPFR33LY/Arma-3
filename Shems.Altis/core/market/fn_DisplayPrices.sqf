disableSerialization;
_dialog = findDisplay 7100;
_listbox = _dialog  displayCtrl 7055;
_moneydisplay = _dialog displayCtrl 7056;
_amountsolddisplay = _dialog displayCtrl 7057;
_moneydisplayold = _dialog displayCtrl 7058;
_index = lbCurSel _listbox;
_type = _listbox lbData _index;
_itemArrayOld = [];

if (!isNil "life_dynMarket_pricesOld") then 
{
	_itemArrayOld = life_dynMarket_pricesOld select (([_type,life_dynMarket_prices] call fnc_index))
} else {
	_itemArrayOld = ["",0];
};

_index = [_type,life_dynMarket_prices] call fnc_index;
_costOld = 0;
_itemArray = life_dynMarket_prices select _index;
_cost = _itemArray select 1;
_costOld = _itemArrayOld select 1;
_itemname = _itemArray select 0;
_amountsold = 0;
{
	_name = _x select 0;
	_sold = _x select 1;
	if (_itemname == _name) then 
	{
		_amountsold = _amountsold + _sold;
	};
} forEach life_dynMarket_boughtItems;

_amountsolddisplay ctrlSetText format ["%1",_amountsold];
_moneydisplay ctrlSetText format ["%1 €",_cost];
_arrowText = "";
if (_cost < _costOld) then 
{
	_percent = (100 - ((_cost/_costOld) * 100));
	_arrowText = format ["<t color='#FF0000'>↓ %1%2",_percent,"%"];
} else {
	if (_costOld<_cost) then 
	{
		_percent = (100 - ((_costOld/_cost) * 100));
		_arrowText = format ["<t color='#04B404'>↑ %1%2",_percent,"%"];
	} else {
		_percent = (100 - ((_costOld/_cost) * 100));
		_arrowText = format [""];
	};
};