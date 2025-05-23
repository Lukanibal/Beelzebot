
if( async_load[? "id"] == llamaLoader)
{
    if( async_load[? "status"] == 0)
    {
        show_debug_message( "llama 3.2 is loaded and ready for prompts");
        query := http_post_string( "http://localhost:11434/api/generate?", json_stringify( wakeup));
    }
}

if( async_load[? "id"] == query)
{
    if( async_load[? "status"] == 0)
    {
        var _response := json_parse( async_load[? "result"]);
        text = _response.response;
        global.bot.messageSend( productionChannelID, _response.response);

    }
}

