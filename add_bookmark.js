var headerTo = "undisclosed-recipients:;";
var headerSubject = "[BOOKMARK] " + window.location.href.toString(); /* use buffer.URL in vimperator*/
var headerBcc = "your@mail.local";
var headerKeywords = "bookmark";
var body = "";

var uri = "mailto:" + encodeURIComponent(headerTo) +
          "?subject=" + encodeURIComponent(headerSubject) +
          "&bcc=" + encodeURIComponent(headerBcc) +
          "&keywords=" + encodeURIComponent(headerKeywords) +
          "&body=" + encodeURIComponent(body);

window.open(uri);
