/*
*	TODO:
*	-> Clan tag setting
*	-> HintBox Counting
*/

#include <sourcemod>

#pragma semicolon 1 
#pragma newdecls required 

#define TAG_MESSAGE "[\x04VoidRealityCheck\x01]"

bool b_PlayerReady[MAXPLAYERS+1];
int i_PlayersNeeded;
int i_PlayersReady;
int i_PlayersUnready;

public Plugin myinfo =  
{ 
    name        = "Ready Check", 
    author      = "B3none", 
    description = "Player Ready System", 
    version     = "0.0.1", 
    url         = "https://www.youtube.com/watch?v=IW3aI6zjGl4" 
}; 

public void OnPluginStart()
{
	CreateTimer(30.0, Announce_Ready);
	RegConsoleCmd("sm_ready", Command_PlayerReady);
}

public Action Announce_Ready(Handle timer)
{
	PrintToChatAll("%s \x0C%i\x01/\x0C%i\x01 players ready.", TAG_MESSAGE, i_PlayersReady, i_PlayersNeeded);
	PrintToChatAll("%s There are \x0C%i\x01 players unready.", TAG_MESSAGE, i_PlayersUnready);
	
	CreateTimer(30.0, Announce_Ready);
}

public Action Command_PlayerReady(int client, int args)
{
	b_PlayerReady[client] = true;
	i_PlayersUnready = i_PlayersUnready - 1;
	i_PlayersReady++;
	
	PrintToChat(client, "%s You are now ready.");
	PrintToChatAll("%s There are now \x0C%i\x01/\x0C%i\x01 players ready.", TAG_MESSAGE, i_PlayersReady, i_PlayersNeeded);
	
	if(i_PlayersReady == i_PlayersNeeded)
	{
		AllReady();
	}
}

public Action AllReady()
{
	PrintToChatAll("%s The threshold has been met, game starting...", TAG_MESSAGE);
	ServerCommand("mp_warmuptime 0;");
	ServerCommand("mp_death_drop_defuser 1;");
	ServerCommand("mp_death_drop_grenade 1;");
	ServerCommand("mp_death_drop_gun 1;");
	ServerCommand("mp_restartgame 1;");
}

public void OnClientPutInServer() 
{ 
	i_PlayersUnready++;
} 

public void OnClientDisconnect(int client) 
{ 
	b_PlayerReady[client] = false;
} 

public void OnMapStart() 
{
	i_PlayersNeeded = 2;
	i_PlayersReady = 0;
	i_PlayersUnready = 0;
	
	for(int i = 1; i <= MAXPLAYERS+1; i++)
	{
		b_PlayerReady[i] = false;
	}
}

public void OnMapEnd() 
{ 
	i_PlayersNeeded = 2;
	i_PlayersReady = 0;
	i_PlayersUnready = 0;
	
	for(int i = 1; i <= MAXPLAYERS+1; i++)
	{
		b_PlayerReady[i] = false;
	}
}
