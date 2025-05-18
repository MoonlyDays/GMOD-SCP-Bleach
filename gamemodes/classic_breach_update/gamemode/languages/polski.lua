polski = {}
polski.roundtype = "Typ rundy: {type}"
polski.preparing = "Przygotuj się, runda zacznie się za {num} sekund"
polski.round = "Gra się rozpoczeła, powodzenia"
polski.lang_pldied = "{num} graczy zginęło"
polski.lang_descaped = "{num} personel(u) Klasy D uciekło"
polski.lang_sescaped = "{num} obiektów SCP uciekło"
polski.lang_rescaped = "{num} Naukowców uciekło"
polski.lang_dcaptured = "{num} personel(u) Klasy D zostało pojmanych przez Chaos Insurgency"
polski.lang_rescorted = "{num} Naukowców zostało eskortowanych przez MTF"
polski.lang_teleported = "{num} graczy zostało porwane do wymiaru łuzowego"
polski.lang_snapped = "{num} graczy zostało zabitych przez SCP - 173"
polski.lang_zombies = '{num} graczy zostało "wyleczonych" przez SCP - 049'
polski.lang_secret_found = "Sekret nie został odnaleziony"
polski.lang_secret_nfound = "Sekret został odnaleziony"
polski.starttexts = {
	{
		--1
		"Jesteś SCP - 173",
		{"Twoim celem jest ucieczka z placówki", "Nie możesz sie ruszać jeśli ktoś się na ciebie patrzy", "Pamiętaj, ludzie mrugają", "LPM - złamanie karku ofierze", "PPM - aktywacja specjalnej umiejętności: oślepienie wszystkich w około"}
	},
	{
		--2
		"Jesteś SCP - 106",
		{"Twoim celem jest ucieczka z placówki", "Jeśli dotkniesz kogoś, przeteleportujesz go do wymiaru łuzowego", "LPM - przeniesienie ofiary do wymiaru łuzowego"}
	},
	{
		--3
		"Jesteś SCP - 049",
		{"Twoim celem jest ucieczka z placówki", "Jak dotkniesz kogoś, to stanie się SCP-049-2", "LPM - przemiana ofiary w zombie"}
	},
	{
		--4
		"Jesteś Ochroniarzem",
		{"Twoim celem jest znalezienie wszystkich naukowców i eliminacja Klasy D", "Eskortuj ich do lądowiska", "Musisz zabić każdego kto ci przeszkodzi", "Słuchaj się swojego Dowódcy i wykonuj jego polecenia"}
	},
	{
		--5 roundtype: trouble in scp town
		"Jesteś Ochroniarzem",
		{"Twoim celem jest zabicie wszystkich szpiegów z Chaos Insurgency", "Nie ufaj nikomu"}
	},
	{
		--6
		"Jesteś Szefem Ochrony",
		{"Twoim celem jest znalezienie wszystkich naukowców", "Eskortuj ich do lądowiska", "Musisz zabić każdego kto ci przeszkodzi", "Wydawaj polecenia ochroniarzom"}
	},
	{
		--7
		"Jesteś agentem MTF Jednostki Nine-Tailed Fox",
		{"Twoim celem jest znalezienie wszystkich naukowców i eliminacja Klasy D", "Eskortuj ich do lądowiska", "Musisz zabić każdego kto ci przeszkodzi", "Wejdź do placówki i pomóż ochroniarzom"}
	},
	{
		--8
		"Jesteś personelem Klasy D",
		{"Twoim celem jest ucieczka z placówki", "Pomagaj swoim kolegom, samemu masz nikłe szanse na przeżycie", "Współpracuj z Rebelią Chaosu", "Szukaj kart dostępu i uważaj na MTF i obiekty SCP"}
	},
	{
		--9
		"Jesteś naukowcem",
		{"Twoim celem jest ucieczka z placówki", "Szukaj pomocy i spróbuj wydostać się z placówki", "Uważaj na klasę D, mogą próbować cię zabić"}
	},
	{
		--10
		"Jesteś SCP - 049 - 2",
		{"Twoim celem jest ucieczka z placówki", "Pomagaj SCP-049", "LPM - atak", "PPM - mocniejszy atak"}
	},
	{
		--11
		"Jesteś Dowódcą CI",
		{"Twoim zadaniem jest zabicie wszystkich jednostek MTF i pojmanie Klasy D", "Eskortuj ich do lądowiska poza placówką", "Zabij każdego kto ci przeszkodzi", "Wydawaj polecenia Rebelii Chaosu"}
	},
	{
		--12
		"Jesteś żołnierzem Chaos Insurgency",
		{"Twoim zadaniem jest zabicie wszystkich jednostek MTF i pojmanie Klasy D", "Eskortuj ich do lądowiska poza placówką", "Będą myśleć, że jesteś z nimi", "Nie zdradź się", "Zabij każdego kto ci przeszkodzi"}
	},
	{
		--13 roundtype: trouble in scp town
		"Jesteś szpiegiem Chaos Insurgency",
		{"Twoim celem jest zabicie ochroniarzy MTF", "Oni są w placówce, idź tam i ich zabij", "Będą myśleć, że jesteś z nimi", "Nie zdradź się", "Jeśli znajdziesz personel Klasy D lub Naukowców eskortuj ich do lądowiska"}
	},
	{
		--14 roundtype: assault 
		"Jesteś żołnierzem Chaos Insurgency",
		{"Twoim celem jest zabicie ochroniarzy MTF", "Są w placówce, idź tam i ich zabij", "Współpracuj ze swoją drużyną"}
	},
	{
		--15
		"Jesteś SCP - 035",
		{"Twoim celem jest ucieczka z placówki", "Pomóz uciec Personelowi Klasy D oraz SCP", "NIE ZABIJAJ KLASY D ANI SCP JAKO SCP 035", "Posiadasz karte dostępu 3 oraz Deagle"}
	},
	{
		--16
		"Jesteś SCP - 457",
		{"Twoim celem jest ucieczka z placówki", "Zawsze się palisz", "Jeśli będziesz blisko kogoś, zaczniesz go podpalać"}
	},
	{
		--17 roundtype: zombie plague
		"Jesteś Ochroniarzem MTF",
		{"Twoim celem jest zabicie wszystkich SCP-008-2", "Po rozpoczęciu rundy niektórzy zostaną zombie"}
	},
	{
		--18
		"Jesteś SCP - 008 - 2",
		{"Twoim celem jest zarażenie wszystkich ochroniarzy", "Jeśli zaatakujesz kogoś to stanie się 008-2"}
	},
	{
		--19
		"Jesteś Obserwatorem",
		{"Użyj komendy 'br_spectate' żeby wrócić"}
	},
	{
		--20
		"Jesteś SCP - 096",
		{"Twoim celem jest ucieczka z placówki", "Ruszasz się niezwykle szybko gdy ktoś na ciebie patrzy", "LPM - atak"}
	},
	{
		--21
		"Jesteś SCP - 939",
		{"Twoim celem jest ucieczka z placówki", "Jesteś szybki i silny", "LPM - ugryzienie ofiary"}
	}
}

