using Gtk;
using GtkLayerShell;

struct App {
  string name;
  string[] exec;
  string icon;
}

class Launcher: Object {
  private Window window;
  private int apps_list_length = 0;
  private int selected_app = 0;
  private App[] app_list = new App[256];
  private Widget[] wid_list = new Widget[256];

  private Box main_box;
  private Box search_box;
  private Label search;
  private string query = "";
  private Box app_holder;
  private Box in_app_holder;
  private ScrolledWindow scrolled;
  private Viewport viewport;

  public Launcher(string[] args) {
Gtk.init(ref args);
    this.window = new Window();
    base_box();
  
    GtkLayerShell.init_for_window(window);
    GtkLayerShell.set_keyboard_mode(window, KeyboardMode.EXCLUSIVE);
    GtkLayerShell.set_margin(this.window, GtkLayerShell.Edge.LEFT, 10);
    GtkLayerShell.set_margin(this.window, GtkLayerShell.Edge.TOP, 5);

    GtkLayerShell.set_anchor(this.window, GtkLayerShell.Edge.LEFT, true);

    this.window.destroy.connect(Gtk.main_quit);

    this.window.add(this.main_box);
    this.window.show_all();

    Utils.load_style("launcher.css");
    Gtk.main();
  }

  void base_box() {
    this.main_box = new Box(Gtk.Orientation.VERTICAL, 0);
    this.search_box = new Box(Gtk.Orientation.HORIZONTAL, 0);
    this.search = new Label("Search...");
    this.app_holder = new Box(Gtk.Orientation.VERTICAL, 0);
    this.in_app_holder = new Box(Gtk.Orientation.VERTICAL, 0);
    this.scrolled = new ScrolledWindow(null, null);
    this.viewport = new Viewport(null, null);

    this.main_box.pack_start(this.search_box, true, true, 0);
    this.search_box.pack_start(this.search, false, false, 0);
    this.main_box.pack_start(this.app_holder, true, true, 0);
    this.app_holder.pack_start(this.scrolled, false, false, 0);
    this.scrolled.add(this.viewport);
    this.viewport.add(this.in_app_holder);

    this.scrolled.set_min_content_height(500);
    this.scrolled.set_min_content_width(200);

    load_apps();
    set_search_bar();
    show_apps(this.query);
    Utils.add_class(this.search_box, "searchBox");
    Utils.add_class(this.search, "searchBarEmpty");
    Utils.add_class(this.scrolled, "appScroll");
    Utils.add_class(this.app_holder, "appHolder");
    Utils.add_class(this.main_box, "baseBox");
  }
  
  private void select_app(bool remove_prev, bool up) {
    if (remove_prev) {
      if (up) {
        Utils.remove_class(this.wid_list[this.selected_app+1], "selectedApp");
      } else {
        Utils.remove_class(this.wid_list[this.selected_app-1], "selectedApp");
      }
    }
    Utils.add_class(this.wid_list[this.selected_app], "selectedApp");
  }

  private bool allowed_key(uint key) {
    if (32<=key && key<=126) {
      return true;
    }
    if (key==65288 || key==65293 || key==65362 || key==65364) {
      // 65288 is Backspace, 655293 is Enter, 65362 is UP, 65364 is DOWN
      return true;
    }
    return false;
  }

  private void set_search_bar() {
    this.window.key_press_event.connect((key) => {
      //stdout.printf("%d\n", (int)key.keyval);
      if (this.allowed_key(key.keyval)) {
        if (key.keyval==65288) {
          if (this.query.length>0) {
            this.query = this.query[0:-1];
          }
        } else if (key.keyval==65362) {
          if (this.selected_app>0) {
            this.selected_app--;
            print("up\n");
            this.select_app(true, true);
          }
        } else if (key.keyval==65364) {
          if (this.selected_app<this.apps_list_length) {
            print("down\n");
            this.selected_app++;
            this.select_app(true, false);
          }
        } else {
          this.query = this.query.concat(key.str);
        }
        this.search.set_label(this.query);
        if (this.query.length==0) {
          this.search.set_label("Search...");
        }
        if (key.keyval!=65363 && key.keyval!=65364) {
          this.show_apps(this.query);
        }
      }
      return false;
    });
  }

