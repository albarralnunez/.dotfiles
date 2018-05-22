{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
module Config where
import XMonad
import XMonad.Actions.FloatKeys
import XMonad.Actions.FloatSnap
import XMonad.Actions.Navigation2D
import XMonad.Actions.Submap
import XMonad.Hooks.EwmhDesktops (fullscreenEventHook)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Place
import qualified XMonad.Layout.BoringWindows as B
import XMonad.Layout.IM
import XMonad.Layout.LayoutModifier (ModifiedLayout(..))
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.Minimize
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.Spacing
import XMonad.Layout.Tabbed

-- import XMonad.Layout.Named
import XMonad.Layout.Gaps
import XMonad.Layout.Accordion
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.SubLayouts
import XMonad.Layout.Simplest

import XMonad.Util.NamedScratchpad
import System.Exit
import Graphics.X11.ExtraTypes.XF86

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Data.Ratio ((%))

import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

modMask' :: KeyMask
modMask' = mod4Mask

delta :: Rational
delta = 3 / 100

fg         = "#ebdbb2"
bg         = "#282828"
gray       = "#a89984"
bg1        = "#3c3836"
bg2        = "#504945"
bg3        = "#665c54"
bg4        = "#7c6f64"

green      = "#b8bb26"
darkgreen  = "#98971a"
red        = "#fb4934"
darkred    = "#cc241d"
yellow     = "#fabd2f"
blue       = "#83a598"
purple     = "#d3869b"
aqua       = "#8ec07c"
orange     = "#fe8019"
darkorange = "#d65d0e"

myIM :: LayoutClass l a => l a -> ModifiedLayout AddRoster l a
myIM = withIM (1 % 4) (ClassName "TelegramDesktop")

myLayouts = fullscreenToggle
    $ tiled ||| tabs
  where
    fullscreenToggle = mkToggle (single NBFULL)
    tiled = renamed [Replace "\xf036"]
        $ avoidStruts
        $ smartSpacingWithEdge 1
        $ smartBorders
        $ minimize
        $ B.boringWindows
        $ myIM
        $ Tall 1 (3 / 100) (1 / 2)
--     tornado = renamed [Replace "\xf036"]
--        $ avoidStruts 
--        $ smartSpacingWithEdge 1
--        $ smartBorders 
--        $ emptyBSP
    tabs = renamed [Replace "\xf2d1"]
        $ avoidStruts
        $ smartBorders
        $ minimize
        $ B.boringWindows
        $ myIM
        $ tabbedBottom shrinkText defTabbed
    defTabbed = def
        { activeColor = bg
        , urgentColor = red
        , inactiveColor = bg
        , activeBorderColor = bg
        , inactiveBorderColor = bg
        , urgentBorderColor = red
        , inactiveTextColor = gray -- Gray color on dark gray background
        , activeTextColor = green
        , urgentTextColor = "#ffffff"
        , fontName = "xft:Roboto:size=10" }

switchWorkspaceToWindow :: Window -> X ()
switchWorkspaceToWindow w = windows $ do
    tag <- W.currentTag
    W.focusWindow w . W.greedyView tag . W.focusWindow w

workspaces' = ["\xf269", "\xf120", "\xe7b5", "\xf086", "\xf1d0", "\xf1c0", "\xe727", "\xf11b", "\xf6ed"]

chats = "rambox"
player = "spotify"
mailing = "thunderbird-nightly"

scratchpads =
    [ (NS player player (className =? "Spotify") doFullFloat )
    , (NS chats chats (className =? "Rambox") doFullFloat )
    , (NS mailing mailing (className =? "Thunderbird") doFullFloat ) ]

myManageHook :: ManageHook
myManageHook =
    manageSpecific
    <+> namedScratchpadManageHook scratchpads
  where
    manageSpecific = composeAll
        [ isFullscreen                    --> doFullFloat
        -- When Spotify is started the WM_CLASS is unset so here we match on
        -- title instead. Title will later change depending on the song
        -- playing.
        , className =? "Spotify"          --> doFullFloat
        , className =? "Rambox"           --> doFloat
        , className =? "MPlayer"          --> doFloat
        , className =? "Gimp"             --> doFloat
        , className =? "Thunderbird"      --> doFloat
        -- Flash :(
        , className =? "Plugin-container" --> doFloat
        , className =? "mpv"              --> doFloat
        , className =? "feh"              --> doFloat
        , className =? "Gpick"            --> doFloat
        , className =? "Qalculate-gtk"    --> doFloat
        , className =? "Pcmanfm"          --> doFloat
        , className =? "Lightscreen"      --> doFloat
        -- Used by Chromium developer tools, maybe other apps as well
        , role =? "pop-up"                --> doFloat
        , transience' ]
    role = stringProperty "WM_WINDOW_ROLE"

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf)
    , ((modm, xK_r), spawn "rofi -show run -switchers 'run,window' -no-levenshtein-sort")
    , ((modm .|. shiftMask, xK_r), spawn "rofi -show window -switchers 'window,run' -no-levenshtein-sort")

    -- Lock screen
    , ((modm, xK_a), submap . M.fromList $
        [ ((0, xK_l), spawn "$HOME/.local/usr/bin/lock.sh")
        , ((0, xK_9), spawn "togglelayout") ])

    -- close focused window
    , ((modm, xK_w), kill)
     -- Rotate through the available layout algorithms
    , ((modm, xK_space), sendMessage NextLayout)
    , ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)
    -- Resize viewed windows to the correct size
    , ((modm, xK_n), refresh)
    -- Move focus to the next window
    , ((modm, xK_Tab), B.focusDown)
    -- Move focus to the next window
    , ((modm, xK_j), B.focusDown)
    -- Move focus to the previous window
    , ((modm, xK_k), B.focusUp)
    -- Move focus to the master window
    , ((modm, xK_m), B.focusMaster)
    -- Swap the focused window with the master window
    , ((modm .|. shiftMask, xK_m), windows W.swapMaster)
    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j), windows W.swapDown)
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k), windows W.swapUp)
    -- Shrink the master area
    , ((modm, xK_h), sendMessage Shrink)
    -- Expand the master area
    , ((modm, xK_l), sendMessage Expand)
    -- Push window back into tiling
    , ((modm, xK_t), withFocused toggleFloat)
    -- Increment the number of windows in the master area
    , ((modm, xK_comma), sendMessage (IncMasterN 1))
    -- Deincrement the number of windows in the master area
    , ((modm, xK_period), sendMessage (IncMasterN (-1)))
    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q), io exitSuccess)
    -- Restart xmonad
    , ((modm, xK_q), spawn "xmonad --recompile && xmonad --restart")

    -- Toggle fullscreen MultiToggle
    , ((modm, xK_f), sendMessage $ Toggle NBFULL)
    , ((modm .|. shiftMask, xK_f), withFocused $
        \w -> windows $ W.float w (W.RationalRect 0 0 1 1) )

    -- 2D navigation
    , ((modm .|. shiftMask, xK_l), screenGo R True)
    , ((modm .|. shiftMask, xK_h), screenGo L True)
    , ((modm .|. controlMask, xK_l), screenSwap R True)
    , ((modm .|. controlMask, xK_h), screenSwap L True)

    -- Float handling (snapping to edges)
    , ((modm, xK_Right), withFocused $ snapMove R Nothing)
    , ((modm, xK_Left), withFocused $ snapMove L Nothing)
    , ((modm, xK_Up), withFocused $ snapMove U Nothing)
    , ((modm, xK_Down), withFocused $ snapMove D Nothing)

    , ((modm .|. shiftMask, xK_Right), withFocused $ keysResizeWindow (20, 0) (0, 0))
    , ((modm .|. shiftMask, xK_Left), withFocused $ keysResizeWindow (-20, 0) (0, 0))
    , ((modm .|. shiftMask, xK_Up), withFocused $ keysResizeWindow (0, -20) (0, 0))
    , ((modm .|. shiftMask, xK_Down), withFocused $ keysResizeWindow (0, 20) (0, 0))

    -- Minimize stuff
    , ((modm, xK_v), withFocused minimizeWindow)
    , ((modm .|. shiftMask, xK_v), sendMessage RestoreNextMinimizedWin)

    , ((modm, xK_g), placeFocused $ smart (0.5, 0.5))

    -- Scratchpads
    , ((modm, xK_s), submap . M.fromList $
        [ ((0, xK_s), namedScratchpadAction scratchpads player)
        , ((0, xK_c), namedScratchpadAction scratchpads chats)
        , ((0, xK_m), namedScratchpadAction scratchpads mailing)
        ])

    -- Struts...
    , ((modm .|. controlMask, xK_0), sendMessage $ ToggleStrut U)
    ]
    ++
    -- Media hotkeys
    [((mod5Mask, k), spawn $ "playerctl " ++ m)
        | (m, k) <- zip ["previous", "play-pause", "next"] [xK_3..xK_5]]
    ++
    [((0, k), spawn $ "playerctl " ++ m)
        | (m, k) <-
            [ ("previous", xF86XK_AudioPrev)
            , ("play-pause", xF86XK_AudioPlay)
            , ("next", xF86XK_AudioNext) ]]
    ++
    [((mod5Mask, k), spawn $ "ponymix " ++ m)
      | (m, k) <-
          zip ["toggle", "decrease 3", "increase 3"] [xK_8, xK_9, xK_0]]
    ++
    [((0, k), spawn $ "ponymix " ++ m)
        | (m, k) <-
            [ ("toggle", xF86XK_AudioMute)
            , ("decrease 3", xF86XK_AudioLowerVolume)
            , ("increase 3", xF86XK_AudioRaiseVolume) ]]
    ++
    [((0, k), spawn $ "brightnessctl s 5%" ++ c)
        | (c, k) <-
            [ ("-", xF86XK_MonBrightnessDown)
            , ("+", xF86XK_MonBrightnessUp) ]]
    ++
    [((0, k), spawn $ "asus-kbd-backlight " ++ c)
        | (c, k) <-
            [ ("down", xF86XK_KbdBrightnessDown)
            , ("up", xF86XK_KbdBrightnessUp) ]]
    ++
    -- Manage screens using autorandr
    [((0, xF86XK_LaunchB), spawn $ "autorandr --change --default laptop")]
    ++
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
  where
      toggleFloat w = windows
        $ \s -> if M.member w (W.floating s)
                   then W.sink w s
                   else W.float w (W.RationalRect (1/10) (1/10) (4/5) (4/5)) s

