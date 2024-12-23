public class Upower: Object {
  public signal void sig_battery_level_change(int level);
  public signal void sig_state_change(string state);
  public signal void sig_icon_name_change(string name);
  public signal void sig_time_change(string time);

  public int battery_level{get; private set; default=0; }
  public string state{get; private set; }
  public string time_remaining{get; private set; }
  public string icon_name{get; private set; }

  public void start() {
    this.update();
    string[] command = {"upower", "--monitor"};
    Utils.Exec_Threads thread = new Utils.Exec_Threads(command, "power");

    thread.output.connect((output) => {
      if (output.contains("device changed") && output.contains("/org/freedesktop/UPower/devices/battery_BAT0")) {
        this.update();
      }
    });
    thread.start();
  }

  private void update() {
    string output = Utils.exec({"upower", "-i", "/org/freedesktop/UPower/devices/battery_BAT0"});
    string output_type;
    string output_value;
    
    foreach (string str in output.split("\n")) {
      output_type = str.split(":")[0];
      output_value = str.split(":")[1];
      if (output_value==null || output_type==null) {
        continue;
      }
      output_type = output_type.chomp().chug();
      output_value = output_value.chomp().chug();
      switch (output_type) {
        case "percentage":
          if (int.parse(output_value)!=this.battery_level) {
            this.battery_level = int.parse(output_value);
            this.sig_battery_level_change(this.battery_level);
          }
          break;
        case "state":
          if (output_value!=this.state) {
            this.state = output_value;
            this.sig_state_change(this.state);
          }
          break;
        case "time to empty":
          if (output_value!=this.time_remaining) {
            this.time_remaining = output_value;
            this.sig_time_change(this.time_remaining);
          }
          break;
        case "time to full":
          if (output_value!=this.time_remaining) {
            this.time_remaining = output_value;
            this.sig_time_change(this.time_remaining);
          }
          break;
        case "icon-name":
          if (output_value!=this.icon_name) {
            this.icon_name = output_value[1:-1];
            this.sig_icon_name_change(this.icon_name);
          }
          break;
      }
    }
  }
}
