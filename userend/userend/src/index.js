import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";
import "./index.css";

// Make date inputs clickable anywhere to open calendar
const makeDateInputsClickable = () => {
  const handleDateInputClick = (e) => {
    const input = e.target;
    if (input && input.type === 'date') {
      // Use modern showPicker API if available (Chrome/Edge 99+, Safari 16.4+)
      if (typeof input.showPicker === 'function') {
        // Always open the picker when clicking anywhere on the date input
        // Small delay to ensure the input is focused first
        setTimeout(() => {
          try {
            input.showPicker();
          } catch (_err) {
            // showPicker may fail in some contexts (e.g., user interaction required)
            // Allow normal browser behavior in those cases
          }
        }, 50);
      }
    }
  };

  // Attach click handlers to all date inputs
  const attachHandlersBetter = () => {
    document.querySelectorAll('input[type="date"]').forEach(input => {
      // Check if handler is already attached
      if (!input.hasAttribute('data-date-clickable')) {
        input.setAttribute('data-date-clickable', 'true');
        input.addEventListener('click', handleDateInputClick);
      }
    });
  };

  // Initial attachment
  attachHandlersBetter();

  // Use MutationObserver to handle dynamically added date inputs
  const observer = new MutationObserver(attachHandlersBetter);
  observer.observe(document.body, {
    childList: true,
    subtree: true
  });
};

// Initialize when DOM is ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', makeDateInputsClickable);
} else {
  makeDateInputsClickable();
}

import { BrowserRouter, Routes, Route } from "react-router-dom";
import RoomLanding from "./components/RoomLanding";

// ... existing code ...

const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(
  <React.StrictMode>
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<App />} />
        <Route path="/room/:id" element={<RoomLanding />} />
        {/* Support existing QR codes that include the /pomma path prefix */}
        <Route path="/pomma/room/:id" element={<RoomLanding />} />
      </Routes>
    </BrowserRouter>
  </React.StrictMode>
);
