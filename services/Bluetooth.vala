[DBus (name = "org.bluez.Adapter1")]
private interface Bluez : Object {
    public signal void discovery_started ();
    public signal void discovery_completed ();
    public signal void remote_device_found (string address, uint klass, int rssi);
    public signal void remote_name_updated (string address, string name);

    public abstract void start_discovery () throws GLib.Error;
    public abstract string[] get_discovery_filters();
    public abstract string address {owned get; }
}

public class Bluetooth: Object {
  MainLoop loop;

  void on_remote_device_found (string address, uint klass, int rssi) {
    stdout.printf ("Remote device found (%s, %u, %d)\n",
      address, klass, rssi);
  }

  void on_discovery_started () {
    stdout.printf ("Discovery started\n");
  }

  void on_remote_name_updated (string address, string name) {
    stdout.printf ("Remote name updated (%s, %s)\n", address, name);
  }

  void on_discovery_completed () {
    stdout.printf ("Discovery completed\n");
    loop.quit ();
  }

  public Bluetooth () {
    Bluez bluez;
    try {
        bluez = Bus.get_proxy_sync (BusType.SYSTEM, "org.bluez",
                                                          "/org/bluez/hci0");

        // Connect to D-Bus signals
        bluez.remote_device_found.connect (on_remote_device_found);
        bluez.discovery_started.connect (on_discovery_started);
        bluez.discovery_completed.connect (on_discovery_completed);
        bluez.remote_name_updated.connect (on_remote_name_updated);

        // Async D-Bus call
        bluez.start_discovery ();
        print(bluez.address);
    } catch (GLib.Error e) {
        stderr.printf ("%s\n", e.message);
    }

    loop = new MainLoop ();
    loop.run ();
  }
}
