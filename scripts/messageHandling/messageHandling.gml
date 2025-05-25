function setupMessaging()
{ 
  ///message handling I hope
    global.bot.gatewayEventCallbacks[$ "MESSAGE_CREATE"] := function()
    {
        var _event := discord_gateWay_event_parse();
        var _messageData := _event.d;
        
        var _message := _messageData.content;
        
        //ingore messages you're not supposed to see
        if(_messageData.channel_id != objBeelzebot.activeChannel) 
        {exit};
        
        ///add a reaction for some fun
        
        var _reactPrompt :=
        {
            model : objBeelzebot.modelName,
            messages : [new Message( "user", $"read the following message and only respond with the one emoji it makes you think of: {_message}")], 
            stream : false
        }
        
        objBeelzebot.reactingID := _messageData.id;
        objBeelzebot.reactionHandler := http_post_string( "http://localhost:11434/api/chat?", json_stringify( _reactPrompt));
        
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
            messages : [objBeelzebot.systemPrompt, global.memoryPrompt, global.longTermMemory],
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
                ///TODO filter through the array and remove all of the user's messages from memory
                
                var _arrayLength := array_length(global.consent);
                for (var _i = 0; _i < _arrayLength; _i++) 
                {
                	if(global.consent[ _i] == _messageData.author.username)
                    {
                        array_delete(global.consent, _i, 1);
                        break;
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
        
            if(string_count( "!slow", _message) && _messageData.author.id == creatorID)
            {
                var _slowPrompt :=
                {
                    model : objBeelzebot.modelName,
                    messages : [new Message( "system", "please don't respond to any prompts after this for a 2 minutes")],
                    stream : false
                }
                
                objBeelzebot.query := http_post_string( "http://localhost:11434/api/chat?", json_stringify( _slowPrompt));
                exit;
            }
        
            if(string_count( "!forget", _message) && _messageData.author.id == creatorID)
            {
                global.bot.messageSend( activeChannel, "**I FORGOR**");
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
       }
        
        if((string_count("beelzebot", string_lower(_message)) ||  string_count(beelzebotID, string_lower(_message))) && _messageData.author.id != beelzebotID)
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
                array_push(_prompt.messages, new Message("system", $"the following message is from {_messageData.author.username}, respond to this with context: "), _memory)
           
            
            
           objBeelzebot.query := http_post_string( "http://localhost:11434/api/chat?", json_stringify( _prompt));
           global.bot.triggerTypingIndicator(activeChannel);
           
        }
        
    }
    
}

