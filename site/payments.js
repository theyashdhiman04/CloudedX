// Simple client-side mock for a payment gateway integration.

function simulatePayment() {
  const button = document.querySelector("[data-checkout-button]");
  const status = document.querySelector("[data-checkout-status]");

  if (!button || !status) return;

  button.disabled = true;
  status.textContent = "Processing payment with mock gateway...";

  setTimeout(() => {
    status.textContent = "Payment authorized (demo). No real charges were made.";
    button.disabled = false;
  }, 900);
}

window.addEventListener("DOMContentLoaded", () => {
  const button = document.querySelector("[data-checkout-button]");
  if (button) {
    button.addEventListener("click", simulatePayment);
  }
});

