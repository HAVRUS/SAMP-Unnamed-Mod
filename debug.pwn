/*
  _____  ______ ____  _    _  _____   __  __  ____  _____  ______
 |  __ \|  ____|  _ \| |  | |/ ____| |  \/  |/ __ \|  __ \|  ____|
 | |  | | |__  | |_) | |  | | |  __  | \  / | |  | | |  | | |__
 | |  | |  __| |  _ <| |  | | | |_ | | |\/| | |  | | |  | |  __|
 | |__| | |____| |_) | |__| | |__| | | |  | | |__| | |__| | |____
 |_____/|______|____/_\____/ \_____| |_|  |_|\____/|_____/|______|_____
 | |           |  _/ __ \| |/ /_  |   | |  | |     |  _|  __ \_  |  __ \
 | |__  _   _  | || |  | | ' /  | |   | |__| | __ _| | | |__) || | |  | |
 | '_ \| | | | | || |  | |  <   | |   |  __  |/ _` | | |  _  / | | |  | |
 | |_) | |_| | | || |__| | . \  | |   | |  | | (_| | | | | \ \ | | |__| |
 |_.__/ \__, | | |_\____/|_|\_\_| |   |_|  |_|\__,_| |_|_|  \_\| |_____/
         __/ | |___|          |___|_____           |___|     |___|
        |___/                    |______|

															Verison 1.1.2
													  		01.03.2017
*/

#include <a_samp>
#include <core>
#include <float>

#include <colors>
#include <strtok>

#pragma tabsize 0

// #define MAX_CHAT_MESSAGE 146

//======= КООРДИНАТЫ РАНДОМНОГО СПАВНА =========================================
new Float:gRandomSpawns[3][4] = {
{-1346.1572,491.9534,11.2027,1.4121},
{-1348.1433,495.3761,11.1953,182.3520},
{-1343.3337,496.5833,11.2027,84.9045}
};

//======= КООРДИНАТЫ РАНДОМНОГО СПАВНА DM & Derby ==============================
new Float:gRandomDM1Spawns[6][4] = {
{-2222.0735,403.9738,59.5489,268.6603},
{-2222.6123,379.8876,59.5489,268.1061},
{-2168.2883,381.4497,59.5489,271.7936},
{-2170.9783,412.5139,59.5489,171.5494},
{-2198.3745,429.8558,59.5489,0.7811},
{-2196.7351,380.5588,59.5489,271.7936}
};

new Float:gRandomDM2Spawns[6][4] = {
{-2222.0735,403.9738,59.5489,268.6603},
{-2222.6123,379.8876,59.5489,268.1061},
{-2168.2883,381.4497,59.5489,271.7936},
{-2170.9783,412.5139,59.5489,171.5494},
{-2198.3745,429.8558,59.5489,0.7811},
{-2196.7351,380.5588,59.5489,271.7936}
};

new Float:gRandomDM3Spawns[6][4] = {
{-2222.0735,403.9738,59.5489,268.6603},
{-2222.6123,379.8876,59.5489,268.1061},
{-2168.2883,381.4497,59.5489,271.7936},
{-2170.9783,412.5139,59.5489,171.5494},
{-2198.3745,429.8558,59.5489,0.7811},
{-2196.7351,380.5588,59.5489,271.7936}
};

new Float:gRandomDM4Spawns[4][4] = {
{-1423.7616,937.0624,1036.5115,359.2050},
{-1279.7686,993.0848,1037.2025,90.0725},
{-1404.4294,1058.5273,1038.5120,181.7978},
{-1517.5829,993.0541,1037.6272,269.2186}
};

//======= СЧЕТЧИК ТРАНСПОРТА ===================================================
new CreatedCars[100];
new CreatedCar = 0;

//======= ТЕКСТДРАВЫ ===========================================================
new Text:txtModeName;
new Text:txtPlayerCoord;

//======= ФОРВАРДЫ =============================================================
forward UpdateCoords();
forward SpawnCars();
forward pRandomSpawns(playerid); // Main random spawns
forward pRandomDM1Spawns(playerid); // DM1 random spawns
forward pRandomDM2Spawns(playerid); // DM2 random spawns
forward pRandomDM3Spawns(playerid); // DM3 random spawns
forward pRandomDM4Spawns(playerid); // Derby random spawns

new Float:x_c,Float:y_c,Float:z_c;
new bool:ShowPlayerCoord[MAX_PLAYERS] = true;
new PlayerDMZone[MAX_PLAYERS] = 0;
new coordsstr[32];

new	DerbyCars[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9};

main()
{
	print("\n- - - - - - - - - - - - - - - - - - - -");
	print("  Debug Mode v1.1 -Initializated- \n");
	print("  Created by HAVRUS aka [OK]_Ha[R]D \n");
	print("- - - - - - - - - - - - - - - - - - - -\n");
}

