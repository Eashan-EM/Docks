using PulseAudio;

public class Audio: Object {
  public signal void sig_state_unconnected();
  public signal void sig_state_connecting();
  public signal void sig_state_authorizing();
  public signal void sig_state_setting_name();
  public signal void sig_state_ready();
  public signal void sig_state_failed();
  public signal void sig_state_terminated();

  public signal void sig_default_sink_change(string name, int id);
  public signal void sig_default_sink_vol_change(int percent);
  public signal void sig_default_sink_mute_change(bool muted);

  private PulseAudio.MainLoop loop;

  public string[] sinks{get; private set; }
  private int sinks_length = 0;
  public string default_sink_name{get; private set; }
  public int default_sink_id{get; private set; }
  public string default_sink_icon_name{get; private set; }
  public int default_sink_volume{get; private set; }
  public bool default_sink_mute{get; private set; }

  public void start() {
    var thread = new Thread<void>("audio", this.run);
  }
  private void run() {
    this.loop = new PulseAudio.MainLoop();
    this.sinks = new string[10];
    Context con = new Context(this.loop.get_api(), "Audio");

    con.connect(null, Context.Flags.NOFAIL, null);
    con.set_state_callback(this.state_callback);
    this.loop.run();
  }

  public string set_sink_default_volume(int volume) {
    if (0<=volume && volume<=100) {
      return Utils.exec({"pactl", "set-sink-volume", this.default_sink_name, volume.to_string().concat("%")});
    }
    return "Volume out of bounds\n";
  }

  public string set_sink_default_volume_inc(int volume) {
    if (0<=volume && volume<=10) {
      return Utils.exec({"pactl", "set-sink-volume", this.default_sink_name, "+".concat(volume.to_string(), "%")});
    }
    return "Volume out of bounds\n";
  }

  public string set_sink_default_volume_dec(int volume) {
    if (0<=volume && volume<=10) {
      return Utils.exec({"pactl", "set-sink-volume", this.default_sink_name, "-".concat(volume.to_string(), "%")});
    }
    return "Volume out of bounds\n";
  }

  public string set_sink_default_mute(bool mute) {
    return Utils.exec({"pactl", "set-sink-mute", this.default_sink_name, mute.to_string()});
  }

  public string set_sink_default_toggle_mute() {
    return Utils.exec({"pactl", "set-sink-mute", this.default_sink_name, "toggle"});
  }

  public void state_callback(Context con) {
    Context.State state = con.get_state();
    if (state == Context.State.UNCONNECTED) {this.sig_state_unconnected();}
    if (state == Context.State.CONNECTING) {this.sig_state_connecting();}
    if (state == Context.State.AUTHORIZING) {this.sig_state_authorizing();}
    if (state == Context.State.SETTING_NAME) {this.sig_state_setting_name();}
    if (state == Context.State.READY) {
      con.subscribe(Context.SubscriptionMask.SINK);
      con.set_subscribe_callback(this.subscribe_callback);
      this.sig_state_ready();
      this.update(con);
    }
    if (state == Context.State.FAILED) {this.sig_state_failed();}
    if (state == Context.State.TERMINATED) {this.sig_state_terminated();}
  }

  public void default_sink_callback(Context c, SinkInfo? i, int eol) {
    if (i!=null) {
      bool sink_changed = (this.default_sink_name!=i.name);
      if (sink_changed) {
        this.default_sink_name = i.name;
        this.default_sink_id = (int) i.index;
        this.sig_default_sink_change(i.name, (int) i.index);
      }
      CVolume volume = i.volume;
      int vol = int.parse(volume.avg().to_string().chug());
      if (this.default_sink_volume!=vol || sink_changed) {
        this.default_sink_volume = vol;
        this.sig_default_sink_vol_change(this.default_sink_volume);
      }
      if (this.default_sink_mute!=volume.is_muted() || sink_changed) {
        this.default_sink_mute = volume.is_muted();
        this.sig_default_sink_mute_change(this.default_sink_mute);
      }
      this.default_sink_icon_name = i.proplist.PROP_APPLICATION_ICON_NAME;
    }
  }

  private void get_default_sink(Context context) {
    string sink_name = Utils.exec({"pactl", "get-default-sink"});
    context.get_sink_info_by_name(sink_name, this.default_sink_callback);
  }

  public void sinks_list_callback(Context context, SinkInfo? i, int eol) {
    if (i!=null) {
      this.sinks[this.sinks_length++] = i.name;
    }
  }

  private void update(Context context) {
    this.sinks_length = 0;
    context.get_sink_info_list(this.sinks_list_callback);
    this.get_default_sink(context);
  }

  public void subscribe_callback(Context context, Context.SubscriptionEventType e, uint32 id) {
    if (e==Context.SubscriptionEventType.CHANGE) {
      this.update(context);
    }
  }
}
