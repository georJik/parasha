#include <a_samp>
#include <a_mysql>
#include <sscanf2>

#undef MAX_PLAYERS
const 
	MAX_PLAYERS = 100,		// change 
	MAX_CHARTERS = 2, 		// change
	MAX_QUERY_LEN = 500; 	// change

#define	PVB<%0:%1>		(PVB[%0] & %1)
#define PXOR<%0:%1>  	PVB[%0] ^= %1
#define PNULL<%0:%1>  	PVB[%0] &= ~%1
#define PUP<%0:%1>  	PVB[%0] |= %1
#define PRES<%0>		PVB[%0] = BooleanPVar:0

#define	int%0(%1)		forward%0(%1); public%0(%1)
#define current			Player[playerid][currented] // DANGEROUS

enum BooleanPVar:(<<= 1)
{
	logged = 1,
	status,
	selected,
	sex
}

enum PlayerInfo
{
	Name[MAX_PLAYER_NAME],
	Name2[MAX_PLAYER_NAME],
	LName[MAX_PLAYER_NAME],
	LName2[MAX_PLAYER_NAME],
	Email[32],
	Password[24],
	Sex[MAX_CHARTERS],
	Skin[MAX_CHARTERS],
	Age[MAX_CHARTERS+1],
	currented
}

new 
	Player[MAX_PLAYERS][PlayerInfo],
	BooleanPVar:PVB[MAX_PLAYERS],
	handle,
	query[MAX_QUERY_LEN];

new skin_array[10] = {215, 8, 11, 92, 191, 299, 71, 5, 4, 294};

	
// td
new Text:acc_log;
new Text:acc_reg;
new Text:next;
new Text:un_box1;
new Text:e_email[MAX_PLAYERS];
new Text:e_pass[MAX_PLAYERS];
new Text:login;
new Text:reg;
new Text:ch_text;
new Text:un_box;
new Text:ch_1m[MAX_PLAYERS];
new Text:ch_2m[MAX_PLAYERS];
new Text:ch_1[MAX_PLAYERS];
new Text:ch_2[MAX_PLAYERS];
new Text:c_cch;
new Text:c_unbox;
new Text:c_next;
new Text:tname[MAX_PLAYERS];
new Text:lname[MAX_PLAYERS];
new Text:gender[MAX_PLAYERS];
new Text:g_left;
new Text:g_right;
new Text:m_right;
new Text:m_left;
new Text:model[MAX_PLAYERS];
new Text:age[MAX_PLAYERS];
new Text:minus;
new Text:plus;

