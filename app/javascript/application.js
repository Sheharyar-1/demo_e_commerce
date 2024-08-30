// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import { Dropdown } from 'bootstrap';


document.addEventListener('turbo:load', () => {
  const photoInput = document.getElementById('photo-input');
  const photoPreview = document.getElementById('photo-preview');

  photoInput.addEventListener('change', function() {
    const file = this.files[0];
    if (file) {
      const reader = new FileReader();

      reader.onload = function(event) {
        photoPreview.src = event.target.result;
        photoPreview.style.display = 'block';
      };

      reader.readAsDataURL(file);
    } else {
      photoPreview.style.display = 'none';
    }
  });
});
