--导入需要的管理类和自定义layer
local AudioManager = import (".NNManager.AudioManager")
local UserHeader = import (".CommonLayers.UserHeader")
local MyHeader = import (".CommonLayers.MyHeader")
local PlayMode = import (".Model.PlayMode")
local GameResultLayer = import (".CommonLayers.GameResultLayer")
local PlayPrepareLayer = import (".CommonLayers.PlayPrepareLayer")

local PlayScene = class("PlayScene",cc.load("mvc").ViewBase)

local SCREEN_WIDTH = cc.Director:getInstance():getWinSize().width
local SCREEN_HEIGHT = cc.Director:getInstance():getWinSize().height

local Pk_Width = 60 --牌宽度
local Pk_Height = 100 --牌高度
local MinePk_Width = 100
local MinePk_Height = 160

local Allow_HandOut = 0 --是否允许发牌

--其他用户头像坐标
local Header_Posi = {cc.p(100,250),cc.p(100,450),cc.p(SCREEN_WIDTH-100,450),cc.p(SCREEN_WIDTH-100,250)}

--其他牌
--设置牌的x坐标
local LeftPosiX_tab = {240,260,280,300,320}    
local RightPosiX_tab = {SCREEN_WIDTH-320,SCREEN_WIDTH-300,SCREEN_WIDTH-280,SCREEN_WIDTH-260,SCREEN_WIDTH-240}
--设置牌的y坐标
local posiY_tab = {270,470} 

--我的牌的x坐标
local MinePosiX_tab = {display.cx-(MinePk_Width+10)*2,display.cx-(MinePk_Width+10),display.cx,display.cx+(MinePk_Width+10),display.cx+(MinePk_Width+10)*2}
local MinePosiY = 20 + MinePk_Height/2

--设置结果 牛X的坐标
local POSI_niuResultX = {display.cx,280,280,SCREEN_WIDTH-280,SCREEN_WIDTH-280}
local POSI_niuResultY = {MinePosiY,270,470,470,270}

--玩家数量
local allNumCount = 4
local layer

--用于记录玩家的倍数（牌型）
--local gameResult = {}
-- 五小牛>五花牛>4炸>牛牛>牛9-牛7>牛1-牛6=没牛
-- 13     12     11   10   7-9       1-6      0 

--tempTab 用于随机给牌的tab
local imgFrameTab
--table.remove(testArray, 2) 移除index=2的值

local mineImgArray
local play1Array
local play2Array
local play3Array
local play4Array

function PlayScene:onCreate()

    display.loadSpriteFrames("public_ui.plist","public_ui.png")
    display.loadSpriteFrames("puke_textTure.plist","puke_textTure.pvr.ccz")
    display.loadSpriteFrames("niuResult_textTure.plist","niuResult_textTure.pvr.ccz")
    
    --添加背景layer
    self:createPlayLayer()
    self:setBackButton()
    self:setMineView()--我的头像
    self:setOtherView()--其他头像
    self:addPrepareButton()

    Allow_HandOut = 0 --不允许点击发牌
    --初始化牌的图片表
    imgFrameTab = PlayMode:initPkSpriteFrameTab()
    
    --洗牌 打乱后的牌
    -- local disruptTab = PlayMode:disruptSequence(imgFrameTab)
    
    -- mineImgArray = PlayMode:getRandom5ImgArray(disruptTab,1)
    -- play1Array = PlayMode:getRandom5ImgArray(disruptTab,2)
    -- play2Array = PlayMode:getRandom5ImgArray(disruptTab,3)
    -- play3Array = PlayMode:getRandom5ImgArray(disruptTab,4)
    -- play4Array = PlayMode:getRandom5ImgArray(disruptTab,5)

     --设置发牌动画
     --self:createNewPkAnimation()
    
     self:AddMineBottomButtons()

     --注册弹框取消的自定事件
     self:registResultDismiss()
     --注册准备按钮自定义事件
     self:registPrepareBtnEvent()

     print("进入PlayScene!!!!")
end


function PlayScene:onEnter()
    --加载声音文件
    AudioManager:getInstance():playRoomMusic()
end

function PlayScene:createPlayLayer()
   
    layer = cc.LayerColor:create(cc.c4b(255, 255, 255, 255))
    layer:setPosition(cc.p(display.cx,display.cy))
    layer:setIgnoreAnchorPointForPosition(false)--设置锚点默认为（0.5，0.5）
    layer:setContentSize(cc.size(cc.Director:getInstance():getWinSize().width,cc.Director:getInstance():getWinSize().height))
    self:addChild(layer)

    -- 背景图
    local bg = cc.Sprite:create("play_bg.png")
    bg:setContentSize(cc.Director:getInstance():getWinSize())
    bg:setAnchorPoint(cc.p(0,0))
    layer:addChild(bg)