public OnPlayerConnect(playerid)
{
	SendClientMessage(playerid, COLOR_YELLOWGREEN, "Успешное подключение к отладочному серверу.");
	SetPlayerMapIcon(playerid, 1, -1375.2230, 469.6149, 7.1875, 8, 0, MAPICON_LOCAL);
	PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
//======= СООБЩЕНИЕ ПРИ ПОДКЛЮЧЕНИИ ИГРОКА  ====================================
	new message[146];
    format(message, sizeof(message), "Игрок %s [%s] подключился к серверу.", GetName(playerid), GetIp(playerid));
    SendClientMessageToAll(COLOR_YELLOWGREEN, message);
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new cmd[256];
	new idx;
	cmd = strtok(cmdtext, idx);
	
//======= HELP =================================================================
	if(strcmp(cmd, "/help", true ) == 0 )
	{
	SendClientMessage(playerid, COLOR_RED, "Команды отладочного сервера:");
	SendClientMessage(playerid, COLOR_ORANGE, "/admins - администраторы в сети");
	SendClientMessage(playerid, COLOR_ORANGE, "/veh - заспавнить транспорт");
	SendClientMessage(playerid, COLOR_ORANGE, "/dveh - удалить транспорт");
	SendClientMessage(playerid, COLOR_ORANGE, "/sveh - респавн транспорта");
	SendClientMessage(playerid, COLOR_ORANGE, "/weap - выдать оружие");
	SendClientMessage(playerid, COLOR_ORANGE, "/goto - телепортироваться к игроку");
	SendClientMessage(playerid, COLOR_ORANGE, "/teleport - открыть меню телепорта");
	SendClientMessage(playerid, COLOR_ORANGE, "/gethere - телепортировать игрока к себе");
	SendClientMessage(playerid, COLOR_ORANGE, "/gotocar - телепортироваться к транспорту");
	SendClientMessage(playerid, COLOR_ORANGE, "/cchat - очистить чат");
	SendClientMessage(playerid, COLOR_ORANGE, "/pkill - убить игрока");
	SendClientMessage(playerid, COLOR_ORANGE, "/coords - включить отображение координат");
	SendClientMessage(playerid, COLOR_ORANGE, "/setweather - установить погоду");
	return 1;
	}
	
//======= VEH ==================================================================
	if(strcmp(cmd, "/veh", true) == 0)
 	{
 	if(IsPlayerConnected(playerid))
 	{
 	if (!IsPlayerAdmin(playerid))
 	{
 	SendClientMessage(playerid, COLOR_RED, "Ошибка: Недостаточно прав доступа."); // Администратор?
 	return 1;
 	}
	new tmp[256];
 	tmp = strtok(cmdtext, idx);
 	if(!strlen(tmp))
 	{
 	SendClientMessage(playerid, COLOR_YELLOW, "Использование: /veh [id транспорта] [цвет 1] [цвет 2].");
 	return 1;
 	}
 	new car;
 	car = strval(tmp);
 	if(car < 400 || car > 611) { SendClientMessage(playerid, COLOR_RED, "Ошибка: Неверный ID транспорта. Используйте значение от 400 до 611."); return 1; }
	tmp = strtok(cmdtext, idx);
 	new color1;
 	color1 = strval(tmp);
 	if(color1 < 0 || color1 > 255) { SendClientMessage(playerid, COLOR_RED, "Ошибка: Неверный цвет транспорта. Используйте значение от 0 до 255."); return 1; }
 	tmp = strtok(cmdtext, idx);
 	new color2;
 	color2 = strval(tmp);
 	if(color2 < 0 || color2 > 255) { SendClientMessage(playerid, COLOR_RED, "Ошибка: Неверный цвет транспорта. Используйте значение от 0 до 255."); return 1; }
	if(!strlen(tmp)) { color1 = random(255); color2 = random(255); }
	new Float:X,Float:Y,Float:Z;
 	GetPlayerPos(playerid, X,Y,Z);
 	new carid;
 	carid = CreateVehicle(car, X,Y,Z, 0.0, color1, color2, -1);
 	CreatedCars[CreatedCar] = carid;
 	CreatedCar ++;
 	LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
	new message1[146];
 	format(message1, sizeof(message1), "Транспорт создан: ID %d Порядковый номер %d.", car, carid);
 	SendClientMessage(playerid, COLOR_YELLOW, message1);
	new message2[146];
 	format(message2, sizeof(message2), "Администратор %s создал транспорт: ID %d Порядковый номер %d.", GetName(playerid), car, carid);
 	SendClientMessageToAll(COLOR_RED, message2);
 	}
 	return 1;
 	}
 	
//======= DVEH =================================================================
 	if(strcmp(cmd, "/dveh", true) == 0)
	{
	if(IsPlayerConnected(playerid))
	{
	if(!IsPlayerAdmin(playerid))
	{
	SendClientMessage(playerid, COLOR_RED, "Ошибка: Недостаточно прав доступа."); // Администратор?
	return 1;
	}
	new tmp[256];
 	tmp = strtok(cmdtext, idx);
 	if(!strlen(tmp))
 	{
 	SendClientMessage(playerid, COLOR_YELLOW, "Использование: /dveh [порядковый номер транспорта].");
 	return 1;
 	}
	new dvehnum;
	dvehnum = strval(tmp);
	new dvehid;
	dvehid = GetVehicleModel(strval(tmp));
    if(dvehid == 0) { SendClientMessage(playerid, COLOR_RED, "Ошибка: Неверный порядковый номер транспорта."); return 1; }
	SendClientMessage(playerid, COLOR_YELLOW, "Транспорт удален.");
	new message[146];
 	format(message, sizeof(message), "Администратор %s уничтожил транспорт: ID %d Порядковый номер %d.", GetName(playerid), dvehid, dvehnum);
 	SendClientMessageToAll(COLOR_RED, message);
  	DestroyVehicle(strval(tmp));
	}
	return 1;
	}
	
//======= SVEH =================================================================
	if(strcmp(cmd, "/sveh", true ) == 0 )
	{
	if(IsPlayerConnected(playerid))
	{
	if(!IsPlayerAdmin(playerid))
	{
	SendClientMessage(playerid, COLOR_RED, "Ошибка: Недостаточно прав доступа."); // Администратор?
	return 1;
	}
	SendClientMessage(playerid, COLOR_YELLOW, "Транспорт зареспавнен.");
	for(new i = 0; i < sizeof(CreatedCars); i++)
	{
 	if(i != 0)
 	{
 	DestroyVehicle(i);
 	}
 	}
	SpawnCars();
	new message[146];
 	format(message, sizeof(message), "Администратор %s зареспавнил весь транспорт.", GetName(playerid));
 	SendClientMessageToAll(COLOR_RED, message);
 	}
	return 1;
 	}
 	
//======= WEAP =================================================================
	if(strcmp(cmd, "/weap", true) == 0)
 	{
 	if(IsPlayerConnected(playerid))
 	{
 	if (!IsPlayerAdmin(playerid))
 	{
 	SendClientMessage(playerid, COLOR_RED, "Ошибка: Недостаточно прав доступа."); // Администратор?
 	return 1;
 	}
	new tmp[256];
 	tmp = strtok(cmdtext, idx);
 	if(!strlen(tmp))
 	{
 	SendClientMessage(playerid, COLOR_YELLOW, "Использование: /weap [id оружия] [патроны].");
 	return 1;
 	}
 	new weaponid;
 	weaponid = strval(tmp);
 	if(weaponid < 0 || weaponid > 46) { SendClientMessage(playerid, COLOR_RED, "Ошибка: Неверный ID оружия. Используйте значение от 0 до 46."); return 1; }
	tmp = strtok(cmdtext, idx);
 	if(!strlen(tmp))
 	{
 	new ammo;
 	ammo = 1;
 	GivePlayerWeapon(playerid, weaponid, ammo);
	new message1[146];
 	format(message1, sizeof(message1), "Оружие выдано: ID %d Патроны %d.", weaponid, ammo);
 	SendClientMessage(playerid, COLOR_YELLOW, message1);
 	return 1;
 	} else {
 	new ammo;
 	ammo = strval(tmp);
 	if(ammo < 0 || ammo > 9999) { SendClientMessage(playerid, COLOR_RED, "Ошибка: Неверное количество патронов. Используйте значение от 0 до 9999."); return 1; }
 	tmp = strtok(cmdtext, idx);
 	GivePlayerWeapon(playerid, weaponid, ammo);
	new message2[128];
 	format(message2, sizeof(message2), "Оружие выдано: ID %d Патроны %d.", weaponid, ammo);
 	SendClientMessage(playerid, COLOR_YELLOW, message2);
 	}
 	}
 	return 1;
 	}
 	
//======= GOTO =================================================================
 	if (!strcmp(cmd, "/goto", true))
    {
    if(!IsPlayerAdmin(playerid))
	{
	SendClientMessage(playerid, COLOR_RED, "Ошибка: Недостаточно прав доступа."); // Администратор?
	return 1;
	}
	new tmp[256];
    tmp = strtok(cmdtext, idx);
    if (!strlen(tmp)) return SendClientMessage(playerid, COLOR_YELLOW, "Использование: /goto [id игрока].");
    new giveplayerid;
    giveplayerid = strval(tmp);
    if (!IsPlayerConnected(giveplayerid)) return SendClientMessage(playerid, COLOR_RED, "Ошибка: Игрок не найден.");
    new Float:x, Float:y, Float:z;
    GetPlayerPos(giveplayerid, x, y, z);
    SetPlayerInterior(playerid, GetPlayerInterior(giveplayerid));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(giveplayerid));
    SendClientMessage(playerid, COLOR_YELLOW, "Вы были успешно телепортированы.");
    if (IsPlayerInAnyVehicle(playerid))
    {
 	LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(giveplayerid));
    SetVehiclePos(GetPlayerVehicleID(playerid), x+1,y+1,z);
    return true;
    }
    SetPlayerPos(playerid, x+1, y+1, z);
    return true;
    }
    
