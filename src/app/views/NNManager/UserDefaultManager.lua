local UserDefaultManager = {}

function UserDefaultManager.saveBackgroungVolume(value)

    cc.UserDefault:getInstance():setIntegerForKey("BackgroundVolumePercent", value)-- 整型  
    
    -- cc.UserDefault:getInstance():setStringForKey("string", "value1")-- 字符串  
    -- cc.UserDefault:getInstance():setIntegerForKey("integer", 10)-- 整型  
    -- cc.UserDefault:getInstance():setFloatForKey("float", 2.3)--浮点型  
    -- cc.UserDefault:getInstance():setDoubleForKey("double", 2.4)-- 双精度  
    -- cc.UserDefault:getInstance():setBoolForKey("bool", true)-- 布尔型  
end

function UserDefaultManager.getBackgroundVolume()
   
    local percent = cc.UserDefault:getInstance():getIntegerForKey("BackgroundVolumePercent")
    if percent==nil then
        percent = 60
    end

    return percent

    -- print value  
  -- 打印获取到的值  
  -- 根据key获取字符串值  
--   local ret = cc.UserDefault:getInstance():getStringForKey("string")  
--   cclog("string is %s", ret)  
  
--   -- 根据key获取双精度值  
--   local d = cc.UserDefault:getInstance():getDoubleForKey("double")  
--   cclog("double is %f", d)  
  
--   -- 根据key获取整型值  
--   local i = cc.UserDefault:getInstance():getIntegerForKey("integer")  
--   cclog("integer is %d", i)  
  
--   -- 根据key获取浮点数值  
--   local f = cc.UserDefault:getInstance():getFloatForKey("float")  
--   cclog("float is %f", f)  
  
--   -- 根据key获取布尔值  
--   local b = cc.UserDefault:getInstance():getBoolForKey("bool")  
--   if b == true then  
--     cclog("bool is true")  
--   else  
--     cclog("bool is false")  
--   end  

end

return UserDefaultManager