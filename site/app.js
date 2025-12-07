// Lightweight client-side logic for the CloudedX marketing page.
// Simulates fetching cluster metrics to demonstrate optimized queries.

async function fetchClusterSummary() {
  const start = performance.now();
  // In a real deployment this would call an API that aggregates Prometheus metrics.
  await new Promise((resolve) => setTimeout(resolve, 50));
  const duration = performance.now() - start;

  const el = document.querySelector("[data-cluster-summary]");
  if (el) {
    el.textContent = `Sample metrics fetched in ${duration.toFixed(1)} ms (simulated).`;
  }
}

window.addEventListener("DOMContentLoaded", () => {
  fetchClusterSummary().catch(() => {
    // Fail silently in this lightweight demo.
  });
});

