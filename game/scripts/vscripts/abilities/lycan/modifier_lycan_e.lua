modifier_lycan_e = class({})
self = modifier_lycan_e
self.itsTimeToStop = 0

if IsServer() then
    function modifier_lycan_e:OnCreated()
        self.bleedingOccured = LycanUtil.IsBleeding(self:GetParent():GetParentEntity())

        local unit = self:GetParent()

        unit:Interrupt()
        self.direction = (unit:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
        self:StartIntervalThink(0.1)
        self:OnIntervalThink()
    end

    function modifier_lycan_e:OnIntervalThink()
        if self.itsTimeToStop >= 3 then
            self:Destroy()
        end
        local unit = self:GetParent()
        local position = unit:GetAbsOrigin() + self.direction * 500

        unit:MoveToPosition(position)
    end
end

function modifier_lycan_e:OnDestroy()
    if IsServer() and self.bleedingOccured then
        local hero = self:GetCaster().hero
        local target = self:GetParent().hero

        if LycanUtil.IsTransformed(hero) then
            target:AddNewModifier(hero, self:GetAbility(), "modifier_silence_lua", { duration = 2.5 })
        end
    end
end

function modifier_lycan_e:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_lycan_e:GetEffectName()
    return "particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void.vpcf"
end
 
function modifier_lycan_e:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
 
function modifier_lycan_e:CheckState()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_INVISIBLE] = false
    }
 
    return state
end

function modifier_lycan_e:GetModifierMoveSpeedBonus_Percentage(params)
    return -20
end

function modifier_lycan_e:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_lycan_e:OnDamageReceived(source, hero, amount)
    self.itsTimeToStop = self.itsTimeToStop + amount
    return amount
end