//======= GOTOCAR ==============================================================
	if (!strcmp(cmd, "/gotocar", true))
    {
    if(!IsPlayerAdmin(playerid))
	{
	SendClientMessage(playerid, COLOR_RED, "Ошибка: Недостаточно прав доступа."); // Администратор?
	return 1;
	}
	new tmp[256];
    tmp = strtok(cmdtext, idx);
    if (!strlen(tmp)) return SendClientMessage(playerid, COLOR_YELLOW, "Использование: /gotocar [порядковый номер].");
    new gid = strval(tmp);
    new Float:x, Float:y, Float:z;
    GetVehiclePos(gid, x, y, z);
    if (x == 0.0 && y == 0.0 && z == 0.0) return SendClientMessage(playerid, COLOR_RED, "Ошибка: Неверный порядковый номер транспорта.");
    SetPlayerVirtualWorld(playerid, GetVehicleVirtualWorld(gid));
    SendClientMessage(playerid, COLOR_YELLOW, "Вы были успешно телепортированы.");
    /*new carinterior;
 	carinterior =  GetVehicleInterior(gid);
 	SetPlayerInterior(playerid, carinterior);*/
    if (IsPlayerInAnyVehicle(playerid))
    {
    SetVehiclePos(GetPlayerVehicleID(playerid), x+1,y+1,z);
    return true;
    }
    SetPlayerPos(playerid, x+1, y+1, z);
    return true;
    }
    
