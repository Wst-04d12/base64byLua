--base64 encoder/decoder based on Lua by wst             Copyright (C) wst.pub All rights reserved.
--table `gamesense` may has multiple subtables(components), these codes are the source code from gamesense. [Copyright (C) gamesense.pub], modified and bugs fixed by wst.

local gamesense = {
    base64
}

local wst = {

    cmd = {
        title = function(text)
            os.execute("title " .. tostring(text))
        end,
        pause = function()
            os.execute("pause")
        end,
        clear = function()
            os.execute("cls")
        end
    },

    showcredits = function()
        print("------------------------------------------------------\n"..
        "base64 encoder/decoder based on Lua by wst\n\tCopyright (C) wst.pub All rights reserved.\n\tVer 1.0"..
        "\n------------------------------------------------------")
    end,

    txt2str = function(Name, fileType) --Str Name, Str fileType; return a multiple lines String.
        if not (type(Name) == "string") then
            Name = tostring(Name)
        end
        local extName = ""
        if not fileType then
            extName = ".txt"
        else
            if not (type(fileType) == "string") then
                fileType = tostring(fileType)
            end
            extName = "." .. fileType
        end
        local absName = Name .. extName

        local target_file = io.open(absName, "r")
        if target_file == nil then
            print(absName .. ": No such file or directory")
            os.execute("pause")
        else
            io.close(target_file)
            local rtnstr = ""
            print("Reading ".. absName .. "........")
            for line in io.lines(absName) do
                rtnstr = rtnstr .. line .. "\n"
            end
            print("Done!")
            rtnstr = string.sub(rtnstr, 1, -2) --delete last `\n`
            return rtnstr
        end
    end,

    str2txt = function(str, Name, fileType) --Str string, Str Name, Str fileType.

        if not (type(Name) == "string") then
            Name = tostring(Name)
        end
        local extName = ""
        if not fileType then
            extName = ".txt"
        else
            if not (type(fileType) == "string") then
                fileType = tostring(fileType)
            end
            extName = "." .. fileType
        end
        local absName = Name .. extName
        print("Write to " .. absName .. "........")
        local txt = io.open(absName, "w")
        txt.write(txt, str)
        io.close(txt)
        print("Success!")
        return true

    end,

    instantshow = function(wst, hoster)

        local instantshow = tostring(io.read("*l"))
        local str = ""

        if hoster == "encoder" then
            str = "encode"
        elseif hoster == "decoder" then
            str = "decode"
        end

        if instantshow == "y" then
            print(wst.txt2str("output", "txt"))
        elseif instantshow ~= "n" then
            print("You can check the " .. str .. " result in output.txt.")
        else
            return
        end

    end,

    b64encoder = function(wst, mode) --Table self, Number mode[1 or 2].

        xpcall(function()
            local toencode = ""
            if mode == 1 then
                print("Input or Paste your content to encode here[In cmd, Right Click to Paste] and Press Enter.")
                toencode = tostring(io.read("*l"))
            elseif mode == 2 then
                toencode = wst.txt2str("input", "txt")
            end
            print("Encoding........")
            local encoded = gamesense.base64.encode(toencode)
            if wst.str2txt(encoded, "output", "txt") == true then
                print("Successfully encoded, the result are saved to output.txt.\nShow here right now? (y/n)")
            end
        end,

        function(err)
            error("There is an unexpected error occurred when encoding: \n" .. err)
        end)

        wst:instantshow("encoder")
        wst.cmd.pause()

    end,

    b64decoder = function(wst, mode) --Table self, Number mode[1 or 2].

        --xpcall(function()
            local encoded = ""
            if mode == 1 then
                print("Input or Paste your base64 encoded content here[In cmd, Right Click to Paste] and Press Enter.")
                encoded = tostring(io.read("*l"))
            elseif mode == 2 then
                encoded = wst.txt2str("input", "txt")
            end
            print("Decoding........")
            local decoded = gamesense.base64.decode(encoded)
             --print(decoded)
            if wst.str2txt(decoded, "output", "txt") == true then
                print("Successfully decoded, the result are saved to output.txt.\nShow here right now? (y/n) [Some of the characters might not be shown correctly in here]")
            end
        --end,

        --[[function(err)
            error("There is an unexpected error occurred when decoding: \n" .. err)
        end)]]

        wst:instantshow("decoder")
        wst.cmd.pause()

    end
}


local function Initialization()
    wst.cmd.clear()
    wst.showcredits()
    package.path = package.path .. ";./Library/?.lua;./Library/?.ljbc"
    package.cpath = package.cpath .. ";./Library/?.dll"
    xpcall(function()
        gamesense.base64 = require "base64"
        if type(gamesense.base64) == "table" then
            print("\nInitialization Succeed, Library Loaded.")
        else
            error()
        end
    end,
    function(err)
        print("\nCannot load the base64 Library from ./Library/base64.lua, because there is an unexpected error occurred: \n\n" .. err)
        wst.cmd.pause()
        os.exit()
    end)
end

local function main()

    Initialization()
    --print(wst.txt2str('test'))

    print("\nPlease select the mode of the encoder/decoder:\nMode 1: You input or paste your content to encode or base64 encoded content here.\nMode 2: You put your content to encode or base64 encoded content into input.txt.\n**Important: Because of the Terminal like cmd or Powershell on Windows has a LIMITED number of how many characters you can paste in this window, so I strongly recommend you to put the unprocessed content into input.txt and use Mode 2 especially when your content is pretty long.\n\nInput the Mode.(1/2)")

    local mode = nil
    local actType = nil

    repeat
        mode = io.read("*l")
        if mode == "1" or mode == "2" then
            break
        else
            print("Please give a valid input.")
        end
    until tonumber(mode) == 1 or tonumber(mode) == 2
    if not (type(mode) == "number") then
        mode = tonumber(mode)
    end

    print("Please select that you want to encode or decode content? (e/d)")

    repeat
        actType = io.read("*l")
        if actType == "e" or actType == "d" then
            wst.cmd.clear()
            break
        else
            print("Please give a valid input.")
        end
    until tostring(actType) == "e" or tostring(actType) == "d"
    if not (type(actType) == "string") then
        actType = tostring(actType)
    end
     --print(type(actType), actType, type(mode), mode)
    if actType == "e" then
        wst:b64encoder(mode)
    elseif actType == "d" then
        wst:b64decoder(mode)
    end

end

main()
