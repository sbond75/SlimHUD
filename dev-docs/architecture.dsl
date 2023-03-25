# https://structurizr.com/dsl

workspace {
    model {
        sparkle = element "Sparkle" "Framework"
        softwareSystem = softwareSystem "SlimHUD" {
            
            services = container "Services" {
                keyboardManager = component "KeyboardManager"
                appleScriptRunner = component "AppleScriptRunner"
                volumeManager = component "VolumeManager" {
                    this -> appleScriptRunner "Delegate volume info retrieval
                }
                displayManager = component "DisplayManager"
                positionManager = component "PositionManager"
                hudAnimator = component "HudAnimator"
                iconManager = component "IconManager"
                displayer = component "Displayer" {
                    this -> positionManager "Ask to calculate HUD position on screen"
                    this -> iconManager "Delegate icons retrieval
                    this -> keyboardManager "Get current keyboard brightness"
                    this -> volumeManager "Get current volume info"
                    this -> displayManager "Get current brightness"
                }
                changesObserver = component "ChangesObserver" {
                    this -> keyboardManager "Check for keyboard brightness"
                    this -> volumeManager "Check for volume changes"
                    this -> displayManager "Check for brightness changes"
                    this -> displayer "Notifies on changes"
                }
                keyPressObserver = component "KeyPressObserver" {
                    this -> changesObserver "Notifies when media key is pressed"
                }
                userDefaultsManager = component "UserDefaultsManager"
                settingsManager = component "SettingsManager" "Stores all settings" {
                    this -> userDefaultsManager "Delegate reading and writing of user defaults"
                }
                OSDUIManager = component "OSDUIManager"
                appDelegate = component "AppDelegate" {
                    this -> OSDUIManager "hide / show default macOS Huds on startup / quit"
                }
                
                updaterDelegate = component "UpdaterDelegate" {
                    sparkle -> this "Get channel for updates: beta / normal"
                }
            }
            userDefaults = container "UserDefaults" {
                userDefaultsManager -> this
            }
            viewElements = container "Views" {
                barView = component "BarView"
                hud = component "Hud" {
                    this -> hudAnimator "Delegate in/out animation of HUDs"
                    this -> barView "contains"
                }
            }
        }
    }

    views {

        theme default
    }

}