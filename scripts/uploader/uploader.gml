///Thanks to Brian Laclair for this https://www.youtube.com/watch?v=dJkw0bm1cxs
var _file := file_text_open_read("uploads.secret");

global.base_url := file_text_read_string(_file);
file_text_readln(_file);

global.upload_url := file_text_read_string(_file);
file_text_readln(_file);

file_text_close(_file);

global.upload_image := -1;
global.painting_url := "";

function upload_painting(_name)
{
	var _file := "painting.png";
	var _filename := filename_name(_file);
	
	/*var _headers := ds_map_create();
	
	
	ds_map_set(_headers, "Host", global.base_url);
	ds_map_set(_headers, "User-Agent", "Beelzebot");
	ds_map_set(_headers, "Content-Type", "application/x-www-form-urlencoded");
	ds_map_set(_headers, "Accept", "*//*");*/
	
	var _data := buffer_create(1, buffer_grow, 1);
	buffer_load_ext(_data, "/painting.png", 0);
	
	var _data_encoded := buffer_base64_encode(_data, 0, buffer_get_size(_data));
	
	global.painting_url := string_replace_all(_name, " ", "%20");
	global.upload_image := painter_upload($"name={global.painting_url}&data={_data_encoded}");//http_request(global.upload_url, "POST", _headers, $"name={_filename}&data={_data_encoded}");
	call_later(5, time_source_units_seconds, function()
	{
		global.bot.triggerTypingIndicator(objBeelzebot.responseAreaID);
		global.bot.messageSend(objBeelzebot.responseAreaID, $"I've painted [this]({global.base_url}{global.painting_url}.png)");
	})
	
	/*buffer_delete(_data);
	ds_map_destroy(_headers);*/
}



