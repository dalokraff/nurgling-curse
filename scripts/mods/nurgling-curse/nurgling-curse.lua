local mod = get_mod("nurgling-curse")
math.randomseed(os.time())

-- Your mod code goes here.
-- https://vmf-docs.verminti.de

local Vector3box = stingray.Vector3Box

local spawn_points = {
    Vector3box(-34.4249, 42.1626, 12.1008),
    Vector3box(-3.42184, 38.1748, 10.9329),
    Vector3box(39.7328, 21.7402, 16.9672),
    Vector3box(24.3688, -3.70495, 12.9672),
    Vector3box(24.5883, 0.728823, 12.9672),
    Vector3box(18.6826, 0.48982, 12.9639),
    Vector3box(16.0435, -4.13696, 12.7978),
    Vector3box(19.3393, -4.42023, 20.0253),
    Vector3box(10.5778, -12.7683, 2.18378),
    Vector3box(24.2501, -9.95114, 3.54168),
    Vector3box(-22.547, 1.64003, 5.94422),
    Vector3box(-11.0378, 8.3607, -1.738),
    Vector3box(7.38834, -18.8161, 10.6521),
    Vector3box(20.1461, 47.3728, 8.30593),
    Vector3box(16.7941, 9.23699, 3.7197),
}

local init_spawn_pos = Vector3box(-4.55132, -0.114992, 5.00524)
local rot = QuaternionBox(Quaternion.from_elements(0, 0, 0, 0))

mod.nurgling_count = mod.nurgling_count or 0

mod.on_game_state_changed = function(status, state_name)
    if state_name == "StateIngame" and status == "enter" then
        local level_name = Managers.level_transition_handler:get_current_level_keys()
        if level_name == "inn_level" then
            local nurgling_breed = Breeds['critter_nurgling']
            local spawned_unit = Managers.state.conflict:spawn_queued_unit(nurgling_breed, init_spawn_pos, rot, nurgling_breed.debug_spawn_category or "debug_spawn", 
                nil, nil, nurgling_breed.debug_spawn_optional_data)
            local i = 0
            while (i < math.min(mod.nurgling_count, 50)) do
                Managers.state.conflict:spawn_queued_unit(nurgling_breed, spawn_points[math.random(#spawn_points)], rot, 
                    nurgling_breed.debug_spawn_category or "debug_spawn", nil, nil, nurgling_breed.debug_spawn_optional_data)
                i = i +1
            end
        end
        mod.nurgling_count = 50
    end
end

mod:hook(StatisticsUtil, "register_kill", function(func, victim_unit, damage_data, statistics_db, is_server)
    local level_name = Managers.level_transition_handler:get_current_level_keys()
    if level_name == "inn_level" then
        local breed_killed = Unit.get_data(victim_unit, "breed")
        local breed_killed_name = breed_killed.name
        breed_killed.debug_spawn_optional_data = breed_killed.debug_spawn_optional_data or {}
        breed_killed.debug_spawn_optional_data.ignore_breed_limits = true
        breed_killed.debug_spawn_optional_data.enhancements = nil
        if breed_killed_name == "critter_nurgling" then
            mod.nurgling_count = mod.nurgling_count + 7
            local i = 0
            while (i < 7) do
                Managers.state.conflict:spawn_queued_unit(breed_killed, spawn_points[math.random(#spawn_points)], rot, breed_killed.debug_spawn_category or "debug_spawn", 
                nil, nil, breed_killed.debug_spawn_optional_data)
                i = i +1
            end
        end
    end 
    return func(victim_unit, damage_data, statistics_db, is_server)
end)











--nurglings currently aren't in the default list of creatures in creature spawn
local spawn_mod = get_mod("CreatureSpawner")

if spawn_mod then
    local add_spawn_catagory = {
        critter_nurgling = {
            "Misc",
        }
    }
    table.merge(spawn_mod.unit_categories, table)
    breed_name = 'critter_nurgling'
    table.insert(spawn_mod["all_units"], breed_name)
end