LoadPlayerTextDraw(playerid)
{
	e_email[playerid] = TextDrawCreate(121.000000, 182.000000, "Enter e-mail");
	TextDrawBackgroundColor(e_email[playerid], 255);
	TextDrawFont(e_email[playerid], 1);
	TextDrawLetterSize(e_email[playerid], 0.180000, 1.500000);
	TextDrawColor(e_email[playerid], -1);
	TextDrawSetOutline(e_email[playerid], 0);
	TextDrawSetProportional(e_email[playerid], 1);
	TextDrawSetShadow(e_email[playerid], 0);
	TextDrawUseBox(e_email[playerid], 1);
	TextDrawBoxColor(e_email[playerid], 1431655782);
	TextDrawTextSize(e_email[playerid], 219.000000, 10.000000);
	TextDrawSetSelectable(e_email[playerid], 1);

	e_pass[playerid] = TextDrawCreate(121.000000, 202.000000, "Enter password");
	TextDrawBackgroundColor(e_pass[playerid], 255);
	TextDrawFont(e_pass[playerid], 1);
	TextDrawLetterSize(e_pass[playerid], 0.180000, 1.500000);
	TextDrawColor(e_pass[playerid], -1);
	TextDrawSetOutline(e_pass[playerid], 0);
	TextDrawSetProportional(e_pass[playerid], 1);
	TextDrawSetShadow(e_pass[playerid], 0);
	TextDrawUseBox(e_pass[playerid], 1);
	TextDrawBoxColor(e_pass[playerid], 1431655765);
	TextDrawTextSize(e_pass[playerid], 219.000000, 10.000000);
	TextDrawSetSelectable(e_pass[playerid], 1);

	acc_log = TextDrawCreate(170.000000, 156.000000, "LOGIN");
	TextDrawAlignment(acc_log, 2);
	TextDrawBackgroundColor(acc_log, 255);
	TextDrawFont(acc_log, 2);
	TextDrawLetterSize(acc_log, 0.310000, 1.899999);
	TextDrawColor(acc_log, -1);
	TextDrawSetOutline(acc_log, 0);
	TextDrawSetProportional(acc_log, 1);
	TextDrawSetShadow(acc_log, 0);
	TextDrawUseBox(acc_log, 1);
	TextDrawBoxColor(acc_log, -1639101048);
	TextDrawTextSize(acc_log, 230.000000, 110.000000);
	TextDrawSetSelectable(acc_log, 0);

	acc_reg = TextDrawCreate(170.000000, 156.000000, "REGISTRATION");
	TextDrawAlignment(acc_reg, 2);
	TextDrawBackgroundColor(acc_reg, 255);
	TextDrawFont(acc_reg, 2);
	TextDrawLetterSize(acc_reg, 0.310000, 1.899999);
	TextDrawColor(acc_reg, -1);
	TextDrawSetOutline(acc_reg, 0);
	TextDrawSetProportional(acc_reg, 1);
	TextDrawSetShadow(acc_reg, 0);
	TextDrawUseBox(acc_reg, 1);
	TextDrawBoxColor(acc_reg, -1639101048);
	TextDrawTextSize(acc_reg, 230.000000, 110.000000);
	TextDrawSetSelectable(acc_reg, 0);
	
	ch_1m[playerid] = TextDrawCreate(466.000000, 176.000000, "ch1");
	TextDrawBackgroundColor(ch_1m[playerid], 0);
	TextDrawFont(ch_1m[playerid], 5);
	TextDrawLetterSize(ch_1m[playerid], 0.500000, 1.000000);
	TextDrawColor(ch_1m[playerid], -1);
	TextDrawSetOutline(ch_1m[playerid], 1);
	TextDrawSetProportional(ch_1m[playerid], 1);
	TextDrawUseBox(ch_1m[playerid], 1);
	TextDrawBoxColor(ch_1m[playerid], 0);
	TextDrawTextSize(ch_1m[playerid], 60.000000, 80.000000);
	TextDrawSetPreviewModel(ch_1m[playerid], 23000);
	TextDrawSetPreviewRot(ch_1m[playerid], -16.000000, 0.000000, -55.000000, 1.000000);
	TextDrawSetSelectable(ch_1m[playerid], 1);

	ch_2m[playerid] = TextDrawCreate(536.000000, 176.000000, "ch2");
	TextDrawBackgroundColor(ch_2m[playerid], 0);
	TextDrawFont(ch_2m[playerid], 5);
	TextDrawLetterSize(ch_2m[playerid], 0.500000, 1.000000);
	TextDrawColor(ch_2m[playerid], -1);
	TextDrawSetOutline(ch_2m[playerid], 1);
	TextDrawSetProportional(ch_2m[playerid], 1);
	TextDrawUseBox(ch_2m[playerid], 1);
	TextDrawBoxColor(ch_2m[playerid], 0);
	TextDrawTextSize(ch_2m[playerid], 60.000000, 80.000000);
	TextDrawSetPreviewModel(ch_2m[playerid], 23000);
	TextDrawSetPreviewRot(ch_2m[playerid], -16.000000, 0.000000, -55.000000, 1.000000);
	TextDrawSetSelectable(ch_2m[playerid], 1);

	ch_1[playerid] = TextDrawCreate(473.000000, 256.000000, "No charter");
	TextDrawBackgroundColor(ch_1[playerid], 255);
	TextDrawFont(ch_1[playerid], 2);
	TextDrawLetterSize(ch_1[playerid], 0.170000, 1.000000);
	TextDrawColor(ch_1[playerid], -1);
	TextDrawSetOutline(ch_1[playerid], 0);
	TextDrawSetProportional(ch_1[playerid], 1);
	TextDrawSetShadow(ch_1[playerid], 0);
	TextDrawSetSelectable(ch_1[playerid], 0);

	ch_2[playerid] = TextDrawCreate(544.000000, 256.000000, "No charter");
	TextDrawBackgroundColor(ch_2[playerid], 255);
	TextDrawFont(ch_2[playerid], 2);
	TextDrawLetterSize(ch_2[playerid], 0.170000, 1.000000);
	TextDrawColor(ch_2[playerid], -1);
	TextDrawSetOutline(ch_2[playerid], 0);
	TextDrawSetProportional(ch_2[playerid], 1);
	TextDrawSetShadow(ch_2[playerid], 0);
	TextDrawSetSelectable(ch_2[playerid], 0);
	
	tname[playerid] = TextDrawCreate(262.000000, 149.000000, "Enter Name");
	TextDrawBackgroundColor(tname[playerid], 255);
	TextDrawFont(tname[playerid], 1);
	TextDrawLetterSize(tname[playerid], 0.260000, 1.500000);
	TextDrawColor(tname[playerid], -1);
	TextDrawSetOutline(tname[playerid], 0);
	TextDrawSetProportional(tname[playerid], 1);
	TextDrawSetShadow(tname[playerid], 0);
	TextDrawUseBox(tname[playerid], 1);
	TextDrawBoxColor(tname[playerid], 1431655765);
	TextDrawTextSize(tname[playerid], 377.000000, 10.000000);
	TextDrawSetSelectable(tname[playerid], 1);

	lname[playerid] = TextDrawCreate(262.000000, 169.000000, "Enter Last Name");
	TextDrawBackgroundColor(lname[playerid], 255);
	TextDrawFont(lname[playerid], 1);
	TextDrawLetterSize(lname[playerid], 0.260000, 1.500000);
	TextDrawColor(lname[playerid], -1);
	TextDrawSetOutline(lname[playerid], 0);
	TextDrawSetProportional(lname[playerid], 1);
	TextDrawSetShadow(lname[playerid], 0);
	TextDrawUseBox(lname[playerid], 1);
	TextDrawBoxColor(lname[playerid], 1431655765);
	TextDrawTextSize(lname[playerid], 377.000000, 10.000000);
	TextDrawSetSelectable(lname[playerid], 1);

	gender[playerid] = TextDrawCreate(319.000000, 197.000000, "Gender: Male");
	TextDrawAlignment(gender[playerid], 2);
	TextDrawBackgroundColor(gender[playerid], 255);
	TextDrawFont(gender[playerid], 1);
	TextDrawLetterSize(gender[playerid], 0.200000, 1.300000);
	TextDrawColor(gender[playerid], -1);
	TextDrawSetOutline(gender[playerid], 0);
	TextDrawSetProportional(gender[playerid], 1);
	TextDrawSetShadow(gender[playerid], 0);
	TextDrawUseBox(gender[playerid], 1);
	TextDrawBoxColor(gender[playerid], 1431655765);
	TextDrawTextSize(gender[playerid], 377.000000, 70.000000);
	TextDrawSetSelectable(gender[playerid], 0);
	
	model[playerid] = TextDrawCreate(293.000000, 221.000000, "model");
	TextDrawAlignment(model[playerid], 2);
	TextDrawBackgroundColor(model[playerid], 0);
	TextDrawFont(model[playerid], 5);
	TextDrawLetterSize(model[playerid], 0.500000, 1.000000);
	TextDrawColor(model[playerid], -1);
	TextDrawSetOutline(model[playerid], 0);
	TextDrawSetProportional(model[playerid], 1);
	TextDrawSetShadow(model[playerid], 1);
	TextDrawUseBox(model[playerid], 1);
	TextDrawBoxColor(model[playerid], 0);
	TextDrawTextSize(model[playerid], 50.000000, 60.000000);
	TextDrawSetPreviewModel(model[playerid], 1);
	TextDrawSetPreviewRot(model[playerid], 0.000000, 0.000000, 15.000000, 1.000000);
	TextDrawSetSelectable(model[playerid], 0);

	age[playerid] = TextDrawCreate(319.000000, 294.000000, "Age: 18");
	TextDrawAlignment(age[playerid], 2);
	TextDrawBackgroundColor(age[playerid], 255);
	TextDrawFont(age[playerid], 1);
	TextDrawLetterSize(age[playerid], 0.200000, 1.300000);
	TextDrawColor(age[playerid], -1);
	TextDrawSetOutline(age[playerid], 0);
	TextDrawSetProportional(age[playerid], 1);
	TextDrawSetShadow(age[playerid], 0);
	TextDrawUseBox(age[playerid], 1);
	TextDrawBoxColor(age[playerid], 1431655765);
	TextDrawTextSize(age[playerid], 377.000000, 40.000000);
	TextDrawSetSelectable(age[playerid], 0);
}

