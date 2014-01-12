var quoteBuffer = new StringBuffer();
var myselfAdr = "myself@myhost.local";

function addQuoteString()
{
	quoteBuffer = quoteBuffer.append(window.getSelection());
}

function sendQuote()
{
	var author = "";
        window.prompt("Author",author);
	quoteBuffer = auhtor.append(":\n").append(quoteBuffer);
	quoteBuffer = quoteBuffer.append("[0] ").append(window.location.href.toString());
	
	var mailtoUri = "mailto:"
	mailtoUri = mailtoUri.append(myselfAdr);
	mailtoUri = mailtoUri.append("&from=");	
	mailtoUri = mailtoUri.append(myselfAdr);
	mailtoUri = mailtoUri.append("&subject=");
	mailtoUri = mailtoUri.append(encodeUriComponent("Zitat des Tages"));
	mailtoUri = mailtoUri.append("&keywords=");
	mailtoUri = mailtoUri.append(encodeUriComponent("quote"));
	mailtoUri = mailtoUri.append("&body=");
	mailtoUri = mailtoUri.append(encodeUriComponent(quoteBuffer));

	// window.open(mailtoUri, '_blank');

	quoteBuffer = "";
}

function sendBookmark()
{
	var mailtoUri = "mailto:"
	mailtoUri = mailtoUri.append(myselfAdr);
	mailtoUri = mailtoUri.append("&from=");	
	mailtoUri = mailtoUri.append(myselfAdr);
	mailtoUri = mailtoUri.append("&subject=");
	mailtoUri = mailtoUri.append(encodeUriComponent("[bookmark] "));
	mailtoUri = mailtoUri.append(encodeUriComponent(window.location.href.toString()));
	mailtoUri = mailtoUri.append("&keywords=");
	mailtoUri = mailtoUri.append(encodeUriComponent("bookmark"));
	mailtoUri = mailtoUri.append("&body=");
	mailtoUri = mailtoUri.append(encodeUriComponent(window.location.href.toString()));

	// window.open(mailtoUri, '_blank');
}

