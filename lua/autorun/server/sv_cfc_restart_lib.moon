RestartUrl = file.Read "cfc/restart/url.txt", "DATA"
RestartUrl = string.Replace RestartUrl, "\r", ""
RestartUrl = string.Replace RestartUrl, "\n", ""

getRestartToken = -> file.Read "cfc/restart/token.txt", "DATA"

restart = (success, failure) -> http.Post RestartUrl, { restartToken: getRestartToken! }, success, failure

generateTimerName = -> "restart-countdown-#{math.Round(math.Random! * 1000)}"

class CFCRestartLib
    new: =>
        @timerName = nil
        @onSuccess = (result) -> print result
        @onFailure = (result) -> print result
    restart: => restart @onSuccess, @onFailure
    createTimer: (delay) =>
        @timerName = generateTimerName!

        timer.Create @timerName, delay, 1, @restart

    stopTimer: => timer.Remove @timerName


    scheduleRestart: (delay, reason) => @createTimer delay
