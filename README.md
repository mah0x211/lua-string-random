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
print(('%q, %q'):format(randstr(10))) -- "Uy~lZ3I<LE", "os.urandom"
```


## s, genname = random( n [, charset] )

`string.random` function generate a random string.

**Parameters**

- `n:integer`: number of bytes to be generated.
- `charset:string`: specifiy one of the following character set names.
    - `uppercase`: `ABCDEFGHIJKLMNOPQRSTUVWXYZ`
    - `lowercase`: `abcdefghijklmnopqrstuvwxyz`
    - `alpha`: `uppercase` and `lowercase`
    - `numeric`: `0123456789`
    - `alnum`: `alpha` and `numeric`
    - `symbol`: <code>!"#$%&'()*+,-./:;<=>?@[]^_`{|}~</code>
    - `printable`: `alnum` and `symbol`
    - `urlsafe`: `alnum` and `-_`

**Returns**

- `s:string`: generated string.
- `genname:string`: name of the generator used.
    - `os.urandom`: use `os.urandom` module.
    - `sfmt`: use `sfmt` module.


