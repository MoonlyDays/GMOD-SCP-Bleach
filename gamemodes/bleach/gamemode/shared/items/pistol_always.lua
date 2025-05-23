ITEM.Spawn = MAP.SPAWN_ALWAYS_PISTOLS
ITEM.Entity = {
    "weapon_mtf_usp",
    "weapon_mtf_usp",
    "weapon_mtf_usp",
    "weapon_mtf_deagle",
}

function ITEM:Spawned()
    self.DroppedAmmo = self.Primary.ClipSize
end