LoadTextDraw()
{
	next = TextDrawCreate(170.000000, 223.000000, "NEXT");
	TextDrawAlignment(next, 2);
	TextDrawBackgroundColor(next, 255);
	TextDrawFont(next, 2);
	TextDrawLetterSize(next, 0.310000, 1.899999);
	TextDrawColor(next, -1);
	TextDrawSetOutline(next, 0);
	TextDrawSetProportional(next, 1);
	TextDrawSetShadow(next, 0);
	TextDrawUseBox(next, 1);
	TextDrawBoxColor(next, -1639101048);
	TextDrawTextSize(next, 15.000000, 120.000000);
	TextDrawSetSelectable(next, 1);

	un_box1 = TextDrawCreate(170.000000, 178.000000, "_");
	TextDrawAlignment(un_box1, 2);
	TextDrawBackgroundColor(un_box1, 255);
	TextDrawFont(un_box1, 2);
	TextDrawLetterSize(un_box1, 0.310000, 4.500000);
	TextDrawColor(un_box1, 85);
	TextDrawSetOutline(un_box1, 0);
	TextDrawSetProportional(un_box1, 1);
	TextDrawSetShadow(un_box1, 0);
	TextDrawUseBox(un_box1, 1);
	TextDrawBoxColor(un_box1, 85);
	TextDrawTextSize(un_box1, 230.000000, 103.000000);
	TextDrawSetSelectable(un_box1, 0);
	
	login = TextDrawCreate(250.000000, 190.000000, "LOGIN");
	TextDrawBackgroundColor(login, 255);
	TextDrawFont(login, 1);
	TextDrawLetterSize(login, 0.500000, 2.000000);
	TextDrawColor(login, 1104210431);
	TextDrawSetOutline(login, 0);
	TextDrawSetProportional(login, 1);
	TextDrawSetShadow(login, 0);
	TextDrawTextSize(login, 302.0, 15.0);
	TextDrawSetSelectable(login, 1);

	reg = TextDrawCreate(330.000000, 190.000000, "REGISTRATION");
	TextDrawBackgroundColor(reg, 255);
	TextDrawFont(reg, 1);
	TextDrawLetterSize(reg, 0.500000, 2.000000);
	TextDrawColor(reg, 1104210431);
	TextDrawSetOutline(reg, 0);
	TextDrawSetProportional(reg, 1);
	TextDrawSetShadow(reg, 0);
	TextDrawTextSize(reg, 447.0, 15.0);
	TextDrawSetSelectable(reg, 1);

	ch_text = TextDrawCreate(533.000000, 156.000000, "CHARTERS");
	TextDrawAlignment(ch_text, 2);
	TextDrawBackgroundColor(ch_text, 255);
	TextDrawFont(ch_text, 2);
	TextDrawLetterSize(ch_text, 0.310000, 1.899999);
	TextDrawColor(ch_text, -1);
	TextDrawSetOutline(ch_text, 0);
	TextDrawSetProportional(ch_text, 1);
	TextDrawSetShadow(ch_text, 0);
	TextDrawUseBox(ch_text, 1);
	TextDrawBoxColor(ch_text, -1639101048);
	TextDrawTextSize(ch_text, 230.000000, 140.000000);
	TextDrawSetSelectable(ch_text, 0);

	un_box = TextDrawCreate(533.000000, 178.000000, "_");
	TextDrawAlignment(un_box, 2);
	TextDrawBackgroundColor(un_box, 255);
	TextDrawFont(un_box, 2);
	TextDrawLetterSize(un_box, 0.310000, 10.500000);
	TextDrawColor(un_box, 85);
	TextDrawSetOutline(un_box, 0);
	TextDrawSetProportional(un_box, 1);
	TextDrawSetShadow(un_box, 0);
	TextDrawUseBox(un_box, 1);
	TextDrawBoxColor(un_box, 85);
	TextDrawTextSize(un_box, 230.000000, 140.000000);
	TextDrawSetSelectable(un_box, 0);
	
	c_cch = TextDrawCreate(320.000000, 120.000000, "CREATE CHARTER");
	TextDrawAlignment(c_cch, 2);
	TextDrawBackgroundColor(c_cch, 255);
	TextDrawFont(c_cch, 2);
	TextDrawLetterSize(c_cch, 0.319999, 1.500000);
	TextDrawColor(c_cch, -1);
	TextDrawSetOutline(c_cch, 0);
	TextDrawSetProportional(c_cch, 1);
	TextDrawSetShadow(c_cch, 0);
	TextDrawUseBox(c_cch, 1);
	TextDrawBoxColor(c_cch, -1639101099);
	TextDrawTextSize(c_cch, 0.000000, 120.000000);
	TextDrawSetSelectable(c_cch, 0);

	c_unbox = TextDrawCreate(320.000000, 140.000000, "_");
	TextDrawAlignment(c_unbox, 2);
	TextDrawBackgroundColor(c_unbox, 255);
	TextDrawFont(c_unbox, 2);
	TextDrawLetterSize(c_unbox, 0.219999, 19.500000);
	TextDrawColor(c_unbox, -1);
	TextDrawSetOutline(c_unbox, 0);
	TextDrawSetProportional(c_unbox, 1);
	TextDrawSetShadow(c_unbox, 0);
	TextDrawUseBox(c_unbox, 1);
	TextDrawBoxColor(c_unbox, 85);
	TextDrawTextSize(c_unbox, 0.000000, 120.000000);
	TextDrawSetSelectable(c_unbox, 0);

	c_next = TextDrawCreate(320.000000, 319.000000, "NEXT");
	TextDrawAlignment(c_next, 2);
	TextDrawBackgroundColor(c_next, 255);
	TextDrawFont(c_next, 2);
	TextDrawLetterSize(c_next, 0.319999, 1.500000);
	TextDrawColor(c_next, -1);
	TextDrawSetOutline(c_next, 0);
	TextDrawSetProportional(c_next, 1);
	TextDrawSetShadow(c_next, 0);
	TextDrawUseBox(c_next, 1);
	TextDrawBoxColor(c_next, -1639101099);
	TextDrawTextSize(c_next, 57.000000, 120.000000);
	TextDrawSetSelectable(c_next, 1);

	g_left = TextDrawCreate(263.000000, 196.000000, "LD_BEAT:left");
	TextDrawAlignment(g_left, 2);
	TextDrawBackgroundColor(g_left, 255);
	TextDrawFont(g_left, 4);
	TextDrawLetterSize(g_left, 0.000000, 1.300000);
	TextDrawColor(g_left, -1);
	TextDrawSetOutline(g_left, 0);
	TextDrawSetProportional(g_left, 1);
	TextDrawSetShadow(g_left, 0);
	TextDrawUseBox(g_left, 1);
	TextDrawBoxColor(g_left, 1431655765);
	TextDrawTextSize(g_left, 14.000000, 16.000000);
	TextDrawSetSelectable(g_left, 1);

	g_right = TextDrawCreate(362.000000, 196.000000, "LD_BEAT:right");
	TextDrawAlignment(g_right, 2);
	TextDrawBackgroundColor(g_right, 255);
	TextDrawFont(g_right, 4);
	TextDrawLetterSize(g_right, 0.000000, 1.300000);
	TextDrawColor(g_right, -1);
	TextDrawSetOutline(g_right, 0);
	TextDrawSetProportional(g_right, 1);
	TextDrawSetShadow(g_right, 0);
	TextDrawUseBox(g_right, 1);
	TextDrawBoxColor(g_right, 1431655765);
	TextDrawTextSize(g_right, 14.000000, 16.000000);
	TextDrawSetSelectable(g_right, 1);

	m_right = TextDrawCreate(362.000000, 245.000000, "LD_BEAT:right");
	TextDrawAlignment(m_right, 2);
	TextDrawBackgroundColor(m_right, 255);
	TextDrawFont(m_right, 4);
	TextDrawLetterSize(m_right, 0.000000, 1.300000);
	TextDrawColor(m_right, -1);
	TextDrawSetOutline(m_right, 0);
	TextDrawSetProportional(m_right, 1);
	TextDrawSetShadow(m_right, 0);
	TextDrawUseBox(m_right, 1);
	TextDrawBoxColor(m_right, 1431655765);
	TextDrawTextSize(m_right, 14.000000, 16.000000);
	TextDrawSetSelectable(m_right, 1);

	m_left = TextDrawCreate(263.000000, 245.000000, "LD_BEAT:left");
	TextDrawAlignment(m_left, 2);
	TextDrawBackgroundColor(m_left, 255);
	TextDrawFont(m_left, 4);
	TextDrawLetterSize(m_left, 0.000000, 1.300000);
	TextDrawColor(m_left, -1);
	TextDrawSetOutline(m_left, 0);
	TextDrawSetProportional(m_left, 1);
	TextDrawSetShadow(m_left, 0);
	TextDrawUseBox(m_left, 1);
	TextDrawBoxColor(m_left, 1431655765);
	TextDrawTextSize(m_left, 14.000000, 16.000000);
	TextDrawSetSelectable(m_left, 1);
	
	minus = TextDrawCreate(289.000000, 294.000000, "-");
	TextDrawAlignment(minus, 2);
	TextDrawBackgroundColor(minus, 255);
	TextDrawFont(minus, 1);
	TextDrawLetterSize(minus, 0.350000, 1.300000);
	TextDrawColor(minus, -16776961);
	TextDrawSetOutline(minus, 0);
	TextDrawSetProportional(minus, 1);
	TextDrawSetShadow(minus, 0);
	TextDrawUseBox(minus, 1);
	TextDrawBoxColor(minus, 1431655765);
	TextDrawTextSize(minus, 377.000000, 9.000000);
	TextDrawSetSelectable(minus, 1);

	plus = TextDrawCreate(349.000000, 294.000000, "+");
	TextDrawAlignment(plus, 2);
	TextDrawBackgroundColor(plus, 255);
	TextDrawFont(plus, 1);
	TextDrawLetterSize(plus, 0.350000, 1.300000);
	TextDrawColor(plus, 96492799);
	TextDrawSetOutline(plus, 0);
	TextDrawSetProportional(plus, 1);
	TextDrawSetShadow(plus, 0);
	TextDrawUseBox(plus, 1);
	TextDrawBoxColor(plus, 1431655765);
	TextDrawTextSize(plus, 377.000000, 9.000000);
	TextDrawSetSelectable(plus, 1);
}

