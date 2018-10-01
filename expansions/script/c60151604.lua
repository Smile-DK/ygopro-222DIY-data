--夜空下的思念 鹿目圆香
function c60151604.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --
    local e11=Effect.CreateEffect(c)
    e11:SetCategory(CATEGORY_RECOVER+CATEGORY_ATKCHANGE)
    e11:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCode(EVENT_CHAIN_ACTIVATING)
    e11:SetOperation(c60151604.disop)
    c:RegisterEffect(e11)
    --negate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60151604,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
    e1:SetCountLimit(1,60151604)
    e1:SetCondition(c60151604.condition)
    e1:SetTarget(c60151604.target)
    e1:SetOperation(c60151604.operation)
    c:RegisterEffect(e1)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60151604,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCountLimit(1,6011604)
    e3:SetTarget(c60151604.sptg)
    e3:SetOperation(c60151604.spop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetCondition(c60151604.spcondition)
    c:RegisterEffect(e4)
end
function c60151604.spcondition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c60151604.filter(c)
    return c:IsFaceup() and c:IsSetCard(0xcb25) and c:IsType(TYPE_MONSTER)
end
function c60151604.disop(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp or not (re:IsActiveType(TYPE_MONSTER) and re:IsActivated()) then return end
    Duel.Hint(HINT_CARD,0,60151604)
    Duel.Recover(tp,300,REASON_EFFECT)
    local g=Duel.GetMatchingGroup(c60151604.filter,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(100)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end
function c60151604.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=re:GetHandler()
    return re:IsActiveType(TYPE_MONSTER) and re:IsActivated() and rc:IsSetCard(0xcb25)
end
function c60151604.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if e:GetHandler():IsLocation(LOCATION_EXTRA) then
        if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    else
        if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    end
end
function c60151604.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        if c:GetSummonLocation()==LOCATION_EXTRA then
            local e1=Effect.CreateEffect(c)
            e1:SetDescription(aux.Stringid(60151601,0))
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
            e1:SetReset(RESET_EVENT+0x47e0000)
            e1:SetValue(LOCATION_REMOVED)
            c:RegisterEffect(e1,true)
        end
    end
end
function c60151604.filter3(c,e,tp)
    return c:IsSetCard(0xcb25) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151604.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and Duel.IsExistingMatchingCard(c60151604.filter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c60151604.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c60151604.filter3),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end