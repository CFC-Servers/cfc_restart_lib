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

    getRestartToken: =>
        token = Read "cfc/restart/token.txt", "DATA"
        token = Replace token, "\r", ""
        token = Replace token, "\n", ""
        return token

    performRestart: (success, failure) =>
        http.Post RestartUrl, {}, success, failure, { Authorization: @getRestartToken! }

    restart: => @performRestart @onSuccess, @onFailure

    generateTimerName: => "restart-countdown-#{math.Round math.random! * 1000}"

    createTimer: (delay) =>
        @timerName = @generateTimerName!
        timer.Create @timerName, delay, 1, -> @restart!

    stopTimer: => timer.Remove @timerName

    scheduleRestart: (delay, reason) => @createTimer delay
