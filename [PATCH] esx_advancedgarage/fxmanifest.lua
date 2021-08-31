fx_version 'cerulean'
game 'gta5'

author 'HumanTree92 (Patched and Optimised by Alv#9999)'
description 'Regular Advanced Garage just had a commonly used Money Exploit patched and protected as well as optimisation for performance increase when using the garage.'
url 'https://github.com/HumanTree92 and https://alv.gg'

client_scripts {
	'@es_extended/locale.lua',
	"shared/*",
	"client/*",
}


server_scripts {
	'@es_extended/locale.lua',
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	"shared/*",
	"server/*",
}