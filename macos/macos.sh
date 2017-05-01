#!/usr/bin/env bash
# Subset of preferences from https://github.com/mathiasbynens/dotfiles/blob/master/.macos


# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Set computer name (as done via System Preferences → Sharing)
sudo scutil --set ComputerName "MacBookAir"
sudo scutil --set HostName "MacBookAir"
sudo scutil --set LocalHostName "MacBookAir"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "MacBookAir"

# Menu bar: hide the Time Machine, Volume, and User icons
# for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
# 	defaults write "${domain}" dontAutoLoad -array \
# 		"/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
# 		"/System/Library/CoreServices/Menu Extras/Volume.menu" \
# 		"/System/Library/CoreServices/Menu Extras/User.menu"
# done
# defaults write com.apple.systemuiserver menuExtras -array \
# 	"/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
# 	"/System/Library/CoreServices/Menu Extras/AirPort.menu" \
# 	"/System/Library/CoreServices/Menu Extras/Battery.menu" \
# 	"/System/Library/CoreServices/Menu Extras/Clock.menu"


###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Set language and text formats
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en" "es"
defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true


###############################################################################
# General UI/UX                                                               #
###############################################################################

# Dark theme for the Dock and menubar
defaults write NSGlobalDomain AppleInterfaceStyle Dark
sudo defaults write /Library/Preferences/.GlobalPreferences AppleInterfaceTheme Dark

# Position left on screen
defaults write com.apple.dock orientation -string left

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
sudo systemsetup -settimezone "Europe/London" > /dev/null

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Stop iTunes from responding to the keyboard media keys
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null


###############################################################################
# Screen                                                                      #
###############################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 0
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: allows quitting Finder via ⌘ + Q; doing so will also hide desktop icons
# Otherwise Finder is always open
defaults write com.apple.finder QuitMenuItem -bool true

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: hide status bar
defaults write com.apple.finder ShowStatusBar -bool false

# Finder: hide path bar
defaults write com.apple.finder ShowPathbar -bool false

# New window points to home
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable Automatical open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool false
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool false
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool false

# Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Show item info to the right of the icons on the desktop
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 60" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 60" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 60" ~/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 40" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 40" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 40" ~/Library/Preferences/com.apple.finder.plist

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Remove Dropbox’s green checkmark icons in Finder
# file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
# [ -e "${file}" ] && mv -f "${file}" "${file}.bak"

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock tilesize -int 36

# Change minimize/maximize window effect
defaults write com.apple.dock mineffect -string "suck"

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
#defaults write com.apple.dock persistent-apps -array

# Show only open applications in the Dock
#defaults write com.apple.dock static-only -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
# defaults write com.apple.dock autohide-time-modifier -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Mission Control
# defaults write com.apple.dock wvous-tl-corner -int 2
# defaults write com.apple.dock wvous-tl-modifier -int 0
# Bottom right screen corner → Desktop
defaults write com.apple.dock wvous-br-corner -int 4
defaults write com.apple.dock wvous-br-modifier -int 0
# Bottom left screen corner → Start screen saver
# defaults write com.apple.dock wvous-bl-corner -int 5
# defaults write com.apple.dock wvous-bl-modifier -int 0


###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Hide Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Enable continuous spellchecking
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
# Disable auto-correct
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

# Block pop-up windows
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

# Enable “Do Not Track”
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# Update extensions automatically
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

###############################################################################
# Mail                                                                        #
###############################################################################

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Disable automatic spell checking
# defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"


###############################################################################
# Terminal & iTerm 2                                                          #
###############################################################################

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Enable Secure Keyboard Entry in Terminal.app
# See: https://security.stackexchange.com/a/47786/8918
defaults write com.apple.terminal SecureKeyboardEntry -bool true


