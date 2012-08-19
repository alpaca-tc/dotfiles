if application "Safari" is running then
    tell application "Safari"
        do JavaScript "location.reload(true);" in document 1
    end tell
end if

if application "Google Chrome" is running then
    tell application "Google Chrome" to reload active tab of window 1
end if
