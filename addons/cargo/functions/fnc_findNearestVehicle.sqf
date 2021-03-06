/*
 * Author: Glowbal
 * Get nearest vehicle from unit, priority: Car-Air-Tank-Ship.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return value:
 * Vehicle in Distance <OBJECT>
 *
 * Example:
 * [unit] call ace_cargo_fnc_findNearestVehicle
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_unit"];

private _loadCar = nearestObject [_unit, "car"];
if (_unit distance _loadCar <= MAX_LOAD_DISTANCE) exitWith {_loadCar};

private _loadHelicopter = nearestObject [_unit, "air"];
if (_unit distance _loadHelicopter <= MAX_LOAD_DISTANCE) exitWith {_loadHelicopter};

private _loadTank = nearestObject [_unit, "tank"];
if (_unit distance _loadTank <= MAX_LOAD_DISTANCE) exitWith {_loadTank};

private _loadShip = nearestObject [_unit, "ship"];
if (_unit distance _loadShip <= MAX_LOAD_DISTANCE) exitWith {_loadShip};

private _loadContainer = nearestObject [_unit,"Cargo_base_F"];
if (_unit distance _loadContainer <= MAX_LOAD_DISTANCE) exitWith {_loadContainer};

objNull
