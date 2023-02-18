--[[Time = 2.10
Test = "caderno"
if (Time > 1) and (Time > 2) then
    io.write(Time.." is good".." not good\n")
end

if (Time > 1) and (Time > 2) then io.write(Time.." is good".." not good\n") end

io.write(#Test, string.gsub( Test,"a","MUITO TEXTO"),Test)
Test = string.gsub( Test,"a","MUITO TEXTO")
print('\n',Test)
Test = "caderno"
Index = string.find( Test,"c")
print(Index)
io.write(string.upper(Test),string.lower(Test))
--]]

--[[
i = 1
while (i < 5) do
    io.write(i)
    i = i + 1
    if i == 6 then break end
end
print("\n")
--]]

--[[
repeat
    io.write("Enter your guess: " )
    guess = io.read()
until tonumber(guess) == 15
print('funciona')
--]]

--[[
months = {'a','b','c','d'}

--[[for i = 1, 10, 1 do
    io.write(i)
end

for k, value in pairs(months) do
    io.write(value,' ')
end
]]--
--[[
atable =  {}

for i = 1, 10 do
    atable[i] = i
end
atable[-1] = 4
print(atable[-1],atable[1])

table.insert(atable, 1, 0)
print(atable[1])

print(table.concat(atable,', '))
table.remove(atable,1)
print(table.concat(atable,', '))
--]]

--[[aMultiTable = {}

for i = 0, 9 do
    aMultiTable[i] = {}
    for j = 0 , 9 do
        aMultiTable[i][j] = tostring(i) .. tostring(j)
    end
end

for i = 0, 9 do
    for j = 0 , 9 do
        io.write(aMultiTable[i][j],' : ')
    end
end]]--

--[[
function getSum(num1,num2)
    return num1 + num2
end

print(string.format("5 + 2 = %d", getSum(5,2)))

function splitStr(theString)
    stringTable = {}
    local i = 1
    for word in string.gmatch(theString, '[^%s]+') do
        stringTable[i] = word
        i = i + 1
    end

    return stringTable, i
end

splitStrTable, numOfStr = splitStr("the turtle")

for j = 1, numOfStr - 1 do
    print(string.format( "%d : %s",j ,splitStrTable[j]))
end
--]]

--[[function getSumMore(...) do
    local sum = 0
    for k, v in pairs {...} do
        sum = sum + v
    end
    return sum
end
end


io.write("Sum ", getSumMore(1,2,3,4,5,6),'\n')
--]]

--[[doubleIt = function(x) return x * 2 end

print(doubleIt(4))--]]

--[[function outerFunc() do
    local i = 0

    return function()
        i = i + 1
        return i
    end
end
end

getI = outerFunc()

print(getI())
print(getI())
--]]

co = coroutine.create(function()
    for i = 1, 10, 1 do
        print(i)
        print(coroutine.status(co))
        if i == 5 then coroutine.yield() end
    end
end)

print(coroutine.status( co ))
coroutine.resume(co)
print(coroutine.status( co ))

co2 = coroutine.create(function()
    for i = 101, 110, 1 do
        print(i)
    end end)

coroutine.resume(co2)
coroutine.resume(co)


--[[
-- FILES
-- r: read only
-- w: overwrite or create a new file
-- a: append or create a  new file
-- r+: read and write existing file
-- w+: overwrite read or create a file
-- a+: append read or create file

file = io.open("test.lua", "w+")
file:write("random String of Text\n")
file:write("some more text\n")

file:seek("set", 0)
print(file:read("*a"))
file:close()


file = io.open("test.lua","a+")

file:write("even more text\n")
file:seek("set",0)
print(file:read("*a"))
file:close()
--]]

--[[
a = require("convert")

print(a.ftToCm(12))

--]]

--[[
aTable = {}

for x = 1,10 do
    aTable[x] = x
end

mt = {
    __add = function(table1,table2)
        sumTable = {}

        for y = 1,#table1 do
            if (table1[y] ~= nil) and (table2[y] ~= nil) then
                sumTable[y] = table1[y] + table2[y]
            else
                sumTable[y] = 0
            end
        end
        return sumTable
    end,

    __eq == function(table1, table2)
        return table1.value == table2.value
    end,

}


setmetatable(aTable, mt)

print(aTable == aTable)

addTable = aTable + aTable

for z = 1,#addTable do
    print(addTable[z])
end

--]]

--[[
Animal = {height = 0, weight = 0, name = "No Name", sound="No Sound"}

function Animal:new (height,weight,name, sound)
    setmetatable({}, Animal)
    self.height = height
    self.weight = weight
    self.name = name
    self.sound = sound
    return self
end

function Animal:toString()
    animalStr = string.format("%s weighs %.1f lbs, is %.1f in tall and says %s", self.name, self.weight, self.height, self.sound)
    return animalStr
end

spot = Animal:new(10,15,"Spot","Woof")

print(spot.weight)
print(spot:toString())

Cat = Animal:new()

function Cat:new (height,weight,name, sound, favFood)
    setmetatable({}, Cat)

    self.height = height
    self.weight = weight
    self.name = name
    self.sound = sound
    self.favFood = favFood

    return self
end

function Cat:toString()
    animalStr = string.format("%s weighs %.1f lbs, is %.1f in tall and says %s and loves %s", self.name, self.weight, self.height, self.sound,self.favFood)
    return animalStr
end

fluffy = Cat:new(10,15,"Fluffy","Meow","Tuna")

print(fluffy:toString())--]]
