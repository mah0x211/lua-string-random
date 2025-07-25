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
local new_sfmt = require('sfmt').new
local new_urandom = require('os.urandom')
local CACHE_SFMT
local CACHE_URANDOM

--- generate n bytes of random bytes
--- @param n integer
--- @return string str random string
--- @return string generator generator name
local function gen_bytes(n)
    local r = CACHE_URANDOM or new_urandom()
    if r then
        local s = r:bytes(n)
        if s then
            CACHE_URANDOM = r
            return s, 'os.urandom'
        end
        -- close urandom if failed to get random numbers
        CACHE_URANDOM = nil
        r:close()
    end

    -- fallback to sfmt
    r = CACHE_SFMT or new_sfmt()
    CACHE_SFMT = r

    return r:bytes(n), 'sfmt'
end

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

local byte = string.byte
local format = string.format
local gsub = string.gsub
local base64 = require('base64mix')

--- Encoder functions for different encodings
local ENCODER = {
    base64 = base64.encode,
    base64url = base64.encodeURL,
    hex = function(b)
        return (gsub(b, '.', function(c)
            return format('%02x', byte(c))
        end))
    end,
}

--- Number of bits per byte for each encoding
local BIT_PER_ENCBYTE = {
    base64 = 6,
    base64url = 6,
    hex = 4,
}

local sub = string.sub
local ceil = math.ceil

--- generate encoded random string
--- @param len integer
--- @param charset string
--- @return string? str random string
--- @return string generator generator name
--- @return any err error object
local function gen_random_encstr(len, charset)
    -- calculate the number of random bytes needed for the encoding
    local blen = ceil(len * BIT_PER_ENCBYTE[charset] / 8)
    local b, generator = gen_bytes(blen)
    local s, err = ENCODER[charset](b)
    -- truncate to the desired length
    return s and sub(s, 1, len) or nil, generator, err
end

local concat = table.concat

--- generate random string from charset
--- @param len integer
--- @param charset string[]
--- @return string str random string
--- @return string generator generator name
--- @return any err error object
local function gen_random_str(len, charset)
    local nchar = #charset
    local s, generator = gen_bytes(len * 2)
    local offset = 1
    local res = {}

    for i = 1, len do
        local n = byte(s, offset) * 256 + byte(s, offset + 1)
        offset = offset + 2
        res[i] = charset[1 + (n % nchar)]
    end
    return concat(res), generator
end

local floor = math.floor
local INF_POS = math.huge

--- random return n bytes of random string
--- @param n integer
--- @param charset? string
--- @return string? str
--- @return string generator
--- @return any err
local function random(n, charset)
    if type(n) ~= 'number' or n < 0 or n == INF_POS or floor(n) ~= n then
        error('n must be uint', 2)
    elseif charset == nil then
        charset = 'printable'
    elseif type(charset) ~= 'string' then
        error('charset must be string', 2)
    end

    if n == 0 then
        return '', 'os.urandom'
    elseif CHARSETS[charset] then
        -- if charset is a table, use it directly
        return gen_random_str(n, CHARSETS[charset])
    elseif ENCODER[charset] then
        return gen_random_encstr(n, charset)
    end
    error(format('invalid charset %q', charset), 2)
end

return random
