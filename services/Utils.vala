namespace Utils {
  public void add_class(Gtk.Widget wid, string class_name) {
    Gtk.StyleContext context = wid.get_style_context();
    context.add_class(class_name);
  }

  public void remove_class(Gtk.Widget wid, string class_name) {
    Gtk.StyleContext context = wid.get_style_context();
    context.remove_class(class_name);
  }

  public void load_style(string file_name) {
    Gtk.CssProvider css_provider = new Gtk.CssProvider();
    try {
      css_provider.load_from_path(file_name);
      Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
    } catch (GLib.Error e) {
      stdout.printf("Cannot read css file: %s\n", e.message);
    }
  }

  public string curr_dir() {
    return GLib.Environment.get_variable("PWD");
  }

  public string exec(string[] command) {
    Subprocess process = new Subprocess.newv(command, STDOUT_PIPE);
    InputStream inp = process.get_stdout_pipe();
    string output = "";
    uint8[] buf;
    int64 bytes_read = 0;
    do {
      buf = new uint8[512];
      inp.read_all(buf, out bytes_read);
      output = output.concat((string) buf);
    } while (bytes_read==512);
    return output;
  }

  public class Exec_Threads: Object {
    public signal void output(string o);

    private string str = "";
    private string[] command;
    private Thread thread;
    private string name;

    public Exec_Threads(string[] command, string name) {
      this.command = command;
      this.name = name;
    }

    public void start() {
      this.thread = new Thread<void>(this.name, execute);
    }

    private void execute() {
      Subprocess process = new Subprocess.newv(this.command, STDOUT_PIPE);
      InputStream inp = process.get_stdout_pipe();
      int64 bytes_read = 0;
      uint8[] buf;
      while (!inp.is_closed()) {
        str = "";
        do {
          buf = new uint8[512];
          inp.read(buf);
          str = str.concat((string) buf);
        } while (bytes_read==512);
        foreach (string s in str.split("\n")) {
          this.output(s);
        } 
      }
    }
  }

  public class Time_Threads: Object {
    public signal void output(string o);
    
    private string str = "";
    private int time;
    private string[] command;
    private Thread thread;
    private string name;

    public Time_Threads(int time, string[] command, string name) {
      this.time = time;
      this.command = command;
      this.name = name;
    }

    public void start() {
      this.thread = new Thread<void>(this.name, execute);
    }

    private void execute() {
      Subprocess process;
      InputStream inp;
      int64 bytes_read = 128;
      uint8[] buf;
      while (true) {
        process = new Subprocess.newv(this.command, STDOUT_PIPE);
        inp = process.get_stdout_pipe();
        str = "";
        do {
          buf = new uint8[128];
          inp.read_all(buf, out bytes_read);
          str = str.concat((string) buf);
        } while (bytes_read==128);
        this.output(str[0:-1]);
        Utils.exec({"sleep", @"$(this.time)"});
      }
    }
  }
}
