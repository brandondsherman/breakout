EventHandler = Class{}


function EventHandler:init(  )
    self.listeners = {}
end

function EventHandler:subscribe(listener, listeningToEvent)
    if self.listeners[listeningToEvent] then
        table.insert(self.listeners[listeningToEvent], listener)    
        return true
    else 
        self.listeners[listeningToEvent] = {}
        table.insert(self.listeners[listeningToEvent], listener)
        return true
    end
    return false
end

function EventHandler:alert(event)
    if self.listeners[event] then
        for _, subscriber in pairs(self.listeners[event]) do
            subscriber:alert(event)
        end
        return true
    end
    return false
end