# window-restore
Emulates clicking the currently active, or frontmost, application in the dock. What this does depends that specific application, but more often than not it restores the applications primary window.

## Features
- Matches the name of the active application with a corresponding dock item. Uses _includes_ to match short and long names - Chrome with Google Chrome, for example.
- By default binds (`Cmd + Alt + W`) to restore a window.  

## Installation

**Install Hammerspoon**  
 If you haven't installed Hammerspoon yet, download it from [here](https://www.hammerspoon.org/) and follow the installation instructions.
 Take a look at their [Github repo](https://github.com/Hammerspoon/hammerspoon) for more information.

**Clone the Repository to `.hammerspoon/Spoons`**  
 Clone this repository into the `.hammerspoon/Spoons` directory using the following command:

```bash
git clone https://github.com/silasburger/restore-window ~/.hammerspoon/Spoons/WindowRestore.spoon
```

**Add to Hammerspoon Configuration**
`.hammerspoon/init.lua`
```lua
hs.loadSpoon("WindowRestore")
spoon.WindowRestore:bindHotkeys()
```

## Notes
- Easily customizable hotkeys, for example:
`.hammerspoon/init.lua`
  ```lua
  hs.loadSpoon("WindowRestore")
  spoon.WindowRestore:bindHotkeys({
    restore_window = { {"cmd", "alt"}, "e" } 
  })
  ```