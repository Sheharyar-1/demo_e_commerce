// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import { Dropdown } from 'bootstrap';

// Initialize Bootstrap dropdowns
document.addEventListener('turbo:load', () => {
  document.querySelectorAll('.dropdown-toggle').forEach(element => {
    new Dropdown(element);
  });
});
