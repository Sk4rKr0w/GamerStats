document.addEventListener('DOMContentLoaded', () => {
    const searchInput = document.getElementById('item-search');
    const gallery = document.getElementById('image-gallery');
    const items = gallery.getElementsByClassName('item-image');
  
    searchInput.addEventListener('input', () => {
      const filter = searchInput.value.toLowerCase();
      Array.from(items).forEach(item => {
        const itemName = item.getAttribute('data-name').toLowerCase();
        if (itemName.includes(filter)) {
          item.style.display = '';
        } else {
          item.style.display = 'none';
        }
      });
    });
  });