//======= GETHERE ==============================================================
    if (!strcmp(cmd, "/gethere", true))
    {
    if(!IsPlayerAdmin(playerid))
	{
	SendClientMessage(playerid, COLOR_RED, "Ошибка: Недостаточно прав доступа."); // Администратор?
	return 1;
	}
	new tmp[256];
    tmp = strtok(cmdtext, idx);
    if (!strlen(tmp)) return SendClientMessage(playerid, COLOR_YELLOW, "Использование: /gethere [id игрока].");
    new gid = strval(tmp);
    if (!IsPlayerConnected(gid)) return SendClientMessage(playerid, COLOR_RED, "Ошибка: Игрок не найден.");
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
	new message1[146];
 	format(message1, sizeof(message1), "Игрок %s успешно телепортирован.", GetName(gid));
    SendClientMessage(playerid, COLOR_YELLOW, message1);
	new message2[146];
 	format(message2, sizeof(message2), "Вы были телепортированы администратором %s.", GetName(playerid));
 	SendClientMessage(gid, COLOR_RED, message2);
    if (IsPlayerInAnyVehicle(gid))
    {
 	LinkVehicleToInterior(GetPlayerVehicleID(gid), GetPlayerInterior(playerid));
    SetVehiclePos(GetPlayerVehicleID(gid), x+1,y+1,z);
    return true;
    }
    SetPlayerPos(gid, x+1, y+1, z);
    SetPlayerInterior(gid, GetPlayerInterior(playerid));
    SetPlayerVirtualWorld(gid, GetPlayerVirtualWorld(playerid));
    return true;
    }
    
//======= TELEPORT =============================================================
    if (!strcmp(cmd, "/teleport", true))
    {
    if(!IsPlayerAdmin(playerid))
	{
	SendClientMessage(playerid, COLOR_RED, "Ошибка: Недостаточно прав доступа."); // Администратор?
	return 1;
	}
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_LIST, "Телепортироваться", "База\nЦентр San Fierro\nЦентр Los Santos\nЦентр Las Venturas", "Ок", "Выход");
    return true;
    }
    
//======= COORDS ===============================================================
    if (!strcmp(cmd, "/coords", true))
    {
    if(!IsPlayerAdmin(playerid))
	{
	SendClientMessage(playerid, COLOR_RED, "Ошибка: Недостаточно прав доступа."); // Администратор?
	return 1;
	}
	if(ShowPlayerCoord[playerid] == true)
 	{
 	ShowPlayerCoord[playerid] = false;
 	TextDrawHideForPlayer(playerid, txtPlayerCoord);
  	SendClientMessage(playerid, COLOR_RED,"<< Отображение координат отключено");
   	}
    else if(ShowPlayerCoord[playerid] == false)
    {
    ShowPlayerCoord[playerid] = true;
    TextDrawShowForPlayer(playerid, txtPlayerCoord);
    SendClientMessage(playerid, COLOR_RED,">> Отображение координат включено");
    }
    return true;
    }
    
//======= DMZONE ===============================================================
    if (!strcmp(cmd, "/dmzone", true))
    {
	if(PlayerDMZone[playerid] != 0)
 	{
 	PlayerDMZone[playerid] = 0;
	pRandomSpawns(playerid); // Паблик на рандомный спавн
  	SendClientMessage(playerid, COLOR_LIME, "Вы покинули зону DM.");
	new message[146];
    format(message, sizeof(message), "Игрок %s покинул зону DM.", GetName(playerid));
	SendClientMessageToAll(COLOR_LIME, message);
	PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
   	}
    else if (PlayerDMZone[playerid] == 0)
    {
	ShowPlayerDialog(playerid, 2, DIALOG_STYLE_LIST, "Выбрать DM-зону", "DM 1\nDM 2\nDM 3\nDerby", "Ок", "Выход");
    }
    return true;
    }
    
//======= ADMINS ===============================================================
    if(!strcmp(cmdtext, "/admins", true))
	{
	if(!IsPlayerAdmin(playerid))
	{
	SendClientMessage(playerid, COLOR_RED, "Ошибка: Недостаточно прав доступа."); // Администратор?
	return 1;
	}
	SendClientMessage(playerid, COLOR_ORANGE, "Aдминистраторы онлайн:");
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	if(IsPlayerConnected(i))
	{
	if(IsPlayerAdmin(i))
	{
	new message[146];
	format(message, sizeof(message), "Никнейм: %s | ID: %d | IP: %s", GetName(i), i, GetIp(i));
	SendClientMessage(playerid, COLOR_GREENYELLOW, message);
 	}
 	}
	}
	return 1;
	}
	
