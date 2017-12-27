local AudioManager = import (".NNManager.AudioManager")
local UserDefaultManager = import (".NNManager.UserDefaultManager")
local MsgAlertLayer = import (".CommonLayers.MsgAlertLayer")
local HelpAlertLayer = import (".CommonLayers.HelpAlertLayer")
local SetAlertLayer = import (".CommonLayers.SetAlertLayer")
local HomeMode = import(".Model.HomeMode")

local HomeScene = class("HomeScene",cc.load("mvc").ViewBase)

local SCREEN_WIDTH = cc.Director:getInstance():getWinSize().width
local SCREEN_HEIGHT = cc.Director:getInstance():getWinSize().height

function HomeScene:onCreate()
    --加载home资源文件  
    display.loadSpriteFrames("main_scene.plist","main_scene.png")
    display.loadSpriteFrames("public_ui.plist","public_ui.png")
    
    self:setViews()

    --注册音量修改监听事件
    self:registSetMusicVolume()
end

function HomeScene:onEnter()
    --播放背景音乐文件
    AudioManager:getInstance():playBackgroundMusic()
end


function HomeScene:setViews()

    local layer = cc.LayerColor:create(cc.c4b(255, 255, 255, 255))
    layer:setPosition(cc.p(display.cx,display.cy))
    layer:setIgnoreAnchorPointForPosition(false)--设置锚点默认为（0.5，0.5）
    layer:setContentSize(cc.size(cc.Director:getInstance():getWinSize().width,cc.Director:getInstance():getWinSize().height))
    self:addChild(layer)

    -- 背景图
    local bg = cc.Sprite:create("bg_home@2x.png")
    bg:setContentSize(cc.Director:getInstance():getWinSize())
    bg:setAnchorPoint(cc.p(0,0))
    self:addChild(bg)

    --topLayer
    local topView = cc.LayerColor:create(cc.c4b(0,0,0,0))
    topView:setPosition(cc.p(display,cx,SCREEN_HEIGHT-50))
    topView:setAnchorPoint(cc.p(0.5,0.5))
    topView:setContentSize(cc.size(SCREEN_WIDTH,100))
    self:addChild(topView)

    --topbg
    local topBG = cc.Sprite:create("top_bar.png")
    topBG:setContentSize(cc.size(SCREEN_WIDTH,100))
    topBG:setPosition(cc.p(SCREEN_WIDTH/2,SCREEN_HEIGHT-50))
    topView:addChild(topBG)
    
    --topheaderimage
    local imgIcon = ccui.ImageView:create()
    imgIcon:loadTexture("head_img_female.png",1)
    imgIcon:setTouchEnabled(true)
    imgIcon:setContentSize(cc.size(70,70))
    imgIcon:setPosition(cc.p(60,SCREEN_HEIGHT-45))
    imgIcon:setScale(0.6)
    topView:addChild(imgIcon)
    imgIcon:addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.began then
            --返回登陆页面
            local LoginScene = self:getApp():getSceneWithName("LoginScene")
            local transition = cc.TransitionFade:create(0.3,LoginScene)  
            cc.Director:getInstance():replaceScene(transition)
        end
    end)

    --topHeaderFrame
    local topHeaderFrame = cc.Sprite:createWithSpriteFrame(display.newSpriteFrame("public_frame_head.png"))
    topHeaderFrame:setContentSize(cc.size(74,74))
    topHeaderFrame:setPosition(cc.p(60,SCREEN_HEIGHT-45))
    topView:addChild(topHeaderFrame)

    local nameLab = cc.LabelTTF:create("雾岛桐人1997","","25")
    nameLab:setColor(cc.c3b(0,120,255))
    nameLab:setAnchorPoint(cc.p(0,1))
    nameLab:setPosition(cc.p(100,SCREEN_HEIGHT-15))
    nameLab:setContentSize(cc.size(150,25))
    topView:addChild(nameLab)
    
    local fkSp = cc.Sprite:createWithSpriteFrame(display.newSpriteFrame("card.png"))
    fkSp:setAnchorPoint(cc.p(0,1))
    fkSp:setPosition(cc.p(100,SCREEN_HEIGHT-50))
    fkSp:setContentSize(cc.size(60,30))
    topView:addChild(fkSp)

    local fkNum = cc.LabelTTF:create("99999","","25")
    fkNum:setColor(cc.c3b(255,215,0))
    fkNum:setAnchorPoint(cc.p(0,1))
    fkNum:setPosition(cc.p(170,SCREEN_HEIGHT-50))
    fkNum:setContentSize(cc.size(100,25))
    topView:addChild(fkNum) 

    local addFkBtn = cc.Sprite:createWithSpriteFrame(display.newSpriteFrame("goumaixiaojiahao.png"))
    addFkBtn:setContentSize(cc.size(30,30))
    addFkBtn:setAnchorPoint(cc.p(0,1))
    addFkBtn:setPosition(cc.p(270,SCREEN_HEIGHT-50))
    topView:addChild(addFkBtn)
    
    --消息
    local msgBtn = ccui.Button:create()
    msgBtn:setTouchEnabled(true)
    msgBtn:loadTextures("xiao'xi.png","xiao'xi.png","",1)
    msgBtn:setScale(0.8)
    msgBtn:setPosition(cc.p(SCREEN_WIDTH-180,SCREEN_HEIGHT-50))
    msgBtn:setContentSize(cc.size(50, 60))
    msgBtn:setAnchorPoint(cc.p(1,0.5))
    topView:addChild(msgBtn)
    msgBtn:addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.began then
            print("消息点击了")
            AudioManager:getInstance():playAlertMusic()

            local msgAlert = MsgAlertLayer.new()
            msgAlert:init()
            msgAlert:setPosition(cc.p(display.cx,display.cy))
            self:addChild(msgAlert)
            msgAlert:ShowAnimation()
        end
    end)


    --帮助
    local helpBtn = ccui.Button:create()
    helpBtn:setTouchEnabled(true)
    helpBtn:loadTextures("bangzhu.png","bangzhu.png","",1)
    helpBtn:setScale(0.8)
    helpBtn:setPosition(cc.p(SCREEN_WIDTH-110,SCREEN_HEIGHT-50))
    helpBtn:setContentSize(cc.size(50, 60))
    helpBtn:setAnchorPoint(cc.p(1,0.5))
    topView:addChild(helpBtn)
    helpBtn:addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.began then
            print("帮助点击了")
            AudioManager:getInstance():playAlertMusic()

            local helpAlert = HelpAlertLayer.new()
            helpAlert:init()
            helpAlert:setPosition(cc.p(display.cx,display.cy))
            self:addChild(helpAlert)
            helpAlert:ShowAnimation()
        end
    end)


    --设置
    local setBtn = ccui.Button:create()
    setBtn:setTouchEnabled(true)
    setBtn:loadTextures("shezhi.png","shezhi.png","",1)
    setBtn:setScale(0.8)
    setBtn:setPosition(cc.p(SCREEN_WIDTH-40,SCREEN_HEIGHT-50))
    setBtn:setContentSize(cc.size(50, 60))
    setBtn:setAnchorPoint(cc.p(1,0.5))
    topView:addChild(setBtn)
    setBtn:addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.began then
            AudioManager:getInstance():playAlertMusic()

            print("设置点击了")

            --获取用户设置的音量
            local volume = UserDefaultManager.getBackgroundVolume()
            
            local setAlert = SetAlertLayer.new()
            setAlert:init()
            setAlert:setPosition(cc.p(display.cx,display.cy))
            setAlert:setVolumePercent(volume)--设置默认音量为60或者用户设置的音量
            self:addChild(setAlert)
            setAlert:ShowAnimation()

        end
    end)


    --公告
    local noticeLayer = cc.LayerColor:create(cc.c4b(110,110,110,0))
    noticeLayer:setIgnoreAnchorPointForPosition(false)--设置锚点默认为（0.5，0.5）
    noticeLayer:setContentSize(cc.size(SCREEN_HEIGHT*4/9,SCREEN_HEIGHT*5/9))
    noticeLayer:setPosition(cc.p(300,display.cy))
    self:addChild(noticeLayer)

    --公告背景图
    local noticeBg = cc.Sprite:create("notice.png")
    noticeBg:setPosition(cc.p(SCREEN_HEIGHT*4/9/2,SCREEN_HEIGHT*5/9/2))
    noticeBg:setContentSize(cc.size(SCREEN_HEIGHT*4/9,SCREEN_HEIGHT*5/9))
    noticeLayer:addChild(noticeBg)

    --公告Scroll
    local scrollview=ccui.ScrollView:create() 
    scrollview:setTouchEnabled(true) 
    scrollview:setBounceEnabled(true) --这句必须要不然就不会滚动噢 
    scrollview:setDirection(ccui.ScrollViewDir.vertical) --设置滚动的方向 
    scrollview:setContentSize(cc.size(noticeBg:getContentSize().width-60,noticeBg:getContentSize().height-120)) --设置尺寸 
    scrollview:setPosition(cc.p(30,SCREEN_HEIGHT*5/9-70))
    scrollview:setAnchorPoint(cc.p(0,1))
    scrollview:setScrollBarWidth(5) --滚动条的宽度 
    scrollview:setScrollBarColor(cc.BLUE) --滚动条的颜色 
    scrollview:setScrollBarPositionFromCorner(cc.p(2,2)) 
    noticeLayer:addChild(scrollview) --这里我是加在层上的你可以直接self:addChild(scrollview)

    local innerWidth = noticeBg:getContentSize().width-10
    local innerHeight = noticeBg:getContentSize().height
    --设置内容尺寸
    scrollview:setInnerContainerSize(cc.size(innerWidth,innerHeight))

    local content = cc.LabelTTF:create("牛牛游戏，又名“斗牛”游戏。是流行于浙南一带的游戏。该游戏由2到5人玩一副牌（54张），其中一家为庄家，其余为闲家，发完牌后即可开牌比牌，庄家与所有闲家一一进行比较，牌型大者为赢，牌型小者为输。","","20",cc.size(innerWidth-60, 0), cc.TEXT_ALIGNMENT_CENTER) --创建一个label加在scrollview上
    content:setPosition(cc.p(5,innerHeight))
    content:setAnchorPoint(cc.p(0,1))
    content:setContentSize(cc.size(innerWidth,innerHeight))
    content:setColor(cc.c3b(255,255,255))
    scrollview:addChild(content)


    -- --跳转之前的动画
    local function enterAnimation(leftLayer,rightLayer)
        local rightLayerAction = cc.MoveBy:create(0.6, cc.p(800, 0))
        local leftLayerAction = cc.MoveBy:create(0.6, cc.p(-800, 0))
        -- local spawn = cc.Spawn:create(leftLayerAction, rightLayerAction)
        local function pushPlayScene()
            print("跳转执行")
            local homeScene = self:getApp():getSceneWithName("PlayScene")
            local transition = cc.TransitionFade:create(0.3,homeScene)  
            cc.Director:getInstance():replaceScene(transition)
        end
        leftLayer:runAction(cc.Sequence:create(leftLayerAction, cc.DelayTime:create(0.5),pushPlayScene()))
        rightLayer:runAction(rightLayerAction)
    end
    

    -- 创建房间bgLayer
    local roomBtnLayer = cc.LayerColor:create(cc.c4b(110,110,110,0))
    roomBtnLayer:setIgnoreAnchorPointForPosition(false)--设置锚点默认为（0.5，0.5）
    roomBtnLayer:setContentSize(cc.size(SCREEN_HEIGHT*4/9,SCREEN_HEIGHT*4/9))
    roomBtnLayer:setPosition(cc.p(SCREEN_WIDTH-300,display.cy))
    self:addChild(roomBtnLayer)

    local roomX = roomBtnLayer:getContentSize().width/2
    local createY = roomBtnLayer:getContentSize().height * 3/4
    local enterY = roomBtnLayer:getContentSize().height / 4

    --创建房间
    local createRoomBtn = ccui.ImageView:create()
    createRoomBtn:loadTexture("chuangjianfang.png",1)
    createRoomBtn:setTouchEnabled(true)
    createRoomBtn:setAnchorPoint(cc.p(0.5,0.5))
    createRoomBtn:setPosition(cc.p(roomX,createY))
    createRoomBtn:setScale(0.7,0.8)
    roomBtnLayer:addChild(createRoomBtn)

    createRoomBtn:addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.began then
            AudioManager:getInstance():playButtonMusic()
            enterAnimation(noticeLayer,roomBtnLayer)
        end
    end)



    --加入房间
    local enterRoomBtn = ccui.ImageView:create()
    enterRoomBtn:loadTexture("jiaruyouxi.png",1)
    enterRoomBtn:setTouchEnabled(true)
    enterRoomBtn:setAnchorPoint(cc.p(0.5,0.5))
    enterRoomBtn:setPosition(cc.p(roomX,enterY))
    enterRoomBtn:setScale(0.7,0.8)
    roomBtnLayer:addChild(enterRoomBtn)

    enterRoomBtn:addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.began then
            print("点击了加入房间")   
            AudioManager:getInstance():playButtonMusic()
            enterAnimation(noticeLayer,roomBtnLayer)
        end
    end)

    self:addBottomLayer()

