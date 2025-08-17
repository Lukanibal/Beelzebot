///this is used form image resizing
if(resize > -1)
{
	var _spr := imageConvert(images[0], "png");
	_spr := resizeImage(_spr);
	
	//array_shift(images);
	
	var _prompt := new imagePrompt( message, _spr);
	imagePromptDeliver( _prompt);
	resize := -1;
}