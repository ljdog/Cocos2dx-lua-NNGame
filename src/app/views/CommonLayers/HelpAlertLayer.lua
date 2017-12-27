

local SCREEN_WIDTH = cc.Director:getInstance():getWinSize().width
local SCREEN_HEIGHT = cc.Director:getInstance():getWinSize().height

local HelpAlertLayer = class("HelpAlertLayer",function()
    return cc.Layer:create()
end)

local alertLayer

function HelpAlertLayer:init()
    
    display.loadSpriteFrames("setting.plist","setting.png")
    display.loadSpriteFrames("public_ui.plist","public_ui.png")

    --默认锚点在中心
    self:setIgnoreAnchorPointForPosition(false)
    self:setTouchEnabled(true)

    local bgLayer = cc.LayerColor:create(cc.c4b(0,0,0,120))
    bgLayer:setPosition(cc.p(0,0))
    bgLayer:setContentSize(cc.size(SCREEN_WIDTH,SCREEN_HEIGHT))
    self:addChild(bgLayer)

    alertLayer = cc.LayerColor:create(cc.c4b(255,255,255,0))
    alertLayer:setIgnoreAnchorPointForPosition(false)
    alertLayer:setPosition(cc.p(display.cx,display.cy))
    alertLayer:setContentSize(cc.size(SCREEN_WIDTH/2,SCREEN_HEIGHT-200))
    alertLayer:setScale(0.01)
    self:addChild(alertLayer)

    local sprite = cc.Sprite:createWithSpriteFrame(display.newSpriteFrame("setting8.png"))
    sprite:setContentSize(cc.size(SCREEN_WIDTH/2,SCREEN_HEIGHT-200))
    sprite:setPosition(cc.p(0,0))
    sprite:setAnchorPoint(cc.p(0,0))
    alertLayer:addChild(sprite)

    local tips = cc.Label:createWithSystemFont("帮助","","30")
    tips:setPosition(cc.p(alertLayer:getContentSize().width/2,SCREEN_HEIGHT-200-50))
    tips:setContentSize(cc.size(SCREEN_WIDTH/3-20,30))
    tips:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    tips:setAnchorPoint(cc.p(0.5,0.5))
    tips:setColor(cc.c3b(255,255,255))
    tips:setTag(1)
    alertLayer:addChild(tips)


    local content = cc.Label:createWithSystemFont("有问题请致电：110 或 120","","20",cc.size(SCREEN_WIDTH/2-60, 0), cc.TEXT_ALIGNMENT_CENTER)
    content:setPosition(cc.p(30,SCREEN_HEIGHT/2-100))
    content:setContentSize(cc.size(SCREEN_WIDTH/2-60,SCREEN_HEIGHT-300))
    content:setAnchorPoint(cc.p(0,0.5))
    content:setColor(cc.c3b(40,40,255))
    alertLayer:addChild(content)


    local confirmBtn = ccui.Button:create()
    confirmBtn:loadTextures("public_btn_ok.png","public_btn_ok.png","",1)
    confirmBtn:setPosition(cc.p(alertLayer:getContentSize().width/2,60))
    confirmBtn:setContentSize(cc.size(150, 50))
    confirmBtn:setScale(0.8)
    confirmBtn:addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.began then
            --handOut:setTouchEnabled(false)
            self:close()
        end
    end)
    alertLayer:addChild(confirmBtn)


end

function HelpAlertLayer:ShowAnimation()
    local scale = cc.ScaleTo:create(0.15,1.2)
    local scale2 = cc.ScaleTo:create(0.1,1)
    alertLayer:runAction(cc.Sequence:create(scale,scale2))
end

function HelpAlertLayer:close()
    local scale = cc.ScaleTo:create(0.2,0.01)
    local myfunc = function()
        self:removeFromParentAndCleanup(true)
        --发送自定义事件
        local myEvent = cc.EventCustom:new("resultDismiss")
        local customEventDispatch=cc.Director:getInstance():getEventDispatcher() 
        customEventDispatch:dispatchEvent(myEvent)  

    end
    alertLayer:runAction(cc.Sequence:create(scale,cc.CallFunc:create(myfunc)))
end

return HelpAlertLayer