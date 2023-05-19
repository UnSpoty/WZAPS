
AddCSLuaFile()

ENT.Type 		= "anim"
ENT.PrintName 	= "Armor"
ENT.Category 	= "Armor"
ENT.Author 		= "KEKler1337"
ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = false

if SERVER then

    function ENT:Initialize()
        self:SetModel( "models/weapons/plita.mdl" )
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_WORLD)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetTrigger(true)
        self:SetUseType( SIMPLE_USE )

        local phys = self:GetPhysicsObject()

        if (IsValid(phys)) then
            phys:EnableGravity(true)
            phys:Wake()
        end

    end

end

function ENT:Use(ply)

	local wep = ply:GetActiveWeapon()
	local ammoType = wep:GetPrimaryAmmoType()
	
	if (ply:GetActiveWeapon():GetClass() != "weapon_armor") then return end
	if ply:IsPlayer() then self:Remove() end
	
	ply:GiveAmmo(1, ammoType, false)
end


function ENT:Draw()
    self:DrawModel()
end

function ENT:Think()

end