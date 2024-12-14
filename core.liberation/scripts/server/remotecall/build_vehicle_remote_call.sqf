if (!isServer && hasInterface) exitWith {};
params [
		"_player",
		"_classname",
		"_owner",
		"_manned",
		"_truepos",
		"_veh_dir",
		"_veh_vup"
];

private _allow_damage = true;
private _vehicle = _classname createVehicle _truepos;
if (isNull _vehicle) exitWith { _player setVariable ["GRLIB_player_vehicle_build", nil, true] };

_vehicle allowDamage false;
_vehicle setVectorDirAndUp [_veh_dir, _veh_vup];
if (_classname in boats_names && surfaceIsWater _truepos) then {
	_vehicle setposASL _truepos;
} else {
	_vehicle setPosATL _truepos;
};

// ACE Support
[_vehicle] call F_aceInitVehicle;

// Vehicle owner
if (_owner != "") then {
	if (!([_vehicle, GRLIB_vehicle_blacklist] call F_itemIsInClass)) then {
		_vehicle setVariable ["GRLIB_vehicle_owner", _owner, true];
		_vehicle allowCrewInImmobile [true, false];
		_vehicle setUnloadInCombat [true, false];
	};
};

// Crewed vehicle
if (_manned) then {
	[_vehicle] call F_forceCrew;
	_vehicle setVariable ["GRLIB_vehicle_manned", true, true];
};

// UAVs
if (_classname in uavs_vehicles) then {
	[_vehicle] call F_forceCrew;
	_vehicle setVariable ["GRLIB_vehicle_manned", true, true];
};

// Ammo Box clean inventory
if !(_classname in (GRLIB_Ammobox_keep + GRLIB_disabled_arsenal)) then {
	[_vehicle] call F_clearCargo;
};

// AI Static Weapon
if (_classname in static_vehicles_AI) then {
	[_vehicle] call F_forceCrew;
	_vehicle setVariable ["GRLIB_vehicle_manned", true, true];
	_vehicle setVehicleLock "LOCKED";
	_vehicle allowCrewInImmobile [true, false];
	_vehicle setUnloadInCombat [true, false];
	_vehicle setAutonomous true;
};

// Vehicles
if (_classname isKindOf "LandVehicle" || _classname isKindOf "Air") then {
	// Cutomize Vehicle
	[_vehicle] call F_fixModVehicle;

	// Default Paint
	if (_classname in ["I_E_Truck_02_MRL_F"]) then {
		[_vehicle, ["EAF",1], true ] spawn BIS_fnc_initVehicle;
	};
};

// Automatic ReAmmo
if (_classname in vehicle_rearm_sources) then {
	_vehicle setAmmoCargo 0;
};

// Mobile respawn
if (_classname in respawn_vehicles) then {
	[_vehicle, "add"] call mobile_respawn_remote_call;
};

// Personal Box
if (_classname == playerbox_typename) then {
	_vehicle setMaxLoad playerbox_cargospace;
	_allow_damage = false;
};

// Arsenalbox
if (_classname == Arsenal_typename) then {
	_vehicle setMaxLoad 0;
};

// Ammobox (add Charge)
if (_classname == Box_Ammo_typename) then {
	_vehicle addItemCargoGlobal ["SatchelCharge_Remote_Mag", 2];
};

// Helipad lights
if (_classname isKindOf "Land_PortableHelipadLight_01_F") then {
	_allow_damage = false;
};

// Magic ClutterCutter
if (_classname == land_cutter_typename) then {
	[_truepos] call build_cutter_remote_call;
};

// WareHouse
if (_classname == Warehouse_typename) then {
	[_vehicle] call warehouse_init_remote_call;
	_allow_damage = false;
};

// Storage
if (_classname == storage_medium_typename) then {
	_vehicle setVariable ["GRLIB_vehicle_owner", PAR_Grp_ID, true];
	private _drop_zone_dir = (getdir _vehicle);
	private _drop_zone_pos = (getposATL _vehicle) vectorAdd ([[0, -5, 0], -_drop_zone_dir] call BIS_fnc_rotateVector2D);
	private _drop_zone = createVehicle ["VR_Area_01_square_2x2_yellow_F", ([] call F_getFreePos), [], 0, "NONE"];
	_drop_zone_pos set [2, 0.02];
	_drop_zone setDir _drop_zone_dir;
	_drop_zone setPosATL _drop_zone_pos;
	_drop_zone setVectorDirAndUp [[-cos _drop_zone_dir, sin _drop_zone_dir, 0] vectorCrossProduct surfaceNormal _drop_zone_pos, surfaceNormal _drop_zone_pos];
	_allow_damage = false;
};

if (_allow_damage) then { _vehicle allowDamage true };
_vehicle setDamage 0;

if (count crew _vehicle == 0) then {
	_vehicle setOwner (owner _player);
} else {
	private _grp = group (crew _vehicle select 0);
    _grp setGroupOwner (owner _player);
};
sleep 1;
_player setVariable ["GRLIB_player_vehicle_build", _vehicle, true];