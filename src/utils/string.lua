function pad(str,len)
    if (#str>=len) return str
    return "0"..pad(str,len-1)
end

function in_table(a,t)
    for b in all(t) do
        if a==b then
            return true
        end
    end
    return false
end

function merge_table(t,sep)
    sep=sep or ","
    local s=""
    for i in all(t) do
        if s!="" then
            s..=sep
        end
        s..=tostr(i)
    end
    return s
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
