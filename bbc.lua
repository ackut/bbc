script_name('MyHome News')
script_author('ASKIT')
script_version('14.08.23')
script_prefix = '{90aaff}MyHome News: {ffffff}'

require('lib.moonloader')
sampev = require('lib.samp.events')


local active = false
local ad_author = nil
local ad_text = nil
local ad_retext = nil
local is_cancelled = false


function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(200) end

    sampRegisterChatCommand('bbc', cmd)

    while true do wait(0)
        if active then
            if wasKeyPressed(81) then
                if not sampIsDialogActive() and not sampIsChatInputActive() and not isSampfuncsConsoleActive() then
                   sampSendChat('/edit')
                end
            end
        end
    end
end


function cmd()
    active = not active
    sampAddChatMessage(script_prefix..'Скрипт '..(active and 'активирован.' or 'деактевирован.'), -1)
end


function SearchMarker(posX, posY, posZ, radius, isRace)
    local ret_posX = 0.0
    local ret_posY = 0.0
    local ret_posZ = 0.0
    local isFind = false

    for id = 0, 31 do
        local MarkerStruct = 0
        if isRace then MarkerStruct = 0xC7F168 + id * 56
        else MarkerStruct = 0xC7DD88 + id * 160 end
        local MarkerPosX = representIntAsFloat(readMemory(MarkerStruct + 0, 4, false))
        local MarkerPosY = representIntAsFloat(readMemory(MarkerStruct + 4, 4, false))
        local MarkerPosZ = representIntAsFloat(readMemory(MarkerStruct + 8, 4, false))

        if MarkerPosX ~= 0.0 or MarkerPosY ~= 0.0 or MarkerPosZ ~= 0.0 then
            if getDistanceBetweenCoords3d(MarkerPosX, MarkerPosY, MarkerPosZ, posX, posY, posZ) < radius then
                ret_posX = MarkerPosX
                ret_posY = MarkerPosY
                ret_posZ = MarkerPosZ
                isFind = true
                radius = getDistanceBetweenCoords3d(MarkerPosX, MarkerPosY, MarkerPosZ, posX, posY, posZ)
            end
        end
    end

    return isFind, ret_posX, ret_posY, ret_posZ
end


function checkAdInTable(table, text)
    for k, v in pairs(table) do
        if table[k][2] == text then
            return true
        end
    end

    return false
end


function sampev.onShowDialog(id, style, title, button1, button2, text)
    if active then
        if id == 1000 then
            claimAd(id, text)
            
        elseif id == 1536 then
            ad_author = getAdAuthor(text)
            if ad_text == nil then ad_text = getAdText(text) end
            getAd(ad_text)
        end
    end
end


function sampev.onSendDialogResponse(id, button, list_item, input)
    if active then
        if id == 1536 then
            ad_retext = input
            if button == 0 then is_cancelled = true saveAd() end
    
        elseif id == 1537 then
            if button == 1 then saveAd() end
        end
    end
end


function getAd(text)
    local file = io.open('moonloader/ads.json', 'r')
    local a = file:read('*a')
    file:close()
    local adsFile = decodeJson(a)

    if checkAdInTable(adsFile, ad_text) then
        for k, v in pairs(adsFile) do
            if adsFile[k][2] == text then
                local button = adsFile[k][1] and 0 or 1
                sampSendDialogResponse(1536, button, -1, adsFile[k][3])
            end
        end
    end
end


function saveAd()
    local file = io.open('moonloader/ads.json', 'r')
    local a = file:read('*a')
    file:close()
    local adsFile = decodeJson(a)

    if not checkAdInTable(adsFile, ad_text) then
        table.insert(adsFile, {is_cancelled, ad_text, ad_retext})
    end

    adsFile = encodeJson(adsFile)
    local file = io.open('moonloader/ads.json', 'w')
    file:write(adsFile)
    file:flush()

    is_cancelled, ad_text, ad_retext, ad_author = false, nil, nil, nil
end


function claimAd(id, text)
    local i = 0
    for str in text:gmatch("[^\r\n]+") do
        if str ~= nil and str:find('-') and str:len() > 19 then
            sampSendDialogResponse(id, 1, i-1, -1)
            break
        end
        i = i + 1
    end
end


function getAdAuthor(text)
    return (text:match('Отправитель: %{7FFF00%}(%w+ %w+)')):gsub('\n', ''):gsub(' ', '_')
end


function getAdText(text)
    return (text:match('Текст:%{7FFF00%} (.*)%{ffffff%}')):gsub('\n', ''):lower()
end


function splitString(str, sep)
    if sep == nil then
            sep = "%s"
    end
    local t = {}
    for str in string.gmatch(str, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end


function check_table(arg, table, mode)
    if mode == 1 then -- Если нужен поиск по ключу
        for k, v in pairs(table) do
            if k == arg then
                return true
            end
        end
    else -- Если нужен поиск по значению
        for k, v in pairs(table) do
            if v == arg then
                return true
            end
        end
    end
    return false
end