require('luacov')
local testcase = require('testcase')
local assert = require('assert')
local random = require('string.random')

function testcase.random()
    -- test that returns a n bytes of random string
    for i = 0, 100 do
        local s = random(i)
        assert.equal(#s, i)
    end
end

function testcase.uppercase()
    -- test that returns a random uppercase string
    local s = random(100, 'uppercase')
    assert.match(s, '^[A-Z]+$', false)
    assert.equal(#s, 100)
end

function testcase.lowercase()
    -- test that returns a random lowercase string
    local s = random(100, 'lowercase')
    assert.match(s, '^[a-z]+$', false)
    assert.equal(#s, 100)
end

function testcase.numeric()
    -- test that returns a random numeric string
    local s = random(100, 'numeric')
    assert.match(s, '^[0-9]+$', false)
    assert.equal(#s, 100)
end

function testcase.symbol()
    -- test that returns a random symbol string
    local s = random(100, 'symbol')
    assert.match(s, '^[!"#$%%&\'()*+,%-./:;<=>?@[%]^_`{|}~]+$', false)
    assert.equal(#s, 100)
end

function testcase.alpha()
    -- test that returns a random alpha string
    local s = random(100, 'alpha')
    assert.match(s, '^[A-Za-z]+$', false)
    assert.equal(#s, 100)
end

function testcase.alnum()
    -- test that returns a random alnum string
    local s = random(100, 'alnum')
    assert.match(s, '^[0-9A-Za-z]+$', false)
    assert.equal(#s, 100)
end

function testcase.printable()
    -- test that returns a random printable string
    local s = random(100, 'printable')
    assert.match(s, '^[0-9A-Za-z!"#$%%&\'()*+,-./:;<=>?@[%]^_`{|}~]+$', false)
    assert.equal(#s, 100)
end

function testcase.urlsafe()
    -- test that returns a random urlsafe string
    local s = random(100, 'urlsafe')
    assert.match(s, '^[0-9A-Za-z%-_]+$', false)
    assert.equal(#s, 100)
end

function testcase.hex()
    -- test that returns a hex encoded random string
    local s = random(80, 'hex')
    assert.match(s, '^[0-9a-f]+$', false)
    assert.equal(#s, 80)
end

function testcase.invalid_charset()
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

