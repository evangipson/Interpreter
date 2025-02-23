-- Set the package path so all the tests get good relative require paths
package.path = '.\\scripts\\?.lua;.\\tests\\lua\\?.tests.lua;' .. package.path

--------------
-- Cache tests
--------------
print('\nrunning lua unit tests.\n')
assert(require('cache.in_memory'))
assert(require('cache.distributed'))
assert(require('cache.hybrid'))
print('\nlua tests complete.\n')