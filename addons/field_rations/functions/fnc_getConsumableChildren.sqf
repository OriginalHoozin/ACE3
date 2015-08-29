/*
 * Author: PabstMirror
 * Gets all the children that you can eat.
 *
 * Arguments:
 * 0: Player <OBJECT>
 * 1: Consumable Type ("eat", "drink", or "" for both) <STRING>
 *
 * Return Value:
 * Actions <ARRAY>
 *
 * Example:
 * [player, ''] call ace_field_rations_fnc_getConsumableChildren
 *
 * Public: No
 */
#include "script_component.hpp"

systemChat "gcc";

PARAMS_2(_player,_typeOfConsumble);

_actions = [];
_consumableItems = [];
{
    _cfg = configFile >> "CfgWeapons" >> _x;
    if ((isClass _cfg) && {!(_x in _consumableItems)}) then {
        _showItem = switch (true) do {
        case (_typeOfConsumble == "drink"): {getNumber (_cfg >> QGVAR(isDrinkable)) > 0};
        case (_typeOfConsumble == "eat"): {getNumber (_cfg >> QGVAR(isEatable)) > 0};
            default {(getNumber (_cfg >> QGVAR(isDrinkable)) > 0) || {getNumber (_cfg >> QGVAR(isEatable)) > 0}};
        };
        if (_showItem) then {
            _consumableItems pushBack _x;

            _displayName = getText (_cfg >> "displayName");
            _picture = getText (_cfg >> "picture");

            _action = [_x, _displayName, _picture, {_this call FUNC(actionConsumeItem)}, {_this call FUNC(canConsumeItem)}, {}, _x] call EFUNC(interact_menu,createAction);
            _actions pushBack [_action, [], _player];
        };
    };
} forEach (items _player);

_actions