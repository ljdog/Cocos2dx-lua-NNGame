
local AudioManager = import (".NNManager.AudioManager")
local UserDefaultManager = import (".NNManager.UserDefaultManager")

local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()

    --添加资源搜索路径
    cc.FileUtils:getInstance():addSearchPath("res/Images/")
    cc.FileUtils:getInstance():addSearchPath("res/Music/")
    
    --预加载音效文件
    AudioManager:getInstance():preloadAudioSourse()
    --预设音量值为60
    UserDefaultManager.saveBackgroungVolume(60)
    print(UserDefaultManager.getBackgroundVolume()) 

    print("MainScene onCreate")
    -- add LayerColor view
    -- setIgnoreAnchorPointForPosition() 场景和层等大型节点的此属性为true 默认锚点（0，0） 其余的节点默认锚点（0.5,0.5）

    local layer = cc.LayerColor:create(cc.c4b(255, 255, 255, 255))
    layer:setPosition(cc.p(display.cx,display.cy))
    layer:setIgnoreAnchorPointForPosition(false)--设置锚点默认为（0.5，0.5）
    layer:setContentSize(cc.size(cc.Director:getInstance():getWinSize().width,cc.Director:getInstance():getWinSize().height))
    self:addChild(layer)

end



function MainScene:onEnter()                                            
    print("MainScene onEnter")  

    local isLogin = 0

    if isLogin == 0 then
        local loginScene = self:getApp():getSceneWithName("LoginScene")
        local transition = cc.TransitionFade:create(0.3,loginScene)  
        cc.Director:getInstance():replaceScene(transition)  

        -- local spriteView = MySprite:createSprite("HelloWorld.png")
        -- spriteView:setPosition(cc.p(100,100))   
    else
        local homeScene = self:getApp():getSceneWithName("HomeScene")
        local transition = cc.TransitionFade:create(0.3,homeScene)  
        cc.Director:getInstance():replaceScene(transition)
    end

end  

function MainScene:onEnterTransitionFinish()                                     
    print("MainScene onEnterTransitionFinish")  
end  

function MainScene:onExit()                                              
    print("MainScene onExit")  
end 


function MainScene:onExitTransitionStart()                                  
    print("MainScene onExitTransitionStart")  
end  


function MainScene:cleanup()                                             
    print("MainScene cleanup")  
end  

return MainScene