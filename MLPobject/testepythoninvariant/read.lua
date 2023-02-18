file = io.open("text.txt",r)
list = {}

for i = 1,7 do
    list[i] = file:read("n")
    print(list[i])
end

io.close(file)