end

-- 创建牌及发牌动画
function PlayScene:createNewPkAnimation()

    -- 我的牌发牌动画
    for i=1, 5 do
        local pkSprite = cc.Sprite:create("puke_bac.png")
        pkSprite:setContentSize(cc.size(MinePk_Width,MinePk_Height))
        pkSprite:setAnchorPoint(cc.p(0.5,0.5))
        pkSprite:setPosition(cc.p(display.cx,display.cy))
        pkSprite:setRotation3D(cc.vec3(0, 180, 0));
        pkSprite:setScale(0.1,0.1)
        pkSprite:setTag(i+100)
        layer:addChild(pkSprite)
        local moveTo = cc.MoveTo:create(0.4,cc.p(MinePosiX_tab[i],MinePosiY))
        local scaleTo = cc.ScaleTo:create(0.4, 1)
        local rotate = cc.RotateBy:create(0.4, 180)
        local sequene1 = cc.Sequence:create(cc.DelayTime:create(i/10.0),cc.Spawn:create(scaleTo,moveTo))


        --首次进入我的自动翻牌
        --翻转动画
        local orbit = cc.OrbitCamera:create(0.+i/10, 1, 0, 0, 180, 0, 0)
        --延迟0.5一半时间执行换牌操作
        local callFun = function()
            --替换牌
            pkSprite:setSpriteFrame(display.newSpriteFrame(mineImgArray[i]))
            pkSprite:setContentSize(cc.size(MinePk_Width,MinePk_Height)) 
            --print(mineImgArray[i])
        end
        local sequene2 = cc.Sequence:create(cc.DelayTime:create((0.2+i/10)/2),cc.CallFunc:create(callFun))
        --同时执行翻转及换牌动画
        local spawn = cc.Spawn:create(orbit,sequene2)
        
        pkSprite:runAction(cc.Sequence:create(sequene1,cc.DelayTime:create(0.4),spawn))

    end
    

    --其他牌发牌动画
    for j=1,allNumCount-1 do
        for i=1, 5 do
            local pkSprite = cc.Sprite:create("puke_bac.png")
            pkSprite:setContentSize(cc.size(Pk_Width,Pk_Height))
            pkSprite:setTag(j*5+i+100)
            pkSprite:setRotation3D(cc.vec3(0, 180, 0))
            pkSprite:setAnchorPoint(cc.p(0.5,0.5))     
            pkSprite:setScale(0.1)
            pkSprite:setPosition(cc.p(display.cx,display.cy))       
            layer:addChild(pkSprite)
            
            local moveTo
            
            if j==1 then
                moveTo = cc.MoveTo:create(0.4,cc.p(LeftPosiX_tab[i],posiY_tab[1]))  
            elseif j==2 then
                moveTo = cc.MoveTo:create(0.4,cc.p(LeftPosiX_tab[i],posiY_tab[2]))
            elseif j==3 then
                moveTo = cc.MoveTo:create(0.4,cc.p(RightPosiX_tab[i],posiY_tab[2]))
            elseif j==4 then
                moveTo = cc.MoveTo:create(0.4,cc.p(RightPosiX_tab[i],posiY_tab[1]))
            end
            local scaleTo = cc.ScaleTo:create(0.4, 1)
            local rotate = cc.RotateBy:create(0.4, 180)
            pkSprite:runAction(cc.Sequence:create(cc.DelayTime:create((i/10.0)),cc.Spawn:create(scaleTo,moveTo)))        
        end
    end
    

   
end


