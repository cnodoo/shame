

function bookmark() {
    var mail = "mymail@local";
    var url = document.location.href;
    var title = document.title;
    var selection = window.getSelection();

    var mailto = "mailto:" + mail + "?" + "from=" + mail + "&"
                                        + "subject=" + encodeURIComponent("[bookmark]" + title) + "&"
                                        + "bcc=" + encodeURIComponent(mail) + "&"
                                        + "body=" + encodeURIComponent(url);
                                        
    window.open(mailto);
    // void(window.open(mailto));
    // bookmarklet => javascript:...
}


function quote() {
    var mail = "mymail@local";
    var url = document.location.href;
    var title = document.title;
    var selection = window.getSelection();

    var mailto = "mailto:" + mail + "?" + "from=" + mail + "&"
                                        + "subject=" + encodeURIComponent("[bookmark]" + title) + "&"
                                        + "bcc=" + encodeURIComponent(mail) + "&"
                                        + "body=" + encodeURIComponent(selection + "\n" + "[0] " + url);
                                        
    window.open(mailto);
    // void(window.open(mailto));
    // bookmarklet => javascript:...
}



// bookmark bookmarklet
javascript:void(window.open("mailto:"+"mymail@local"+"?"+"from="+"mymail@local"+"&"+"subject="+encodeURIComponent("[bookmark]"+document.title)+"&"+"bcc="+encodeURIComponent("mymail@local")+"&"+"body="+encodeURIComponent(document.location.href)))

// quote bookmarklet
javascript:void(window.open("mailto:"+"mymail@local"+"?"+"from="+"mymail@local"+"&"+"subject="+encodeURIComponent("[quote]")+"&"+"bcc="+encodeURIComponent("mymail@local")+"&"+"body="+encodeURIComponent(window.getSelection()+"\n"+"[0]\ "+document.location.href)))