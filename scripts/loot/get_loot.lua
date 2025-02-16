-- Localize standard library functions for slight performance gain
local math_random = math.random
local math_randomseed = math.randomseed
local os_time = os.time

-- Define loot table for each monster type
local loot_table = {
    goblin = { rare = 0.2, magic = 0.5, common = 0.8 },
    orc = { rare = 0.1, magic = 0.4, common = 0.8 },
}

-- Seed random number generator
math_randomseed(os_time())

local function get_loot(monster_name)
    local drop_chances = loot_table[monster_name]
    if not drop_chances then
        return "nothing"
    end

    local roll = math_random()
    local drops = {"rare", "magic", "common"}
    for i, drop_type in ipairs(drops) do
        if roll <= drop_chances[drop_type] then
            return drop_type
        end
    end

    return "nothing"
end

return get_loot