

local SCREEN_WIDTH = cc.Director:getInstance():getWinSize().width
local SCREEN_HEIGHT = cc.Director:getInstance():getWinSize().height

local SetAlertLayer = class("SetAlertLayer",function()
    return cc.Layer:create()
end)

local alertLayer

function SetAlertLayer:init()
    
    display.loadSpriteFrames("setting.plist","setting.png")

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

    local tips = cc.Label:createWithSystemFont("设置","","30")
    tips:setPosition(cc.p(alertLayer:getContentSize().width/2,SCREEN_HEIGHT-200-50))
    tips:setContentSize(cc.size(SCREEN_WIDTH/3-20,30))
    tips:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    tips:setAnchorPoint(cc.p(0.5,0.5))
    tips:setColor(cc.c3b(255,255,255))
    tips:setTag(1)
    alertLayer:addChild(tips)

    local bgMusicLab = cc.Label:createWithSystemFont("音量","","26")
    bgMusicLab:setPosition(cc.p(80,alertLayer:getContentSize().height/2+30))
    bgMusicLab:setContentSize(cc.size(120,30))
    bgMusicLab:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    bgMusicLab:setAnchorPoint(cc.p(0.5,0.5))
    bgMusicLab:setColor(cc.c3b(0,0,0))
    alertLayer:addChild(bgMusicLab)


    local function durationSliderChangedEvent(sender,eventType)
        --print(sender:getPercent())

        --发送事件
        local myEvent = cc.EventCustom:new("setAlert")
        myEvent._usedata = {value = sender:getPercent()}
        local myEventDispatch = cc.Director:getInstance():getEventDispatcher()
        myEventDispatch:dispatchEvent(myEvent)
        
    end

    local durationSlider = ccui.Slider:create()
    durationSlider:setPercent(80)
    durationSlider:setTag(10)
    durationSlider:setTouchEnabled(true)
    durationSlider:setScale9Enabled(true)
    durationSlider:setCapInsets(cc.rect(15,15))
    durationSlider:loadBarTexture("slider-bac.png")
    durationSlider:loadSlidBallTextures("slider-default.png", "slider-default.png", "")
    durationSlider:loadProgressBarTexture("slider-cover.png")
    durationSlider:setAnchorPoint(cc.p(0,0.5))
    durationSlider:setPosition(cc.p(150,alertLayer:getContentSize().height/2+30))
    durationSlider:setContentSize(cc.size(alertLayer:getContentSize().width-200,10))
    durationSlider:addEventListener(durationSliderChangedEvent)
    alertLayer:addChild(durationSlider)



   
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

function SetAlertLayer:setVolumePercent(value)
    local slider = alertLayer:getChildByTag(10)
    slider:setPercent(value)
end

function SetAlertLayer:ShowAnimation()
    local scale = cc.ScaleTo:create(0.15,1.2)
    local scale2 = cc.ScaleTo:create(0.1,1)
    alertLayer:runAction(cc.Sequence:create(scale,scale2))
end

function SetAlertLayer:close()
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

return SetAlertLayer