function pad(str,len)
    if (#str>=len) return str
    return "0"..pad(str,len-1)
end

function var_dump(t)
    for k,v in pairs(t) do
        if type(v)=="function" or type(v)=="table" then
            printh(k..":"..type(v))
        else
            printh(k..":"..type(v)..":"..tostr(v))
        end
    end
end
