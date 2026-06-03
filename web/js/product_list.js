function filterChanged() {
    document.getElementById('pageInput').value = 1; 
    document.getElementById('filterForm').submit();
}
function goToPage(page) {
    document.getElementById('pageInput').value = page;
    document.getElementById('filterForm').submit();
}
