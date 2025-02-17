-- Define global key input
getgenv().LDKey = "VirtualHub_335353535"

local gg = [[

____   ____.__         __               .__    ___ ___      ___.      ____    _______   
\   \ /   /|__|_______/  |_ __ _______  |  |  /   |   \ __ _\_ |__   /_   |   \   _  \  
 \   Y   / |  \_  __ \   __\  |  \__  \ |  | /    ~    \  |  \ __ \   |   |   /  /_\  \ 
  \     /  |  ||  | \/|  | |  |  // __ \|  |_\    Y    /  |  / \_\ \  |   |   \  \_/   \
   \___/   |__||__|   |__| |____/(____  /____/\___|_  /|____/|___  /  |___| /\ \_____  /
                                      \/            \/           \/         \/       \/ 
]]

print(gg)

-- Attempt to load keys
local success, data = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/Aldoriahub/Test2222/refs/heads/main/keys.lua', true))()
end)

if not success or type(data) ~= "table" then
    print("Failed to load key system.")
    return
end

-- Store keys in a global variable safely
getgenv().keys = data.keys or {}
getgenv().devkeys = data.devkeys or {}

-- Validate key data structure
if type(getgenv().keys) ~= "table" then
    print("Key error: 255")
end

if type(getgenv().devkeys) ~= "table" then
    print("Key error: 256")
end

-- Ensure keys are loaded before printing success message
if type(getgenv().keys) == "table" and type(getgenv().devkeys) == "table" then
    print("Key system loaded")
else
    print("Key system failed to initialize properly.")
    return
end

-- Validate key function
local function isValidKey(key, devkeys)
    for _, validKey in pairs(devkeys) do
        if key == validKey then
            return true
        end
    end
    return false
end

-- Get the user-inputted key
local inputedkey = LDKey 
