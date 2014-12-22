// void(window.open(mailto));
// javascript:{arbitrary script};void(0);
// bookmarklet => javascript:...
// javascript:(function(){})();

function note() {
    var mail = "mymail@local";
    var url = document.location.href;
    var title = document.title;
    var selection = window.getSelection();
    var note = window.prompt("Enter note:", "");

    var mailto = "mailto:" + mail + "?" + "from=" + mail + "&"
                                        + "subject=" + encodeURIComponent("[note] " + note) + "&"
                                        + "bcc=" + encodeURIComponent(mail) + "&"
                                        + "body=" + encodeURIComponent(note);
                                        
    window.open(mailto);
}

function bookmark() {
    var mail = "mymail@local";
    var url = document.location.href;
    var title = document.title;
    var selection = window.getSelection();

    var mailto = "mailto:" + mail + "?" + "from=" + mail + "&"
                                        + "subject=" + encodeURIComponent("[bookmark] " + title) + "&"
                                        + "bcc=" + encodeURIComponent(mail) + "&"
                                        + "body=" + encodeURIComponent(url);
                                        
    window.open(mailto);
}

function quote() {
    var mail = "mymail@local";
    var url = document.location.href;
    var title = document.title;
    var selection = window.getSelection();

    var mailto = "mailto:" + mail + "?" + "from=" + mail + "&"
                                        + "subject=" + encodeURIComponent("[quote] " + title) + "&"
                                        + "bcc=" + encodeURIComponent(mail) + "&"
                                        + "body=" + encodeURIComponent(selection + "\n" + "[0] " + url);
                                        
    window.open(mailto);
}


// note bookmarklet
javascript:void(window.open("mailto:"+"mymail@local"+"?"+"from="+"mymail@local"+"&"+"subject="+encodeURIComponent("[note]"+window.prompt("Enter note:",""))+"&"+"bcc="+encodeURIComponent("mymail@local")))

// bookmark bookmarklet
javascript:void(window.open("mailto:"+"mymail@local"+"?"+"from="+"mymail@local"+"&"+"subject="+encodeURIComponent("[bookmark]"+document.title)+"&"+"bcc="+encodeURIComponent("mymail@local")+"&"+"body="+encodeURIComponent(document.location.href)))

// quote bookmarklet
javascript:void(window.open("mailto:"+"mymail@local"+"?"+"from="+"mymail@local"+"&"+"subject="+encodeURIComponent("[quote]")+"&"+"bcc="+encodeURIComponent("mymail@local")+"&"+"body="+encodeURIComponent(window.getSelection()+"\n"+"[0]\ "+document.location.href)))
