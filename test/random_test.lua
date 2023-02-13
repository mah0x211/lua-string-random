require('luacov')
local testcase = require('testcase')
local random = require('random')

function testcase.random()
    -- test that returns a n bytes of random string
    for i = 0, 100 do
        local s = random(i)
        assert.equal(#s, i)
    end

    -- test that returns a random uppercase string
    local s = random(100, 'uppercase')
    assert.match(s, '^[A-Z]+$', false)

    -- test that returns a random lowercase string
    s = random(100, 'lowercase')
    assert.match(s, '^[a-z]+$', false)

    -- test that returns a random numeric string
    s = random(100, 'numeric')
    assert.match(s, '^[0-9]+$', false)

    -- test that returns a random symbol string
    s = random(100, 'symbol')
    assert.match(s, '^[!"#$%%&\'()*+,%-./:;<=>?@[%]^_`{|}~]+$', false)

    -- test that returns a random alpha string
    s = random(100, 'alpha')
    assert.match(s, '^[a-zA-Z]+$', false)

    -- test that returns a random alnum string
    s = random(100, 'alnum')
    assert.match(s, '^[a-zA-Z0-9]+$', false)

    -- test that returns a random printable string
    s = random(100, 'printable')
    assert.match(s, '^[a-zA-Z0-9!"#$%%&\'()*+,-./:;<=>?@[%]^_`{|}~]+$', false)

    -- test that returns a random urlsafe string
    s = random(100, 'urlsafe')
    assert.match(s, '^[a-zA-Z0-9%-_]+$', false)

    -- test that throws an error if n argument is invalid
    local err = assert.throws(random, 'foo')
    assert.match(err, 'n must be uint')

    -- test that throws an error if charset argument is invalid
    err = assert.throws(random, 1, {})
    assert.match(err, 'charset must be string')

    -- test that throws an error if charset argument is invalid
    err = assert.throws(random, 1, 'foo')
    assert.match(err, 'invalid charset "foo"')
end