myDbusHook :: D.Client -> PP
myDbusHook dbus = def
    { ppOutput = dbusOutput dbus
    , ppCurrent = wrap ("%{u" ++ green ++ " B" ++ bg1 ++ " +u}  ") "  %{B- u- -u}"
    , ppVisible = wrap ("%{u" ++ yellow ++ " +u}  ") "  %{u- -u}"
    , ppUrgent = wrap ("%{u" ++ red ++ " +u}  ") "  %{u- -u}"
    , ppHidden = wrap "  " "  " . noScratchPad
    , ppWsSep = ""
    , ppSep = " : "
    , ppTitle = shorten 40
    }
  where
    -- then define it down here: if the workspace is NSP then print
    -- nothing, else print it as-is
    noScratchPad ws = if ws == "NSP" then "" else ws

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal objectPath interfaceName memberName) {
            D.signalBody = [D.toVariant $ UTF8.decodeString str]
        }
    D.emit dbus signal
  where
    objectPath = D.objectPath_ "/org/xmonad/Log"
    interfaceName = D.interfaceName_ "org.xmonad.Log"
    memberName = D.memberName_ "Update"

myConfig = def
    { terminal = "urxvt"
    , layoutHook = myLayouts
    , manageHook = myManageHook
    , handleEventHook = fullscreenEventHook
    , keys = myKeys
    -- Don't be stupid with focus
    , focusFollowsMouse = False
    , clickJustFocuses = False
    , borderWidth = 2
    , normalBorderColor = gray
    , focusedBorderColor = darkorange
    , workspaces = workspaces'
    , modMask = modMask' }
