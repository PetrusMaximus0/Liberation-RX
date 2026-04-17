params ["_item", "_list"]; 
private _ret = false; 

{ 
    if ([_x, _item] call F_startsWith) exitWith { _ret = true }; 
} forEach _list;

_ret; 
