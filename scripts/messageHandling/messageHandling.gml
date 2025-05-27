function setupMessaging()
{///setup the gateway to handle incoming messages and commands
    global.bot.gatewayEventCallbacks[$ "MESSAGE_CREATE"] := function()
    {
        var _event := discord_gateWay_event_parse();
        var _messageData := _event.d;
        
        var _message := _messageData.content;
        
        //ingore messages you're not supposed to see
        if(_messageData.channel_id != objBeelzebot.activeChannel) 
        {exit};
        
        ///add a reaction for some fun
        if( string_count("beelzebot", string_lower(_message)) ||  string_count(beelzebotID, string_lower(_message)) || string_count(creatorID, _message) || string_count("lukan", string_lower(_message)) 
        || array_contains(global.consent, _messageData.author.username) )
        { 
            var _reactPrompt :=
            {
                model : objBeelzebot.modelName,
                messages : [new Message( "user", $"read the following message and only respond with the one emoji it makes you think of:"), new Message("user", _message, _messageData.author.username)], 
                stream : false
            }
            objBeelzebot.reactingID := _messageData.id;
            objBeelzebot.reactionHandler := http_post_string( "http://localhost:11434/api/chat?", json_stringify( _reactPrompt));
        }
        
        ///add this message to the short term memory
        var _memory := new ShortTermMemory( "user", _message, _messageData.author.id);
        
        ///add to long term memory, only for consenting users!
        if(array_contains( global.consent, _messageData.author.username))
        {
            array_push(global.longTermMemory, new LongTermMemory("user", _message, _messageData.author.username));
        }
        
        var _memoryPrompt :=
        {
            model : objBeelzebot.modelName,
            messages : [objBeelzebot.systemPrompt, global.memoryPrompt],
            stream : false
        }
        
        array_push(_memoryPrompt.messages, objBeelzebot.messages);
        
        array_push( objBeelzebot.messages, _memory);
        
        var _messageHistory := new Message("system", "here is what has been said in the conversation so far: ");
        
        ///COMMANDS
       if((string_count("beelzebot", string_lower(_message)) ||  string_count(beelzebotID, string_lower(_message))) && _messageData.author.id != beelzebotID)
       { 
            if(string_count( "!manual", _message))
            {
                global.bot.messageSend( activeChannel, objBeelzebot.rules.help);
                exit;
            }
            
            if(string_count( "!iconsent", _message))
            {
                if(!array_contains(global.consent, _messageData.author.username))
                {
                    global.bot.messageSend( activeChannel, $"Okay, I will remember your messages to me going forward, {_messageData.author.username}");
                    array_push( global.consent, _messageData.author.username);
                }
                else 
                {
                    global.bot.messageSend( activeChannel, $"**FOOLISH {_messageData.author.username}, YOU HAVE ALREASDY CONSENTED, MORTAL!**");
                }
                exit;
            }
            
            if(string_count( "!idonotconsent", _message))
            {
                global.bot.messageSend( activeChannel, $"Okay, I will purge you from my data banks, {_messageData.author.username}");
                var _arrayLength := array_length(global.consent);
                for ( var _i = 0; _i < _arrayLength; _i++) 
                {
                	if( global.consent[ _i] == _messageData.author.username)
                    {
                        array_delete( global.consent, _i, 1);
                        break;
                    }
                }
                
                _arrayLength := ( array_length( global.longTermMemory)-1);
                for ( var _i = _arrayLength; _i > 0; _i--) 
                {
                	if( global.longTermMemory[ _i][$ "name"] == _messageData.author.username)
                    {
                        array_delete( global.longTermMemory, _i, 1);
                    }
                }
                
                exit;
            }
        
            if(string_count( "!deleteme", _message))
            {
                global.bot.messageSend( activeChannel, $"Okay, {_messageData.author.username}, your old messages have been deleted, but new messages will still be stored in my data banks!");
                
                _arrayLength := ( array_length( global.longTermMemory)-1);
                for ( var _i = _arrayLength; _i > 0; _i--) 
                {
                	if( global.longTermMemory[ _i][$ "name"] == _messageData.author.username)
                    {
                        array_delete( global.longTermMemory, _i, 1);
                    }
                }
                
                exit;
            }
            
            ///Creator Commands
            if(string_count( "!goodnight", _message) && _messageData.author.id == creatorID)
            {
                global.bot.messageSend( activeChannel, "**GOODNIGHT, MORTALS**");
                saveMemories();
                game_end();
                exit;
            }
        
            if(string_count( "!forget", _message) && _messageData.author.id == creatorID)
            {
                global.bot.messageSend( activeChannel, choose("**I FORGOR**", "_**MEMEORY WIPED**_"));
                wipeMemories();
                exit;
            }
        
            if(string_count( "!shortwipe", _message) && _messageData.author.id == creatorID)
            {
                global.bot.messageSend( activeChannel, "*Short Term Memory erradicated, but long term memory intact, this may have little effect!*");
                objBeelzebot.messages := [];
                exit;
            }
        
            if(string_count( "!longwipe", _message) && _messageData.author.id == creatorID)
            {
                global.bot.messageSend( activeChannel, "*Long Term Memory erradicated, but short term memory intact, this may help with behavior problems!*");
                global.longTermMemory := [];
                exit;
            }
        
            if(string_count( "!status", _message) && _messageData.author.id == creatorID)
            {
                var _status := string_replace( _message, "!status", "");
                
                ///I tired using the correct discordActivity struct as well, but it also doesn't work!!!!
                var _activity := 
                {
                    name : _status,
                    type : int64(DISCORD_PRESENCE_ACTIVITY.custom),
                    emoji : "",
                    state : _status
                }//new discordPresenceActivity( _status, DISCORD_PRESENCE_ACTIVITY.custom)
                
                global.bot.presenceSend( _activity, "online");
                exit;
            }
       }
        ///check for mentions
        if(!is_undefined(_messageData[$ "mentions"]))
        {
            var _arrayLength := array_length(_messageData.mentions);
            for (var _i = 0; _i < _arrayLength; _i++)
            {
            	if( _messageData.mentions[ _i].id == beelzebotID)
                {
                    objBeelzebot.isMentioned := true;
                }
                else 
                {
                    continue;
                }
            }
        }
        
        if((string_count("beelzebot", string_lower(_message)) || string_count(beelzebotID, string_lower(_message)) || objBeelzebot.isMentioned) && _messageData.author.id != beelzebotID)
        {
           
                var _prompt :=
                {
                    model: objBeelzebot.modelName,
                    messages: [objBeelzebot.systemPrompt, _messageHistory],
                    stream: false
                }
                var _arrayLength := array_length(global.longTermMemory);
                for (var _i = 0; _i < _arrayLength; _i++) 
                {
                	array_push(_prompt.messages, global.longTermMemory[ _i]);
                }
                array_push(_prompt.messages, new Message("system", $"the following message is from {_messageData.author.username}, respond to this with context if you want to: "), _memory);
                
           
            
            
           objBeelzebot.query := http_post_string( "http://localhost:11434/api/chat?", json_stringify( _prompt));
           global.bot.triggerTypingIndicator(activeChannel);
           
        }
        
    }
    
}

