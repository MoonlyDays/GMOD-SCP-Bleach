AddCSLuaFile()

br_time_preparing = CreateConVar("br_time_preparing", "45", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }, "Set preparing time")
br_time_round = CreateConVar("br_time_round", "720", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }, "Set round time")
br_time_postround = CreateConVar("br_time_postround", "20", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }, "Set postround time")
br_time_ntf_enter_delay_min = CreateConVar("br_time_ntf_enter_delay_min", "90", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }, "Minimum time that NTF units will enter the facility")
br_time_ntf_enter_delay_max = CreateConVar("br_time_ntf_enter_delay_max", "180", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }, "Maximum time that NTF units will enter the facility")
br_time_blink = CreateConVar("br_time_blink", "0.2", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }, "Blink timer")
br_time_blink_delay = CreateConVar("br_time_blink_delay", "4", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }, "Delay between blinks")

