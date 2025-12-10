local RegisteredStashes = {}

-- Get Framework
if GetResourceState('qb-core') == 'started' then
    Framework = "qb-core"
    QBCore = exports['qb-core']:GetCoreObject()
elseif GetResourceState('es_extended') == 'started' then
    Framework = "esx"
end

-- Get Inventory
if GetResourceState('qb-inventory') == 'started' then
    Inventory = "qb-inventory"
elseif GetResourceState('ox_inventory') == 'started' then
    Inventory = "ox_inventory"
elseif GetResourceState('ps-inventory') == 'started' then
    Inventory = "ps-inventory"
elseif GetResourceState('ak47_inventory') == 'started' then
    Inventory = "ak47_inventory"
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    if Framework == "esx" then
    local exists = false
    TriggerEvent('esx_society:getSocieties', function(societies)
        for _, s in ipairs(societies) do
            if s.name == 'burgershot' then
                exists = true
                break
            end
        end
    end)
    if not exists then
        exports["esx_society"]:registerSociety('burgershot', 'Burgershot', 'society_burgershot', 'society_burgershot', 'society_burgershot', {type = 'private'})
    end
  end
end)

function RemoveItem(Player, itemname, quantity)
  if Inventory == "qb-inventory" then
    return Player.Functions.RemoveItem(itemname, quantity)
  elseif Inventory == "ps-inventory" then
    return Player.Functions.RemoveItem(itemname, quantity)
  elseif Inventory == "ox_inventory" then
    return exports.ox_inventory:RemoveItem(Player, itemname, quantity)
  elseif Inventory == "ak47_inventory" then
    exports['ak47_inventory']:RemoveItem(Player, itemname, quantity)
  end
end

function AddItem(Player, itemname, quantity)
  if Inventory == "qb-inventory" then
    return Player.Functions.AddItem(itemname, quantity)
  elseif Inventory == "ps-inventory" then
    return Player.Functions.AddItem(itemname, quantity)
  elseif Inventory == "ox_inventory" then
    return exports.ox_inventory:AddItem(Player, itemname, quantity)
  elseif Inventory == "ak47_inventory" then
    return exports['ak47_inventory']:AddItem(Player, itemname, quantity)
  end
end

function ItemBox(source, itemName, action, quantity)
  if Inventory == "qb-inventory" then
    TriggerClientEvent('qb-inventory:client:ItemBox', source, QBCore.Shared.Items[itemName], action, quantity)
  elseif Inventory == "ps-inventory" then
    TriggerClientEvent('ps-inventory:client:ItemBox', source, QBCore.Shared.Items[itemName], action, quantity)
  end
end

function OpenStash(src, data, slot, maxweights)
  if Inventory == "qb-inventory" then
    exports['qb-inventory']:OpenInventory(src, data.stash, {
        maxweight = maxweights,
        slots = slot,
    })
  elseif Inventory == "ps-inventory" then
    TriggerClientEvent("burgershot:client:triggerpsinventory", src, data)
  elseif Inventory == "ox_inventory" then
    if not RegisteredStashes[data.stash] then
      exports.ox_inventory:RegisterStash(data.stash, data.stash, slot, maxweights)
      RegisteredStashes[data.stash] = true
    end
    TriggerClientEvent("burgershot:client:ForceOpenStash", src, data)
  elseif Inventory == "ak47_inventory" then
    if not RegisteredStashes[data.stash] then
      exports['ak47_inventory']:CreateInventory(data.stash, {label = data.stash, maxWeight = maxweights, slots = slot, type = 'stash',})
      exports['ak47_inventory']:OpenInventory(src, data.stash)
      RegisteredStashes[data.stash] = true
    else
      exports['ak47_inventory']:OpenInventory(src, data.stash)
  end
end

function PlayerSource(src)
  if Framework == "qb-core" then
   return QBCore.Functions.GetPlayer(src)
  elseif Framework == "esx" then
   return ESX.GetPlayerFromId(src)
  end
