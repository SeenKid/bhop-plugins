 #include <geoip>
 
 public PlVers:__version =
{
	version = 5,
	filevers = "1.9.0.6226",
	date = "05/07/2018",
	time = "23:39:56"
};

public Extension:__ext_core =
{
	name = "Core",
	file = "core",
	autoload = 0,
	required = 0,
};

public Extension:__ext_geoip =
{
	name = "GeoIP",
	file = "geoip.ext",
	autoload = 1,
	required = 1,
};
public Plugin:myinfo =
{
	name = "Connect MSG (fixed by Nairda)",
	description = "",
	author = "Crazy & Nairda",
	version = "1.1",
	url = ""
};

public void OnPluginStart()
{
	HookEvent("player_disconnect", Event_PlayerDisconnect, EventHookMode:0);
	return;
}

public void:OnClientPutInServer(client)
{
	new String:name[100];
	new String:IP[100];
	new String:Country[100];
	GetClientName(client, name, 99);
	decl String:sSteamID[32];
	GetClientAuthId(client, AuthIdType:1, sSteamID, 32, true);
	GetClientIP(client, IP, 99, true);
	if (!GeoipCountry(IP, Country, 99))
	{
		Country = "Unknown Country";
	}
	PrintToChatAll("\x01Player \x03%s (%s) \x01connected from \x03%s.", name, sSteamID, Country);
	return;
}

public Action:Event_PlayerDisconnect(Handle:event, String:name[], bool:dontBroadcast)
{
	if (!dontBroadcast)
	{
		new userid = GetEventInt(event, "userid", 0);
		new client = GetClientOfUserId(userid);
		new var1;
		if (!client || !IsClientInGame(client))
		{
			SetEventBroadcast(event, true);
			return Action:1;
		}
		decl String:clientName[64];
		decl String:networkID[28];
		decl String:reason[68];
		decl String:sSteamID[32];
		GetClientAuthId(client, AuthIdType:1, sSteamID, 32, true);
		GetEventString(event, "name", clientName, 64, "");
		GetEventString(event, "networkid", networkID, 25, "");
		GetEventString(event, "reason", reason, 65, "");
		PrintToChatAll("\x01Player \x03%s (%s) \x01has disconnected (Reason: %s).", clientName, sSteamID, reason);
		new Handle:newEvent = CreateEvent("player_disconnect", true);
		SetEventInt(newEvent, "userid", userid);
		SetEventString(newEvent, "reason", reason);
		SetEventString(newEvent, "name", clientName);
		SetEventString(newEvent, "networkid", networkID);
		FireEvent(newEvent, true);
		return Action:3;
	}
	return Action:0;
}

 