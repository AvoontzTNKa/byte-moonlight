author 'Byte.py'
version '1.0'

fx_version "adamant"
lua54 'yes'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game "rdr3"

shared_scripts {
    'config.lua',
	
}

client_scripts {
	'client/client.lua',
	'@vorp_core/client/dataview.lua'
}

server_scripts {
	'server/server.lua'
}
