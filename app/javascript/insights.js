document.addEventListener('DOMContentLoaded', () => {
    const searchInput = document.getElementById('champion-search');
    const table = document.getElementById('champion-table');
    const rows = table.getElementsByClassName('table-row');
  
    searchInput.addEventListener('input', () => {
      const filter = searchInput.value.toLowerCase();
      Array.from(rows).forEach(row => {
        const championName = row.getAttribute('data-name').toLowerCase();
        if (championName.includes(filter)) {
          row.style.display = '';
        } else {
          row.style.display = 'none';
        }
      });
    });
  });
  