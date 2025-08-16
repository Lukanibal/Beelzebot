///I hope to test minicpm-v or llava for this purpose
global.imageMemory := [];

global.imageModel := "minicpm-v";

global.imageResponse := -1;

///this needs to be handed the message from message handler to properly understand the user's request
///possibly hand the response back to beelzebot for amplified crazy

function imagePrompt( _role, _message, _image) constructor
{
	model  := global.imageModel;
	prompt := _message;
	//messages := _message;
	stream := false;
	images := [ ];
	
}

function imagePromptDeliver( _prompt)
{
	var _json := json_stringify(_prompt);
	show_debug_message($"IMAGE PROCESSING LOG: {_json}")
	global.imageResponse := http_post_string( "http://localhost:11434/api/generate?", _json);
}