ResetPlayerInfo(playerid)
{
	for(new PlayerInfo:i; i < PlayerInfo; ++i) Player[playerid][i] = 0;
}

main();

public OnGameModeInit()
{
	handle = mysql_connect("localhost","root","parasha","");
	print( (!mysql_errno()) ? ("Connected MYSQL R39-2") : ("Not-Connected MYSQL R39-2") );
	SetGameModeText("Blank Script");
	LoadTextDraw();
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	ResetPlayerInfo(playerid);
	LoadPlayerTextDraw(playerid);
	SetSpawnInfo(playerid,0,0,0,0,1500+random(3000),0,0,0,0,0,0,0);
	SpawnPlayer(playerid);
	TogglePlayerSpectating(playerid, true);
	PRES<playerid>; 
	SelectTextDraw(playerid, 0x9DDDFFFF);
	SetPVarInt(playerid,"Select",1);
	TextDrawShowForPlayer(playerid, login), TextDrawShowForPlayer(playerid, reg);
	Player[playerid][Age][2] = 18;
	PUP<playerid:sex>;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerSpawn(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case 1:
		{
			switch(GetPVarInt(playerid,"DialogCase"))
			{
				case 1:
				{
					if(!strlen(inputtext)) return true;
					strmid(Player[playerid][Email], inputtext, 0, strlen(inputtext), 32);
					TextDrawSetString(e_email[playerid], Player[playerid][Email]);
				}
				case 2:
				{
					if(!strlen(inputtext)) return true;
					strmid(Player[playerid][Password], inputtext, 0, strlen(inputtext), 24);
					TextDrawSetString(e_pass[playerid], Player[playerid][Password]);
				}
				case 3:
				{
					if(!strlen(inputtext)) return true;
					if(!PVB<playerid:selected>) strmid(Player[playerid][Name], inputtext, 0, strlen(inputtext), 24), TextDrawSetString(tname[playerid], Player[playerid][Name]);
					else strmid(Player[playerid][Name2], inputtext, 0, strlen(inputtext), 24), TextDrawSetString(tname[playerid], Player[playerid][Name2]);
					SetPVarInt(playerid,"Name",1);
				}
				case 4:
				{
					if(!strlen(inputtext)) return true;
					if(!PVB<playerid:selected>) strmid(Player[playerid][LName], inputtext, 0, strlen(inputtext), 24), TextDrawSetString(lname[playerid], Player[playerid][LName]);
					else strmid(Player[playerid][LName2], inputtext, 0, strlen(inputtext), 24), TextDrawSetString(lname[playerid], Player[playerid][LName2]);
					SetPVarInt(playerid,"LName",1);
				}
			}
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == login || clickedid == reg)
	{
		if(clickedid == login) PUP<playerid:status>;
		TextDrawHideForPlayer(playerid, login), TextDrawHideForPlayer(playerid, reg);
		TextDrawShowForPlayer(playerid, (PVB<playerid:status>) ? acc_log : acc_reg), TextDrawShowForPlayer(playerid, next), TextDrawShowForPlayer(playerid, un_box1), TextDrawShowForPlayer(playerid, e_email[playerid]),
		TextDrawShowForPlayer(playerid, e_pass[playerid]);
	}
	if(clickedid == e_email[playerid]) SetPVarInt(playerid, "DialogCase", 1), ShowPlayerDialog(playerid, 1, DIALOG_STYLE_INPUT, "{1faee9}Мыло", "{ffffff}введите мыло", "Далее", "Отмена");
	if(clickedid == e_pass[playerid]) SetPVarInt(playerid, "DialogCase", 2), ShowPlayerDialog(playerid, 1, DIALOG_STYLE_INPUT, "{1faee9}пасс", "{ffffff}введите пасс", "Далее", "Отмена");
	if(clickedid == next) 
	{
		if(!strlen(Player[playerid][Email]) || !strlen(Player[playerid][Password])) return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "error", "что-то не ввел!", "Ок", "");
		if(PVB<playerid:status>)
		{
			mysql_format(handle, query, 128, "SELECT * FROM `accounts` WHERE `Email` = '%s' AND `Password` = '%s'",Player[playerid][Email], Player[playerid][Password]);
			mysql_tquery(handle, query, "LoadAccount", "i", playerid);
		}
		else
		{
			mysql_format(handle, query, 128, "SELECT `Email` FROM `accounts` WHERE `Email` = '%s'", Player[playerid][Email]);
			mysql_tquery(handle, query, "CheckAccount", "i", playerid);
		}
	}
	if(clickedid == ch_1m[playerid] || clickedid == ch_2m[playerid])
	{
		if(PVB<playerid:status>)
		{
			if((!Player[playerid][Skin][0] && clickedid == ch_1m[playerid]) || (!Player[playerid][Skin][1] && clickedid == ch_2m[playerid])) return true;
			if(clickedid == ch_2m[playerid]) PUP<playerid:selected>; // так нужно
			TogglePlayerSpectating(playerid, false), SpawnPlayer(playerid);
			DeletePVar(playerid,"Select"), CancelSelectTextDraw(playerid);
		}
		else
		{
			if(clickedid == ch_2m[playerid]) PUP<playerid:selected>;
			TextDrawShowForPlayer(playerid, c_unbox), TextDrawShowForPlayer(playerid, c_next), TextDrawShowForPlayer(playerid, tname[playerid]), TextDrawShowForPlayer(playerid, lname[playerid]),
			TextDrawShowForPlayer(playerid, gender[playerid]), TextDrawShowForPlayer(playerid, g_left), TextDrawShowForPlayer(playerid, g_right), TextDrawShowForPlayer(playerid, m_left),
			TextDrawShowForPlayer(playerid, m_right), TextDrawShowForPlayer(playerid, model[playerid]), TextDrawShowForPlayer(playerid, age[playerid]), TextDrawShowForPlayer(playerid, minus),
			TextDrawShowForPlayer(playerid, plus);
			PUP<playerid:sex>;
		}
		TextDrawHideForPlayer(playerid, ch_text), TextDrawHideForPlayer(playerid, un_box), TextDrawHideForPlayer(playerid, ch_1m[playerid]), TextDrawHideForPlayer(playerid, ch_2m[playerid]),
		TextDrawHideForPlayer(playerid, ch_1[playerid]), TextDrawHideForPlayer(playerid, ch_2[playerid]);
	}
	if(clickedid == tname[playerid])  SetPVarInt(playerid, "DialogCase", 3), ShowPlayerDialog(playerid, 1, DIALOG_STYLE_INPUT, "{1faee9}имя", "{ffffff}введите имя", "Далее", "Отмена");
	if(clickedid == lname[playerid])  SetPVarInt(playerid, "DialogCase", 4), ShowPlayerDialog(playerid, 1, DIALOG_STYLE_INPUT, "{1faee9}фамилия", "{ffffff}введите фамилия", "Далее", "Отмена");
	if(clickedid == g_left || clickedid == g_right)
	{
		if(PVB<playerid:sex>) PNULL<playerid:sex>;
		else PUP<playerid:sex>;
		TextDrawSetString(gender[playerid], (PVB<playerid:sex>)  ? ("Gender: Male") : ("Gender: Female"));
	}
	if(clickedid == m_left || clickedid == m_right)
	{
		current = (clickedid == m_left) ? current-1 : current+1;
		if(current < 0) current = 9;
		else if(current > 9) current = 0;
		TextDrawSetPreviewModel(model[playerid], skin_array[current]), TextDrawShowForPlayer(playerid, model[playerid]);
	}
	if(clickedid == minus || clickedid == plus)
	{
		Player[playerid][Age][2] = (clickedid == minus) ? Player[playerid][Age][2]-1 : Player[playerid][Age][2]+1;
		if(Player[playerid][Age][2] < 18) Player[playerid][Age][2] = 60;
		else if(Player[playerid][Age][2] > 60) Player[playerid][Age][2] = 18;
		new form[9];
		format(form, sizeof(form), "Age: %i", Player[playerid][Age][2]);
		TextDrawSetString(age[playerid], form), TextDrawShowForPlayer(playerid, age[playerid]);
	}
	if(clickedid == c_next)
	{
		if(!GetPVarInt(playerid,"Name") || !GetPVarInt(playerid,"LName")) return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "error", "что-то не ввел!", "Ок", "");
		if(!PVB<playerid:selected>)
		{
			Player[playerid][Skin][0] = skin_array[current], Player[playerid][Age][0] = Player[playerid][Age][2];
			if(PVB<playerid:sex>) Player[playerid][Sex][0] = 1;
			else Player[playerid][Sex][0] = 0;
		}
		else 
		{
			Player[playerid][Skin][1] = skin_array[current], Player[playerid][Age][1] = Player[playerid][Age][2];
			if(PVB<playerid:sex>) Player[playerid][Sex][1] = 1;
			else Player[playerid][Sex][1] = 0;
		}
		SendClientMessage(playerid, -1, "Всё!");
		mysql_format(handle, query, 220, "INSERT INTO `accounts` (`Email`, `Password`, `Name`, `LName`, `Skin`, `Sex`, `Age`) VALUES ('%s', '%s', '%s,%s', '%s,%s', '%i,%i', '%i,%i', '%i,%i')", Player[playerid][Email], Player[playerid][Password], Player[playerid][Name], 
		Player[playerid][Name2], Player[playerid][LName], Player[playerid][LName2], Player[playerid][Skin][0], Player[playerid][Skin][1]
		, Player[playerid][Sex][0], Player[playerid][Sex][1]
		, Player[playerid][Age][0], Player[playerid][Age][1]);
		mysql_tquery(handle, query, "","i", playerid);
		TogglePlayerSpectating(playerid, false);
		SpawnPlayer(playerid);
		TextDrawHideForPlayer(playerid, c_unbox), TextDrawHideForPlayer(playerid, c_next), TextDrawHideForPlayer(playerid, tname[playerid]), TextDrawHideForPlayer(playerid, lname[playerid]),
		TextDrawHideForPlayer(playerid, gender[playerid]), TextDrawHideForPlayer(playerid, g_left), TextDrawHideForPlayer(playerid, g_right), TextDrawHideForPlayer(playerid, m_left),
		TextDrawHideForPlayer(playerid, m_right), TextDrawHideForPlayer(playerid, model[playerid]), TextDrawHideForPlayer(playerid, age[playerid]), TextDrawHideForPlayer(playerid, minus),
		TextDrawHideForPlayer(playerid, plus);
		CancelSelectTextDraw(playerid), DeletePVar(playerid,"Select");
	}
	if(clickedid == Text:INVALID_TEXT_DRAW && GetPVarInt(playerid,"Select")) return SelectTextDraw(playerid, 0x9DDDFFFF);
	return true;
}