defaults write com.apple.Terminal "Window Settings" -dict-add "Hybrid" "
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
	<key>ANSIBlackColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECcw
	LjE2NjU2NDQ2NDYgMC4xODE4MDI2NjAyIDAuMjAxNzk2OTE5MQAQAoAC0hAREhNaJGNs
	YXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hp
	dmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhOW2KMjpCVoKmxtL3P0tcAAAAAAAABAQAAAAAA
	AAAZAAAAAAAAAAAAAAAAAAAA2Q==
	</data>
	<key>ANSIBlueColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECcw
	LjQzMDMxODgzMjQgMC41NjU5Njg5OTAzIDAuNjkxMDM4MzcwMQAQAoAC0hAREhNaJGNs
	YXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hp
	dmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhOW2KMjpCVoKmxtL3P0tcAAAAAAAABAQAAAAAA
	AAAZAAAAAAAAAAAAAAAAAAAA2Q==
	</data>
	<key>ANSIBrightBlackColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECcw
	LjExNDgyNzM1NzIgMC4xMjAyMDAyNDY2IDAuMTMyMjgyODM4MgAQAoAC0hAREhNaJGNs
	YXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hp
	dmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhOW2KMjpCVoKmxtL3P0tcAAAAAAAABAQAAAAAA
	AAAZAAAAAAAAAAAAAAAAAAAA2Q==
	</data>
	<key>ANSIBrightBlueColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECcw
	LjI5NjA1ODExODMgMC40MjA3MzQ3MDM1IDAuNTMzMzgzOTA1OQAQAoAC0hAREhNaJGNs
	YXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hp
	dmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhOW2KMjpCVoKmxtL3P0tcAAAAAAAABAQAAAAAA
	AAAZAAAAAAAAAAAAAAAAAAAA2Q==
	</data>
	<key>ANSIBrightCyanColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECcw
	LjMwMTk4NDEzMTMgMC40ODM0MTYzNzg1IDAuNDU0NzQ3MzE5MgAQAoAC0hAREhNaJGNs
	YXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hp
	dmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhOW2KMjpCVoKmxtL3P0tcAAAAAAAABAQAAAAAA
	AAAZAAAAAAAAAAAAAAAAAAAA2Q==
	</data>
	<key>ANSIBrightGreenColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECcw
	LjQ3Mjc5Nzg0MDggMC41MTcyNjAyNTM0IDAuMTkzNDkxNDI5MQAQAoAC0hAREhNaJGNs
	YXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hp
	dmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhOW2KMjpCVoKmxtL3P0tcAAAAAAAABAQAAAAAA
	AAAZAAAAAAAAAAAAAAAAAAAA2Q==
	</data>
	<key>ANSIBrightMagentaColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECcw
	LjQzMTg1NzE5ODUgMC4zMTMyMjA2MjAyIDAuNDc1MTI4NDcxOQAQAoAC0hAREhNaJGNs
	YXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hp
	dmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhOW2KMjpCVoKmxtL3P0tcAAAAAAAABAQAAAAAA
	AAAZAAAAAAAAAAAAAAAAAAAA2Q==
	</data>
	<key>ANSIBrightRedColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECcw
	LjU1MjczNDg1MTggMC4xNzkwMDcyNDcxIDAuMTk2MjkwNjI3MQAQAoAC0hAREhNaJGNs
	YXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hp
	dmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhOW2KMjpCVoKmxtL3P0tcAAAAAAAABAQAAAAAA
	AAAZAAAAAAAAAAAAAAAAAAAA2Q==
	</data>
	<key>ANSIBrightWhiteColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECcw
	LjM1MzA0NzQwMDcgMC4zODI2NjUxODcxIDAuNDE0NTQ5Nzk3OAAQAoAC0hAREhNaJGNs
	YXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hp
	dmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhOW2KMjpCVoKmxtL3P0tcAAAAAAAABAQAAAAAA
	AAAZAAAAAAAAAAAAAAAAAAAA2Q==
	</data>
	<key>ANSIBrightYellowColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECYw
	Ljg5OTU1ODM2NTMgMC41Mzk2ODY1MDEgMC4zMTMxMTYxMzMyABACgALSEBESE1okY2xh
	c3NuYW1lWCRjbGFzc2VzV05TQ29sb3KiEhRYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2
	ZXLRFxhUcm9vdIABCBEaIy0yNztBSE5bYouNj5SfqLCzvM7R1gAAAAAAAAEBAAAAAAAA
	ABkAAAAAAAAAAAAAAAAAAADY
	</data>
	<key>ANSICyanColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECYw
	LjQ5OTUyNDk1MSAwLjc0NzI1ODAwNzUgMC43MDQ5MjgzOTgxABACgALSEBESE1okY2xh
	c3NuYW1lWCRjbGFzc2VzV05TQ29sb3KiEhRYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2
	ZXLRFxhUcm9vdIABCBEaIy0yNztBSE5bYouNj5SfqLCzvM7R1gAAAAAAAAEBAAAAAAAA
	ABkAAAAAAAAAAAAAAAAAAADY
	</data>
	<key>ANSIGreenColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECcw
	LjcwMjI2Njc1MjcgMC43NDgwOTg0OTI2IDAuMzUzOTY0NjI2OAAQAoAC0hAREhNaJGNs
	YXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hp
	dmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhOW2KMjpCVoKmxtL3P0tcAAAAAAAABAQAAAAAA
	AAAZAAAAAAAAAAAAAAAAAAAA2Q==
	</data>
	<key>ANSIMagentaColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECcw
	LjYzMDE1MDMxODEgMC40OTQ5NTMzMDQ1IDAuNjczMjcxMTc5MgAQAoAC0hAREhNaJGNs
	YXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hp
	dmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhOW2KMjpCVoKmxtL3P0tcAAAAAAAABAQAAAAAA
	AAAZAAAAAAAAAAAAAAAAAAAA2Q==
	</data>
	<key>ANSIRedColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECcw
	LjcyMDAzMjI3NDcgMC4zMDIxMTU0NzAyIDAuMzE1Njk0ODM4OAAQAoAC0hAREhNaJGNs
	YXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hp
	dmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhOW2KMjpCVoKmxtL3P0tcAAAAAAAABAQAAAAAA
	AAAZAAAAAAAAAAAAAAAAAAAA2Q==
	</data>
	<key>ANSIWhiteColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECYw
	LjcxMDEwNjI1MzYgMC43MjM5ODAyNDggMC43MTQyODk3ODQ0ABACgALSEBESE1okY2xh
	c3NuYW1lWCRjbGFzc2VzV05TQ29sb3KiEhRYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2
	ZXLRFxhUcm9vdIABCBEaIy0yNztBSE5bYouNj5SfqLCzvM7R1gAAAAAAAAEBAAAAAAAA
	ABkAAAAAAAAAAAAAAAAAAADY
	</data>
	<key>ANSIYellowColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECcw
	Ljg5MzM2MjY0MTMgMC43MTAxNTgzNDgxIDAuMzY5NzQ0ODk2OQAQAoAC0hAREhNaJGNs
	YXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hp
	dmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhOW2KMjpCVoKmxtL3P0tcAAAAAAAABAQAAAAAA
	AAAZAAAAAAAAAAAAAAAAAAAA2Q==
	</data>
	<key>BackgroundColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECow
	LjA4NjkzNzU5ODg4IDAuMDkyMTQyNzAxMTUgMC4wOTc3MDc3NTU4NgAQAoAC0hAREhNa
	JGNsYXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFy
	Y2hpdmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhOW2KPkZOYo6y0t8DS1doAAAAAAAABAQAA
	AAAAAAAZAAAAAAAAAAAAAAAAAAAA3A==
	</data>
	<key>CursorColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECcw
	LjcxOTMzNzY0MjIgMC43Mzc4MTcyMjc4IDAuNzI3OTgzNTkzOQAQAoAC0hAREhNaJGNs
	YXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hp
	dmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhOW2KMjpCVoKmxtL3P0tcAAAAAAAABAQAAAAAA
	AAAZAAAAAAAAAAAAAAAAAAAA2Q==
	</data>
	<key>ProfileCurrentVersion</key>
	<real>2.04</real>
	<key>SelectionColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECcw
	LjExNzcyMTQ1MzMgMC4xMjMxMjc2OTE0IDAuMTM1MjgwMTQ3MgAQAoAC0hAREhNaJGNs
	YXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hp
	dmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhOW2KMjpCVoKmxtL3P0tcAAAAAAAABAQAAAAAA
	AAAZAAAAAAAAAAAAAAAAAAAA2Q==
	</data>
	<key>TextBoldColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECcw
	LjcxOTMzNzY0MjIgMC43Mzc4MTcyMjc4IDAuNzI3OTgzNTkzOQAQAoAC0hAREhNaJGNs
	YXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hp
	dmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhOW2KMjpCVoKmxtL3P0tcAAAAAAAABAQAAAAAA
	AAAZAAAAAAAAAAAAAAAAAAAA2Q==
	</data>
	<key>TextColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECcw
	LjcxOTMzNzY0MjIgMC43Mzc4MTcyMjc4IDAuNzI3OTgzNTkzOQAQAoAC0hAREhNaJGNs
	YXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hp
	dmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhOW2KMjpCVoKmxtL3P0tcAAAAAAAABAQAAAAAA
	AAAZAAAAAAAAAAAAAAAAAAAA2Q==
	</data>
	<key>columnCount</key>
	<integer>120</integer>
	<key>name</key>
	<string>Hybrid</string>
	<key>rowCount</key>
	<integer>90</integer>
	<key>type</key>
	<string>Window Settings</string>
