--(unused) local exampleSoundsInstalled = file.Exists("sound/augh.wav", "THIRDPARTY") && file.Exists("sound/audiojungle.wav", "THIRDPARTY")
local chatSoundCVar = CreateClientConVar("chat_sound", "csound", true, false, "Usage is displayed on the addon thumbnail. I'm not halfassed to put it here.")
local file = GetConVar("chat_sound"):GetString()
resource.AddFile(file)
hook.Add("OnPlayerChat", "csound", function() surface.PlaySound("breach/misc/csound.wav") end)
-- whats up