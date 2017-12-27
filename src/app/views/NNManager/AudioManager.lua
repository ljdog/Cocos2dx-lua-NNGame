-- cc.exports.AudioManager = class("AudioManager")  
local AudioManager = class("AudioManager")
--local manager = {}

function AudioManager:new(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self    
    return o   
end

function AudioManager:getInstance()    
    if self.instance == nil then    
        self.instance = self:new()    
    end       
    return self.instance    
end  

--预加载声音文件
function AudioManager:preloadAudioSourse()
    cc.SimpleAudioEngine:getInstance():preloadMusic("bg.mp3")
    cc.SimpleAudioEngine:getInstance():preloadEffect("button.mp3")
    cc.SimpleAudioEngine:getInstance():preloadEffect("cheer2.mp3")
    cc.SimpleAudioEngine:getInstance():preloadEffect("chips_place.mp3")
    cc.SimpleAudioEngine:getInstance():preloadEffect("compare_card.mp3")
    cc.SimpleAudioEngine:getInstance():preloadEffect("menubutton.mp3")
    cc.SimpleAudioEngine:getInstance():preloadEffect("music_game.mp3")
    cc.SimpleAudioEngine:getInstance():preloadEffect("music_room.mp3")
    cc.SimpleAudioEngine:getInstance():preloadEffect("ready.mp3")
    cc.SimpleAudioEngine:getInstance():preloadEffect("select.mp3")
    cc.SimpleAudioEngine:getInstance():preloadEffect("win.mp3")
    cc.SimpleAudioEngine:getInstance():preloadEffect("replace.wav")
    cc.SimpleAudioEngine:getInstance():preloadEffect("kanpai.mp3")
    cc.SimpleAudioEngine:getInstance():preloadEffect("fapai.mp3")
    cc.SimpleAudioEngine:getInstance():preloadEffect("bipai.mp3")

end

function AudioManager:playEffectMusic(name)
    cc.SimpleAudioEngine:getInstance():playEffect(name)
end

function AudioManager:playButtonMusic()
    cc.SimpleAudioEngine:getInstance():playEffect("button.mp3")
end

function AudioManager:playAlertMusic()
    cc.SimpleAudioEngine:getInstance():playEffect("select.mp3")
end

function AudioManager:playBackgroundMusic()
    cc.SimpleAudioEngine:getInstance():stopMusic(true)
    cc.SimpleAudioEngine:getInstance():playMusic("bg.mp3",true)
end

function AudioManager:playRoomMusic()
    cc.SimpleAudioEngine:getInstance():stopMusic(true)
    cc.SimpleAudioEngine:getInstance():playMusic("music_room.mp3",true)
end

--设置背景音乐音量
function AudioManager:setBackgroundVolume(percent)
    cc.SimpleAudioEngine:getInstance():setMusicVolume(percent/100)      
end

return AudioManager