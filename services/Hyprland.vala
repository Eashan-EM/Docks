namespace Hypr {
  public struct Workspace {
    int64 id;
    string name;
    string monitor;
    int64 monitorID;
    int64 windows;
    bool hasfullscreen;
    string lastwindow;
    string lastwindowtitle;
  }

  public struct Window {
    string address;
    bool mapped;
    bool hidden;
    int64 at[2];
    int64 size[2];
    Hypr.Workspace workspace;
    bool floating;
    bool pseudo;
    int64 monitor;
    string class;
    string title;
    string initialClass;
    string initialTitle;
    int64 pid;
    bool xwayland;
    bool pinned;
    int64 fullscreen;
    int64 fullscreenClient;
    int64[] grouped;
    int64[] tags;
    string swallowing;
    int64 focusHistoryID;
  }
}

public class Hyprland: Object {
  public Hypr.Window activewindow {get; private set;}
  public Hypr.Workspace[] workspaces;
  public Hypr.Window[] clients;
  public Hypr.Window[] current_workspace_clients;
  public int current_workspace_id = 1;
  public int actual_workspace_len = 1;

  public signal void sig_change();
  public signal void sig_activewindow(Hypr.Window w);
  public signal void sig_workspaces(Hypr.Workspace[] w);
  public signal void sig_clients(Hypr.Window[] w);
  public signal void sig_current_workspace_clients(Hypr.Window[] w);

  public Hyprland () {
    this.set_active_window();
    this.set_workspaces();
    this.set_clients();
    this.set_current_workspace_clients();
  }

  public void start() {
    this.hypr();
    this.send_signals();
  }

  private void send_signals() {
    this.sig_activewindow(this.activewindow);
    this.sig_workspaces(this.workspaces);
    this.sig_clients(this.clients);
    this.sig_current_workspace_clients(this.current_workspace_clients);
    this.sig_change();
  }

  private void hypr() {
    string HYPRLAND_INSTANCE_SIGNATURE = GLib.Environment.get_variable("HYPRLAND_INSTANCE_SIGNATURE");
    string[] command = {"socat", "-U", "-", @"UNIX-CONNECT:/run/user/1000/hypr/$(HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock"};
    Utils.Exec_Threads thread = new Utils.Exec_Threads(command, "hypr");
    thread.output.connect((action) => {
      this.do_action(action);
    });
    thread.start();
  }

  private void do_action(string action) {
    string[] action_break = action.split(">>");
    string action_type = action_break[0];
    string action_value = action_break[1];
    switch (action_type) {
      case "activewindowv2":
        this.set_active_window();
        this.sig_activewindow(this.activewindow);
        break;
      case "windowtitlev2":
        break;
      case "workspacev2":
        this.current_workspace_id = int.parse(action_value.split(",")[0]);
        this.set_current_workspace_clients();
        this.sig_current_workspace_clients(this.current_workspace_clients);
        this.set_workspaces();
        this.set_actual_workspaces_len();
        this.sig_workspaces(this.workspaces);
        break;
      case "createworkspacev2":
        this.set_workspaces();
        this.set_actual_workspaces_len();
        this.sig_workspaces(this.workspaces);
        break;
      case "destroyworkspacev2":
        this.set_workspaces();
        this.set_actual_workspaces_len();
        this.sig_workspaces(this.workspaces);
        break;
      case "openwindow":
        this.set_clients();
        this.sig_clients(this.clients);
        break;
      case "closewindow":
        this.set_clients();
        this.sig_clients(this.clients);
        break;
    }
  }

  private void set_active_window() {
    string[] command = {"hyprctl", "activewindow", "-j"};
    string data = this.read(command);
    if (data!="{}\n") {
      Json.Parser parser = new Json.Parser();
      parser.load_from_data(data);
      Json.Node root = parser.get_root();
      Json.Object obj = root.get_object();
      this.activewindow = this.get_client(obj);
    }
  }

  private void set_clients() {
    string[] command = {"hyprctl", "clients", "-j"};
    string data = this.read(command);
    Json.Parser parser = new Json.Parser();
    parser.load_from_data(data);
    Json.Node root = parser.get_root();
    Json.Array arr = root.get_array();

    this.clients = new Hypr.Window[arr.get_elements().length()];
    int i = 0;
    foreach (unowned Json.Node node in arr.get_elements()) {
      this.clients[i++] = this.get_client(node.get_object());
    }
  }

