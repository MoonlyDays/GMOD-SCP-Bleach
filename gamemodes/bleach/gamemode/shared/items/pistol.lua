-- Pistols with 66% chance of appearing
ITEM.Spawn = MAP.SPAWN_PISTOLS
ITEM.ChanceFraction = 0.66
ITEM.Entity = {
    "weapon_mtf_usp",
    "weapon_mtf_usp",
    "weapon_mtf_usp",
    "weapon_mtf_deagle", --25% the pistol will be a Deagle
}

function ITEM:Spawned()
    self.DroppedAmmo = self.Primary.ClipSize
end