if(async_load[? "id"] == current_image)
{
	if(async_load[? "status"] == 0)
	{
		var _img := buffer_load(async_load[? "result"]);
		var _size := buffer_get_size(_img);
		var _base_64_image_data := buffer_base64_encode( _img, 0, _size);
		
		var _iPrompt := new imagePrompt("user", message, _base_64_image_data);
		imagePromptDeliver( _iPrompt);
	}
	
	
}




