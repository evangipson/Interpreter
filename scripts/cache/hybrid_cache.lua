local DistributedCache = require('cache.distributed_cache')
local InMemoryCache = require('cache.memory_cache')

-- A base implementation of hybrid cache that leverages both distributed and in-memory
local HybridCache = {
    -- Sets the `name` and `value` in the cache
    set = function(self, name, value)
        local set_in_distributed = false
        local set_in_memory = false

        -- Try to get an existing value out of in-memory cache first, and update it
        local cached_value = InMemoryCache:get(name)
        if cached_value then
            set_in_memory = InMemoryCache:set(name, value)
        end

        -- Try and get an existing value out of distributed cache next, and update it and in-memory
        cached_value = DistributedCache:get(name)
        if cached_value then
            set_in_distributed = DistributedCache:set(name, value)
        end

        -- If both caches were updated, there's nothing more to do here
        if set_in_distributed and set_in_memory then
            return true
        end

        -- Set the value in both distributed cache and in-memory cache, and return the result
        set_in_distributed = DistributedCache:set(name, value)
        set_in_memory = InMemoryCache:set(name, value)
        return set_in_distributed and set_in_memory
    end,
    -- Gets the value from the `cache_key` if it exists in cache, otherwise returns `nil`
    get = function(self, cache_key)
        -- Try and get from in-memory cache first
        local cached_value = InMemoryCache:get(cache_key)
        if cached_value then
            return cached_value
        end

        -- Try and get form distributed cache if it doesn't exist in-memory
        cached_value = DistributedCache:get(cache_key)
        if cached_value then
            -- If there was a value, update in-memory cache so it's there next time
            InMemoryCache:set(cache_key, cached_value)
            return cached_value
        end

        -- Otherwise, the cache value doesn't exist
        return nil
    end,
    -- Removes a value from cache with the associated `cache_key`
    remove = function(self, cache_key)
        local removed_from_in_memory = InMemoryCache:remove(cache_key)
        local removed_from_distributed_cache = DistributedCache:remove(cache_key)

        return removed_from_in_memory and removed_from_distributed_cache
    end,
}

return HybridCache