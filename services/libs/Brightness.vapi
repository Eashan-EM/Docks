/* Brightness.vapi generated by valac 0.56.16, do not modify. */

[CCode (cheader_filename = "Brightness.h")]
public class Brightness : GLib.Object {
	public Brightness ();
	public void set_brightness (int level);
	public void start ();
	public string icon_name { get; private set; }
	public int level { get; private set; }
	public signal void sig_brightness_change (int level);
}
