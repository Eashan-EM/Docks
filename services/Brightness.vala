public class Brightness: Object {
  public signal void sig_brightness_change(int level);

  public int level {get; private set; default=0; }
  public string icon_name {get; private set; default="display-brightness-symbolic"; }

  private Hyprland hypr;

  public Brightness() {
    this.hypr = new Hyprland();
  }

  public void start() {
    this.get_brightness_level();
    this.icon_name = "display-brightness-symbolic";
    this.restore_state();
  }

  public void set_brightness(int level) {
    if (0<=level && level<=100) {
      hypr.dispatch_exec(@"brightnessctl set $(level)%");
      this.level = level;
      this.save_state();
      this.sig_brightness_change(this.level);
    }
  }

  private void save_state() {
    hypr.dispatch_exec("brightnessct --save");
  }

  private void restore_state() {
    hypr.dispatch_exec("brightnessctl --restore");
  }

  private void get_brightness_level() {
     string res = Utils.exec({"brightnessctl", "-m"});
     this.level = int.parse(res.split(",")[3]);
     this.sig_brightness_change(this.level);
  }
}
