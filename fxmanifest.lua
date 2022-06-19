fx_version 'cerulean'
game 'gta5'

author 'dnelyK'
description 'QB-BankRobbery-Target'
version '1.0.0'

ui_page 'html/index.html'

shared_script 'config.lua'

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/fleeca.lua',
    'client/pacific.lua',
    'client/powerstation.lua',
    'client/doors.lua',
    'client/paleto.lua',
}

server_script 'server/main.lua'

files {
    'html/*',
}

lua54 'yes'


--- Dependencies

dependencies {
    'hacking', --- Renaming the script will cause issues.
    'PolyZone',
    -- 'mhacking', Only needed if the Config.TwoHack is enabled. 
}