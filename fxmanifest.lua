game 		 'rdr3'
fx_version 	 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
author 	     'ALTITUDE-DEV.COM'
description  'infinitycore MultiCharacters fully sync with core and skins'
version 	 '1.0.0'
infinitycore_dev 	    'Shepard & iireddev'


ui_page "html/core.html"
files {
    'html/core.html',
    'html/core.js',
	'html/*.webp',
    'html/fonts/*.eot',
	'html/fonts/*.ttf',
	'html/fonts/*.woff',
	'html/fonts/*.woff2',
    'html/design/*.png',
    'html/design/*.jpg',
	'html/vendor/*.css',
    'html/design/*.wav',
    'html/core.css'
}

client_scripts {
	'clothes-skin.lua',
	'client.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua'
}