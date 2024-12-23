using Gtk;
using GtkLayerShell;

public class Bar: Object {
  public Window window;
  public Hyprland hypr;
  public Audio audio;
  public Upower power;

  public Bar(string[] args) {
    this.hypr = new Hyprland();
    this.audio = new Audio();
    this.power = new Upower();

    Gtk.init(ref args);
    this.window = new Window();
    Widget main_box = base_box();

    GtkLayerShell.init_for_window(window);
    GtkLayerShell.auto_exclusive_zone_enable(window);

    GtkLayerShell.set_margin(window, GtkLayerShell.Edge.LEFT, 10);
    GtkLayerShell.set_margin(window, GtkLayerShell.Edge.RIGHT, 10);
    GtkLayerShell.set_margin(window, GtkLayerShell.Edge.TOP, 5);

    GtkLayerShell.set_anchor(window, GtkLayerShell.Edge.TOP, true);

    window.destroy.connect(Gtk.main_quit);

    window.add(main_box);
    window.show_all();

    hypr.start();
    audio.start();
    power.start();
    Utils.load_style("bar.css");
    Gtk.main();
  }

  Widget workspace(string name, int64 id) {
    Button w = new Button();
    w.clicked.connect(() => {
      hypr.dispatch_workspace((int) id);
    });
    Utils.add_class(w, name);
    return w;
  }

  Widget workspaces() {
    Grid box = new Grid();
    Widget w = new Label("");

    for (int i=1;i<=hypr.actual_workspace_len;i++) {
      w = workspace((i==hypr.current_workspace_id)?"activeWorkspace":"nonActiveWorkspace", i);
      box.attach(w, i-1, 0, 1, 1);
    };
  
    Utils.add_class(box, "workspaces");
    return box;
  }

  Widget left_widgets() {
    Box box = new Box(Gtk.Orientation.HORIZONTAL, 0);
    Widget w = new Label("");
    hypr.sig_workspaces.connect((t, ws) => {
      w.destroy();
      w = workspaces();
      box.pack_start(w, false, false, 0);
      box.show_all();
    });
    Utils.add_class(box, "leftWidgets");
    return box;
  }

  Widget clock_label() {
    Label clock = new Label("");
    Utils.add_class(clock, "clock");

    var clock_thread = new Utils.Time_Threads(60, {"date", "+%H:%M / %a %d %B"}, "clock");

    clock_thread.output.connect((t, time) => {
      clock.set_label(time);
    });
    clock_thread.start();
    return clock;
  }
  
  Widget volume() {
    Box box = new Box(Gtk.Orientation.HORIZONTAL, 0);
    Button btn = new Button.from_icon_name("audio-headphones-symbolic");
    btn.clicked.connect(() => {
      audio.set_sink_default_toggle_mute();
    });
    Label volume = new Label("");

    audio.sig_default_sink_vol_change.connect((t, vol) => {
      volume.set_label(vol.to_string().concat("%"));
    });

    box.pack_start(btn);
    box.pack_end(volume);
    btn.set_relief(ReliefStyle.NONE);
    Utils.add_class(btn, "volumeButton");
    Utils.add_class(volume, "volumeLevel");
    Utils.add_class(box, "volume");
    return box;
  }

  Widget battery() {
    Box box = new Box(Gtk.Orientation.HORIZONTAL, 0);
    string icon_name = "";
    Button battery_icon = new Button();
    Image icon = new Image();
    battery_icon.set_image(icon);
    Label battery_level= new Label("");
    Button time_remaining = new Button.with_label("");

    power.sig_icon_name_change.connect((name) => {
      if (name!=icon_name) {
        icon_name = name;
        icon.set_from_icon_name(name, IconSize.BUTTON);
      }
    });

    string[] time_break = new string[2];
    power.sig_battery_level_change.connect((level) => {
      battery_level.set_label(level.to_string().concat("%"));
      time_break = power.time_remaining.split(" ");
      if (time_break.length==2) {
        time_remaining.set_label(time_break[0].concat((time_break[1]=="hours")?"hrs":"min"));
      }
    });

    box.pack_start(battery_icon, false, false, 0);
    box.set_center_widget(battery_level);
    box.pack_end(time_remaining, false, false, 0);

    battery_icon.set_relief(ReliefStyle.NONE);

    Utils.add_class(battery_level, "batteryLevel");
    Utils.add_class(time_remaining, "timeRemaining");
    Utils.add_class(box, "battery");
    return box;
  }