</dict>
</plist>"

# Set the "Basic Improved" as the default
defaults write com.apple.Terminal "Startup Window Settings" -string "Hybrid"
defaults write com.apple.Terminal "Default Window Settings" -string "Hybrid"

# CFPreferencesAppSynchronize "com.apple.Terminal"



<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Ansi 0 Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.12941176470588237</real>
		<key>Green Component</key>
        <real>0.12941176470588237</real>
		<key>Red Component</key>
        <real>0.12941176470588237</real>
	</dict>
	<key>Ansi 1 Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.44313725490196076</real>
		<key>Green Component</key>
        <real>0.027450980392156862</real>
		<key>Red Component</key>
        <real>0.7647058823529411</real>
	</dict>
	<key>Ansi 10 Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.6862745098039216</real>
		<key>Green Component</key>
        <real>0.8431372549019608</real>
		<key>Red Component</key>
        <real>0.37254901960784315</real>
	</dict>
	<key>Ansi 11 Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.18823529411764706</real>
		<key>Green Component</key>
        <real>0.8941176470588236</real>
		<key>Red Component</key>
        <real>0.9529411764705882</real>
	</dict>
	<key>Ansi 12 Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.9882352941176471</real>
		<key>Green Component</key>
        <real>0.7333333333333333</real>
		<key>Red Component</key>
        <real>0.12549019607843137</real>
	</dict>
	<key>Ansi 13 Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.8705882352941177</real>
		<key>Green Component</key>
        <real>0.3333333333333333</real>
		<key>Red Component</key>
        <real>0.40784313725490196</real>
	</dict>
	<key>Ansi 14 Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.8</real>
		<key>Green Component</key>
        <real>0.7215686274509804</real>
		<key>Red Component</key>
        <real>0.30980392156862746</real>
	</dict>
	<key>Ansi 15 Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.9450980392156862</real>
		<key>Green Component</key>
        <real>0.9450980392156862</real>
		<key>Red Component</key>
        <real>0.9450980392156862</real>
	</dict>
	<key>Ansi 2 Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.47058823529411764</real>
		<key>Green Component</key>
        <real>0.6549019607843137</real>
		<key>Red Component</key>
        <real>0.06274509803921569</real>
	</dict>
	<key>Ansi 3 Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.0784313725490196</real>
		<key>Green Component</key>
        <real>0.611764705882353</real>
		<key>Red Component</key>
        <real>0.6588235294117647</real>
	</dict>
	<key>Ansi 4 Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.7686274509803922</real>
		<key>Green Component</key>
        <real>0.5568627450980392</real>
		<key>Red Component</key>
        <real>0.0</real>
	</dict>
	<key>Ansi 5 Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.4745098039215686</real>
		<key>Green Component</key>
        <real>0.23529411764705882</real>
		<key>Red Component</key>
        <real>0.3215686274509804</real>
	</dict>
	<key>Ansi 6 Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.7294117647058823</real>
		<key>Green Component</key>
        <real>0.6470588235294118</real>
		<key>Red Component</key>
        <real>0.12549019607843137</real>
	</dict>
	<key>Ansi 7 Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.8509803921568627</real>
		<key>Green Component</key>
        <real>0.8509803921568627</real>
		<key>Red Component</key>
        <real>0.8509803921568627</real>
	</dict>
	<key>Ansi 8 Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.25882352941176473</real>
		<key>Green Component</key>
        <real>0.25882352941176473</real>
		<key>Red Component</key>
        <real>0.25882352941176473</real>
	</dict>
	<key>Ansi 9 Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.47843137254901963</real>
		<key>Green Component</key>
        <real>0.0</real>
		<key>Red Component</key>
        <real>0.984313725490196</real>
	</dict>
	<key>Background Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.12941176470588237</real>
		<key>Green Component</key>
        <real>0.12941176470588237</real>
		<key>Red Component</key>
        <real>0.12941176470588237</real>
	</dict>
	<key>Bold Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.47843137254901963</real>
		<key>Green Component</key>
        <real>0.0</real>
		<key>Red Component</key>
        <real>0.984313725490196</real>
	</dict>
	<key>Cursor Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.9882352941176471</real>
		<key>Green Component</key>
        <real>0.7333333333333333</real>
		<key>Red Component</key>
        <real>0.12549019607843137</real>
	</dict>
	<key>Cursor Text Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.9450980392156862</real>
		<key>Green Component</key>
        <real>0.9450980392156862</real>
		<key>Red Component</key>
        <real>0.9450980392156862</real>
	</dict>
	<key>Foreground Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.9450980392156862</real>
		<key>Green Component</key>
        <real>0.9450980392156862</real>
		<key>Red Component</key>
        <real>0.9450980392156862</real>
	</dict>
	<key>Selected Text Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.9450980392156862</real>
		<key>Green Component</key>
        <real>0.9450980392156862</real>
		<key>Red Component</key>
        <real>0.9450980392156862</real>
	</dict>
	<key>Selection Color</key>
	<dict>
		<key>Blue Component</key>
        <real>0.9921568627450981</real>
		<key>Green Component</key>
        <real>0.8392156862745098</real>
		<key>Red Component</key>
        <real>0.7137254901960784</real>
	</dict>
