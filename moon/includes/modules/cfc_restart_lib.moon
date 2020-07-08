import Read from file
import Replace from string

RestartUrl = Read "cfc/restart/url.txt", "DATA"
RestartUrl = Replace RestartUrl, "\r", ""
RestartUrl = Replace RestartUrl, "\n", ""

export CFCRestartLib
class CFCRestartLib
    new: =>
        @timerName = nil
        @onSuccess = (result) -> print result
        @onFailure = (result) -> print result

    getRestartToken: => Read "cfc/restart/token.txt", "DATA"

    performRestart: (success, failure) =>
        http.Post RestartUrl, { restartToken: @getRestartToken! }, success, failure

    restart: => @performRestart @onSuccess, @onFailure

    generateTimerName: => "restart-countdown-#{math.Round math.Random! * 1000}"

    createTimer: (delay) =>
        @timerName = @generateTimerName!
        timer.Create @timerName, delay, 1, @restart

    stopTimer: => timer.Remove @timerName

    scheduleRestart: (delay, reason) => @createTimer delay
