local are_arrays_equal = require('utils.are_arrays_equal')

--------------------------
-- Distributed Cache tests
--------------------------

-- delete any previously saved distributed cache files
local old_distributed_cache_file = io.open('./cachefile.cache', 'w')
if old_distributed_cache_file then
    old_distributed_cache_file:write('')
    old_distributed_cache_file:close()
end

-- validate that distributed cache loads correctly
local DistributedCache = require('cache.distributed_cache')
assert(DistributedCache, 'Distributed cache failed to load.')

-- validate getting a value that doesn't exist returns nil
local test_key = 'test-key'
local uncached_value = DistributedCache:get(test_key)
assert(uncached_value == nil, '"' .. test_key .. '" should not be in cache.')

-- validate ability to set simple value in cache
local test_value = 'test value'
local set_distributed_cache = DistributedCache:set(test_key, test_value)
assert(set_distributed_cache, 'Simple value "' .. test_value .. '" was not set correctly in distributed cache.')

-- validate ability to get simple value out of cache
local cached_distributed_value = DistributedCache:get(test_key):gsub('"', '')
assert(cached_distributed_value, 'Got "nil" back from distributed cache when trying to get the "' .. test_key .. '" value.')
assert(cached_distributed_value == test_value, 'Did not retrieve the "' .. test_key .. '" cache value from distributed cache correctly.')

-- validate ability to remove simple value from cache by key
local removed_from_distributed = DistributedCache:remove(test_key)
assert(removed_from_distributed, 'Unable to remove "' .. test_key .. '" from distributed cache.')
local removed_cache_value_from_distributed = DistributedCache:get(test_key)
assert(removed_cache_value_from_distributed == nil, '"' .. test_key .. '" still existed distributed cache.')

-- validate ability to set complex value in cache
local complex_key = 'complex-key'
local complex_value = { value = "wow i'm a cached value!", options = {1, 2, 3} }
local complex_set_distributed_cache = DistributedCache:set(complex_key, complex_value)
assert(complex_set_distributed_cache, 'Complex value: "' .. tostring(complex_value) .. '" was not set correctly in distributed cache.')

-- validate ability to get complex value out of cache correctly
local complex_distributed_value = DistributedCache:get(complex_key)
assert(complex_distributed_value, 'Got "nil" back from distributed cache when trying to get the "' .. complex_key .. '" value.')
local values_match = complex_distributed_value.value == complex_value.value
local options_match = are_arrays_equal(complex_distributed_value.options, complex_value.options)
assert(values_match and options_match, 'Did not retrieve the "' .. complex_key .. '" cache value from distributed cache correctly.')

-- validate ability to remove complex value from cache by key
local removed_complex_from_distributed = DistributedCache:remove(complex_key)
assert(removed_complex_from_distributed, 'Unable to remove "' .. complex_key .. '" from distributed cache.')
local removed_complex_cache_value_from_distributed = DistributedCache:get(complex_key)
assert(removed_complex_cache_value_from_distributed == nil, '"' .. complex_key .. '" still existed in distributed cache.')

-- validate ability to replace values in cache
DistributedCache:set(test_key, test_value)
local replaced_value_distributed = DistributedCache:set(test_key, complex_value)
assert(replaced_value_distributed, 'Unable to replace "' .. test_key .. '" distributed cache value with a complex value.')

-- invalidate the persisting cache values when complete
DistributedCache:remove(test_key)

-- let the tester know the tests passed
print('distributed cache:\t\t\27[32mpass\27[0m')