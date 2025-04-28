// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "@rails/ujs"
import "controllers"

import Rails from "@rails/ujs";
Rails.start();

import { Turbo } from "@hotwired/turbo-rails";
Turbo.session.drive = false;

document.addEventListener("DOMContentLoaded", function() {
    const fileInput = document.getElementById('fileInput');
    const preview = document.getElementById('preview');
  
    if (fileInput) {
      fileInput.addEventListener('change', function(event) {
        const [file] = event.target.files;
        if (file) {
          preview.src = URL.createObjectURL(file);
          preview.style.display = "block";
        } else {
          preview.style.display = "none";
        }
      });
    }
  });
  