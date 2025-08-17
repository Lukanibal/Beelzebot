///I hope to test minicpm-v or llava for this purpose
global.imageMemory := [];

global.imageModel := "minicpm-v";

global.imageResponse := -1;

///this needs to be handed the message from message handler to properly understand the user's request
///possibly hand the response back to beelzebot for amplified crazy

function imagePrompt( _message, _image) constructor
{
	model  := global.imageModel;
	prompt := _message;
	stream := false;
	images := [ _image];
}

function imagePromptDeliver( _prompt)
{
	var _json := json_stringify( _prompt);
	show_debug_message($"IMAGE JSON PROMPT: {_json}");
	global.imageResponse := http_post_string( "http://localhost:11434/api/generate?", _json);
}

function imageTestFunc( _imagedata)
{
	var _iPrompt := new imagePrompt( "Explain this image in detail", _imagedata);
	imagePromptDeliver( _iPrompt);
}

function dumpImage( _imageData)
{
	var _img := buffer_base64_decode( _imageData);
	buffer_save( _img, "imageTest.png");
}

function resizeImage( _image)///must be done in draw event
{
	var _surf := surface_create( 200, 200);
	surface_set_target(_surf);
	
	draw_clear_alpha(c_black, 0.0);
	draw_sprite_stretched(_image, 0, 0, 0, 200, 200);
	surface_reset_target();
	sprite_delete( _image);
	
	var _data := buffer_create(8, buffer_grow, 1);
	buffer_get_surface( _data, _surf, 0);
	
	buffer_save(_data, "resizedimage.png");
	
	var _result := buffer_base64_encode( _data, 0, buffer_get_size( _data));
	buffer_delete( _data);
	
	return _result;//sprite_create_from_surface(_surf, 0, 0, 300, 300, false, false, 0, 0);
	
} 

function imageConvert( _base64_data, _type)
{
	var _data_url = $"data:image/{_type};base64,{_base64_data}";
	return sprite_add(_data_url, 1, false, false, 0, 0);
}