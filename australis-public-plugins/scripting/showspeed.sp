#include <sourcemod>

Handle g_hHud;

public void OnPluginStart()
{
    g_hHud = CreateHudSynchronizer();
}

public Action OnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3], int& weapon, int& subtype, int& cmdnum, int& tickcount, int& seed, int mouse[2])
{
    if(!IsPlayerAlive(client))
        return Plugin_Continue;

    int iSpeed = GetSpeed(client);

    SetHudTextParams(-1.0, 0.5, GetTickInterval(), 255, 255, 255, 255, 0, 0.0, 0.0, 0.0);
    ShowSyncHudText(client, g_hHud, "%i", iSpeed);

    return Plugin_Continue;
}

stock int GetSpeed(int client)
{
    float flVelocity[3];
    GetEntPropVector(client, Prop_Data, "m_vecVelocity", flVelocity);

    return RoundToNearest(SquareRoot(flVelocity[0] * flVelocity[0] + flVelocity[1] * flVelocity[1]));
}