//======= CCHAT ================================================================
	if(!strcmp(cmdtext,"/cchat", true))
    {
    if(IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_RED, "Ошибка: Недостаточно прав доступа."); // Администратор?
   	{
    for(new i=0; i<105; i++)
    {
    SendClientMessageToAll(COLOR_BLACK, " ");
    }
    SendClientMessageToAll(COLOR_BLACK, " ");
    }
    return 1;
    }
    
//======= PKILL ================================================================
    if (!strcmp(cmd, "/pkill", true))
    {
    if(!IsPlayerAdmin(playerid))
	{
	SendClientMessage(playerid, COLOR_RED, "Ошибка: Недостаточно прав доступа."); // Администратор?
	return 1;
	}
	new tmp[256];
    tmp = strtok(cmdtext, idx);
    if (!strlen(tmp)) return SendClientMessage(playerid, COLOR_YELLOW, "Использование: /pkill [id игрока].");
    new gid = strval(tmp);
    if (!IsPlayerConnected(gid)) return SendClientMessage(playerid, COLOR_RED, "Ошибка: Игрок не найден.");
	new message1[146];
 	format(message1, sizeof(message1), "Игрок %s был убит.", GetName(gid));
    SendClientMessage(playerid, COLOR_YELLOW, message1);
    new message2[146];
 	format(message2, sizeof(message2), "Вы были убиты администратором %s.", GetName(playerid));
 	SendClientMessage(gid, COLOR_RED, message2);
    if (IsPlayerInAnyVehicle(gid))
    {
    SetVehicleHealth(GetPlayerVehicleID(gid), 0);
    SetPlayerArmour(gid, 0);
    SetPlayerHealth(gid, 0);
    return true;
    }
    SetPlayerArmour(gid, 0);
    SetPlayerHealth(gid, 0);
    return true;
    }
    
//======= SETWEATHER ===========================================================
	if(strcmp(cmd, "/setweather", true) == 0)
 	{
 	if (!IsPlayerAdmin(playerid))
 	{
 	SendClientMessage(playerid, COLOR_RED, "Ошибка: Недостаточно прав доступа."); // Администратор?
 	return 1;
 	}
	new tmp[256];
 	tmp = strtok(cmdtext, idx);
 	if(!strlen(tmp))
 	{
 	SendClientMessage(playerid, COLOR_YELLOW, "Использование: /setweather [ид погоды]");
 	return 1;
 	}
 	new wid;
 	wid = strval(tmp);
 	if(wid < 0 || wid > 1337) { SendClientMessage(playerid, COLOR_RED, "Ошибка: Неверный ID погоды. Используйте значение от 0 до 1337."); return 1; }
	SetWeather(wid);
	new message1[146];
 	format(message1, sizeof(message1), "Погода изменена: ID %d.", wid);
 	SendClientMessage(playerid, COLOR_YELLOW, message1);
	new message2[146];
 	format(message2, sizeof(message2), "Администратор %s изменил погоду: ID %d.", GetName(playerid), wid);
 	SendClientMessageToAll(COLOR_RED, message2);
 	return 1;
 	}
 	
	return SendClientMessage(playerid, COLOR_RED,"Ошибка: Неизвестная команда.");
}

public OnPlayerSpawn(playerid)
{
	if(PlayerDMZone[playerid] == 0)
 	{
    pRandomSpawns(playerid); // Паблик на рандомный спавн
 	}
	else if(PlayerDMZone[playerid] == 1)
	{
	pRandomDM1Spawns(playerid);
 	}
 	else if(PlayerDMZone[playerid] == 2)
 	{
	pRandomDM2Spawns(playerid);
	}
    else if(PlayerDMZone[playerid] == 3)
 	{
	pRandomDM3Spawns(playerid);
	}
	else if(PlayerDMZone[playerid] == 4)
 	{
	pRandomDM4Spawns(playerid);
	}

	SetPlayerArmour(playerid, 100);
	TogglePlayerClock(playerid, 0);
	PlayerPlaySound(playerid, 0, 0, 0, 0);
	
 	TextDrawShowForPlayer(playerid, txtModeName);
 	if(ShowPlayerCoord[playerid] == true) { TextDrawShowForPlayer(playerid, txtPlayerCoord); }
 	
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    TextDrawHideForPlayer(playerid, txtModeName);
    TextDrawHideForPlayer(playerid, txtPlayerCoord);
    PlayerPlaySound(playerid, 45249, 0, 0, 0);
   	return 1;
}

SetupPlayerForClassSelection(playerid)
{
 	SetPlayerInterior(playerid,0);
	SetPlayerPos(playerid,-1685.6783,710.2925,30.6016);
	SetPlayerFacingAngle(playerid, 225.0);
	SetPlayerCameraPos(playerid,-1680.5488,706.2623,30.6016);
	SetPlayerCameraLookAt(playerid,-1685.6783,710.2925,30.6016);
}

public OnPlayerRequestClass(playerid, classid)
{
	SetupPlayerForClassSelection(playerid);
	return 1;
}

