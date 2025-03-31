local obj = {}
obj.__index = obj

-- Metadata
obj.name = "RestoreWindow"
obj.version = "1.1"
obj.author = "Silas Burger"
obj.license = "MIT"

-- Function to focus the Dock and select the current app
function obj:windowRestore()
    -- Get the Dock element
    local axuielement = require("hs.axuielement")
    local dockElement = axuielement.applicationElement("com.apple.dock")

    -- Function to get the currently active application
    local function getFrontmostApp()
        local frontApp = hs.application.frontmostApplication()
        print("Currently active application: " .. frontApp:name())
        return frontApp:name()
    end

    -- Function to get the list of application names in the Dock
    local function getDockAppNames()
        local appNames = {}

        -- Loop through the children of the Dock element
        for _, child in ipairs(dockElement[1]) do
            if child.AXSubrole == "AXApplicationDockItem" then
                table.insert(appNames, child.AXTitle) -- App name is stored in AXTitle
            end
        end
        return appNames
    end

    local function trimTrailingNumbers(str)
        return string.gsub(str, "[%s%d]+$", "") 
    end

    -- Comparison function with partial string match
    local function findAppInDock(activeAppName, dockApps)
        -- Convert to lowercase
        local activeAppName = trimTrailingNumbers(activeAppName:lower())

        for _, appName in ipairs(dockApps) do
            local dockAppName = trimTrailingNumbers(appName:lower())

            -- Partial string matching: check if the simplified active app name is part of any dock app name
            if dockAppName:find(activeAppName, 1, true) then
                print("Matched dock item: " .. appName)
                return appName
            end
        end
        return nil
    end

    -- Press dock child based on name
    local function pressDockChild(appName)
        for _, child in ipairs(dockElement[1]) do
            if child.AXSubrole == "AXApplicationDockItem" then
                if child.AXTitle == appName then
                    child:performAction("AXPress") -- Simulates a click on the Dock item
                    print("Pressed dock item")
                    return
                end
            end
        end
    end

    -- Get the Dock applications
    local dockAppNames = getDockAppNames()

    -- Check if the active application is in the Dock
    local currentlyActiveApp = getFrontmostApp()
    local dockAppName = findAppInDock(currentlyActiveApp, dockAppNames)
    if dockAppName then
        print("The active app is in the Dock.")
        pressDockChild(dockAppName)
    else
        print("The active app is NOT in the Dock.")
    end
end


-- Bind hotkey function
function obj:bindHotkeys(map)
    if map then
        -- Use the map provided (for example, a map could be provided as an argument when calling this function)
        local def = {
            restore_window = hs.fnutils.partial(self.windowRestore, self)
        }
        -- Bind the hotkeys based on the specification in map
        hs.spoons.bindHotkeysToSpec(def, map)
        return
    end
    -- Bind default hotkey (cmd + alt + e) for windowRestore function if no mapping is passed
    hs.hotkey.bind({"cmd", "alt"}, "w", function()
        self:windowRestore()
    end)
end

return obj