--添加 发牌  比牌
function PlayScene:AddMineBottomButtons()

    local handOut = ccui.Button:create()
    handOut:setTouchEnabled(true)
    handOut:setTag(1001)
    handOut:setTouchEnabled(false)
    handOut:loadTextures("button_send.png","button_send.png","")
    handOut:setPosition(cc.p(SCREEN_WIDTH-110,130))
    handOut:setContentSize(cc.size(150, 64))
    handOut:addTouchEventListener(function(sender,event)

        if event == ccui.TouchEventType.began then
            --handOut:setTouchEnabled(false)

            if Allow_HandOut==0 then
                print("完成此局之后再进行发牌！")
                return
            end

            --发牌
            AudioManager:getInstance():playEffectMusic("fapai.mp3")


            --洗牌 重新给每个用户设置随机牌型
            local disruptTab = PlayMode:disruptSequence(imgFrameTab)
            
            mineImgArray = PlayMode:getRandom5ImgArray(disruptTab,1)
            play1Array = PlayMode:getRandom5ImgArray(disruptTab,2)
            play2Array = PlayMode:getRandom5ImgArray(disruptTab,3)
            play3Array = PlayMode:getRandom5ImgArray(disruptTab,4)
            play4Array = PlayMode:getRandom5ImgArray(disruptTab,5)

            --发牌动画
            self:createNewPkAnimation()

            --不允许再次发牌
            Allow_HandOut = 0
            --设置允许点击比牌
            local compareCard = layer:getChildByTag(1002)
            compareCard:setTouchEnabled(true)
        end
    end) 
    layer:addChild(handOut)



    local compareCard = ccui.Button:create()
    compareCard:setTouchEnabled(true)
    compareCard:setTag(1002)
    compareCard:loadTextures("button_compare.png","button_compare.png","")
    compareCard:setPosition(cc.p(SCREEN_WIDTH-110,50))
    compareCard:setContentSize(cc.size(150, 64))
    compareCard:addTouchEventListener(function(sender,event)

        if event == ccui.TouchEventType.began then
            --比牌
            AudioManager:getInstance():playEffectMusic("kanpai.mp3")

            compareCard:setTouchEnabled(false)

            for i=1, 5*(allNumCount-1) do
                local playSp = layer:getChildByTag(105+i)

                --获取1-5的数
                local randTime = math.mod(i,5)
                if randTime==0 then
                    randTime=5
                end

                local orbit = cc.OrbitCamera:create(0.1+randTime/10, 1, 0, 0, 180, 0, 0)
                local callFun
                if i<=5 then
                    callFun = function()
                        playSp:setSpriteFrame(display.newSpriteFrame(play1Array[i]))
                    end
                elseif i<=10 then
                    callFun = function()
                        playSp:setSpriteFrame(display.newSpriteFrame(play2Array[i-5]))
                    end
                elseif i<=15 then
                    callFun = function()
                        playSp:setSpriteFrame(display.newSpriteFrame(play3Array[i-10]))
                    end
                elseif i<=20 then
                    callFun = function()
                        playSp:setSpriteFrame(display.newSpriteFrame(play4Array[i-15]))
                    end
                end

                local sequence = cc.Sequence:create(cc.DelayTime:create((0.1+randTime/10)/2),cc.CallFunc:create(callFun))
                --执行翻转动画后进行换牌操作
                playSp:runAction(cc.Spawn:create(orbit,sequence))
                 
            end
            --计算牛x结果
            self:showNiu_x_result()

            Allow_HandOut = 1 --结果出来之后允许进行发牌操作
        end
    end) 
    layer:addChild(compareCard)

end

--展示牛X结果
function PlayScene:showNiu_x_result()
    --创建allNumCount个精灵 显示牛X
    local tempArray = {mineImgArray,play1Array,play2Array,play3Array,play4Array}
    local imgs = {}
    local userArray = {}--用于保存用户表的数组
    for i=1 ,allNumCount do

        imgs = tempArray[i]
        
        --获取牛X的结果
        local result_num = PlayMode:getCompareResult(i,imgs)
        local imgString = string.format("niu_%d.png",result_num)

        local resultSP = cc.Sprite:createWithSpriteFrame(display.newSpriteFrame(imgString))
        resultSP:setTag(10+i)
        resultSP:setPosition(cc.p(POSI_niuResultX[i],POSI_niuResultY[i]))
        resultSP:setScale(0.01)
        resultSP:setContentSize(cc.size(150,70))        
        layer:addChild(resultSP)

        local scaleSp = cc.ScaleTo:create(0.2,1.3)
        local scaleSP2 = cc.ScaleTo:create(0.1,1.1)
        resultSP:runAction(cc.Sequence:create(cc.DelayTime:create(1),scaleSp,scaleSP2)) 

        --构建用户结果表
        local userTable = PlayMode:setUserResultTable(i,result_num,imgs[1])

        userArray[i] = userTable
    end

    local winner = PlayMode:getWinnerPlayer(userArray)


    --延时一秒执行
    PlayMode:performWithDelay(self,function()

        --设置下层不允许点击
        local sendBtn = layer:getChildByTag(1001)
        local compareBtn = layer:getChildByTag(1002)
        sendBtn:setTouchEnabled(false)
        compareBtn:setTouchEnabled(false)

        local gameResult = GameResultLayer.new()
        gameResult:init()
        gameResult:setPosition(cc.p(display.cx,display.cy))
        gameResult:setWinnerName(winner)
        self:addChild(gameResult)
        gameResult:ShowAnimation()

        AudioManager:getInstance():playEffectMusic("bipai.mp3")

    end,1.5)

