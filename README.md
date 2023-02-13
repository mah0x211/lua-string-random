# lua-string-random

[![test](https://github.com/mah0x211/lua-string-random/actions/workflows/test.yml/badge.svg)](https://github.com/mah0x211/lua-string-random/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/mah0x211/lua-string-random/branch/master/graph/badge.svg)](https://codecov.io/gh/mah0x211/lua-string-random)

generate a random string.


## Installation

```
luarocks install string-random
```

## Usage

```lua
local randstr = require('string.random')
print(randstr(10)) -- gNp%=m#c:S
```


## s = random( n [, charset] )

`string.random` function generate a random string.

**Parameters**

- `n:integer`: number of bytes to be generated.
- `charset:string`: specifiy one of the following character set names.
    - `uppercase`: `ABCDEFGHIJKLMNOPQRSTUVWXYZ`
    - `lowercase`: `abcdefghijklmnopqrstuvwxyz`
    - `alpha`: `ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz`
    - `numeric`: `0123456789`
    - `alnum`: `ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789`
    - `symbol`: <code>!"#$%&'()*+,-./:;<=>?@[]^_`{|}~</code>
    - `printable`: <code>ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!"#$%&'()*+,-./:;<=>?@[]^_`{|}~</code>
    - `urlsafe`: `ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_`

**Returns**

- `s:string`: generated string.