polski.lang_end1 = "Runda kończy się w tym miejscu"
polski.lang_end2 = "Czas minął"
polski.lang_end3 = "Gra zakończyła się"
polski.escapemessages = {
	{
		main = "Uciekłeś",
		txt = "Uciekłeś w {t} minut, dobra robota!",
		txt2 = "Następnym razem spróbuj zostać eskortowanym przez MTF żeby dostać bonusowe punkty",
		clr = team.GetColor(TEAM_SCP)
	},
	{
		main = "Uciekłeś",
		txt = "Uciekłeś w {t} minut, dobra robota!",
		txt2 = "Następnym razem spróbuj zostać eskortowanym przez CI żeby dostać bonus punktów",
		clr = team.GetColor(TEAM_SCP)
	},
	{
		main = "Zostałeś eskortowany",
		txt = "Zostałeś eskortowany w {t} minut, dobra robota!",
		txt2 = "",
		clr = team.GetColor(TEAM_SCP)
	},
	{
		main = "Uciekłeś",
		txt = "Uciekłeś w {t} minut, dobra robota!",
		txt2 = "",
		clr = team.GetColor(TEAM_SCP)
	}
}

-- ROLES \\ 
polski.ROLE_SCP173 = "SCP-173"
polski.ROLE_SCP106 = "SCP-106"
polski.ROLE_SCP049 = "SCP-049"
polski.ROLE_SCP035 = "SCP-035"
polski.ROLE_SCP457 = "SCP-457"
polski.ROLE_SCP096 = "SCP-096"
polski.ROLE_SCP939 = "SCP-939"
polski.ROLE_SCP0492 = "SCP-049-2"
polski.ROLE_MTFGUARD = "Ochroniarz"
polski.ROLE_MTFCOM = "Szef Ochrony"
polski.ROLE_MTFNTF = "MTF Nine-Tailed Fox"
polski.ROLE_CHAOSCOM = "Dowódca CI"
polski.ROLE_CHAOS = "Chaos Insurgency"
polski.ROLE_CLASSD = "Personel Klasy D"
polski.ROLE_RES = "Naukowiec"
polski.ROLE_SPEC = "Obserwator"
-- HUD \\
-- SCOREBOARD
polski.sb_scpobject = "Obiekt SCP"
polski.sb_score = "Wynik"
polski.sb_deaths = "Śmierci"
polski.sb_ping = "Ping"
polski.sb_group = "Grupa"
-- MTF Manager
polski.mtfmanager = "Menedżer Mobilnej Formacji Operacyjnej"
polski.requestgatea = "Żądanie otwarcia zdalnie Bramy A"
polski.requestescort = "Żądanie eskorty"
polski.sound_random = "Dźwięk: Losowo"
polski.sound_searching = "Dźwięk: Szukanie"
polski.sound_classdfound = "Dźwięk: Znaleziono klasę D"
polski.sound_stop = "Dźwięk: Stop!"
polski.sound_targetlost = "Dźwięk: Zgubiono cel"
polski.dropvest = "Zrzucenie pancerza"
-- SweetFX
polski.SWEETFX_enabled = "[SweetFX]: Włączono żywe kolory"
polski.SWEETFX_disabled = "[SweetFX]: Wyłączono żywe kolory"
-- Thirdperson
polski.thirdperson_enabled = "[Widok trzecioosobowy]: Włączono"
polski.thirdperson_disabled = "[Widok trzecioosobowy]: Wyłączono"
-- F4 Menu
polski.f4close = "Zamknij"
polski.f4settings = "Ustawienia"
polski.f4settings_lang = "Wybierz język:"
polski.f4settings_spectmode = "Zmienić na tryb obserwatora?"
polski.f4settings_sweetfx = "Włączyć żywe kolory? (SweetFX HDR)"
polski.f4settings_soundsfix = "Fix dźwięków"
polski.f4settings_bwt = "Fix na jasne bronie i textury"
polski.f4roles_humans = "Role 1/2 (Ludzie)"
polski.f4roles_scps = "Role 2/2 (SCP)"
polski.f4credits = "Podziękowania"
-- SWEPS \\
-- SCP173 
polski.nooneislooking = "Nikt nie patrzy"
polski.readytousein = "gotowa do użycia za "
polski.readytouse = "gotowa do użycia"
polski.special = "Specjalna umiejętność "
polski.someoneislooking = "Ktoś patrzy"
polski.seconds = " sekund"
-- SCP106 + SCP049 + SCP939
polski.readytoattack = "Gotowy do ataku"
polski.nextattack = "Następny atak za "
-- SCP714
polski.durability = "Wytrzymałość:"
polski.protect = "Jesteś chroniony"
polski.protend = "Twoja ochrona się kończy"
-- SNAV Ultimate
polski.snu_mtfguard = "Wykryto Ochronę MTF"
polski.snu_ci = "Wykryto Żołnierza Rebelii Chaosu"
polski.snu_classd = "Wykryto Personel Klasy D"
polski.snu_researcher = "Wykryto Naukowca"
polski.snu_detected = "Wykryto "
polski.snu_humanoid = "Wykryto humanoidalną postać"
-- RADIO
polski.radiochannel = "Kanał radiowy "
polski.radiodisabled = "Radio wyłączone"
ALLLANGUAGES.polski = polski
--[[
	if rl == ROLE_SCP173 then return 1 end
	if rl == ROLE_SCP106 then return 2 end
	if rl == ROLE_SCP049 then return 3 end
	if rl == ROLE_MTFGUARD then return 4 end
	if rl == ROLE_MTFGUARD then return 5 end (UNUSED) (TTT)
	if rl == ROLE_MTFCOM then return 6 end
	if rl == ROLE_MTFNTF then return 7 end
	if rl == ROLE_CLASSD then return 8 end
	if rl == ROLE_RES then return 9 end
	if rl == ROLE_SCP0492 then return 10 end
	if rl == ROLE_CHAOS then return 11 end (UNUSED) (ASSAULT)
	if rl == ROLE_CHAOS then return 12 end (UNUSED) (TTT)
	if rl == ROLE_CHAOS then return 13 end (UNUSED) (ASSAULT)
	if rl == ROLE_SCP035 then return 14 end
	if rl == ROLE_SCP457 then return 15 end
	if rl == ROLE_MTFGUARD then return 16 end (UNUSED) (ZOMBIE PLAGUE)
	if rl == ROLE_SCP0082 then return 17 end
	if rl == ROLE_SPEC then return 18 end
]]