end

function GetAllPlayers()
  if Framework == "qb-core" then
    return QBCore.Functions.GetPlayers()
  elseif Framework == "esx" then
    return ESX.GetPlayers()
  end
end

function PlayerFirstName(source, Player)
  if Framework == "qb-core" then
    return Player.PlayerData.charinfo.firstname
  elseif Framework == "esx" then
    local fullName = Player.getName()
    return fullName:match("^(%S+)")
  end
end

function PlayerLastName(source, Player)
  if Framework == "qb-core" then
    return Player.PlayerData.charinfo.lastname
  elseif Framework == "esx" then
    local fullName = Player.getName()
    return fullName:match("^%S+%s+(.*)")
  end
end

function PlayerCID(source, Player)
  if Framework == "qb-core" then
    return Player.PlayerData.citizenid
  elseif Framework == "esx" then
    return ESX.GetIdentifier(source)
  end
end

function GetJobName(Player)
  if Framework == "qb-core" then
    return Player.PlayerData.job.name
  elseif Framework == "esx" then
    return Player.job.name
  end
end

function GetDutyStatus(Player)
  if Framework == "qb-core" then
    return Player.PlayerData.job.onduty
  elseif Framework == "esx" then
    return true -- Always on Duty in ESX
  end
end

function GetPlayersCash(Player)
  if Framework == "qb-core" then
    return Player.PlayerData.money.cash
  elseif Framework == "esx" then
    return Player.getMoney()
  end
end

function GetPlayersBank(Player)
  if Framework == "qb-core" then
    return Player.PlayerData.money.bank
  elseif Framework == "esx" then
    return Player.getAccount('bank').money
  end
end

function RemoveCash(Player, pay)
  if Framework == "qb-core" then
    return Player.Functions.RemoveMoney('cash', pay)
  elseif Framework == "esx" then
    Player.removeAccountMoney('money', pay)
  end
end

function RemoveBank(Player, pay)
  if Framework == "qb-core" then
    return Player.Functions.RemoveMoney('bank', pay)
  elseif Framework == "esx" then
    Player.removeAccountMoney('bank', pay)
  end
end

function AddCash(Player, pay)
  if Framework == "qb-core" then
    return Player.Functions.AddMoney('cash', pay)
  elseif Framework == "esx" then
    Player.addAccountMoney('money', pay)
  end
end

function AddCashDelivery(Player, pay, commission)
  if Framework == "qb-core" then
    local amount = pay * commission
    return Player.Functions.AddMoney('cash', amount)
  elseif Framework == "esx" then
    Player.addAccountMoney('money', pay)
  end
end

function GetItemName(Player, name)
  if Framework == "qb-core" then
    return Player.Functions.GetItemByName(name)
  elseif Framework == "esx" then
    return Player.getInventoryItem(name)
  end
end

function GetItemAmount(Player, name)
  if Framework == "qb-core" then
    return Player.Functions.GetItemByName(name).amount
  elseif Framework == "esx" then
    return Player.getInventoryItem(name).count
  end
end

-- Exports
exports('RemoveItem', RemoveItem)
exports('AddItem', AddItem)
exports('ItemBox', ItemBox)
exports('OpenStash', OpenStash)
exports('PlayerSource', PlayerSource)
exports('GetAllPlayers', GetAllPlayers)
exports('PlayerFirstName', PlayerFirstName)
exports('PlayerLastName', PlayerLastName)
exports('PlayerCID', PlayerCID)
exports('GetJobName', GetJobName)
exports('GetDutyStatus', GetDutyStatus)
exports('GetPlayersCash', GetPlayersCash)
exports('GetPlayersBank', GetPlayersBank)
exports('RemoveCash', RemoveCash)
exports('RemoveBank', RemoveBank)
exports('AddCash', AddCash)
exports('AddCashDelivery', AddCashDelivery)
exports('GetItemName', GetItemName)
exports('GetItemAmount', GetItemAmount)