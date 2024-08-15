// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import { Dropdown } from 'bootstrap';


document.addEventListener('turbo:load', () => {
  document.querySelectorAll('.dropdown-toggle').forEach(element => {
    new Dropdown(element);
  });

  const photoInput = document.getElementById('photo-input');
  const photoPreview = document.getElementById('photo-preview');
  const existingPhoto = document.querySelector('.card-img-top');

  if (existingPhoto) {
    photoInput.dataset.existingUrl = existingPhoto.src;
  }

  photoInput.addEventListener('change', function() {
    const file = this.files[0];
    if (file) {
      const reader = new FileReader();

      reader.onload = function(event) {
        photoPreview.src = event.target.result;
        photoPreview.style.display = 'block';
        existingPhoto.style.display = 'none';
      };

      reader.readAsDataURL(file);
    } else {
      photoPreview.style.display = 'none';
      if (photoInput.dataset.existingUrl) {
        debugger
        existingPhoto.src = photoInput.dataset.existingUrl;
        existingPhoto.style.display = 'block';
      }
    }
  });
});
