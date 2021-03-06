/*
 * Author: KoffeinFlummi, commy2
 * Forces a civilian to the ground with a chance of failure.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Target <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [civillian] call ace_interaction_fnc_getDown
 *
 * Public: No
 */
#include "script_component.hpp"

#define SEND_RADIUS 10

params ["_unit", "_target"];

_unit playActionNow "GestureGo";

private "_chance";
_chance = [0.5, 0.8] select (count weapons _unit > 0);

{
    if (count weapons _x == 0 && {random 1 < _chance}) then {
        ["getDown", [_x], [_x]] call EFUNC(common,targetEvent);
    };
    false
} count (_target nearEntities ["Civilian", SEND_RADIUS]);