public OnGameModeInit()
{
	SetGameModeText("Bebug Mode");
	ShowPlayerMarkers(1);
	ShowNameTags(1);
	
	UpdateCoords();
	SetTimer("UpdateCoords", 250, 1);
	SpawnCars();
	
//======= НАЗВАНИЕ МОДА ========================================================
	txtModeName = TextDrawCreate(610.0, 58.0, "BEBUG MODE");
	TextDrawUseBox(txtModeName, 0);
	TextDrawFont(txtModeName, 3);
	TextDrawSetShadow(txtModeName, 0);
    TextDrawSetOutline(txtModeName, 2);
    TextDrawBackgroundColor(txtModeName, 0x000000FF);
    TextDrawColor(txtModeName, COLOR_LIGHTBLUE);
    TextDrawAlignment(txtModeName, 3);
	TextDrawLetterSize(txtModeName, 0.30,0.5);
	
//======= КООРДИНАТЫ ===========================================================
	txtPlayerCoord = TextDrawCreate(88.5, 430.0, "0.0 0.0 0.0");
	TextDrawUseBox(txtPlayerCoord, 0);
	TextDrawFont(txtPlayerCoord, 3);
	TextDrawSetShadow(txtPlayerCoord, 0);
    TextDrawSetOutline(txtPlayerCoord, 1); // 2
    TextDrawBackgroundColor(txtPlayerCoord, COLOR_BLACK);
    TextDrawColor(txtPlayerCoord, COLOR_LIME);
    TextDrawAlignment(txtPlayerCoord, 2); // 3
    TextDrawSetProportional(txtPlayerCoord, 1);
	TextDrawLetterSize(txtPlayerCoord, 0.3, 0.75);
	
//======= КЛАССЫ ===============================================================
	AddPlayerClass(50,-1.0,-1.0,-1.0,180.0,24,400,25,400,31,9000);
	AddPlayerClass(98,-1.0,-1.0,-1.0,180.0,24,400,25,400,31,9000);
	AddPlayerClass(283,-1.0,-1.0,-1.0,180.0,24,400,25,400,31,9000);
	AddPlayerClass(287,-1.0,-1.0,-1.0,180.0,24,400,25,400,31,9000);
	AddPlayerClass(165,-1.0,-1.0,-1.0,180.0,24,400,25,400,31,9000);
	
//====== ОБЪЕКТЫ ===============================================================
	CreateObject(5130,-1335.0000000,478.7999900,8.3000000,0.0000000,0.0000000,224.0000000); // Лестница СФа
	CreateObject(1473,-1334.0000000,485.6000100,10.7000000,0.0000000,0.0000000,178.7500000); // Маленькая лестница СФа
	CreateObject(1473,-1335.6000000,485.7000100,10.7000000,0.0000000,0.0000000,178.7480000); // Маленькая лестница СФа
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	new message[146];
    switch(reason)
    {
    case 0: format(message, sizeof(message), "Игрок %s покинул сервер (Соединение потеряно).", GetName(playerid));
    case 1: format(message, sizeof(message), "Игрок %s покинул сервер (Покинул игру).", GetName(playerid));
    case 2: format(message, sizeof(message), "Игрок %s покинул сервер (Принудительно удален).", GetName(playerid));
    }
    SendClientMessageToAll(COLOR_YELLOWGREEN, message);
    PlayerDMZone[playerid] = 0;
    return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
    if(!success) // If the password was incorrect
    {
        printf("### FAILED RCON LOGIN BY IP %s USING PASSWORD %s", ip, password);
    }
    return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ) // Телепортация для администрации
{
    if(IsPlayerAdmin(playerid))
    {
    SetPlayerPosFindZ(playerid, fX, fY, fZ);
    SendClientMessage(playerid, COLOR_YELLOW, "Вы были успешно телепортированы.");
    return 1;
    }
    return 1;
}