  private Hypr.Window get_client(Json.Object obj) {
    /*
    int64[] at = new int64[2];
    for (int i=0;i<2;i++) {
      at[i] = obj.get_member("at").get_array().get_elements()[i].get_int();
    }
    int64[] size = new int64[2];
    for (int i=0;i<2;i++) {
      size[i] = obj.get_member("size").get_elements()[i].get_int();
    }
    int64[] grouped = new int64[obj.get_member("grouped").get_elements().length];
    for (int i=0;i<grouped.length;i++) {
      grouped[i] = obj.get_member("grouped").get_elements()[i];
    }
    int64[] tags = new int64[obj.get_member("tags").get_elements().length];
    for (int i=0;i<tags.length;i++) {
      tags[i] = obj.get_member("tags").get_elements()[i];
    }
    */
    return Hypr.Window() {
      address = obj.get_member("address").get_string(),
      mapped = obj.get_member("mapped").get_boolean(),
      hidden = obj.get_member("hidden").get_boolean(),
      workspace = Hypr.Workspace() {
        id = obj.get_member("workspace").get_object().get_member("id").get_int(),
        name = obj.get_member("workspace").get_object().get_member("name").get_string(),
      },
      floating = obj.get_member("floating").get_boolean(),
      pseudo = obj.get_member("pseudo").get_boolean(),
      monitor = obj.get_member("monitor").get_int(),
      class = obj.get_member("class").get_string(),
      title = obj.get_member("title").get_string(),
      initialClass = obj.get_member("initialClass").get_string(),
      initialTitle = obj.get_member("initialTitle").get_string(),
      pid = obj.get_member("pid").get_int(),
      xwayland = obj.get_member("xwayland").get_boolean(),
      pinned = obj.get_member("pinned").get_boolean(),
      fullscreen = obj.get_member("fullscreen").get_int(),
      fullscreenClient = obj.get_member("fullscreenClient").get_int(),
      swallowing = obj.get_member("swallowing").get_string(),
      focusHistoryID = obj.get_member("focusHistoryID").get_int()
    };
  }

  private void set_workspaces() {
    string[] command = {"hyprctl", "workspaces", "-j"};
    string data = this.read(command);
    Json.Parser parser = new Json.Parser();
    parser.load_from_data(data);
    Json.Node root = parser.get_root();
    Json.Array arr = root.get_array();
    this.workspaces = new Hypr.Workspace[arr.get_elements().length()];
    int i = 0;
    foreach (unowned Json.Node node in arr.get_elements()) {
      this.workspaces[i++] = Hypr.Workspace() {
          id = node.get_object().get_member("id").get_int(),
          name = node.get_object().get_member("name").get_string(),
          monitor = node.get_object().get_member("monitor").get_string(),
          monitorID = node.get_object().get_member("monitorID").get_int(),
          windows = node.get_object().get_member("windows").get_int(),
          hasfullscreen = node.get_object().get_member("hasfullscreen").get_boolean(),
          lastwindow = node.get_object().get_member("lastwindow").get_string(),
          lastwindowtitle = node.get_object().get_member("lastwindowtitle").get_string()
        };
    }
  }

  private void set_current_workspace_clients() {
    int size = 0;
    foreach (Hypr.Window win in this.clients) {
      if (win.workspace.id==this.current_workspace_id) {
        size++;
      }
    }
    this.current_workspace_clients = new Hypr.Window[size];
    int i = 0;
    foreach (Hypr.Window win in this.clients) {
      if (win.workspace.id==this.current_workspace_id) {
        this.current_workspace_clients[i++] = win;
      }
    }
  }

  private void set_actual_workspaces_len() {
    int64 max = 0;
    foreach (Hypr.Workspace ws in this.workspaces) {
      if (ws.id>max) {
        max = ws.id;
      }
    }
    this.actual_workspace_len = (int) max;
  }

  private string read(string[] command) {
    try {
      Subprocess process = new Subprocess.newv(command, STDOUT_PIPE);
      InputStream inp = process.get_stdout_pipe();
      return this.read_all(inp);
    } catch (GLib.Error e) {
      stdout.printf("GLib.Error occured");
    }
    return "";
  }
  
  private string read_all(InputStream inp) {
    string output = "";
    uint8[] r;
    int64 bytes_read = 0;
    do {
      r = new uint8[1024];
      inp.read_all(r, out bytes_read);
      output = output.concat((string) r);
    } while (bytes_read==1024);
    return output;
  }

  public string dispatch_exec(string command) {
    string cmd = "$(".concat(command, ")");
    string[] base_cmd = {"hyprctl", "dispatch", "exec", cmd};
    return this.read(base_cmd);
  }

  public void dispatch_workspace(int id) {
    this.read({"hyprctl", "dispatch", "workspace", id.to_string()});
  }
}
