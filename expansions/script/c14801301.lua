--奥特战士 初代
local m=14801301
local cm=_G["c"..m]
function cm.initial_effect(c)
    --end battle phase
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(cm.condition)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
    --search itself
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,m)
    e2:SetCost(cm.cost)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
    --to hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,2))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetCountLimit(1,m)
    e3:SetCondition(cm.spcon)
    e3:SetTarget(cm.target2)
    e3:SetOperation(cm.operation2)
    c:RegisterEffect(e3)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttacker()
    return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then
    c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetLabelObject(c)
        e1:SetCondition(cm.descon)
        e1:SetOperation(cm.desop)
        Duel.RegisterEffect(e1,tp)
    end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc:GetFlagEffect(m)~=0 then
        return true
    else
        e:Reset()
        return false
    end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() and Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(1,0)
    e1:SetValue(cm.aclimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.aclimit(e,re,tp)
    return re:IsActiveType(TYPE_MONSTER) and not (re:GetHandler():IsSetCard(0x4808) and re:IsActiveType(TYPE_MONSTER))
end
function cm.thfilter(c)
    return c:IsSetCard(0x4808) and not c:IsCode(m) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp,chk)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp))
        and c:IsPreviousPosition(POS_FACEUP)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function cm.filter1(c)
    return c:IsSetCard(0x4808) and not c:IsCode(m) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.filter2(c,e,tp)
    return c:IsSetCard(0x4808) and not c:IsCode(m) and c:IsType(TYPE_MONSTER)
        and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE))
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local b=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
    if not b then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        local tc=g:GetFirst()
        if tc then
            if not tc:IsAbleToHand() or (tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
                and Duel.SelectYesNo(tp,aux.Stringid(m,3))) then
                Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
            else
                Duel.SendtoHand(tc,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,tc)
            end
        end
    end
end