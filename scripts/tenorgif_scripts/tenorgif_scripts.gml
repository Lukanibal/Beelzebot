//https://tenor.googleapis.com/v2/search?


function request_gif(_q)
{
	global.gif_request := http_get($"https://tenor.googleapis.com/v2/search?key={global.gif_token}&q={__discord_url_encode(_q)}&contentfilter=medium&media_filter=tinygif&random=true&limit=1");
}