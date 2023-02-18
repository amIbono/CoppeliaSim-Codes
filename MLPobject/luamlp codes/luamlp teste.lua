--[[
-- test module luamlp.lua
-- Author: Jhonathan Paulo Banczek
-- Copyright: jpbanczek@gmail.com
-- 09-10-2013
-- example: PROBLEM XOR
--]]

-- load module
luamlp = require 'luamlp'

mlp = luamlp:New(2,5,3,1)
mlp.input = {{0,0},{0,1},{1,0}}
mlp.output = {{0},{1},{1}}
mlp:LoadConfig('teste.txt')
mlp:Training(true)
mlp.input = {{1,1}}
mlp:Test(mlp.input)