</dict>
</plist>



# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false


###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


###############################################################################
# Activity Monitor                                                            #
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Mac App Store                                                               #
###############################################################################

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Messages                                                                    #
###############################################################################
# Disable continuous spell checking
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false


###############################################################################
# Tweetbot                                                                    #
###############################################################################
#Font Size
defaults write com.tapbots.TweetbotMac fontSize -int 12
defaults write com.tapbots.TweetbotMac TextAutomaticQuoteSubstitution -bool NO
defaults write com.tapbots.TweetbotMac TextAutoCorrect -bool NO
defaults write com.tapbots.TweetbotMac TextAutomaticTextReplacement -bool NO

# Don't show status item
defaults write com.tapbots.TweetbotMac showStatusItem -bool false

###############################################################################
# Things                                                                    #
###############################################################################
/usr/libexec/PlistBuddy -c "Set :QuickEntryHotkeyEmpty:keyCode 49" ~/Library/Preferences/com.culturedcode.things.plist 
/usr/libexec/PlistBuddy -c "Set :QuickEntryHotkeyEmpty:characters \\U2325\\U23b5" ~/Library/Preferences/com.culturedcode.things.plist 
/usr/libexec/PlistBuddy -c "Set :QuickEntryHotkeyEmpty:keyModifiers 2048" ~/Library/Preferences/com.culturedcode.things.plist 

/usr/libexec/PlistBuddy -c "Set :QuickEntryHotkeyAutofill:keyCode 49" ~/Library/Preferences/com.culturedcode.things.plist 
/usr/libexec/PlistBuddy -c "Set :QuickEntryHotkeyAutofill:characters \\U2303\\U2325\\U23b5" ~/Library/Preferences/com.culturedcode.things.plist 
/usr/libexec/PlistBuddy -c "Set :QuickEntryHotkeyAutofill:keyModifiers 6144" ~/Library/Preferences/com.culturedcode.things.plist 

/usr/libexec/PlistBuddy -c "Set :com.culturedcode.things:1:Checksum 2474576011" ~/Library/Application\ Support/Cultured\ Code/Licenses.plist
killall Things

