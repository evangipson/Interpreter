------------------------
-- In-Memory Cache tests
------------------------

-- validate that in-memory cache loads correctly
local InMemoryCache = require('cache.memory_cache')
assert(InMemoryCache, 'In-memory cache failed to load.')

-- validate getting a value that doesn't exist returns nil
local test_key = 'test-key'
local uncached_value = InMemoryCache:get(test_key)
assert(uncached_value == nil, '"' .. test_key .. '" should not be in cache.')

-- validate ability to set simple value in cache
local test_value = 'test value'
local set_in_memory_cache = InMemoryCache:set(test_key, test_value)
assert(set_in_memory_cache, 'Simple value "' .. test_value .. '" was not set correctly in-memory cache.')

-- validate ability to get simple value out of cache
local cached_in_memory_value = InMemoryCache:get(test_key):gsub('"', '')
assert(cached_in_memory_value == test_value, 'Did not retrieve the "' .. test_key .. '" cache value from in-memory cache correctly.')

-- validate ability to remove simple value from cache by key
local removed_from_in_memory = InMemoryCache:remove(test_key)
assert(removed_from_in_memory, 'Unable to remove "' .. test_key .. '" from in-memory cache.')
local removed_cache_value_from_in_memory = InMemoryCache:get(test_key)
assert(removed_cache_value_from_in_memory == nil, '"' .. test_key .. '" still existed in-memory cache.')

-- validate ability to set complex value in cache
local complex_key = 'complex-key'
local complex_value = { value = "wow i'm a cached value!", options = {1, 2, 3} }
local complex_set_in_memory_cache = InMemoryCache:set(complex_key, complex_value)
assert(complex_set_in_memory_cache, 'Complex value: "' .. tostring(complex_value) .. '" was not set correctly in-memory cache.')

-- validate ability to get complex value out of cache correctly
local complex_in_memory_value = InMemoryCache:get(complex_key)
assert(complex_in_memory_value, 'Got "nil" back from in-memory cache when trying to get the "' .. complex_key .. '" value.')
assert(complex_in_memory_value == complex_value, 'Did not retrieve the "' .. complex_key .. '" cache value from in-memory cache correctly.')

-- validate ability to remove complex value from cache by key
local removed_complex_from_in_memory = InMemoryCache:remove(complex_key)
assert(removed_complex_from_in_memory, 'Unable to remove "' .. complex_key .. '" from in-memory cache.')
local removed_complex_cache_value_from_in_memory = InMemoryCache:get(complex_key)
assert(removed_complex_cache_value_from_in_memory == nil, '"' .. complex_key .. '" still existed in-memory cache.')

-- validate ability to replace values in cache
local replaced_value_in_memory = InMemoryCache:set(test_key, complex_value)
assert(replaced_value_in_memory, 'Unable to replace "' .. test_key .. '" in-memory cache value with a complex value.')

-- invalidate the persisting cache values when complete
InMemoryCache:remove(test_key)

-- let the tester know the tests passed
print('in-memory cache:\t\t\27[32mpass\27[0m')