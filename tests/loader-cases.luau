local rawBody,rawError,apiBody,apiStatus,apiCalls="return 'raw UI'",false,"return 'API UI'",200,0
local game={HttpGet=function(_,url)
    assert(url=="https://raw.githubusercontent.com/mochiloader/ui-d/main/UniversalUI.lua")
    if rawError then error("raw host unavailable")end
    return rawBody
end}
local request=function(options)
    apiCalls+=1
    assert(options.Url=="https://api.github.com/repos/mochiloader/ui-d/contents/UniversalUI.lua")
    assert(options.Headers.Accept=="application/vnd.github.raw+json" and not options.Headers.Authorization)
    return {StatusCode=apiStatus,Body=apiBody}
end
local function RunLoader()
-- INSERT LOADER
end
assert(RunLoader()=="raw UI" and apiCalls==0)
print("PASS loader returns the original UI API from a valid primary download")
rawError=true;assert(RunLoader()=="API UI" and apiCalls==1)
print("PASS loader falls back to GitHub's public API after a raw download failure")
rawError=false;rawBody="<html>not UI code</html>";assert(RunLoader()=="API UI" and apiCalls==2)
print("PASS loader rejects an error page and uses the valid fallback")
apiStatus=404
local ok,problem=pcall(RunLoader)
assert(not ok and tostring(problem):find("Mochi Hub UI download failed",1,true) and tostring(problem):find("HTTP 404",1,true))
print("PASS loader reports the download cause when both routes fail")
apiStatus=200;apiBody="404: Not Found"
ok,problem=pcall(RunLoader);assert(not ok and tostring(problem):find("not valid UI code",1,true))
print("PASS loader never executes an invalid API response")
rawBody="error('original UI runtime error')";apiCalls=0
ok,problem=pcall(RunLoader);assert(not ok and tostring(problem):find("original UI runtime error",1,true) and apiCalls==0)
print("PASS original UI runtime failures remain visible and are not mislabeled as download failures")
