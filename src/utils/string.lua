function pad(str,len)
    if (#str>=len) return str
    return "0"..pad(str,len-1)
end