  private bool read_desktop_file(string loc) {
    App add_app = App();

    File file = File.new_for_path(loc);
    FileInputStream inp = file.read();
    int64 bytes_read = 0;
    uint8[] buf;
    string contents = "";
    do {
      buf = new uint8[512];
      inp.read_all(buf, out bytes_read);
      contents = contents.concat((string) buf);
    } while (bytes_read==512);
    
    string[] line_break = new string[2];
    string line_type;
    string line_value;
    foreach (string line in contents.split("\n")) {
      line_break = line.split("=");
      line_type = line_break[0];
      line_value = line_break[1];
      if (line_type==null || line_value==null) {
        continue;
      }
      line_type = line_type.chomp().chug();
      line_value = line_value.chomp().chug();
      if (line_type=="Terminal" && line_value=="true") {
        return false;
      }
      switch (line_type) {
        case "Name":
          add_app.name = line_value;
          break;
        case "Exec":
          add_app.exec = line_value.split(" ");
          break;
        case "Icon":
          add_app.icon = line_value;
          break;
      }
    }
    this.app_list[this.apps_list_length++] = add_app;
    return true;
  }

  private void load_appimages() {
    string str = Utils.exec({"ls", "/home/em/bin/"});
    foreach (string app in str.split("\n")) {
      if (app.contains(".AppImage")) {
        this.app_list[this.apps_list_length++] = App() {
          name= app.split(".")[0],
          exec= {@"/home/em/bin/$(app)", "-enable-features=UseOzonePlatform", "-ozone-platform=wayland", "&"},
          icon= " "
        };
      }
    }
  }

  private void load_flatpaks() {
    string str = Utils.exec({"ls", "/home/em/.local/share/flatpak/app/"});
    foreach (string app in str.split("\n")) {
      if (app=="") {
        continue;
      }
      
      if (this.read_desktop_file(@"/home/em/.local/share/flatpak/app/$(app)/current/active/files/share/applications/$(app).desktop")) {
        this.app_list[this.apps_list_length-1].exec = {"flatpak", "run", @"$(app)", "&"};
      }
    }
  }

  private void load_others() {
    string str = Utils.exec({"ls", "/usr/share/applications/"});
    foreach (string app in str.split("\n")) {
      if (app.contains(".desktop")) {
        this.read_desktop_file(@"/usr/share/applications/$(app)");
      }
    }
  }

  private void connect_btn(Button btn, int i) {
    btn.clicked.connect(() => {
      new Subprocess.newv(this.app_list[i].exec, NONE);
      Gtk.main_quit();
    });
  }

  private void show_apps(string name) {
    this.in_app_holder.destroy();
    this.in_app_holder = new Box(Gtk.Orientation.VERTICAL, 0);
    Button temp_btn;

    this.wid_list = new Widget[256];
    for (int i=0; i<this.apps_list_length; i++) {
      temp_btn = new Button.from_icon_name(this.app_list[i].icon);
      new Image.from_icon_name(this.app_list[i].icon, IconSize.BUTTON);
      temp_btn.set_label(this.app_list[i].name);
      this.in_app_holder.pack_start(temp_btn, false, false, 0);
      temp_btn.set_relief(ReliefStyle.NONE);
      connect_btn(temp_btn, i);
      this.wid_list[i] = temp_btn;
    }
    this.selected_app = 0;
    this.select_app(false, false);
    this.viewport.add(this.in_app_holder);
    Utils.add_class(this.in_app_holder, "inAppHolder");
    this.main_box.show_all();
  }

  private void load_apps() {
    load_flatpaks();
    load_appimages();
    load_others();
  }

  public static int main(string[] args) {
    new Launcher(args);

    return 0;
  }
}
