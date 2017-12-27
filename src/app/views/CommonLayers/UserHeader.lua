--用户头像
local UserHeader = class("UserHeader",function() 
    return cc.Layer:create() 
end)

local head
local U_layer

function UserHeader:init(posiX,posiY,width,height)

    display.loadSpriteFrames("public_ui.plist","public_ui.png")
    
    self:setPosition(cc.p(posiX,posiY))

    local otherW = width
    local otherH = height
    
    U_layer = cc.LayerColor:create(cc.c4b(10,10,10,180))
    U_layer:setContentSize(cc.size(otherW,otherH))
    U_layer:setPosition(cc.p(display.cx,display.cy))
    U_layer:setIgnoreAnchorPointForPosition(false)

    local bgSp = ccui.ImageView:create()
    bgSp:loadTexture("head_icon.png",0)
    bgSp:setTouchEnabled(false)
    bgSp:setScale9Enabled(true)
    bgSp:setContentSize(cc.size(otherW,otherH))
    bgSp:setAnchorPoint(cc.p(0,0))
    bgSp:setPosition(cc.p(0,0))
    U_layer:addChild(bgSp)

    head = cc.Sprite:createWithSpriteFrame(display.newSpriteFrame("head_img_female.png"))
    head:setContentSize(cc.size(otherW-20,otherW-20))
    head:setPosition(cc.p(10,otherH-10))
    head:setAnchorPoint(cc.p(0,1))
    U_layer:addChild(head)

    local name = cc.LabelTTF:create("赌神","","16",cc.size(otherW-10, 0), cc.TEXT_ALIGNMENT_CENTER) 
    name:setAnchorPoint(cc.p(0.5,1))
    name:setContentSize(cc.size(otherW-10,16))
    name:setColor(cc.c3b(255,255,255))
    name:setPosition(cc.p(otherW/2,otherH-otherW))
    name:setTag(1)
    U_layer:addChild(name)
    
    local money = cc.LabelTTF:create("99999","","16",cc.size(otherW-10, 0), cc.TEXT_ALIGNMENT_CENTER) 
    money:setAnchorPoint(cc.p(0.5,1))
    money:setContentSize(cc.size(otherW-10,16))
    money:setColor(cc.c3b(246,246,66))
    money:setPosition(cc.p(otherW/2,otherH-otherW-20))
    money:setTag(2)
    U_layer:addChild(money)

    self:addChild(U_layer)
end

--设置用户头像
function UserHeader:setUHeaderFrame(imgFrame)
    head:setSpriteFrame(imgFrame)
end

--传入table={} name，money
function UserHeader:setUserInfo(table)
    local nameLab = U_layer:getChildByTag(1)
    nameLab:setString(table["name"])
    local moneyLab = U_layer:getChildByTag(2)
    moneyLab:setString(table["money"])
end


return UserHeader