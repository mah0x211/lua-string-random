--
-- Copyright (C) 2023 Masatoshi Fukunaga
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
local concat = table.concat
local format = string.format
local floor = math.floor
local INF_POS = math.huge
-- constants
local UPPERCASE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
local LOWERCASE = 'abcdefghijklmnopqrstuvwxyz'
local NUMERIC = '0123456789'
local SYMBOL = [[!"#$%&'()*+,-./:;<=>?@[]^_`{|}~]]
local SYMBOL_URLSAFE = [[-_]]
local ALPHA = UPPERCASE .. LOWERCASE
local ALNUM = ALPHA .. NUMERIC
local PRINTABLE = ALNUM .. SYMBOL
local URLSAFE = ALNUM .. SYMBOL_URLSAFE
-- build character tables
local CHARSETS = {}
for name, s in pairs({
    uppercase = UPPERCASE,
    lowercase = LOWERCASE,
    numeric = NUMERIC,
    symbol = SYMBOL,
    alpha = ALPHA,
    alnum = ALNUM,
    printable = PRINTABLE,
    urlsafe = URLSAFE,
}) do
    local charset = {}
    for i = 1, #s do
        charset[#charset + 1] = string.sub(s, i, i)
    end
    CHARSETS[name] = charset
end

local new_sfmt = require('sfmt').new
local urandom = require('os.urandom')
local CACHE_URANDOM
local CACHE_SFMT

--- genrandstr generate n bytes of random string
--- @param n integer
--- @param charset string[]
--- @return string str random string
--- @return string generator generator name
local function genrandstr(n, charset)
    local nchar = #charset
    local r = CACHE_URANDOM or urandom()
    local res = {}

    if r then
        if n == 0 then
            return '', 'os.urandom'
        end

        local list = r:get32u(n)
        if list then
            for i = 1, n do
                local v = 1 + (list[i] % nchar)
                res[i] = charset[v]
            end
            CACHE_URANDOM = r
            return concat(res), 'os.urandom'
        end
        -- close urandom if failed to get random numbers
        CACHE_URANDOM = nil
        r:close()
    end

    -- fallback to sfmt
    if CACHE_SFMT == nil then
        r = new_sfmt()
        CACHE_SFMT = r
    else
        r = CACHE_SFMT
        r:init()
    end

    for i = 1, n do
        res[i] = charset[r:rand32(nchar, 1)]
    end
    return concat(res), 'sfmt'
end

--- random return n bytes of random string
--- @param n integer
--- @param charset? string
--- @return string str
--- @return string generator
local function random(n, charset)
    if type(n) ~= 'number' or n < 0 or n == INF_POS or floor(n) ~= n then
        error('n must be uint', 2)
    elseif charset == nil then
        charset = 'printable'
    elseif type(charset) ~= 'string' then
        error('charset must be string', 2)
    elseif not CHARSETS[charset] then
        error(format('invalid charset %q', charset), 2)
    end
    -- generate n bytes of random string
    return genrandstr(n, CHARSETS[charset])
end

return random
