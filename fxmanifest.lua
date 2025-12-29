fx_version 'cerulean'
game 'gta5'
description 'ant-bridge'
version '1.0.3'
lua54 'yes'

shared_scripts {
    '@qb-core/shared/locale.lua',
    --'@es_extended/imports.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}

client_exports { 
    'GetPlayerData', 
    'Voice', 
    'FirstName', 
    'LastName', 
    'OpenInventory',
    'OpenStashPSInventory',
    'GetJobStatus',
    'PlayerJobName',
    'IsBoss',
    'OpenBossMenu',
}

server_exports {
    'RemoveItem',
    'AddItem',
    'ItemBox',
    'OpenStash',
    'PlayerSource',
    'GetAllPlayers',
    'PlayerFirstName',
    'PlayerLastName',
    'PlayerCID',
    'GetJobName',
    'GetDutyStatus',
    'GetPlayersCash',
    'GetPlayersBank',
    'RemoveCash',
    'RemoveBank',
    'AddCash',
    'AddCashDelivery',
    'GetItemName',
    'GetItemAmount',
    'AddFundstoSociety',
    'RemoveFundsFromSociety',
    'HasItem',
    'GetMetaData',
    'SetMetaData',
    'RegisterShop'
}