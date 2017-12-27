local MyHeader = class("MyHeader",function()
    return cc.Layer:create()
end)

local U_layer

function MyHeader:init(posiX,posiY,width,height)
   
    display.loadSpriteFrames("public_ui.plist","public_ui.png")
   
    self:setPosition(cc.p(posiX,posiY))

    -- 200 , 100
    U_layer = cc.LayerColor:create(cc.c4b(10,10,10,180))    
    U_layer:setContentSize(cc.size(width,height))
    U_layer:setPosition(cc.p(display.cx,display.cy))
    U_layer:setIgnoreAnchorPointForPosition(false)

    local bgSp = ccui.ImageView:create()
    bgSp:loadTexture("headVer_icon.png",0)
    bgSp:setTouchEnabled(false)
    bgSp:setScale9Enabled(true)
    bgSp:setContentSize(cc.size(width,height))
    bgSp:setAnchorPoint(cc.p(0,0))
    bgSp:setPosition(cc.p(0,0))
    U_layer:addChild(bgSp)

    local head = cc.Sprite:createWithSpriteFrame(display.newSpriteFrame("head_img_female.png"))
    head:setContentSize(cc.size(height-20,height-20))
    head:setPosition(cc.p(10,10))
    head:setAnchorPoint(cc.p(0,0))
    U_layer:addChild(head)

    local name = cc.LabelTTF:create("赌神发哥","","20",cc.size(width - height-5, 0), cc.TEXT_ALIGNMENT_LEFT) 
    name:setAnchorPoint(cc.p(0,1))
    name:setContentSize(cc.size(width - height-5,20))
    name:setColor(cc.c3b(255,255,255))
    name:setPosition(cc.p(height,height-20))
    name:setTag(1)
    U_layer:addChild(name)

    local moneyIcon = ccui.ImageView:create()
    moneyIcon:loadTexture("money.png",0)
    moneyIcon:setTouchEnabled(false)
    moneyIcon:setContentSize(cc.size(24,24))
    moneyIcon:setAnchorPoint(cc.p(0,1))
    moneyIcon:setPosition(cc.p(height,height-50))
    U_layer:addChild(moneyIcon)
    
    local money = cc.LabelTTF:create("99999","","20",cc.size(width - height-30, 0), cc.TEXT_ALIGNMENT_LEFT) 
    money:setAnchorPoint(cc.p(0,1))
    money:setContentSize(cc.size(width - height-30,20))
    money:setColor(cc.c3b(246,246,66))
    money:setPosition(cc.p(height+24,height-50))
    money:setTag(2)
    U_layer:addChild(money)

    self:addChild(U_layer)
end

--传入table={} name，money
function MyHeader:setUserInfo(table)
    local name = U_layer:getChildByTag(1)
    name:setString(table["name"])
    local money = U_layer:getChildByTag(2)
    money:setString(table["money"])
end

return MyHeader