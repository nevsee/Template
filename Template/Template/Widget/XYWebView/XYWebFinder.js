var _xy_searchIndex = -1;
var _xy_searchCount = 0;
var _xy_caseSensitive = false;
var _xy_selectsFirstMatch = true;
var _xy_normalBackgroundColor = "yellow";
var _xy_normalTextColor = "black";
var _xy_seletedBackgroundColor = "orange";
var _xy_selectedTextColor = "black";

function _xy_highlightStringForElement(element, keyword) {
    if (!element || !keyword) return;
    
    if (element.nodeType == 1) { // element node
        if (element.style.display == "none" || element.nodeName.toLowerCase() == "select") return;
        for (var i = element.childNodes.length - 1; i >= 0; i--) {
            _xy_highlightStringForElement(element.childNodes[i], keyword);
        }
    } else if (element.nodeType == 3) { // text node
       while (true) {
           var value = element.nodeValue;
           var index = _xy_caseSensitive ? value.indexOf(keyword) : value.toLowerCase().indexOf(keyword.toLowerCase());
           if (index < 0) break; // not found

           var span = document.createElement("span");
           var text = document.createTextNode(value.substr(index, keyword.length));
           span.appendChild(text);
           span.setAttribute("class", "_xy_highlightedSpan");
           span.style.backgroundColor = _xy_normalBackgroundColor;
           span.style.color = _xy_normalTextColor;
           text = document.createTextNode(value.substr(index + keyword.length));
           element.deleteData(index, value.length - index);
           var next = element.nextSibling;
           element.parentNode.insertBefore(span, next);
           element.parentNode.insertBefore(text, next);
           element = text;
           _xy_searchCount++; // update count
       }
    }
}

function _xy_unhighlightStringForElement(element) {
    if (!element || element.nodeType != 1) return false;

    if (element.getAttribute("class") == "_xy_highlightedSpan") {
        var text = element.removeChild(element.firstChild);
        element.parentNode.insertBefore(text, element);
        element.parentNode.removeChild(element);
        return true;
    } else {
        var normalize = false;
        for (var i = element.childNodes.length - 1; i >= 0; i--) {
            if (_xy_unhighlightStringForElement(element.childNodes[i])) {
                normalize = true;
            }
        }
        if (normalize) {
            element.normalize();
        }
    }
    return false;
}

function _xy_jump(increment) {
    if (_xy_searchCount == 0) return 0;
    previousIndex = _xy_searchIndex;
    nextIndex = _xy_searchIndex + increment;

    if (nextIndex < 0) {
        nextIndex = _xy_searchCount + nextIndex;
    }
    if (nextIndex >= _xy_searchCount) {
        nextIndex = nextIndex - _xy_searchCount;
    }
    _xy_searchIndex = nextIndex;

    previousSpan = document.getElementsByClassName("_xy_highlightedSpan")[previousIndex];
    if (previousSpan) {
        previousSpan.style.backgroundColor = _xy_normalBackgroundColor;
        previousSpan.style.color = _xy_normalTextColor;
    }

    nextSpan = document.getElementsByClassName("_xy_highlightedSpan")[nextIndex];
    if (nextSpan) {
        nextSpan.style.backgroundColor = _xy_seletedBackgroundColor;
        nextSpan.style.color = _xy_selectedTextColor;
        nextSpan.scrollIntoView();
    }
}

function _xy_reset() {
    _xy_searchIndex = -1;
    _xy_searchCount = 0;
}

// use for native

function xy_setAppearance(normalBackgroundColor, normalTextColor, seletedBackgroundColor, selectedTextColor, caseSensitive, selectsFirstMatch) {
    if (normalBackgroundColor) _xy_normalBackgroundColor = normalBackgroundColor;
    if (normalTextColor) _xy_normalTextColor = normalTextColor;
    if (seletedBackgroundColor) _xy_seletedBackgroundColor = seletedBackgroundColor;
    if (selectedTextColor) _xy_selectedTextColor = selectedTextColor;
    _xy_caseSensitive = caseSensitive;
    _xy_selectsFirstMatch = selectsFirstMatch;
    return _xy_normalBackgroundColor;
}

function xy_findAll(keyword) {
    _xy_unhighlightStringForElement(document.body);
    _xy_reset();
    _xy_highlightStringForElement(document.body, keyword);
    if (_xy_selectsFirstMatch) {
        xy_findNext();
    }
    return _xy_searchCount;
}

function xy_findPrevious() {
    _xy_jump(-1);
    return _xy_searchIndex;
}

function xy_findNext() {
    _xy_jump(1);
    return _xy_searchIndex;
}

function xy_clear() {
    _xy_unhighlightStringForElement(document.body);
    _xy_reset();
}


