namespace Utils {
  public void add_class(Gtk.Widget wid, string class_name) {
    if (wid!=null) {
      Gtk.StyleContext context = wid.get_style_context();
      context.add_class(class_name);
    }
  }

  public void remove_class(Gtk.Widget wid, string class_name) {
    if (wid!=null) {   
      Gtk.StyleContext context = wid.get_style_context();
      context.remove_class(class_name);
    }
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

    inp.close();
    process.force_exit();
    return output;
  }

  public class Exec_Threads: Object {
    public signal void output(string o);

    private string str = "";
    private string[] command;
    private Thread thread;
    private string name;

    private Subprocess process;
    private InputStream inp;

    public Exec_Threads(string[] command, string name) {
      this.command = command;
      this.name = name;
    }

    ~Exec_Threads() {
      this.close();
    }

    private void close() {
      if (this.process!=null && this.inp!=null) {
        this.inp.close();
        this.process.force_exit();
      }
    }
    public void start() {
      this.thread = new Thread<void>(this.name, execute);
    }

    private void execute() {
      this.process = new Subprocess.newv(this.command, STDOUT_PIPE);
      this.inp = process.get_stdout_pipe();
      int64 bytes_read = 0;
      uint8[] buf;
      while (!inp.is_closed()) {
        str = "";
        do {
          buf = new uint8[512];
          this.inp.read(buf);
          str = str.concat((string) buf);
        } while (bytes_read==512);
        foreach (string s in str.split("\n")) {
          if (s!="") {
            this.output(s);
          }
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

    private Subprocess process;
    private InputStream inp;

    public Time_Threads(int time, string[] command, string name) {
      this.time = time;
      this.command = command;
      this.name = name;
    }

    ~Time_Threads() {
      this.close();
      Thread.exit(this.thread);
    }

    private void close() {
      if (this.process!=null && this.inp!=null) {
        this.inp.close();
        this.process.force_exit();
      }
    }

    public void start() {
      this.thread = new Thread<void>(this.name, execute);
    }

    private void execute() {
      int64 bytes_read = 128;
      uint8[] buf;
      while (true) {
        this.process = new Subprocess.newv(this.command, STDOUT_PIPE);
        this.inp = process.get_stdout_pipe();
        str = "";
        do {
          buf = new uint8[128];
          this.inp.read_all(buf, out bytes_read);
          str = str.concat((string) buf);
        } while (bytes_read==128);
        this.output(str);
        Utils.exec({"sleep", @"$(this.time)"});
        this.close();
      }
    }
  }
}
