_itemArray = [_this,0,[]] call BIS_fnc_param;

if (count _itemArray < 1) exitWith {};
{
	_itemName = _x select 0;
	_itemAmountSold = _x select 1;
	_index = -1;
	{
		_index = _index + 1;
		_curItemName = _x select 0;
		_curItemPrice = _x select 1;
		_curItemAmountSold = _x select 2;
		if (_curItemName == _itemName) then 
		{
			life_dynMarket_Items_CurrentPriceArr set [_index,[_curItemName, _curItemPrice, _curItemAmountSold + _itemAmountSold]];
		};
	} forEach life_dynMarket_Items_CurrentPriceArr;
} forEach _itemArray;