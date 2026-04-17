diag_log "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=";
diag_log format ["  Blufor Victory at %1 !!", time];
diag_log "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=";

GRLIB_endgame = 1;
publicVariable "GRLIB_endgame";

{ _x setDamage 1 } forEach (units GRLIB_side_enemy);
sleep 1;

publicstats = [];
publicstats pushBack stats_opfor_soldiers_killed;
publicstats pushBack stats_opfor_killed_by_players;
publicstats pushBack stats_blufor_soldiers_killed;
publicstats pushBack stats_player_deaths;
publicstats pushBack stats_opfor_vehicles_killed;
publicstats pushBack stats_opfor_vehicles_killed_by_players;
publicstats pushBack stats_blufor_vehicles_killed;
publicstats pushBack stats_blufor_soldiers_recruited;
publicstats pushBack stats_blufor_vehicles_built;
publicstats pushBack stats_civilians_killed;
publicstats pushBack stats_civilians_killed_by_players;
publicstats pushBack stats_sectors_liberated;
publicstats pushBack stats_playtime;
publicstats pushBack stats_spartan_respawns;
publicstats pushBack stats_secondary_objectives;
publicstats pushBack stats_hostile_battlegroups;
publicstats pushBack stats_ieds_detonated;
publicstats pushBack stats_saves_performed;
publicstats pushBack stats_saves_loaded;
publicstats pushBack stats_reinforcements_called;
publicstats pushBack stats_prisoners_captured;
publicstats pushBack stats_blufor_teamkills;
publicstats pushBack stats_vehicles_recycled;
publicstats pushBack stats_ammo_spent;
publicstats pushBack stats_sectors_lost;
publicstats pushBack stats_fobs_built;
publicstats pushBack stats_fobs_lost;
publicstats pushBack (round stats_readiness_earned);

sleep 2;
[publicstats] remoteExec ["remote_call_endgame", 0];

// GRLIB_endgame = 1;
// publicVariable "GRLIB_endgame";
[] call save_game_mp;
