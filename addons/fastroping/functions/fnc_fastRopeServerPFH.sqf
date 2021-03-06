/*
 * Author: BaerMitUmlaut
 * Server PerFrameHandler during fast roping.
 *
 * Arguments:
 * 0: PFH arguments <ARRAY>
 * 1: PFH handle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[_unit, _vehicle, _rope, _ropeIndex], 0] call ace_fastroping_fnc_fastRopeServerPFH
 *
 * Public: No
 */

#include "script_component.hpp"
params ["_arguments", "_pfhHandle"];
_arguments params ["_unit", "_vehicle", "_rope", "_ropeIndex"];
_rope params ["_attachmentPoint", "_ropeTop", "_ropeBottom", "_dummy", "_hook", "_occupied"];
private ["_vectorUp", "_vectorDir", "_origin"];

//Wait until the unit is actually outside of the helicopter
if (vehicle _unit != _unit) exitWith {};

//Start fast roping
if (animationState _unit != "ACE_FastRoping") exitWith {
    //Fix for twitchyness
    _dummy setMass 80;
    _dummy setCenterOfMass [0, 0, -2];
    _origin = getPosASL _hook;
    _dummy setPosASL (_origin vectorAdd [0, 0, -2]);
    _dummy setVectorUp [0, 0, 1];

    ropeUnwind [_ropeTop, 6, 34.5];
    ropeUnwind [_ropeBottom, 6, 0.5];
};

//Check if rope broke and unit is falling
if (isNull attachedTo _unit) exitWith {
    [_pfhHandle] call CBA_fnc_removePerFrameHandler;
};

//Setting the velocity manually to reduce twitching
_dummy setVelocity [0,0,-6];

//Check if fast rope is finished
if (((getPos _unit select 2) < 0.2) || {ropeLength _ropeTop == 34.5} || {vectorMagnitude (velocity _vehicle) > 5} || {!(alive _unit)} || {captive _unit}) exitWith {
    detach _unit;

    //Reset rope
    deleteVehicle _ropeTop;
    deleteVehicle _ropeBottom;

    _origin = getPosASL _hook;
    _dummy attachTo [_hook, [0, 0, 0]];

    //Restore original mass and center of mass
    _dummy setMass 40;
    _dummy setCenterOfMass [0.000143227,0.00105986,-0.246147];

    _ropeTop = ropeCreate [_dummy, [0, 0, 0], _hook, [0, 0, 0], 0.5];
    _ropeBottom = ropeCreate [_dummy, [0, 0, 0], 35];

    _ropeTop addEventHandler ["RopeBreak", {[_this, "top"] call FUNC(onRopeBreak)}];
    _ropeBottom addEventHandler ["RopeBreak", {[_this, "bottom"] call FUNC(onRopeBreak)}];

    //Update deployedRopes array
    _deployedRopes = _vehicle getVariable [QGVAR(deployedRopes), []];
    _deployedRopes set [_ropeIndex, [_attachmentPoint, _ropeTop, _ropeBottom, _dummy, _hook, false]];
    _vehicle setVariable [QGVAR(deployedRopes), _deployedRopes, true];

    [_pfhHandle] call CBA_fnc_removePerFrameHandler;
};
