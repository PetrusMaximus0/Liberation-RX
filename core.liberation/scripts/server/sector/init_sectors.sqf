private _min_sector_dist = round ((GRLIB_capture_size + GRLIB_fob_range) * 1.5);

sectors_allSectors = [];
sectors_capture = [];
sectors_bigtown = [];
sectors_factory = [];
sectors_military = [];
sectors_tower = [];
sectors_opforSpawn = [];
sectors_airSpawn = [];

{
	_ismissionsector = false;

	if (_x select [0,11] == "opfor_point") then {
		sectors_opforSpawn pushBack _x;
		_ismissionsector = false;
	};

	if (_x select [0,14] == "opfor_airspawn") then {
		sectors_airSpawn pushBack _x;
		_ismissionsector = false;
	};

	if (_x select [0,7] == "capture") then {
		sectors_capture pushBack _x;
		_ismissionsector = true;
	};

	if (_x select [0,7] == "bigtown") then {
		sectors_bigtown pushBack _x;
		_ismissionsector = true;
	};

	if (_x select [0,7] == "factory") then {
		sectors_factory pushBack _x;
		_ismissionsector = true;
	};

	if (_x select [0,8] == "military") then {
		if (isNil "GRLIB_all_fobs") then {
			sectors_military pushBack _x;
			_ismissionsector = true;
		} else {
			private _fob_pos = [markerPos _x] call F_getNearestFob;
			if (_fob_pos distance2D markerPos _x < _min_sector_dist) then {
				_ismissionsector = false;
				deleteMarker _x;
			} else {
				sectors_military pushBack _x;
				_ismissionsector = true;
			};
		};
	};

	if (_x select [0,5] == "tower") then {
		sectors_tower pushBack _x;
		_x setMarkerTextLocal format ["%1 %2",markerText _x, mapGridPosition (markerPos _x)];
		_ismissionsector = true;
	};

	if ( _ismissionsector ) then {
		sectors_allSectors pushBack _x;
	};
} forEach allMapMarkers;
