-- Mochi Hub loader. Returns the original UI API for your existing feature code.
assert(type(loadstring)=="function", "Mochi Hub requires loadstring support")
local repository="mochiloader/ui-d"
local failure="No response"
local function Compile(body)
    if type(body)~="string" or body=="" then failure="Empty download";return nil end
    local ok,chunk,problem=pcall(loadstring,body,"MochiHub/UI")
    if ok and type(chunk)=="function" then return chunk end
    failure="Downloaded content was not valid UI code: "..tostring(problem or chunk)
    return nil
end
local ok,body=pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/"..repository.."/main/UniversalUI.lua")
end)
local chunk
if ok then chunk=Compile(body) else failure=tostring(body) end
if not chunk then
    local send
    for _,probe in ipairs({function()return request end,function()return http_request end,
        function()return syn and syn.request end,function()return http and http.request end}) do
        local available,candidate=pcall(probe)
        if available and type(candidate)=="function" then send=candidate;break end
    end
    if send then
        local fetched,response=pcall(send,{
            Url="https://api.github.com/repos/"..repository.."/contents/UniversalUI.lua",
            Method="GET",Headers={Accept="application/vnd.github.raw+json"},
        })
        if fetched and type(response)=="table" and tonumber(response.StatusCode)==200 then
            chunk=Compile(response.Body)
        else
            failure=fetched and ("GitHub returned HTTP "..tostring(type(response)=="table" and response.StatusCode or "unknown")) or tostring(response)
        end
    end
end
assert(chunk,"Mochi Hub UI download failed: "..failure)
return chunk()
