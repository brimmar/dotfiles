import { file, type ResourceHandle } from 'dotts';

export function cosmicRole(): Record<string, ResourceHandle> {
  const resources: Record<string, ResourceHandle> = {};

  // Theme mode: prefer dark
  resources.darkTheme = file('~/.config/cosmic/com.system76.CosmicTheme.Mode/v1/is_dark', {
    content: 'true\n',
  });

  // Wallpaper / Background
  resources.bgSameOnAll = file('~/.config/cosmic/com.system76.CosmicBackground/v1/same-on-all', {
    content: 'true\n',
  });
  resources.bgAll = file('~/.config/cosmic/com.system76.CosmicBackground/v1/all', {
    content: `(
    output: "all",
    source: Path("/usr/share/backgrounds/pop/nick-nazzaro-space-blue.png"),
    filter_by_theme: false,
    rotation_frequency: 3600,
    filter_method: Lanczos,
    scaling_mode: Zoom,
    sampling_method: Alphanumeric,
)\n`,
  });

  // Idle and power management (disable lock and sleep on idle)
  resources.screenOffTime = file('~/.config/cosmic/com.system76.CosmicIdle/v1/screen_off_time', {
    content: 'None\n',
  });
  resources.suspendOnAc = file('~/.config/cosmic/com.system76.CosmicIdle/v1/suspend_on_ac_time', {
    content: 'None\n',
  });
  resources.suspendOnBattery = file(
    '~/.config/cosmic/com.system76.CosmicIdle/v1/suspend_on_battery_time',
    {
      content: 'Some(1800000)\n',
    },
  );

  // Clock format: 24h (military time)
  resources.militaryTime = file('~/.config/cosmic/com.system76.CosmicAppletTime/v1/military_time', {
    content: 'true\n',
  });

  // Window buttons: close only (hide maximize and minimize)
  resources.showMaximize = file('~/.config/cosmic/com.system76.CosmicTk/v1/show_maximize', {
    content: 'false\n',
  });
  resources.showMinimize = file('~/.config/cosmic/com.system76.CosmicTk/v1/show_minimize', {
    content: 'false\n',
  });

  // Compositor tiling: auto-tile per workspace
  resources.autotile = file('~/.config/cosmic/com.system76.CosmicComp/v1/autotile_behavior', {
    content: 'PerWorkspace\n',
  });

  // Tiling gaps (outer, inner): 0, 0
  resources.themeDarkGaps = file('~/.config/cosmic/com.system76.CosmicTheme.Dark/v2/gaps', {
    content: '(0, 0)\n',
  });
  resources.themeDarkBuilderGaps = file(
    '~/.config/cosmic/com.system76.CosmicTheme.Dark.Builder/v2/gaps',
    {
      content: '(0, 0)\n',
    },
  );

  // Active window hint border (3px)
  resources.themeDarkActiveHint = file(
    '~/.config/cosmic/com.system76.CosmicTheme.Dark/v2/active_hint',
    {
      content: '3\n',
    },
  );
  resources.themeDarkBuilderActiveHint = file(
    '~/.config/cosmic/com.system76.CosmicTheme.Dark.Builder/v2/active_hint',
    {
      content: '3\n',
    },
  );

  // Touchpad scrolling (two-finger scroll, tap to click)
  resources.touchpad = file('~/.config/cosmic/com.system76.CosmicComp/v1/input_touchpad', {
    content:
      '(state:Enabled,click_method:Some(Clickfinger),scroll_config:Some((method:Some(TwoFinger),natural_scroll:None,scroll_button:None,scroll_factor:None)),tap_config:Some((enabled:true,button_map:Some(LeftRightMiddle),drag:true,drag_lock:false)))\n',
  });

  // Mouse speed (-0.34558823529411764)
  resources.mouse = file('~/.config/cosmic/com.system76.CosmicComp/v1/input_mouse', {
    content: '(acceleration:Some(Flat),speed:Some(-0.34558823529411764))\n',
  });

  // Dock auto-hide and size
  resources.dockAutohide = file('~/.config/cosmic/com.system76.CosmicPanel.Dock/v1/autohide', {
    content: 'Auto\n',
  });
  resources.dockExpand = file(
    '~/.config/cosmic/com.system76.CosmicPanel.Dock/v1/expand_to_edges',
    {
      content: 'false\n',
    },
  );

  // Top panel: remove App and Workspaces buttons, align clock to the right
  resources.panelWings = file(
    '~/.config/cosmic/com.system76.CosmicPanel.Panel/v1/plugins_wings',
    {
      content: `Some(([
], [
    "com.system76.CosmicAppletInputSources",
    "com.system76.CosmicAppletStatusArea",
    "com.system76.CosmicAppletA11y",
    "com.system76.CosmicAppletTiling",
    "com.system76.CosmicAppletAudio",
    "com.system76.CosmicAppletBluetooth",
    "com.system76.CosmicAppletNetwork",
    "com.system76.CosmicAppletBattery",
    "com.system76.CosmicAppletNotifications",
    "com.system76.CosmicAppletPower",
    "com.system76.CosmicAppletTime",
]))\n`,
    },
  );
  resources.panelCenter = file(
    '~/.config/cosmic/com.system76.CosmicPanel.Panel/v1/plugins_center',
    {
      content: 'None\n',
    },
  );

  return resources;
}
