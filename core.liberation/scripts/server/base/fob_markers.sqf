waitUntil {sleep 1; !isNil "GRLIB_init_server"};
waitUntil {sleep 1; !isNil "GRLIB_all_fobs"};

private _markers = [];
private _markers_def = [];
GRLIB_redraw_marker_fob = false;

sleep 2;
while { true } do {
	if (count GRLIB_all_fobs > 0 && (count _markers != count GRLIB_all_fobs || GRLIB_redraw_marker_fob)) then {
		GRLIB_redraw_marker_fob = false;
		{ deleteMarkerLocal _x } foreach _markers;
		_markers = [];
		{
			_fobpos = _x;
			_near_outpost = (_fobpos in GRLIB_all_outposts);
			_marker = createMarkerLocal [format ["fobmarker%1", _forEachIndex], markers_reset];
			if (_near_outpost) then {
				_marker setMarkerTypeLocal "b_support";
				_marker setMarkerSizeLocal [ 1.2, 1.2 ];
				_marker setMarkerTextLocal format ["Outpost %1",military_alphabet select _forEachIndex];
				_marker setMarkerColorLocal "ColorYellow";
			} else {
				_marker setMarkerTypeLocal "b_hq";
				_marker setMarkerSizeLocal [ 1.7, 1.7 ];
				_marker setMarkerTextLocal format ["FOB %1",military_alphabet select _forEachIndex];
				_marker setMarkerColorLocal "ColorYellow";
			};
			_marker setMarkerPos _fobpos;
			_markers pushback _marker;
		} forEach GRLIB_all_fobs;
	};

	// Def marker
	if (count _markers_def != count GRLIB_sector_defense || GRLIB_redraw_marker_fob) then {
		{ deleteMarkerLocal _x } foreach _markers_def;
		_markers_def = [];
		{
			private _sector = (_x select 0);
			private _marker = createMarkerLocal [format ["defense_%1", _sector], markers_reset];
			_marker setMarkerShapeLocal "ICON";
			_marker setMarkerTypeLocal "loc_defend";
			private _color = "ColorRed";
			// "MarkerOne" setMarkerColor "#(1,0,0,1)";
			switch (_x select 1) do {
				case 1:	{ _color = "ColorWhite" };
				case 2:	{ _color = "ColorGrey" };
				case 3:	{ _color = "ColorBlack" };
			};
			_marker setMarkerColorLocal _color;
			_marker setMarkerPos (markerPos _sector);
			_markers_def pushback _marker;
		} forEach GRLIB_sector_defense;
	};

	if !(isNull GRLIB_vehicle_huron) then {
		"huronmarker" setMarkerPos (getPosATL GRLIB_vehicle_huron);
	};
	sleep 3;
};