public OnPlayerText(playerid, text[])
{
    SetPlayerChatBubble(playerid, text, COLOR_CYAN, 100.0, 10000);
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(response)// They pressed the first button.
    {
    switch(dialogid)// If you only have one dialog, then this isn't required, but it's neater for when you implement more dialogs.
    {
	case 1:// TeleportMenu
 	{
	switch(listitem)
	{
 	case 0:// База
 	{
 	SendClientMessage(playerid, COLOR_YELLOW, "Вы были успешно телепортированы.");
 	SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
 	if (IsPlayerInAnyVehicle(playerid))
    {
    SetVehiclePos(GetPlayerVehicleID(playerid), -1375.2230,469.6149,7.1875);
    return true;
    }
    SetPlayerPos(playerid, -1375.2230,469.6149,7.1875);
    return true;
 	}
 	case 1: // ЛС
 	{
  	SendClientMessage(playerid, COLOR_YELLOW, "Вы были успешно телепортированы.");
 	SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
   	if (IsPlayerInAnyVehicle(playerid))
    {
    SetVehiclePos(GetPlayerVehicleID(playerid), -1758.0570,908.4375,24.8906);
    return true;
    }
    SetPlayerPos(playerid, 1475.2207,-1713.8995,14.0469);
    return true;
 	}
 	case 2: // СФ
 	{
 	SendClientMessage(playerid, COLOR_YELLOW, "Вы были успешно телепортированы.");
 	SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
 	if (IsPlayerInAnyVehicle(playerid))
    {
    SetVehiclePos(GetPlayerVehicleID(playerid), 1475.2207,-1713.8995,14.0469);
    return true;
    }
    SetPlayerPos(playerid, -1758.0570,908.4375,24.8906);
    return true;
 	}
 	case 3: // ЛВ
 	{
 	SendClientMessage(playerid, COLOR_YELLOW, "Вы были успешно телепортированы.");
 	SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
 	if (IsPlayerInAnyVehicle(playerid))
    {
    SetVehiclePos(GetPlayerVehicleID(playerid), 1842.9346,1879.2367,10.8203);
    return true;
    }
    SetPlayerPos(playerid, 1842.9346,1879.2367,10.8203);
    return true;
 	}
	}
 	}
 	case 2:// DMZoneMenu
 	{
	switch(listitem)
	{
 	case 0:// DM 1
 	{
 	if (IsPlayerInAnyVehicle(playerid))
    {
    SendClientMessage(playerid, COLOR_RED, "Ошибка: Вы должны покинуть транспорт прежде чем телепортироваться в DM зону.");
    return false;
    }
	pRandomDM1Spawns(playerid);

 	SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    
    SendClientMessage(playerid, COLOR_LIME, "Вы были телепортированы в DM зону 1.");
   	PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
   	PlayerDMZone[playerid] = 1;
    
	new message[146];
    format(message, sizeof(message), "Игрок %s зашел в DM зону 1.", GetName(playerid));
	SendClientMessageToAll(COLOR_LIME, message);
	PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
    return true;
 	}
 	case 1: // DM 2
 	{
   	if (IsPlayerInAnyVehicle(playerid))
    {
    SendClientMessage(playerid, COLOR_RED, "Ошибка: Вы должны покинуть транспорт прежде чем телепортироваться в DM зону.");
    return false;
    }
    pRandomDM2Spawns(playerid);

 	SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);

    SendClientMessage(playerid, COLOR_LIME, "Вы были телепортированы в DM зону 2.");
   	PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
   	PlayerDMZone[playerid] = 2;
   	
	new message[146];
    format(message, sizeof(message), "Игрок %s зашел в DM зону 2.", GetName(playerid));
	SendClientMessageToAll(COLOR_LIME, message);
	PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
    return true;
 	}
 	case 2: // DM 3
 	{
 	if (IsPlayerInAnyVehicle(playerid))
    {
    SendClientMessage(playerid, COLOR_RED, "Ошибка: Вы должны покинуть транспорт прежде чем телепортироваться в DM зону.");
    return false;
    }
    pRandomDM3Spawns(playerid);

 	SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);

    SendClientMessage(playerid, COLOR_LIME, "Вы были телепортированы в DM зону 3.");
   	PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
   	PlayerDMZone[playerid] = 3;

	new message[146];
    format(message, sizeof(message), "Игрок %s зашел в DM зону 3.", GetName(playerid));
	SendClientMessageToAll(COLOR_LIME, message);
	PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
    return true;
 	}
 	case 3: // Derby
 	{
 	if (IsPlayerInAnyVehicle(playerid))
    {
    SendClientMessage(playerid, COLOR_RED, "Ошибка: Вы должны покинуть транспорт прежде чем телепортироваться в DM зону.");
    return false;
    }
	pRandomDM4Spawns(playerid);

 	SetPlayerInterior(playerid, 15);
    SetPlayerVirtualWorld(playerid, 0);

    SendClientMessage(playerid, COLOR_LIME, "Вы были телепортированы в Derby зону.");
   	PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
   	PlayerDMZone[playerid] = 4;
   	
	new message[146];
    format(message, sizeof(message), "Игрок %s зашел в Derby зону.", GetName(playerid));
	SendClientMessageToAll(COLOR_LIME, message);
	PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
    return true;
 	}
	}
 	}
	}
    }
    return 1;
}

public UpdateCoords()
{
    format(coordsstr, 32, "%.4f %.4f %.4f", x_c, y_c, z_c);
   	TextDrawSetString(txtPlayerCoord, coordsstr);
   	
	new x = 0;
	while(x != MAX_PLAYERS) {
 	if(IsPlayerConnected(x) && GetPlayerState(x) != PLAYER_STATE_NONE) {
  	GetPlayerPos(x, x_c, y_c, z_c);
 	}
 	x++;
	}
}

public pRandomSpawns(playerid)
{
    new randSpawn = 0;
	randSpawn = random(sizeof(gRandomSpawns));
	SetPlayerPos(playerid,
	gRandomSpawns[randSpawn][0],
 	gRandomSpawns[randSpawn][1],
 	gRandomSpawns[randSpawn][2]);
  	SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    return 1;
}

public pRandomDM1Spawns(playerid)
{
    new randSpawn = 0;
	randSpawn = random(sizeof(gRandomDM1Spawns));
	SetPlayerPos(playerid,
	gRandomDM1Spawns[randSpawn][0],
 	gRandomDM1Spawns[randSpawn][1],
 	gRandomDM1Spawns[randSpawn][2]);
 	SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    return 1;
}

public pRandomDM2Spawns(playerid)
{
    new randSpawn = 0;
	randSpawn = random(sizeof(gRandomDM2Spawns));
	SetPlayerPos(playerid,
	gRandomDM2Spawns[randSpawn][0],
 	gRandomDM2Spawns[randSpawn][1],
 	gRandomDM2Spawns[randSpawn][2]);
 	SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    return 1;
}

