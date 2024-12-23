public int main() {
  Hyprland hypr = new Hyprland();
  hypr.sig_activewindow.connect((t, a) => {
    stdout.printf("%s\n", a.address);
  });
  hypr.sig_current_workspace_clients.connect((t, a) => {
    stdout.printf("%d\n", (int) a.length);
  });
  hypr.start();
  return 0;
}
