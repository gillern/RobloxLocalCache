local Cache = {}

function Cache.Get(Key, Scope)
	if (not Scope) then Scope = "Default" end
	
	if (Cache.Values and Cache.Values[Scope] and Cache.Values[Scope][Key] ~= nil) then
		return Cache.Values[Scope][Key]
	else
		return nil
	end
end

function Cache.Set(Key, Value, Scope)
	if (not Scope) then Scope = "Default" end
	
	if (not Cache.Values) then
		Cache.Values = {}
	end
	
	if (not Cache.Values[Scope]) then
		Cache.Values[Scope] = {}
	end
	
	Cache.Values[Scope][Key] = Value
	
	if (Cache.Events) then
		local EventKey = tostring(Scope) .. "/" .. tostring(Key)
		
		if (Cache.Events[EventKey]) then
			Cache.Events[EventKey]:Fire(Key, Value, Scope)
		end
	end
	
	if (next(Cache.Values[Scope]) == nil) then
		Cache.Values[Scope] = nil
		
		if (next(Cache.Values) == nil) then
			Cache.Values = nil
		end
	end
end

function Cache.GetChangedEvent(Key, Scope)
	if (not Scope) then Scope = "Default" end
	
	local EventKey = tostring(Scope) .. "/" .. tostring(Key)
	
	if (not Cache.Events) then
		Cache.Events = {}
	end
	
	if (Cache.Events[EventKey]) then
		return Cache.Events[EventKey]
	else
		local Event = Instance.new("BindableEvent")
		Event.Name = EventKey
		Event.Parent = nil
		
		Cache.Events[EventKey] = Event
		
		return Event
	end
end

return Cache
