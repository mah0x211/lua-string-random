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
local random = math.random
local INF_POS = math.huge

math.randomseed(os.time())

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

--- random_bytes
--- @param n integer
--- @param charset? string
--- @return string url
local function randstr(n, charset)
    if type(n) ~= 'number' or n < 0 or n == INF_POS or not rawequal(floor(n), n) then
        error('n must be uint', 2)
    elseif charset == nil then
        charset = 'printable'
    elseif type(charset) ~= 'string' then
        error('charset must be string', 2)
    elseif not CHARSETS[charset] then
        error(format('invalid charset %q', charset), 2)
    end

    local tbl = CHARSETS[charset]
    local nchar = #tbl
    local res = {}
    for i = 1, n do
        res[i] = tbl[random(1, nchar)]
    end
    return concat(res)
end

return randstr
