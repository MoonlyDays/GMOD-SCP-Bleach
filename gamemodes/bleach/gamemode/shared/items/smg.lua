ITEM.Spawn = MAP.SPAWN_SMGS
ITEM.Entity = {
    "weapon_mtf_p90",
    "weapon_mtf_tmp",
    "weapon_mtf_ump45"
}

function ITEM:Spawned()
    self.DroppedAmmo = self.Primary.ClipSize
end