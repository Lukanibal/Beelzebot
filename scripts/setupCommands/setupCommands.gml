function setupMessaging()
{ 
  ///message handling I hope
    global.bot.gatewayEventCallbacks[$ "MESSAGE_CREATE"] := function()
    {
        var _event := discord_gateWay_event_parse();
        var _messageData := _event.d;
        
        var _message := _messageData.content;
        
        ///add this message to the short term memory
        var _memory := new ShortTermMemory( "user", _message, _messageData.author.id);
        
        array_push( objBeelzebot.messages, _memory);
        
        var _messageHistory := new Message("system", "here is what has been said in the conversation so far: " + json_stringify(objBeelzebot.messages));
        
        if(string_count("beelzebot", string_lower(_message)) && _messageData.author.id != beelzebotID)
        {
           if(_messageData.author.id == creatorID)
           {
                var _prompt :=
                {
                    model: objBeelzebot.modelName,
                    messages: [objBeelzebot.systemPrompt, _messageHistory , new Message("system", "respond to the following message in character: "), _memory],
                    stream: false
                }
           }
           else 
           {
               var _prompt :=
               {
                    model: objBeelzebot.modelName,
                    context: objBeelzebot.messages,
                    messages: [objBeelzebot.systemPrompt, _messageHistory , new Message("system", "respond to the following message in character: "), _memory],
                    stream: false
                    
               }
           }
           objBeelzebot.query := http_post_string( "http://localhost:11434/api/chat?", json_stringify( _prompt))
           
        }
        
    }
    
}

