if(async_load[? "id"] == current_image)
{
	show_debug_message("IMAGE PROCESSING LOG: BEGINNING PROCESSING");
	
	if(async_load[? "status"] == 0)
	{
		var _img := buffer_load(async_load[? "result"]);
	
		var _size := buffer_get_size(_img);
		var _base_64_image_data := buffer_base64_encode( _img, 0, _size);
		
		//array_push(images, _base_64_image_data);
		//show_debug_message("RAW BASE64 DUMP: " + _base_64_image_data);
		//clipboard_set_text(_base_64_image_data);
		
		var _iPrompt := new imagePrompt( message, _base_64_image_data);
		imagePromptDeliver( _iPrompt);
	}
	
	
}






