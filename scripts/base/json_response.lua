-- A base JSON response, which will return a table with "ok" and "message"
local JsonResponse = {
    -- Returns the response as a JSON string
    tojson = function(self, ok, message)
        return '{' ..
            '"ok":' .. (ok and "true" or "false") ..
            ',"message":' .. (message and message or "") ..
        '}'
    end,
    -- Returns an "ok" response with the message
    ok = function(self, message)
        return self:tojson(true, message)
    end,
    -- Returns a not "ok" response with the message
    error = function(self, message)
        return self:tojson(false, '"' .. message .. '"')
    end
}

return JsonResponse