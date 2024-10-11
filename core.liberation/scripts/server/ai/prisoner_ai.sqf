params ["_unit", ["_friendly", false], ["_canmove", false]];

if (isNull _unit) exitWith {};
if !(isNull objectParent _unit) exitWith {};
if (_unit getVariable ["GRLIB_mission_AI", false]) exitWith {};
if (_unit getVariable ["GRLIB_is_prisoner", false]) exitWith {};
if (surfaceIsWater (getPosATL _unit)) exitWith {};
if (_unit skill "courage" == 1) exitWith {};

sleep 10;
if (!alive _unit) exitWith {};

// Init priso
private _grp = createGroup [GRLIB_side_enemy, true];
[_unit] joinSilent _grp;

doStop _unit;
removeAllWeapons _unit;
//removeHeadgear _unit;
removeBackpack _unit;
removeVest _unit;
private _hmd = (hmd _unit);
_unit unassignItem _hmd;
_unit removeItem _hmd;
_unit setVariable ["GRLIB_can_speak", true, true];
_unit removeAllEventHandlers "HandleDamage";
_unit setCaptive true;
[_unit] spawn F_fixPosUnit;

// Wait
if (!_canmove) then {
	// Halt
	[_unit, "init"] remoteExec ["remote_call_prisoner", 0];
	sleep 3;
	_unit setVariable ["GRLIB_is_prisoner", true, true];
	if (_friendly) then {
		waitUntil { sleep 1; (!alive _unit || side group _unit == GRLIB_side_friendly) };
	} else {
		private _timeout = time + (30 * 60);
		waitUntil { sleep 1; (!alive _unit || side group _unit == GRLIB_side_friendly || time > _timeout) };
	};
	// Follow
	[_unit, "move"] remoteExec ["remote_call_prisoner", 0];
	sleep 3;
} else {
	_unit setVariable ["GRLIB_is_prisoner", true, true];
};

if (isServer) then {
	[_unit, _friendly] spawn prisoner_ai_loop;
} else {
	[_unit, _friendly] remoteExec ["prisoner_ai_loop", 2];
};