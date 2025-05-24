
if( async_load[? "id"] == llamaLoader)
{
    if( async_load[? "status"] == 0)
    {
        show_debug_message( modelName + " is loaded and ready for prompts");
        query := http_post_string( "http://localhost:11434/api/generate?", json_stringify( wakeup));
    }
}

if( async_load[? "id"] == query)
{
    if( async_load[? "status"] == 0)
    {
        var _response := json_parse( async_load[? "result"]);
        if( is_struct( _response) && !is_undefined(_response.response))
        {
            text = _response.response;
            global.bot.messageSend( productionChannelID, _response.response);
        }
        else 
        {
        	global.bot.messageSend( productionChannelID, "Sorry Beelzebot couldn't handle that request, too much is happening in his addled mind right now <3");
        }
        
        var _mem := new ShortTermMemory( "assistant", text);

    }
}

