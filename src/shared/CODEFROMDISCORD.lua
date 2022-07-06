local events = {}

local Event = {}
Event.__index = Event

local TweenService = game:GetService("TweenService")

function Event.new(item)
    if not item:IsA("BasePart") then return end
    local self = setmetatable({},Event)
    self.Object = item
    self.Enabled = true
    self.Debounces = {}
    self.Event = item.Touched:Connect(function(hit)
        if item.Transparency == 1 then return end
        local player = game.Players:GetPlayerFromCharacter(hit.Parent)
        if not player then return end
        if table.find(self.Debounces,player) then return end
        table.insert(self.Debounces,player)
        local character = player.Character
        if not character then return end
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        humanoid:TakeDamage(humanoid.MaxHealth)
        task.delay(0.5,function()
            table.remove(
                self.Debounces,
                table.find(self.Debounces,player)
            )
        end)
    end)
    local states = {
        {Transparency = 0, CanCollide = true},
        {Transparency = 1, CanCollide = false}
    }
    local OnState = 1
    local TimeBetween = script:WaitForChild("TimeBetween").Value
    coroutine.wrap(function()
        while task.wait() and self.Enabled do
            TweenService:Create(
                self.Object,
                TweenInfo.new(0.35),
                states[OnState]
            ):Play()
            OnState = OnState < #states and OnState + 1 or 1
            task.wait(TimeBetween)
        end
    end)()
    return self
end

function Event:Release()
    self.Enabled = false
    self.Event:Disconnect()
end

local function Added(item)
    events[item] = Event.new(item)
end

local function Removed(item)
    if events[item] then
        events[item]:Release()
    end
end

return {
    OnAdded = Added,
    OnRemoved = Removed
}