stock pRandomDM3Spawns(playerid)
{
    new randSpawn = 0;
	randSpawn = random(sizeof(gRandomDM3Spawns));
	SetPlayerPos(playerid,
	gRandomDM3Spawns[randSpawn][0],
 	gRandomDM3Spawns[randSpawn][1],
 	gRandomDM3Spawns[randSpawn][2]);
 	SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    return 1;
}

stock pRandomDM4Spawns(playerid)
{
    new randSpawn = 0;
	randSpawn = random(sizeof(gRandomDM4Spawns));
	SetPlayerPos(playerid,
	gRandomDM4Spawns[randSpawn][0],
 	gRandomDM4Spawns[randSpawn][1],
 	gRandomDM4Spawns[randSpawn][2]);
	SetPlayerInterior(playerid, 15);
    SetPlayerVirtualWorld(playerid, 0);
    return 1;
}

public SpawnCars()
{
	AddStaticVehicle(451,-1340.9086,457.3939,6.8187,358.5780,1,1); // Turismo 1
	AddStaticVehicle(451,-1344.5133,457.5636,6.8932,358.2500,1,1); // Turismo 2
	AddStaticVehicle(411,-1350.1667,457.5306,6.9146,357.6700,1,1); // Infernus 1
	AddStaticVehicle(411,-1354.3356,457.6202,6.9151,1.0844,1,1); // Infernus 2
	AddStaticVehicle(445,-1353.1708,479.3681,7.0625,88.6330,0,0); // Admiral
	AddStaticVehicle(444,-1368.5890,457.3441,7.5588,359.2426,226,0); // Monster
	AddStaticVehicle(447,-1316.4822,455.9489,7.2074,358.3059,75,2); // Seasparrow 1
	AddStaticVehicle(447,-1301.1796,456.0289,7.1992,1.5554,75,2); // Seasparrow 2
	AddStaticVehicle(548,-1285.9926,464.4137,8.6503,359.5496,1,1); // Cargobob
	AddStaticVehicle(425,-1258.2750,464.2839,7.7596,359.8394,43,0); // Hunter
	AddStaticVehicle(432,-1328.3701,447.1666,7.1967,0.1052,43,0); // Rhino
	AddStaticVehicle(470,-1377.4814,458.0373,7.1803,0.4618,43,0); // Patriot
	AddStaticVehicle(473,-1442.6882,510.1674,-0.1446,87.3840,56,15); // Dinghy 1
	AddStaticVehicle(473,-1443.5745,505.3749,-0.3308,91.1688,56,53); // Dinghy 2
	AddStaticVehicle(493,-1449.7620,493.8090,-0.1079,83.7491,226,226); // Jetmax
	AddStaticVehicle(520,-1409.8171,507.2363,18.9576,272.4965,0,0); // Hydra 1
	AddStaticVehicle(520,-1431.1278,507.3575,18.9526,274.9324,0,0); // Hydra 2
	AddStaticVehicle(568,-1314.1091,497.3550,18.1015,179.5953,9,39); // Bandito 1
	AddStaticVehicle(568,-1302.2755,497.7377,18.1008,180.9258,17,1); // Bandito 2

	DerbyCars[1] = AddStaticVehicle(451,-1313.3064,1003.9921,1027.5563,97.3970,-1,-1);
	DerbyCars[2] = AddStaticVehicle(411,-1333.0474,1026.9446,1028.2338,140.2358,-1,-1);
	DerbyCars[3] = AddStaticVehicle(412,-1320.7739,1018.7410,1028.3563,129.9826,-1,-1);
	DerbyCars[4] = AddStaticVehicle(412,-1314.8608,988.7519,1027.0718,88.0251,-1,-1);
	DerbyCars[5] = AddStaticVehicle(440,-1321.6875,973.4872,1027.6084,57.6617,-1,-1);
	DerbyCars[6] = AddStaticVehicle(442,-1335.6788,964.9116,1026.8518,34.2981,-1,-1);
	DerbyCars[7] = AddStaticVehicle(400,-1353.4608,957.8054,1027.0289,24.8061,-1,-1);
	DerbyCars[8] = AddStaticVehicle(401,-1370.2371,954.4924,1026.8207,14.6170,-1,-1);
	DerbyCars[9] = AddStaticVehicle(400,-1383.9635,956.0931,1026.6301,4.6049,-1,-1);

	LinkVehicleToInterior(DerbyCars[1], 15);
	LinkVehicleToInterior(DerbyCars[2], 15);
	LinkVehicleToInterior(DerbyCars[3], 15);
	LinkVehicleToInterior(DerbyCars[4], 15);
	LinkVehicleToInterior(DerbyCars[5], 15);
	LinkVehicleToInterior(DerbyCars[6], 15);
	LinkVehicleToInterior(DerbyCars[7], 15);
	LinkVehicleToInterior(DerbyCars[8], 15);
	LinkVehicleToInterior(DerbyCars[9], 15);
    return 1;
}

stock GetName(playerid)
{
new nick[MAX_PLAYER_NAME];
GetPlayerName(playerid, nick, sizeof(nick));
return nick;
}

stock GetIp(playerid)
{
new ip[12];
GetPlayerIp(playerid, ip, sizeof(ip));
return ip;
}
