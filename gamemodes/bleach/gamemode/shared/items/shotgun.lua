ITEM.Spawn = MAP.SPAWN_SHOTGUNS
ITEM.Entity = {
    "weapon_chaos_m3s90",
    "weapon_chaos_xm1014"
}

function ITEM:Spawned()
    self.DroppedAmmo = self.Primary.ClipSize
end