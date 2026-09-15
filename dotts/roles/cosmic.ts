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

  // Compositor tiling: enable auto-tiling and set behavior on boot for all workspaces
  resources.autotile = file('~/.config/cosmic/com.system76.CosmicComp/v1/autotile', {
    content: 'true\n',
  });
  resources.autotileBehavior = file(
    '~/.config/cosmic/com.system76.CosmicComp/v1/autotile_behavior',
    {
      content: 'BootOn\n',
    },
  );
  resources.panelEntries = file('~/.config/cosmic/com.system76.CosmicPanel/v1/entries', {
    content: '[\n    "Panel",\n]\n',
  });
  resources.compActiveHint = file(
    '~/.config/cosmic/com.system76.CosmicComp/v1/active_hint',
    {
      content: 'true\n',
    },
  );

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

  // Active window hint border (1px)
  resources.themeDarkActiveHint = file(
    '~/.config/cosmic/com.system76.CosmicTheme.Dark/v2/active_hint',
    {
      content: '1\n',
    },
  );
  resources.themeDarkBuilderActiveHint = file(
    '~/.config/cosmic/com.system76.CosmicTheme.Dark.Builder/v2/active_hint',
    {
      content: '1\n',
    },
  );

  // Window and widget corner roundness: sharp square corners (radius 0)
  const sharpCornerRadii = `(
    radius_0: (0.0, 0.0, 0.0, 0.0),
    radius_xs: (0.0, 0.0, 0.0, 0.0),
    radius_s: (0.0, 0.0, 0.0, 0.0),
    radius_m: (0.0, 0.0, 0.0, 0.0),
    radius_l: (0.0, 0.0, 0.0, 0.0),
    radius_xl: (0.0, 0.0, 0.0, 0.0),
)\n`;

  resources.themeDarkCornerRadii = file(
    '~/.config/cosmic/com.system76.CosmicTheme.Dark/v2/corner_radii',
    { content: sharpCornerRadii },
  );
  resources.themeDarkBuilderCornerRadii = file(
    '~/.config/cosmic/com.system76.CosmicTheme.Dark.Builder/v2/corner_radii',
    { content: sharpCornerRadii },
  );

  // Sleek graphite accent and window border
  const graphiteAccent = `(
    base: "#484848FF",
    hover: "#585858FF",
    pressed: "#383838FF",
    selected: "#585858FF",
    selected_text: "#FFFFFFFF",
    focus: "#707070FF",
    divider: "#000000FF",
    on: "#FFFFFFFF",
    disabled: "#383838FF",
    on_disabled: "#282828FF",
    border: "#707070FF",
    disabled_border: "#38383880",
)\n`;

  resources.themeDarkAccent = file(
    '~/.config/cosmic/com.system76.CosmicTheme.Dark/v2/accent',
    { content: graphiteAccent },
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

  // Dock auto-hide, size, and exclusive zone
  resources.dockAutohide = file('~/.config/cosmic/com.system76.CosmicPanel.Dock/v1/autohide', {
    content: 'Always\n',
  });
  resources.dockExpand = file(
    '~/.config/cosmic/com.system76.CosmicPanel.Dock/v1/expand_to_edges',
    {
      content: 'false\n',
    },
  );
  resources.dockExclusiveZone = file(
    '~/.config/cosmic/com.system76.CosmicPanel.Dock/v1/exclusive_zone',
    {
      content: 'false\n',
    },
  );

  // Top panel: clean applets (no a11y, input sources, tiling, bluetooth)
  resources.panelWings = file(
    '~/.config/cosmic/com.system76.CosmicPanel.Panel/v1/plugins_wings',
    {
      content: `Some(([
], [
    "com.system76.CosmicAppletStatusArea",
    "com.system76.CosmicAppletAudio",
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
