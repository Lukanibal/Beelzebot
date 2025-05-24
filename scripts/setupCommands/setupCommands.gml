function setupCommands()
{ 

    // Create a simple slash command where the user types /ping
    var _guildId = objBeelzebot.productionServerID;
    var _testGuildCommand = new discordGuildCommand("speak", "Make Beelzebot say something", DISCORD_COMMAND_TYPE.chatInput );
    
    
    
    global.bot.guildCommandCreate(_guildId, _testGuildCommand);
    
    global.bot.gatewayEventCallbacks[$ "INTERACTION_CREATE"] := function()
    {
        var _event := discord_gateWay_event_parse();
        var _eventData := _event.d;
        
        switch(_eventData.type)
        {
            case DISCORD_INTERACTION_TYPE.applicationCommand:
           {
                switch(_eventData.data.name)
                {
                    case "speak":
                    {
                        var _prompt :=
                        {
                            model: objBeelzebot.modelName,
                            prompt: rules.personality.prompt + " say something insane, but keep it short",
                            stream: false,
                            indentifiers: { id: _eventData.id, token: _eventData.token}
                        }
                        show_debug_message("making him speak");
                        objBeelzebot.query := http_post_string( "http://localhost:11434/api/generate?", json_stringify(_prompt));
                        global.bot.interactionResponseSend(_eventData.id, _eventData.token, DISCORD_INTERACTION_CALLBACK_TYPE.channelMessageWithSource, text);
                    }
                }
            }
        }
        
    }
    
    ///message handling I hope
    global.bot.gatewayEventCallbacks[$ "MESSAGE_CREATE"] := function()
    {
        var _event := discord_gateWay_event_parse();
        var _messageData := _event.d;
        
        var _message := _messageData.content;
        
        ///add this message to the short term memory
        var _memory := new ShortTermMemory( "user", _message, _messageData.author.id);
        
        array_push( objBeelzebot.messages, _memory);
        
        if(string_count("beelzebot", string_lower(_message)) && _messageData.author.id != beelzebotID)
        {
           if(_messageData.author.id == creatorID)
           {
                var _prompt :=
                {
                    model: objBeelzebot.modelName,
                    prompt: objBeelzebot.rules.personality.prompt + $" here is an array of context for the current conversation: {objBeelzebot.messages}" + " the following message is from your esteemed creator, do whatever they ask of you: " + _message,
                    stream: false
                }
           }
           else 
           {
               var _prompt :=
               {
                    model: objBeelzebot.modelName,
                    context: objBeelzebot.messages,
                    prompt: objBeelzebot.rules.personality.prompt + $" here is an array of context for the current conversation: {objBeelzebot.messages}" +  " respond to the following message in character: " + _message,
                    stream: false
                    
               }
           }
           objBeelzebot.query := http_post_string( "http://localhost:11434/api/generate?", json_stringify( _prompt))
           
        }
        
    }
    
}

