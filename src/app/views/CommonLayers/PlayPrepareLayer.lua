local PlayPrepareLayer = class("PlayPrepareLayer",function()
    return cc.Layer:create()
end)

local SCREEN_WIDTH = cc.Director:getInstance():getWinSize().width

local Posi_tab = {cc.p(display.cx,80),cc.p(280,270),cc.p(280,470),cc.p(SCREEN_WIDTH-280,470),cc.p(SCREEN_WIDTH-280,270)}

function PlayPrepareLayer:init(NumCount)
    if NumCount and NumCount>0 then
        for i=2,NumCount do 
            local prepareBtn = cc.Label:createWithSystemFont("已准备","","20")
            prepareBtn:setColor(cc.c3b(50,255,50))
            prepareBtn:setContentSize(cc.size(120,20))
            prepareBtn:setPosition(Posi_tab[i])
            self:addChild(prepareBtn)
        end
    end

    --设置我的准备按钮
    local mineBtn = ccui.Button:create()
    mineBtn:loadTextures("button_prepare.png","button_prepare.png","")
    mineBtn:setContentSize(cc.size(150,64))
    mineBtn:setPosition(Posi_tab[1])
    self:addChild(mineBtn)
    mineBtn:addTouchEventListener(function(sender,event)
        if event==ccui.TouchEventType.began then
            --点击按钮发送通知
            --发送自定义事件
            local myEvent = cc.EventCustom:new("prepare")
            local eventDispatch = cc.Director:getInstance():getEventDispatcher()
            eventDispatch:dispatchEvent(myEvent)
        end
    end)
    
end


return PlayPrepareLayer