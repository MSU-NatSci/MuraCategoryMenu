
function init_category_menu(element) {
    if (element.nodeName == 'SELECT') {
        var select = element;
        select.addEventListener('change', (e) => {
            let option = select.options[select.selectedIndex];
            window.location.href = option.getAttribute('category-url');
        }, false);
        for (let option of select.getElementsByTagName('OPTION')) {
            if (option.getAttribute('category-url') == location.pathname)
                option.selected = 'selected';
        }
    } else if (element.nodeName == 'NAV') {
        nav = element;
        let titleClick = (e) => {
            e.preventDefault();
            let title = e.target;
            let item = title.parentNode;
            let subItems = item.getElementsByClassName('categoryItem');
            if (subItems.length > 0) {
                let selectedCats = Array.from(nav.getElementsByClassName('selectedCategory'));
                for (let selected of selectedCats) {
                    selected.classList.toggle('selectedCategory');
                    let selectedTitle = selected.firstElementChild;
                    selectedTitle.setAttribute('aria-expanded', 'false');
                    selectedTitle.setAttribute('aria-selected', 'false');
                }
                item.classList.toggle('selectedCategory');
                if (item.nodeName != 'NAV') {
                    title.setAttribute('aria-expanded', 'true');
                    title.setAttribute('aria-selected', 'true');
                    while (item.parentNode.parentNode != null &&
                            item.parentNode.parentNode.classList.contains('categoryItem')) {
                        item = item.parentNode.parentNode;
                        itemTitle = item.firstElementChild;
                        item.classList.toggle('selectedCategory');
                        itemTitle.setAttribute('aria-expanded', 'true');
                    }
                }
            } else {
                window.location.href = item.getAttribute('category-url');
            }
        };
        for (let title of nav.getElementsByClassName('categoryTitle')) {
            title.addEventListener('click', titleClick, false);
            title.addEventListener('touchstart', titleClick, false);
            let item = title.parentNode;
            if (item.nodeName != 'NAV') {
                let url = item.getAttribute('category-url');
                if (url == location.pathname) {
                    item.classList.toggle('selectedCategory');
                    title.setAttribute('aria-selected', 'true');
                    while (item.parentNode.parentNode != null &&
                            item.parentNode.parentNode.classList.contains('categoryItem')) {
                        item = item.parentNode.parentNode;
                        item.classList.add('selectedCategory');
                    }
                }
                let subItems = item.getElementsByClassName('categoryItem');
                if (subItems.length > 0)
                    title.setAttribute('aria-expanded', url == location.pathname ? 'true' : 'false');
            }
        }
        nav.removeAttribute('style');
    }
}
