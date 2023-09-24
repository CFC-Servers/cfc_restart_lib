import Read from file
import Replace from string

RestartUrl = CreateConVar "cfc_restart_url", "", FCVAR_PROTECTED, "URL of the Restart endpoint"
RestartToken = CreateConVar "cfc_restart_token", "", FCVAR_PROTECTED, "Token for the Restart endpoint"

export CFCRestartLib
class CFCRestartLib
    new: =>
        @timerName = nil
        @onSuccess = (result) -> print result
        @onFailure = (result) -> print result

    performRestart: (success, failure) =>
        http.Post RestartUrl\GetString!, {}, success, failure, { Authorization: RestartToken\GetString! }

    restart: => @performRestart @onSuccess, @onFailure

    generateTimerName: => "restart-countdown-#{math.Round math.random! * 1000}"

    createTimer: (delay) =>
        @timerName = @generateTimerName!
        timer.Create @timerName, delay, 1, -> @restart!

    stopTimer: => timer.Remove @timerName

    scheduleRestart: (delay, reason) => @createTimer delay
