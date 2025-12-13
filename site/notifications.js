// Simulated real-time notifications using a lightweight polling loop.

function startNotificationStream() {
  const container = document.querySelector("[data-notifications]");
  if (!container) return;

  const messages = [
    "Kubernetes cluster is healthy.",
    "New deployment detected in the monitoring namespace.",
    "Prometheus scrape duration is within normal thresholds.",
  ];

  let index = 0;

  setInterval(() => {
    const message = messages[index % messages.length];
    container.textContent = message;
    index += 1;
  }, 4000);
}

window.addEventListener("DOMContentLoaded", () => {
  startNotificationStream();
});

