
if( async_load[? "id"] == llamaLoader)
{
    if( async_load[? "status"] == 0)
    {
        show_debug_message( modelName + " is loaded and ready for prompts");
        loadMemories();
        query := http_post_string( "http://localhost:11434/api/chat?", json_stringify( wakeup));
    }
}


if( async_load[? "id"] == query)
{
    if( async_load[? "status"] == 0)
    {
        var _response := json_parse( async_load[? "result"]);
        
        if( !is_undefined(_response) && is_struct( _response))
        {
            if(is_undefined(_response[$ "error"]))
            {
                var _message := _response.message.content;
                text = _message;
                global.bot.messageSend( activeChannel, _message);
            }
            else 
            {
            	show_debug_message( $"this is messaed up: {_response}" )
                exit;
            }
        }
        else 
        {
        	global.bot.messageSend( activeChannel, "Sorry Beelzebot couldn't handle that request, too much is happening in his addled mind right now <3");
        }
        
        var _mem := new ShortTermMemory( "assistant", text);
        array_push(global.longTermMemory, _mem);

    }
}