  Widget shutdown() {
    try {
      Gdk.Pixbuf buf = new Gdk.Pixbuf.from_file_at_scale("../imgs/shutdown.svg", 15, 15, true);
      Image img = new Image.from_pixbuf(buf);
      Button btn = new Button();
      btn.set_image(img);
      btn.clicked.connect(() => {
        print("Release");
      });

      Utils.add_class(btn, "shutdown");
      btn.set_relief(ReliefStyle.NONE);
      return btn;
    } catch (GLib.Error e) {
      stdout.printf("%s\n", e.message);
      return new Label("");
    }
  }

  Widget restart() {
    try {
      Gdk.Pixbuf buf = new Gdk.Pixbuf.from_file_at_scale("../imgs/restart.svg", 15, 15, true);
      Image img = new Image.from_pixbuf(buf);
      Button btn = new Button();
      btn.set_image(img);
      btn.clicked.connect(() => {
        print("Release");
      });

      Utils.add_class(btn, "restart");
      btn.set_relief(ReliefStyle.NONE);
      return btn;
    } catch (GLib.Error e) {
      stdout.printf("%s\n", e.message);
      return new Label("");
    }
  }

  Widget lock() {
    try {
      Gdk.Pixbuf buf = new Gdk.Pixbuf.from_file_at_scale("../imgs/lock.svg", 15, 15, true);
      Image img = new Image.from_pixbuf(buf);
      Button btn = new Button();
      btn.set_image(img);
      btn.clicked.connect(() => {
        print("Release");
      });

      Utils.add_class(btn, "lock");
      btn.set_relief(ReliefStyle.NONE);
      return btn;
    } catch (GLib.Error e) {
      stdout.printf("%s\n", e.message);
      return new Label("");
    }
  }

  Widget hibernate() {
    try {
      Gdk.Pixbuf buf = new Gdk.Pixbuf.from_file_at_scale("../imgs/hibernate.svg", 15, 15, true);
      Image img = new Image.from_pixbuf(buf);
      Button btn = new Button();
      btn.set_image(img);
      btn.clicked.connect(() => {
        print("Release");
      });

      Utils.add_class(btn, "hibernate");
      btn.set_relief(ReliefStyle.NONE);
      return btn;
    } catch (GLib.Error e) {
      stdout.printf("%s\n", e.message);
      return new Label("");
    }
  }

  Widget system_buttons() {
    Box system = new Box(Gtk.Orientation.HORIZONTAL, 0);
    system.pack_end(hibernate(), false, false, 0);
    system.pack_end(lock(), false, false, 0);
    system.pack_end(restart(), false, false, 0);
    system.pack_end(shutdown(), false, false, 0);
    Utils.add_class(system, "systemButtons");
    return system;
  }

  Widget right_widgets() {
    Box right = new Box(Gtk.Orientation.HORIZONTAL, 0);
    right.pack_end(system_buttons(), false, false, 0);
    right.pack_end(battery(), false, false, 0);
    right.pack_end(volume(), false, false, 0);
    Utils.add_class(right, "rightBox");
    return right;
  }

  Widget base_box() {
    Box box = new Box(Gtk.Orientation.HORIZONTAL, 0);

    box.pack_start(left_widgets(), false, false, 0);
    box.set_center_widget(clock_label());
    box.pack_end(right_widgets(), false, false, 0);
    Utils.add_class(box, "baseBox");
    return box;
  }

  public static int main(string[] args) {
    Bar bar = new Bar(args);

    return 0;
  }
}
