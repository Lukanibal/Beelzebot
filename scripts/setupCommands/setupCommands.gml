function setupCommands()
{ 

    // Create a simple slash command where the user types /ping
    var _guildId = "1374933575131992186";
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
                            model: "llama3.2",
                            prompt: rules.personality.prompt + " say something insane, but keep it short",
                            stream: false
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
        show_debug_message(_message)
        
        if(string_count(beelzebotID, string_lower(_message)) && _messageData.author.id != beelzebotID)
        {
           if(_messageData.author.id == creatorID)
           {
                var _prompt :=
               {
                    model: "llama3.2",
                    prompt: objBeelzebot.rules.personality.prompt + " the following message is from your esteemed creator, respond in character: " + _message,
                    stream: false
               }
           }
           else 
           {
               var _prompt :=
               {
                    model: "llama3.2",
                    prompt: objBeelzebot.rules.personality.prompt + " respond to the following message in character: " + _message,
                    stream: false
               }
           }
           objBeelzebot.query := http_post_string( "http://localhost:11434/api/generate?", json_stringify( _prompt))
           
        }
        
    }
    
}