int CheckAccount(playerid)
{
	new rows, fields;
	cache_get_data(rows, fields);
	if(rows) return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "error", "уже зареган", "Ок", "");
	else
	{
		TextDrawHideForPlayer(playerid, (PVB<playerid:status>) ? acc_log : acc_reg), TextDrawHideForPlayer(playerid, next), TextDrawHideForPlayer(playerid, un_box1), TextDrawHideForPlayer(playerid, e_email[playerid]),
		TextDrawHideForPlayer(playerid, e_pass[playerid]);
		TextDrawShowForPlayer(playerid, ch_text), TextDrawShowForPlayer(playerid, un_box), TextDrawShowForPlayer(playerid, ch_1m[playerid]), TextDrawShowForPlayer(playerid, ch_2m[playerid]),
		TextDrawShowForPlayer(playerid, ch_1[playerid]), TextDrawShowForPlayer(playerid, ch_2[playerid]);
	}
	return true;
}

int LoadAccount(playerid)
{
    new rows, fields, dynamic[50];
    cache_get_data(rows, fields);
	if(rows)
	{
  		cache_get_field_content(0, "Email", Player[playerid][Email], handle, 32);
		cache_get_field_content(0, "Password", Player[playerid][Password], handle, 24);
		cache_get_field_content(0, "Name", dynamic, handle, 48);
        sscanf(dynamic,"p<,>s[23]s[23]", Player[playerid][Name], Player[playerid][Name2]);
		cache_get_field_content(0, "LName", dynamic, handle, 48);
        sscanf(dynamic,"p<,>s[23]s[23]", Player[playerid][LName], Player[playerid][LName2]);
		cache_get_field_content(0, "Skin", dynamic, handle, 8);
        sscanf(dynamic,"p<,>ii", Player[playerid][Skin][0], Player[playerid][Skin][1]);
		cache_get_field_content(0, "Sex", dynamic, handle, 4);
		sscanf(dynamic,"p<,>ii", Player[playerid][Sex][0], Player[playerid][Sex][1]);
		cache_get_field_content(0, "Age", dynamic, handle, 4);
		sscanf(dynamic,"p<,>ii", Player[playerid][Age][0], Player[playerid][Age][1]);
		TextDrawSetPreviewModel(ch_1m[playerid], (!Player[playerid][Skin][0]) ? 29000 : Player[playerid][Skin][0]), TextDrawSetPreviewModel(ch_2m[playerid], (!Player[playerid][Skin][1]) ? 29000 : Player[playerid][Skin][1]);
		format(dynamic, 24, "%s %s", Player[playerid][Name], Player[playerid][LName]);
		TextDrawSetString(ch_1[playerid], (!Player[playerid][Skin][0]) ? ("No charter") : dynamic),
		format(dynamic, 24, "%s %s", Player[playerid][Name2], Player[playerid][LName2]);
		TextDrawSetString(ch_2[playerid], (!Player[playerid][Skin][1]) ? ("No charter") : dynamic);
		TextDrawShowForPlayer(playerid, ch_text), TextDrawShowForPlayer(playerid, un_box), TextDrawShowForPlayer(playerid, ch_1m[playerid]), TextDrawShowForPlayer(playerid, ch_2m[playerid]),
		TextDrawShowForPlayer(playerid, ch_1[playerid]), TextDrawShowForPlayer(playerid, ch_2[playerid]);
		TextDrawHideForPlayer(playerid, acc_log), TextDrawHideForPlayer(playerid, next), TextDrawHideForPlayer(playerid, un_box1), TextDrawHideForPlayer(playerid, e_email[playerid]),
		TextDrawHideForPlayer(playerid, e_pass[playerid]);
		// ---------------------------------------------------------------------------
	}
	else
	{
		if(GetPVarInt(playerid, "wp") == 2) return Kick(playerid);
		SetPVarInt(playerid, "wp", GetPVarInt(playerid, "wp")+1);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "error", "пасс неверный", "Ок", "");
	}
	return true;
}

int SetPlayerSpawn(playerid)
{
	SetPlayerSkin(playerid, (!PVB<playerid:selected>) ? Player[playerid][Skin][0] : Player[playerid][Skin][1]);
	SetPlayerPos(playerid, 0.0, 0.0, 2.0);
	return true;
}