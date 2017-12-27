
local PlayMode = {}

function PlayMode:init()
    local table = {}
    table["name"] = "zhangsan"
    return table
end


--初始化牌表
function PlayMode:initPkSpriteFrameTab()
    local spFrameTab = {}
    local newStr = ""
    local blackStr = "_a"
    local redStr = "_b"
    local meiStr = "_c"
    local fangStr = "_d"
    for i=1,52 do
        if i<14 then
            newStr = string.format("%d%s.png",i,blackStr)
        elseif i<27 then
            newStr = string.format("%d%s.png",i-13,redStr)
        elseif i<40 then 
            newStr = string.format("%d%s.png",i-13*2,meiStr)
        elseif i<53 then 
            newStr = string.format("%d%s.png",i-13*3,fangStr)
        end
        spFrameTab[i] = newStr
    end
    -- for i=1,53 do
    --     print(spFrameTab[i])
    -- end

    return spFrameTab
    
end


--洗牌逻辑
-- 洗牌 打乱52张牌 result 为最终打乱的imgtab
function PlayMode:disruptSequence(originTab)
    --源表的拷贝
    --print("------------------------------")
    local copyTab = {}
    for i=1,#originTab do
        copyTab[i] = originTab[i]
    end
    local resultTab = {}
    for i=1,#originTab do
        --获取1-100的随机数
        local random = math.random()*1000
        --向下取整floor
        local floorNum = math.floor(random)
        --取模（正数取余）对#copyTab+1取余得到1到copyTab的随机数
        local modNum = math.mod(floorNum,#copyTab)
        if modNum==0 then
            modNum = 1
        end
        if #copyTab == 0 then
            break
        end
        --先添加给resultTab
        resultTab[i] = copyTab[modNum]
        --再删除
        table.remove(copyTab,modNum)
        
    end

    return resultTab
end


--传入randomResTab、 第user_Num个用户 自己为1 返回五个随机的图片资源
function PlayMode:getRandom5ImgArray(randomResTab,user_Num)
    local imgArray = {}
    --遍历五次 每个人只取五个图片
    for i=1,5 do
        
        if user_Num==1 then
            --是本人 截取随机数的前五个作为牌型
            imgArray[i] = randomResTab[i]
        elseif user_Num==2 then
            --是第二个人 截取随机数的6-10个作为牌型
            imgArray[i] = randomResTab[i+5]
        elseif user_Num==3 then 
            --是第三个人 截取随机数的11-15个作为牌型
            imgArray[i] = randomResTab[i+10]
        elseif user_Num==4 then 
            --是第四个人 截取随机数的16-20个作为牌型
            imgArray[i] = randomResTab[i+15]
        elseif user_Num==5 then
            --是第五个人 截取随机数的21-25个作为牌型
            imgArray[i] = randomResTab[i+20]
        end
    end

    -- for i=1,5 do
    --     print(imgArray[i])
    -- end
    self:getBubbleArray(imgArray)
    
    --返回排序好的五张牌
    return imgArray
end


--比牌  返回牌的牛x
function PlayMode:getCompareResult(play_Num,imageArray)
    print("++++++++++++++++++++++++++")

    local currentPlayerResult = 0 --初始化当前没牛

    local niu_num = 0-->10的个数
    local totalHe = 0--总和
    local pukeNumTab = {}--牌的数组 10，2，5，2，1 都<=10
    local originPukeNumTab = {}--源牌数组 12，13，2，1，11 包含大于10的 用于计算花牌

    for i=1,#imageArray do
        local imgString = imageArray[i]
        local index1 = string.find(imgString,"_")
        local result = string.sub(imgString,1,index1-1)
        local resNum = tonumber(result);
        if resNum then
            if resNum >=10 then
                --10 j q k 都是10 
                resNum = 10
                niu_num = niu_num + 1
            end
        else
            print("图片名称格式错误！！！！")
        end
        --设置牌型的数组
        pukeNumTab[i] = resNum
        --计算总和
        totalHe = totalHe + resNum
        --设置源牌的数组 用于计算花色
        originPukeNumTab[i] = tonumber(result)
    end

    --test-------

    -- totalHe = 32
    -- niu_num = 1
    -- pukeNumTab = {10,3,4,6,9}
    -- print(string.format("总和=%d\n牛的数量=%d\n",totalHe,niu_num))

    --test-------
    
    -- 没有一个牛 
    local alrtString = "没牛"
    if niu_num==0 then
        if totalHe <= 10 then
            --五张相加<=10 五小牛  最大的牌
            alrtString = "恭喜你，五小牛！！！我最大"
            currentPlayerResult = 13

        else
            for i=1 ,5 do
                for j=i+1 ,5 do
                    --排除3=3 总和-任意两张牌相加=剩余三张牌相加
                    local threeHe = totalHe - (pukeNumTab[i] + pukeNumTab[j])
                    if math.mod(threeHe,10) == 0 then
                        --有牛
                        local niu = math.mod(totalHe,10)
                        alrtString = string.format("恭喜你，牛%d",niu)
                        currentPlayerResult = niu
                        break
                    end
                end
            end
        end

    elseif niu_num==1 then
        -- 只有一只牛 
        for i=1 ,5 do
            --print("外层遍历次数")
            for j=i+1 ,5 do
                --排除3=3 总和-任意两张牌相加=剩余三张牌相加
                local threeHe = totalHe - (pukeNumTab[i] + pukeNumTab[j])
                local twoHe = pukeNumTab[i] + pukeNumTab[j]
                --print("---------"..string.format("%d,%d",i,j))
                if (math.mod(threeHe,10)==0) and (math.mod(totalHe,10)==0) then
                    alrtString = "恭喜你，牛牛"
                    currentPlayerResult = 10

                elseif (math.mod(threeHe,10)==0) or (math.mod(twoHe,10)==0) then
                    --有牛
                    local niu = math.mod(totalHe,10)
                    alrtString = string.format("恭喜你，牛%d",niu)
                    currentPlayerResult = niu
                    break
                end
            end
        end

    elseif niu_num==2 then
        local niu = math.mod(totalHe,10)
        if niu == 0 then
            alrtString = "恭喜你，牛牛"
            currentPlayerResult = 10
        else
            for i=1 ,5 do
                for j=i+1 ,5 do
                    --排除3=3 重复项
                    if (pukeNumTab[i] + pukeNumTab[j])==10 then
                        alrtString = string.format("恭喜你，牛%s",niu)
                        currentPlayerResult = niu
                        break
                    end
                end
            end
            --print(string)
        end
    elseif niu_num==3 then
       --三张牛 判断其他两张相加是否为牛 
        local niu = math.mod(totalHe,10)
        if niu == 0 then
            alrtString = "恭喜你，牛牛"
            currentPlayerResult = 10
        else
            alrtString = string.format("恭喜你，牛%s",niu)
            currentPlayerResult = niu
        end
    elseif niu_num==4 or niu_num==5 then
        local niu = math.mod(totalHe,10)
        if (niu==0) then
            alrtString = "恭喜你，牛牛"
            currentPlayerResult = 10
        else
            alrtString = string.format("恭喜你，牛%s",niu)
            currentPlayerResult = niu
        end

        --可能产生五花牛
        local is_wuHuaNiu = 1
        for i=1,5 do
            --只要有一张小于等于10 就不是五花牛
            if originPukeNumTab[i]<=10 then
                is_wuHuaNiu = 0
                break
            end
        end
        if is_wuHuaNiu==1 then
            currentPlayerResult = 12
        end

    end
   
    --返回玩家牌型
    return currentPlayerResult
end

--构建用户表 用于存储player，niu，Max，huamax 
function PlayMode:setUserResultTable(player,niuType,maxImgString)

    local index = string.find(maxImgString,"_")
    local number = tonumber(string.sub(maxImgString,1,index-1))
    local huaMark = string.sub(maxImgString,index+1,index+1)
    local hua = 1
    if huaMark=="a" then
        hua = 4
    elseif huaMark=="b" then
        hua = 3
    elseif huaMark=="c" then
        hua = 2
    elseif huaMark=="d" then
        hua = 1
    end

    local userTab = {}
    userTab["player"] = player
    userTab["niuType"] = niuType
    userTab["max"] = number
    userTab["huaMax"] = hua

    -- print("=====================")
    -- for k,v in pairs(userTab) do
    --     print(k.."="..v)
    -- end
    -- print("=====================")

    return userTab
end

--根据用户表来比较最大的 获取winner
function PlayMode:getWinnerPlayer(userArray)
    
    --默认第一个作为最大的
    local defaultPlayer = self:EqualTable(userArray[1])

    for j=1,#userArray do

        print("============循环次数统计")
        local defaultNiuType = defaultPlayer["niuType"]
        local defaultMax = defaultPlayer["max"]
        local defaultHuaMax = defaultPlayer["huaMax"]

        local userTab1 = userArray[j]
        local niuType1 = userTab1["niuType"]
        local max1 = userTab1["max"]
        local huaMax1 = userTab1["huaMax"]
            
        if niuType1 > defaultNiuType then
            --如果牌型大直接设置为最大
            defaultPlayer = self:EqualTable(userTab1)
        elseif niuType1 == defaultNiuType then
            --如果牌型相等
            --1.比较最大的一张牌
            if max1 > defaultMax then
                --如果payer大于默认的 则替换
                defaultPlayer = self:EqualTable(userTab1)
            elseif max1 == defaultMax then
                --如果player最大牌等于默认 则进行花色比较
                if huaMax1 > defaultHuaMax then
                    --如果花色大于默认 则替换
                    defaultPlayer = self:EqualTable(userTab1)
                end
            end
        end
            
            --单独进行五小牛中最大牌型的比较
    end
    --输出winner的名字
    local winnerNum = defaultPlayer["player"]
    print("胜利者属于player："..winnerNum)
    return winnerNum
end



-- 冒泡排序 将牌从大到小排序  并且按照花色黑红梅方排序
function PlayMode:getBubbleArray(images)
    local n = #images;
    --将 11_a.png 格式改成 11_4.png 
    
    local copyImages = {}
    for i=1,n do
        local string = images[i]
        local idx_a = string.find(string,"a")
        local idx_b = string.find(string,"b")
        local idx_c = string.find(string,"c")
        local idx_d = string.find(string,"d")
       
        if idx_a then
            copyImages[i] = string.gsub(string,"a","4")
        elseif idx_b then
            copyImages[i] = string.gsub(string,"b","3")
        elseif idx_c then
            copyImages[i] = string.gsub(string,"c","2")
        elseif idx_d then
            copyImages[i] = string.gsub(string,"d","1")
        end
    end

    --将打乱的牌进行排序 只排大小
    for i=1,n do
        for j=1,n-i do
            local index1 = string.find(copyImages[j],"_")
            local number1 = tonumber(string.sub(copyImages[j],1,index1-1))
            
            local index2 = string.find(copyImages[j+1],"_")
            local number2 = tonumber(string.sub(copyImages[j+1],1,index2-1))

            --1.进行大小比较
            if number1<number2 then
                --调换两者位置
                local x = copyImages[j]
                copyImages[j] = copyImages[j+1]
                copyImages[j+1] = x

                local y = images[j]
                images[j] = images[j+1]
                images[j+1] = y
            end

             --2.进行花色比较
             local idx1 = string.find(copyImages[j],"_")
             local idx2 = string.find(copyImages[j+1],"_")
             local num1 = tonumber(string.sub(copyImages[j],1,idx1-1))
             local num2 = tonumber(string.sub(copyImages[j+1],1,idx2-1))
              --获取花色进行比较
             local huaNum1 = tonumber(string.sub(copyImages[j],idx1+1,idx1+1))
             local huaNum2 = tonumber(string.sub(copyImages[j+1],idx2+1,idx2+1))
             
             --如果有相同的才进行花色比较 否则不用比
             if (num1==num2) and (huaNum1<huaNum2) then
                 --调换两者位置
                 local a = copyImages[j]
                 copyImages[j] = copyImages[j+1]
                 copyImages[j+1] = a

                 local b = images[j]
                 images[j] = images[j+1]
                 images[j+1] = b

             end

        end
    end
end


--表a=表b方法
function PlayMode:EqualTable(originTable)
    if originTable then
        local newTable = {}
        for k, v in pairs(originTable) do
            newTable[k] = v
        end
        return newTable
    end
end

--延迟方法
function PlayMode:performWithDelay(node, callback, delay)
    local delay = cc.DelayTime:create(delay)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
    node:runAction(sequence)
    return sequence
end


return PlayMode