// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";

// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

let Hooks = {};

Hooks.Flash = {
  mounted() {
    let hide = () =>
      liveSocket.execJS(this.el, this.el.getAttribute("phx-click"));
    this.timer = setTimeout(() => hide(), 8000);
    this.el.addEventListener("phx:hide-start", () => clearTimeout(this.timer));
    this.el.addEventListener("mouseover", () => {
      clearTimeout(this.timer);
      this.timer = setTimeout(() => hide(), 8000);
    });
  },
  destroyed() {
    clearTimeout(this.timer);
  },
};

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
});

// Show progress bar on live navigation and form submits
topbar.config({
  barColors: { 0: "#c084fc" },
  shadowColor: "rgba(0, 0, 0, .3)",
});
window.addEventListener("phx:page-loading-start", (info) => topbar.show());
window.addEventListener("phx:page-loading-stop", (info) => topbar.hide());

window.addEventListener("card:toggle", e => {
  e.target.classList.toggle("is-flipped")
});

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
