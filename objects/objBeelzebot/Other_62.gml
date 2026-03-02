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
		
        var _emote := json_stringify(_response.message.content);
		_emote := json_parse(_emote);
		
		global.bot.messageReactionCreate( responseAreaID, reactingID, _emote);
		
		/*if( is_array(_emote))
		{
			show_debug_message("it worked?")
		}
		else 
		{
			show_debug_message(_response.message.content);
		}
		
		array_push(reactions_array, new reactionQueue( _emote, array_shift(self.reactingID)));*/
		
		
        //global.bot.messageReactionCreate( responseAreaID, reactingID, _emote);
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

///wiki stuff
if( async_load[? "id"] == global.wikiQuestion)
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
				messages: [objBeelzebot.systemPrompt],
				stream: false
			}
	        
			switch(_json.response)
			{
				case "ME":
				{
					array_push(_prompt.messages, new Message("user", "Answer the previous question in character."));
					break;
				}
				
				default:	
				case "WIKI":
				{
					wiki_query(global.heldQuestion);
					exit;
				}
			}
			
			objBeelzebot.query := http_post_string( "http://localhost:11434/api/chat?", json_stringify( _prompt));
	        global.bot.triggerTypingIndicator(objBeelzebot.responseAreaID);
			
		}
		else if(variable_struct_exists(_json, "error"))
		{
			global.bot.messageSend( responseAreaID, $"Beelzebot is being a bitch, sorry!");
		}
        
    }
}

if( async_load[? "id"] == global.wikiRequest)
{
    if( async_load[? "status"] == 0)
    {
        try 
		{
			var _response := json_parse(async_load[? "result"]);
			var _prompt :=
			{
				model: objBeelzebot.modelName,
				messages: [objBeelzebot.systemPrompt],
				stream: false
			}
			
			array_push(_prompt.messages, new Message("user", $"strip out the HTML and tell the chat this info in your own insane words: {_response[$ "extract"]}"));
			objBeelzebot.query := http_post_string( "http://localhost:11434/api/chat?", json_stringify( _prompt));
		    global.bot.triggerTypingIndicator(objBeelzebot.responseAreaID);
		}
		catch(_err)
		{
			show_debug_message($"Well Shit: {_err.message} \r\nGOT:{async_load[? "result"]}");
			global.bot.triggerTypingIndicator(objBeelzebot.responseAreaID);
			global.bot.messageSend( responseAreaID, $"That's a newer feature and it confused me sorry.\r\nTry again later!\r\n<@{creatorID}>");
		}
		
    }
}


if( async_load[? "id"] == global.gif_request)
{
    if( async_load[? "status"] == 0)
    {
        show_debug_message(async_load[? "result"]);
		var _json := json_parse(async_load[? "result"]);
		show_debug_message(_json);
		//var _response := _json.message.content;
        
		//have beelzebot respond instead of vision ai
		
		global.bot.triggerTypingIndicator(objBeelzebot.responseAreaID);
	        
		global.bot.messageSend( responseAreaID, $"{_json[$ "results"][0][$ "media_formats"][$ "tinygif"][$ "url"]}");
		
		
		
        
    }
}


if( async_load[? "id"] == global.upload_image)
{
    if( async_load[? "status"] == 0)
    {
        show_debug_message(async_load[? "result"]);
		
    }
}



if( async_load[? "id"] == global.grab_art)
{
    if( async_load[? "status"] == 0)
    {
        var _result := string_replace_all(async_load[? "result"], " ", "%20");
		global.bot.triggerTypingIndicator(objBeelzebot.responseAreaID);
		global.bot.messageSend(objBeelzebot.responseAreaID, $"I've painted [this]({global.base_url}{_result})");
    }
}