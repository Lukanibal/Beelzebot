///again, I don't even think I _need_ to do this, but here it is just in case
if( async_load[? "id"] == llamaLoader)
{
    if( async_load[? "status"] == 0)
    {
        show_debug_message( modelName + " is loaded and ready for prompts");
        loadMemories();
        query := http_post_string( "http://localhost:11434/api/chat?", json_stringify( wakeup));
    }
}

///chat responses
if( async_load[? "id"] == query)
{
    if( async_load[? "status"] == 0)
    {
        var _response := json_parse( async_load[? "result"]);
        
        if( !is_undefined(_response) && is_struct( _response))
        {
            if(is_undefined(_response[$ "error"]))
            {
                text := _response.message.content;
                if(!objBeelzebot.isMentioned)
                {
                    global.bot.messageSend( responseAreaID, $"{text}");
                }
                else 
                {
                	global.bot.messageSend( responseAreaID, $"{text}");
                }
                
                var _mem := new ShortTermMemory( "assistant", $"{text}");
                array_push(global.longTermMemory, _mem);
            }
            else 
            {
            	show_debug_message( $"this sent an error back: {_response}" );
                exit;
            }
        }
        else 
        {
        	
            global.bot.messageSend( responseAreaID, "Sorry Beelzebot couldn't handle that request, too much is happening in his addled mind right now <3");
            
        }
        isMentioned := false;
    }
}

///this handle reations to messages
if( async_load[? "id"] == reactionHandler)
{
    if( async_load[? "status"] == 0)
    {
        var _response := json_parse(async_load[? "result"]);
        var _emote := _response.message.content;
        
        global.bot.messageReactionCreate( responseAreaID, reactingID, _emote);
    }
}


///image handler
if( async_load[? "id"] == global.imageResponse)
{
    if( async_load[? "status"] == 0)
    {
        var _json := json_parse(async_load[? "result"]);
		show_debug_message(_json);
		//var _response := _json.message.content;
        
		//have beelzebot respond instead of vision ai
		
		if(variable_struct_exists(_json, "response"))
		{
	        
			var _prompt :=
			{
				model: objBeelzebot.modelName,
				messages: [objBeelzebot.systemPrompt, new Message("system", "Take this response and say it in your own insane words:"), new Message("user", _json.response)],
				stream: false
			}
			
			objBeelzebot.query := http_post_string( "http://localhost:11434/api/chat?", json_stringify( _prompt));
	        global.bot.triggerTypingIndicator(objBeelzebot.responseAreaID);
			
			show_debug_message("IMAGE RESPONSE");
		}
		else if(variable_struct_exists(_json, "error"))
		{
			global.bot.messageSend( responseAreaID, $"Beelzebot cannot handle very large or overly complex images.\r\nPlease try reducing the size to 300X300 or smaller, or reducing complexity by cutting out background noise.");
			//objImageHandler.resize := 0;
		}
        
    }
}