end

function PlayScene:registResultDismiss()
    local listenerCustom = cc.EventListenerCustom:create("resultDismiss",function()
        --点击确认按钮  设置下层允许点击
        local sendBtn = layer:getChildByTag(1001)
        local compareBtn = layer:getChildByTag(1002)
        sendBtn:setTouchEnabled(true)
        compareBtn:setTouchEnabled(true)
        print("接收到自定义事件啦！！！！！")

        --清楚桌面的所有牌
         --获取所有牌 
         for i=1,allNumCount*5 do
            local pkSprite = layer:getChildByTag(100+i)
            if pkSprite then
                pkSprite:removeFromParent()
            end
            --101-105
            if i<=allNumCount then
                local niuSprite = layer:getChildByTag(10+i)
                if niuSprite then
                    niuSprite:removeFromParent()
                end
            end
        end

    end)  
    local customEventDispatch=cc.Director:getInstance():getEventDispatcher()  
    customEventDispatch:addEventListenerWithFixedPriority(listenerCustom, 1)  
end

function PlayScene:addPrepareButton()
    
    local prepareBtn = PlayPrepareLayer.new()
    prepareBtn:init(allNumCount)
    prepareBtn:setTag(1234)
    layer:addChild(prepareBtn)
end

--注册准备按钮点击事件
function PlayScene:registPrepareBtnEvent()
    local listenerCustom = cc.EventListenerCustom:create("prepare",function()
        
        local Btn = layer:getChildByTag(1234)
        if Btn then
            Btn:removeFromParent()
        end

        --我一旦准备立马发牌
        print("准备按钮点击了！！！")
         --发牌
         AudioManager:getInstance():playEffectMusic("fapai.mp3")

         --洗牌 重新给每个用户设置随机牌型
         local disruptTab = PlayMode:disruptSequence(imgFrameTab)
         
         mineImgArray = PlayMode:getRandom5ImgArray(disruptTab,1)
         play1Array = PlayMode:getRandom5ImgArray(disruptTab,2)
         play2Array = PlayMode:getRandom5ImgArray(disruptTab,3)
         play3Array = PlayMode:getRandom5ImgArray(disruptTab,4)
         play4Array = PlayMode:getRandom5ImgArray(disruptTab,5)

         --发牌动画
         self:createNewPkAnimation()

    end)
    local customEventDispatch=cc.Director:getInstance():getEventDispatcher()  
    customEventDispatch:addEventListenerWithFixedPriority(listenerCustom, 1) 
end

-- 设置返回按钮
function PlayScene:setBackButton()
     --public_btn_back

     local backBtn = ccui.ImageView:create()
     backBtn:loadTexture("back.png",0)
     backBtn:setTouchEnabled(true)
     backBtn:setAnchorPoint(cc.p(0,1))
     backBtn:setPosition(cc.p(30,SCREEN_HEIGHT-30))
     backBtn:setScale(0.7,0.8)
     layer:addChild(backBtn)
 
     backBtn:addTouchEventListener(function(sender,event)
         if event == ccui.TouchEventType.began then
             local homeScene = self:getApp():getSceneWithName("HomeScene")
             local transition = cc.TransitionFade:create(0.4,homeScene)  
             cc.Director:getInstance():replaceScene(transition)

         end
     end)

end

-- 设置我的头像view
function PlayScene:setMineView()
    
    local header = MyHeader.new()
    header:init(150,80,200,100)
    header:setUserInfo({name="周润发",money="999"})
    header:setIgnoreAnchorPointForPosition(false)--设置锚点默认为（0.5，0.5）    
    self:addChild(header)
    
end

--设置其他用户头像view
function PlayScene:setOtherView()

    local nameArray = {"陈一发","小周周","小米","麻花疼"}
    for i=1,allNumCount-1 do
        
        local x,y = Header_Posi[i]

        local userHeader = UserHeader.new()
        userHeader:init(x,y,100,150)
        userHeader:setIgnoreAnchorPointForPosition(false)--设置锚点默认为（0.5，0.5） 
        
        local table = {name = "dadada",money = "998"}
        table["name"] = nameArray[i]
        userHeader:setUserInfo(table)  
        self:addChild(userHeader)
    end

end

function PlayScene:onCleanup()  -- cc.Node
    --print("被释放了！！！！移除事件监听")
    for i, var in ipairs(self.eventListeners) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(var)
    end  
end



return PlayScene

