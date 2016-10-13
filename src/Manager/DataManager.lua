
DataManager.__cname = "DataManager"

DataManager._classes = {}
DataManager._values = {}
DataManager._aliasClass = {}  -- alias of classes. exist in pairs. below two value exist simultaneously.
DataManager._aliasValue = {}  -- eg: DataManager._aliasClass[a] = b, DataManager._aliasClass[b] = a

function DataManager:getInstance(...)
    if DataManager._instance == nil then
        DataManager._instance = DataManager:ctor(...)
    end
    return DataManager._instance
end

function DataManager:ctor(...)
	return self
end

function DataManager:storeClass(class)
	if class.__cname then
		if not DataManager._classes[class.__cname] then
			DataManager._classes[class.__cname] = class
		else
			printError("Store class failed. (value " .. name .. " is already exists)")
		end
	else
		printError("class is a nil cocos class")
	end
end

function DataManager:getClass(name)
	if DataManager._classes[name] then
		return DataManager._classes[name]
	else
		printError("Get Class failed. (value " .. name .. " is not exists)")
	end
end

function DataManager:removeClass(name)
	if DataManager._classes[name] then
		DataManager._classes[name] = nil
		local alies = DataManager._aliasClass[name]
		if alies then
			DataManager._classes[alies] = nil
			DataManager._aliasClass[name] = nil
			DataManager._aliasClass[alies] = nil
		end
	else
		print("Remove class failed. (" .. name .. " No such class)")
	end
end

function DataManager:aliasClass(orgName, newName)
	local orgCls = DataManager._classes[newName]
	if not orgCls then
		printError("Alias class error. (" .. orgName .. " No such class)")
		return
	end
	if self:getClass(newName) then
		printError("Alias error. (value " .. newName .. " is already exist)")
		return
	end
	self._classes[newName] = orgCls
	self._aliasClass[orgName] = newName
	self._aliasClass[newName] = orgName
end

function DataManager:storeValue(name, value)
	if not DataManager._values[name] then
		DataManager._values[name] = value
	else
		printError("Store value failed. (value " .. name .. " is already exists)")
	end
end

function DataManager:getValue(name)
	if DataManager._values[name] then
		return DataManager._values[name]
	else
		printError("Get value failed. (" .. name .. " No such value)")
	end
end

function DataManager:removeValue(name)
	if DataManager._values[name] then
		DataManager._values[name] = nil
		local alies = DataManager._aliasValue[name]
		if alies then
			DataManager._values[alies] = nil
			DataManager._aliasValue[name] = nil
			DataManager._aliasValue[alies] = nil
		end
	else
		print("Remove value failed. (" .. name .. " No such value)")
	end
end

function DataManager:aliasValue(orgName, newName)
	local orgVal = DataManager._values[orgName]
	if not orgVal then
		printError("Alias value error. (" .. orgName .. " No such value)")
		return
	end
	if DataManager._values[newName] then
		printError("Alias error. (value " .. newName .. " is already exist)")
		return
	end
	self._values[newName] = orgVal
	self._aliasValue[orgName] = newName
	self._aliasValue[newName] = orgName
end

DM = DataManager
