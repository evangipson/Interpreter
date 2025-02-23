------------------------
-- hybrid Cache tests
------------------------

-- validate that hybrid cache loads correctly
local HybridCache = require('cache.hybrid_cache')
assert(HybridCache, 'hybrid cache failed to load.')

-- validate getting a value that doesn't exist returns nil
local test_key = 'test-key'
local uncached_value = HybridCache:get(test_key)
assert(uncached_value == nil, '"' .. test_key .. '" should not be in cache.')

-- validate ability to set simple value in cache
local test_value = 'test value'
local set_hybrid_cache = HybridCache:set(test_key, test_value)
assert(set_hybrid_cache, 'Simple value "' .. test_value .. '" was not set correctly hybrid cache.')

-- validate ability to get simple value out of cache
local cached_hybrid_value = HybridCache:get(test_key):gsub('"', '')
assert(cached_hybrid_value == test_value, 'Did not retrieve the "' .. test_key .. '" cache value from hybrid cache correctly.')

-- validate ability to remove simple value from cache by key
local removed_from_hybrid = HybridCache:remove(test_key)
assert(removed_from_hybrid, 'Unable to remove "' .. test_key .. '" from hybrid cache.')
local removed_cache_value_from_hybrid = HybridCache:get(test_key)
assert(removed_cache_value_from_hybrid == nil, '"' .. test_key .. '" still existed hybrid cache.')

-- validate ability to set complex value in cache
local complex_key = 'complex-key'
local complex_value = { value = "wow i'm a cached value!", options = {1, 2, 3} }
local complex_set_hybrid_cache = HybridCache:set(complex_key, complex_value)
assert(complex_set_hybrid_cache, 'Complex value: "' .. tostring(complex_value) .. '" was not set correctly hybrid cache.')

-- validate ability to get complex value out of cache correctly
local complex_hybrid_value = HybridCache:get(complex_key)
assert(complex_hybrid_value, 'Got "nil" back from hybrid cache when trying to get the "' .. complex_key .. '" value.')
assert(complex_hybrid_value == complex_value, 'Did not retrieve the "' .. complex_key .. '" cache value from hybrid cache correctly.')

-- validate ability to remove complex value from cache by key
local removed_complex_from_hybrid = HybridCache:remove(complex_key)
assert(removed_complex_from_hybrid, 'Unable to remove "' .. complex_key .. '" from hybrid cache.')
local removed_complex_cache_value_from_hybrid = HybridCache:get(complex_key)
assert(removed_complex_cache_value_from_hybrid == nil, '"' .. complex_key .. '" still existed hybrid cache.')

-- validate ability to replace values in cache
local replaced_value_hybrid = HybridCache:set(test_key, complex_value)
assert(replaced_value_hybrid, 'Unable to replace "' .. test_key .. '" hybrid cache value with a complex value.')

-- invalidate the persisting cache values when complete
HybridCache:remove(test_key)

-- let the tester know the tests passed
print('hybrid cache:\t\t\t\27[32mpass\27[0m')