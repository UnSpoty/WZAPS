AddCSLuaFile()

SWEP.PrintName = "Armor plate"
SWEP.Author = "KEKler1337"
SWEP.Purpose = "LMB - Add armor, RMB - extract the plate"

SWEP.Slot = 0
SWEP.SlotPos = 2

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/weapons/c_hands_plita.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_hands_plita.mdl" )
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Plits"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false

local AddArmor = Sound( "items/battery_pickup.wav" )
local ExtractArmor = Sound( "WallHealth.Deny" )

function SWEP:Initialize()

	self:SetHoldType( "slam" )
	
end

function SWEP:PrimaryAttack() -- Мега насрал
	
	
	local MinArmor = 5
	local vm = self.Owner:GetViewModel()
    local anim = "ARM_addarmor"
    self:SetNextSecondaryFire( CurTime() + 2 )

	if (IsValid( self.Owner ) && self:Clip1() >= 1 && self.Owner:Armor() < MinArmor) then
	
	    vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )
		self:TakePrimaryAmmo( 1 )
		
	    if SERVER then 
		self.Owner:SetArmor( self.Owner:GetMaxArmor() )
		end
		
	    self:EmitSound( AddArmor )
		self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() + 2 )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
	else

		self.Owner:EmitSound( ExtractArmor )
		self:SetNextPrimaryFire( CurTime() + 2 )

	end
end

function SWEP:SecondaryAttack() -- Ультра мега насрал 
	
	
	local MaxArmor = 5
	local vm = self.Owner:GetViewModel()
    local anim = "ARM_extractplate"
	local ammoType = self:GetPrimaryAmmoType()
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() + 2 )
	self:SetNextSecondaryFire( CurTime() + 2 )
	self:EmitSound( ExtractArmor )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	if (IsValid( self.Owner ) && (self.Owner:Armor() >= self.Owner:GetMaxArmor()) ) then
	 vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )
	 
	 if SERVER then 
     self.Owner:SetArmor( 0 )
	 self.Owner:GiveAmmo(1, ammoType, true)
	 end
	
	 self:SetNextSecondaryFire( CurTime() + self:SequenceDuration() + 1 )
	 
	elseif(IsValid( self.Owner ) && self.Owner:Armor() <= (self.Owner:GetMaxArmor() - MaxArmor) && self.Owner:Armor() >= MaxArmor ) then

	 vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )
	 
	 if SERVER then 
     self.Owner:SetArmor( 0 )
	 end
	 
	 self:SetNextSecondaryFire( CurTime() + self:SequenceDuration() + 2 )	 
	end	
end


function SWEP:OnDrop()

end

function SWEP:Think()

end

function SWEP:DrawHUD() -- Вообще этот парт нахуй тут не нужен но мне было нехуй делать.
   if CLIENT then
    local ourMat = Material( "models/plate/HUD_Plate" )
    surface.SetFont( "BudgetLabel" )

    if (self:Clip1() <= 0) && (self:Ammo1() <= 0) then surface.SetTextColor( 255, 0, 0 ) else surface.SetTextColor( 255, 255, 255 ) end

    surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( ourMat ) 
	surface.DrawTexturedRect( ScrW() / 2.1, ScrH() / 1.1, 64, 64 ) 
	
	surface.SetTextPos( ScrW() / 2.0, ScrH() / 1.099 ) 
	surface.DrawText( self:Clip1() .. " In hands" )
	surface.SetTextPos( ScrW() / 2.0, ScrH() / 1.086 ) 
	surface.DrawText( "--" )
	surface.SetTextPos( ScrW() / 2.0, ScrH() / 1.074 ) 
	surface.DrawText( self:Ammo1() .. " In ammo")
	end
end

function SWEP:OnDrop()

	self:Remove()

end