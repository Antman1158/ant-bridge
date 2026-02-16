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
elseif GetResourceState('ak47_inventory') == 'started' then
  Inventory = "ak47_inventory"
elseif GetResourceState('ps-inventory') == 'started' then
  Inventory = "ps-inventory"
end

-- Get Management
if GetResourceState('qb-management') == 'started' then
  Management = "qb-management"
elseif GetResourceState('qbx_management') == 'started' then
  Management = "qbx-management"
elseif GetResourceState('esx_society') == 'started' then
  Management = "esx_society"
  elseif GetResourceState('ant-management') == 'started' then
  Management = "ant-management"
end

-- Get Voice
if GetResourceState('pma-voice') == 'started' then
  Voice = "pma-voice"
end

function GetPlayerData()
  if Framework == "qb-core" then
    return QBCore.Functions.GetPlayerData()
  elseif Framework == "esx" then
    return ESX.GetPlayerData()
  end
end

PlayerData = GetPlayerData()

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
  PlayerData = QBCore.Functions.GetPlayerData()
end)

function Voice(Channel)
  if Voice == "pma-voice" then
   exports['pma-voice']:setCallChannel(Channel)
  end
end

function FirstName()
  if Framework == "qb-core" then
    return QBCore.Functions.GetPlayerData().charinfo.firstname
  elseif Framework == "esx" then
    return ESX.PlayerData.firstName
  end
end

function LastName()
  if Framework == "qb-core" then
    return QBCore.Functions.GetPlayerData().charinfo.lastname
  elseif Framework == "esx" then
    return ESX.PlayerData.lastName
  end
end

function OpenInventory(data)
  if Inventory == "qb-inventory" then
    TriggerServerEvent("burgershot:server:CreateStash", data)
  elseif Inventory == "ps-inventory" then
    TriggerServerEvent("burgershot:server:CreateStash", data)
  elseif Inventory == "ox_inventory" then
    return exports.ox_inventory:openInventory('stash', data.stash)
  elseif Inventory == "ak47_inventory" then
    return exports['ak47_inventory']:OpenInventory(data.stash)
  end
end

function OpenShop(data)
  if Inventory == "ox_inventory" then
    return exports.ox_inventory:openInventory('shop', { type = data.shop })
  end
end

function OpenStashPSInventory(data)
  if Inventory == "ps-inventory" then
    TriggerEvent('ps-inventory:client:SetCurrentStash', data.stash)
    TriggerServerEvent('ps-inventory:server:OpenInventory', 'stash', data.stash)
  end
end

function GetJobStatus(job)
  if Framework == "qb-core" then
    local data = QBCore.Functions.GetPlayerData()
    return data.job.name == job and data.job.onduty == true
  elseif Framework == "esx" then
    local data = ESX.GetPlayerData()
    return data.job and data.job.name == job
  end
  return false
end

function PlayerJobName()
  if Framework == "qb-core" then
    return PlayerData.job.name
  elseif Framework == "esx" then
    return ESX.PlayerData.job.name
  end
end

function IsBoss()
  if Framework == "qb-core" then
    return PlayerData.job.isboss
  elseif Framework == "esx" then
    return ESX.GetPlayerData().job.grade >= 0
  end
end

function OpenBossMenu()
  if Management == "qb-management" then
    return TriggerEvent('qb-bossmenu:client:OpenMenu')
  elseif Management == "qbx-management" then
    return exports.qbx_management:OpenBossMenu('job')
  elseif Management == "esx_society" then
    return TriggerEvent('esx_society:openBossMenu', 'burgershot', function(data, menu)
      menu.close()
    end, {wash = false})
  elseif Management == "ant-management" then
    return TriggerEvent('ant-bossmenu:client:openMenu')
  end
end

function GetMetaData(PlayerData, metadata)
  if Framework == "qb-core" then
    return PlayerData.metadata[metadata]
  elseif Framework == "esx" then
    return ESX.GetPlayerData().metadata['fishing']
  end
end

function GetLicense(PlayerData, license, cb)
  if Framework == "qb-core" then
    cb(PlayerData.metadata.licences[license] == true)
    return
  elseif Framework == "esx" then
    local target = GetPlayerServerId(PlayerId())
    ESX.TriggerServerCallback('esx_license:checkLicense', function(haslicense)
      cb(haslicense == true)
    end, target, license)
    return
  end
end

-- Exports
exports('GetPlayerData', GetPlayerData)
exports('FirstName', FirstName)
exports('LastName', LastName)
exports('OpenInventory', OpenInventory)
exports('OpenStashPSInventory', OpenStashPSInventory)
exports('GetJobStatus', GetJobStatus)
exports('PlayerJobName', PlayerJobName)
exports('IsBoss', IsBoss)
exports('OpenBossMenu', OpenBossMenu)
exports('Voice', Voice)
exports('GetLicense', GetLicense)
exports('OpenShop', OpenShop)
exports('GetMetaData', GetMetaData)
exports('CheckLevel', CheckLevel)