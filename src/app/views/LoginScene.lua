
local AudioManager = import (".NNManager.AudioManager")

local LoginScene = class("LoginScene",cc.load("mvc").ViewBase)


-- 配置屏幕尺寸
LoginScene.SCREEN_SIZE = cc.Director:getInstance():getWinSize()
LoginScene.SCREEN_WIDTH = cc.Director:getInstance():getWinSize().width
LoginScene.SCREEN_HEIGHT = cc.Director:getInstance():getWinSize().height
LoginScene.CENTER_X = cc.Director:getInstance():getWinSize().width/2
LoginScene.CENTER_Y = cc.Director:getInstance():getWinSize().height/2

-- local Util = require "app.views.SceneClass.Util"

function LoginScene:onCreate()
    print("this is loginscence！！！")    

    --AudioManager:getInstance()
    -- audioManager:playBackgroundMusic()


    local layer = cc.LayerColor:create(cc.c4b(255, 255, 255, 255))
    layer:setPosition(cc.p(display.cx,display.cy))
    layer:setIgnoreAnchorPointForPosition(false)--设置锚点默认为（0.5，0.5）
    layer:setContentSize(cc.size(cc.Director:getInstance():getWinSize().width,cc.Director:getInstance():getWinSize().height))
    self:addChild(layer)


   

    -- 背景图
    local bg = cc.Sprite:create("bg_login@2x.png")
    bg:setContentSize(LoginScene.SCREEN_SIZE)
    bg:setAnchorPoint(cc.p(0,0))
    self:addChild(bg)


    -- local titleLab = cc.Label:createWithSystemFont("欢乐牛牛","Arial","70")
    -- titleLab:setColor(cc.c3b(250,250,210))
    -- titleLab:setPosition(cc.p(LoginScene.SCREEN_WIDTH/2,LoginScene.SCREEN_HEIGHT-250))
    -- titleLab:setContentSize(cc.size(LoginScene.SCREEN_WIDTH-200,20))
    -- self:addChild(titleLab)

    -- local spritelu = cc.Sprite:create("sp_sprite.png")
    -- spritelu:setPosition(cc.p(display.cx-200,display.cy+100))
    -- spritelu:setContentSize(cc.size(256,256))
    -- self:addChild(spritelu)
 
    -- 跳转到homepage
    local popScene = function()
        print("跳转执行")
        AudioManager:getInstance():playButtonMusic()

        local homeScene = self:getApp():getSceneWithName("HomeScene")
        local transition = cc.TransitionFade:create(0.3,homeScene)  
        cc.Director:getInstance():replaceScene(transition)  
    end 

    -- 登陆按钮
    local function loginClick(node,type)

        if type == ccui.TouchEventType.began then

            -- ScaleTo，第一个参数是缩放时间，第二个参数为缩放因子  
            local action1 = cc.ScaleTo:create(0.15, 1.2)
            local action2 = cc.ScaleTo:create(0.1,1)
            -- 执行动作序列
            node:runAction(cc.Sequence:create(action1, action2, cc.CallFunc:create(popScene)))

        elseif type == ccui.TouchEventType.ended then
            --print("点击了按钮")            
        end
    end

    local loginButton = ccui.Button:create()
    loginButton:setTouchEnabled(true)
    loginButton:loadTextures("button_wechat.png","button_wechat.png","")
    loginButton:setPosition(cc.p(LoginScene.SCREEN_WIDTH/2,130))
    loginButton:setContentSize(cc.size(150, 50))
    loginButton:addTouchEventListener(loginClick) 
    self:addChild(loginButton)

    -- 同意许可
    local agreeButton = ccui.Button:create()
    agreeButton:setTouchEnabled(true)
    agreeButton:loadTextures("button_noselected@2x.png","button_noselected@2x.png","")
    agreeButton:setPosition(cc.p(LoginScene.SCREEN_WIDTH/3,50))
    agreeButton:setContentSize(cc.size(40, 40))
    agreeButton:addTouchEventListener(function(node,type)
        if type == ccui.TouchEventType.began then
            
        end
    end) 
    self:addChild(agreeButton)
    

    local agreeLab = cc.Label:createWithSystemFont("我已详细阅读并同意","Arial","16")
    agreeLab:setColor(cc.c3b(255,255,255))
    agreeLab:setAnchorPoint(cc.p(0,0.5))
    agreeLab:setPosition(cc.p(LoginScene.SCREEN_WIDTH/3+25,50))
    agreeLab:setContentSize(cc.size(140,20))
    self:addChild(agreeLab)

    local protoclButton = ccui.Button:create()
    protoclButton:setTouchEnabled(true)
    protoclButton:loadTextures("", "", "")
    protoclButton:setTitleText("《云暴游戏使用许可服务协议》")
    protoclButton:setTitleColor(cc.c3b(0,0,255))
    protoclButton:setTitleFontSize(16.0)
    protoclButton:setPosition(cc.p(LoginScene.SCREEN_WIDTH/3+25+140,50))
    protoclButton:setAnchorPoint(cc.p(0,0.5))
    protoclButton:setContentSize(cc.size(180, 30))
    protoclButton:addTouchEventListener(function (sender,event)  
        if event==ccui.TouchEventType.began then

            protoclButton:setTouchEnabled(false)
            loginButton:setTouchEnabled(false)
            -- 展示alert
            
            local bgLayer = cc.LayerColor:create(cc.c4b(0,0,0,120))
            bgLayer:setPosition(cc.p(display.cx,display.cy))
            bgLayer:setContentSize(LoginScene.SCREEN_SIZE)
            bgLayer:setIgnoreAnchorPointForPosition(false)--设置锚点默认为（0.5，0.5）
            self:addChild(bgLayer)

            -- local eventDispatcher = self:getEventDispatcher()
            --     local function onTouchBegan(touch, event)
            --         bgLayer:removeFromParent()
            --     return false   
            -- end

            -- local listener = cc.EventListenerTouchOneByOne:create()
            -- listener:setSwallowTouches(true)
            -- eventDispatcher:addEventListenerWithSceneGraphPriority(listener, bgLayer)
        

            -- local alertSp = cc.Sprite:create("alert.png")
            -- alertSp:setPosition(cc.p(display.cx,display.cy))
            -- alertSp:setContentSize(cc.size(800,497))
            -- bgLayer:addChild(alertSp)

            local okBtn = ccui.Button:create()
            okBtn:setTouchEnabled(true)
            okBtn:loadTextures("alert.png", "alert.png", "")
            okBtn:setContentSize(cc.size(800,497))
            okBtn:addTouchEventListener(function (sender,event)
                if event==ccui.TouchEventType.began then
                    protoclButton:setTouchEnabled(true)
                    loginButton:setTouchEnabled(true)
                    bgLayer:removeFromParent()
                end
            end)
            okBtn:setPosition(cc.p(display.cx,display.cy))
            bgLayer:addChild(okBtn)

        end
    end) 
    self:addChild(protoclButton)

    local skeletonNode = sp.SkeletonAnimation:create("spineboy.json", "spineboy.atlas",0.5)

    --skeletonNode:setMix("walk", "jump", 0.2)
    --skeletonNode:setMix("jump", "run", 0.2)
    --skeletonNode:setAnimation(0, "walk", true)

    --skeletonNode:addAnimation(0, "jump", false, 3)
    --skeletonNode:addAnimation(0, "run", true)

    skeletonNode:addAnimation(0, "walk", true)

    skeletonNode:setPosition(cc.p(display.cx-200,display.cy-100))
    self:addChild(skeletonNode)


end

function LoginScene:onEnter()
    --播放背景音乐文件
    AudioManager:getInstance():playBackgroundMusic()
end

return LoginScene