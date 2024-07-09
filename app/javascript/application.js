// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
//= require jquery
//= require bootstrap
//= require items
//= require insights

document.addEventListener("DOMContentLoaded", function() {
    const form = document.getElementById('champion_form');
    const select = document.getElementById('champion');
  
    form.addEventListener('submit', function(event) {
      event.preventDefault();
      const selectedChampion = select.value;
      form.action = "/champions/${selectedChampion}";
      form.submit();
    });
  }); 
