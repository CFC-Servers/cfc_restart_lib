local Read
Read = file.Read
local Replace
Replace = string.Replace
local RestartUrl = CreateConVar("cfc_restart_url", "", FCVAR_PROTECTED, "URL of the Restart endpoint")
local RestartToken = CreateConVar("cfc_restart_token", "", FCVAR_PROTECTED, "Token for the Restart endpoint")
do
  local _class_0
  local _base_0 = {
    performRestart = function(self, success, failure)
      return http.Post(RestartUrl:GetString(), { }, success, failure, {
        Authorization = RestartToken:GetString()
      })
    end,
    restart = function(self)
      return self:performRestart(self.onSuccess, self.onFailure)
    end,
    generateTimerName = function(self)
      return "restart-countdown-" .. tostring(math.Round(math.random() * 1000))
    end,
    createTimer = function(self, delay)
      self.timerName = self:generateTimerName()
      return timer.Create(self.timerName, delay, 1, function()
        return self:restart()
      end)
    end,
    stopTimer = function(self)
      return timer.Remove(self.timerName)
    end,
    scheduleRestart = function(self, delay, reason)
      return self:createTimer(delay)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.timerName = nil
      self.onSuccess = function(result)
        return print(result)
      end
      self.onFailure = function(result)
        return print(result)
      end
    end,
    __base = _base_0,
    __name = "CFCRestartLib"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  CFCRestartLib = _class_0
  return _class_0
end
