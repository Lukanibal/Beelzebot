/*
Wikipedia process
ask the LLM if it thinks wikipedia could answer ther query, if it says yes, ask it for the best search term for wikipedia and then run that through the REST api
a la



*/
wikiQuestion := -1;
wikiRequest := -1;
heldQuestion := "";

function wiki_query( _term)
{
	var _clean_term := __discord_url_encode(_term);
	
	//global.wikiRequest := http_get($"https://api.wikimedia.org/core/v1/wikipedia/en/search/page?q={_clean_term}&limit=1");
	//https://en.wikipedia.org/api/rest_v1/page/summary/{_clean_term}
	global.wikiRequest := http_get($"https://en.wikipedia.org/api/rest_v1/page/summary/{_clean_term}");
	clipboard_set_text($"https://en.wikipedia.org/api/rest_v1/page/summary/{_clean_term}");
}