end

function HomeScene:addTopLayer()
end

function HomeScene:addMidLayer()
end

function HomeScene:addBottomLayer()
     --底部layer
     local bottomLayer = cc.LayerColor:create(cc.c4b(110,110,110,0))
     bottomLayer:setPosition(cc.p(0,0))
     bottomLayer:setContentSize(cc.size(SCREEN_WIDTH,100))
     self:addChild(bottomLayer)
 
     -- 背景图
     local bottombg = cc.Sprite:createWithSpriteFrame(display.newSpriteFrame("xixia001.png") )
     bottombg:setContentSize(cc.size(SCREEN_WIDTH,90))
     bottombg:setAnchorPoint(cc.p(0,0))
     bottomLayer:addChild(bottombg)
end

function HomeScene:registSetMusicVolume()

    local listenerCustom = cc.EventListenerCustom:create("setAlert",function(event)
        local val = event._usedata["value"]
        print(val)
        --保存用户设置的音量大小
        UserDefaultManager.saveBackgroungVolume(val)
        AudioManager:getInstance():setBackgroundVolume(val)
    end)
    local customEventDispatch=cc.Director:getInstance():getEventDispatcher()  
    customEventDispatch:addEventListenerWithFixedPriority(listenerCustom, 1) 
end

function HomeScene:onCleanup()  -- cc.Node
    --print("被释放了！！！！移除事件监听")
    for i, var in ipairs(self.eventListeners) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(var)
    end  
end

return HomeScene