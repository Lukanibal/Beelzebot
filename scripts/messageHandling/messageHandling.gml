function setupMessaging()
{///setup the gateway to handle incoming messages and commands
    global.bot.gatewayEventCallbacks[$ "MESSAGE_CREATE"] := function()
    {
        var _event := discord_gateWay_event_parse();
        var _messageData := _event.d;
        
		show_debug_message($"MESSAGE LOGGED: {_messageData.content}");
		
        var _message := _messageData.content;
        
        //ingore messages you're not supposed to see
        if( is_array(objBeelzebot.activeChannels) && !array_contains(objBeelzebot.activeChannels, _messageData.channel_id)) 
        {exit}
        else
        {
        	objBeelzebot.responseAreaID := _messageData.channel_id;
        }
        
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
            array_push(global.longTermMemory, new LongTermMemory("user", _message, nameGet(_messageData.author.username)));
        }
        
        var _memoryPrompt :=
        {
            model : objBeelzebot.modelName,
            messages : [objBeelzebot.systemPrompt, global.memoryPrompt],
            stream : false
        }
        
        array_push(_memoryPrompt.messages, objBeelzebot.messages);
        
        array_push( objBeelzebot.messages, _memory);
        
        var _messageHistory := new Message( "system", "here is what has been said in the conversation so far: ");
        
        ///COMMANDS
       if((string_count("beelzebot", string_lower(_message)) ||  string_count(beelzebotID, string_lower(_message))) && _messageData.author.id != beelzebotID)
       { 
            if(string_count( "!manual", _message))
            {
                global.bot.messageSend( objBeelzebot.responseAreaID, objBeelzebot.rules.help);
                exit;
            }
            
            if(string_count( "!iconsent", _message))
            {
                if(!array_contains(global.consent, _messageData.author.username))
                {
                    global.bot.messageSend( objBeelzebot.responseAreaID, $"Okay, I will remember your messages to me going forward, {nameGet(_messageData.author.username)}");
                    array_push( global.consent, _messageData.author.username);
                }
                else 
                {
                    global.bot.messageSend( objBeelzebot.responseAreaID, $"**FOOLISH {_messageData.author.username}, YOU HAVE ALREASDY CONSENTED, MORTAL!**");
                }
                exit;
            }
            
            if(string_count( "!idonotconsent", _message))
            {
                global.bot.messageSend( objBeelzebot.responseAreaID, $"Okay, I will purge you from my data banks, {nameGet(_messageData.author.username)}");
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
                
                if(array_contains( global.consent, _messageData.author.username))
                {
                    global.bot.messageSend( objBeelzebot.responseAreaID, $"Okay, {nameGet(_messageData.author.username)}, your old messages have been deleted, but new messages will still be stored in my data banks!");
                    
                    _arrayLength := ( array_length( global.longTermMemory)-1);
                    for ( var _i = _arrayLength; _i > 0; _i--) 
                    {
                    	if( global.longTermMemory[ _i][$ "name"] == _messageData.author.username)
                        {
                            array_delete( global.longTermMemory, _i, 1);
                        }
                    }
                }
                else 
                {
                    global.bot.messageSend( objBeelzebot.responseAreaID, $"{nameGet(_messageData.author.username)}, I am not storing your messages, I have no messages to delete.");
                }
                exit;
            }
        
            if(string_count( "!myname", _message))
            {
                
                /*
				var _name := string_replace_all( _message, "!myname", "");
                _name := string_replace_all( _name, "!myname ", "");
                _name := string_replace_all( _name, "beelzebot ", "");
                _name := string_replace_all( _name, "Beelzebot ", "");
                _name := string_replace_all( _name, $"<@{objBeelzebot.beelzebotID}> ", "");
                
                show_debug_message( $"NEW NICKNAME ASSOCIATION {_messageData.author.username} : {_name}")
                updateName( _messageData.author.username, _name);
                global.bot.messageSend( objBeelzebot.responseAreaID, $"_Name preference updated, thank you for letting me know, **{_name}!**_");
				*/
				global.bot.messageSend( objBeelzebot.responseAreaID, $"Naming Services are currently offline, in other words get fucked <3");
                exit;
            }
            
            ///Creator Commands
            if(string_count( "!goodnight", _message) && _messageData.author.id == creatorID)
            {
                global.bot.messageSend( objBeelzebot.responseAreaID, "**GOODNIGHT, MORTALS**");
                saveMemories();
                game_end();
                exit;
            }
        
            if(string_count( "!forget", _message) && _messageData.author.id == creatorID)
            {
                global.bot.messageSend( objBeelzebot.responseAreaID, choose("**I FORGOR**", "_**MEMEORY WIPED**_"));
                wipeMemories();
                exit;
            }
		
			if(string_count( "!imagetest", _message) && _messageData.author.id == creatorID)
            {
                global.bot.messageSend( objBeelzebot.responseAreaID, "testing image capabilities");
                imageTestFunc( objImageHandler.testImage);
				dumpImage( objImageHandler.testImage);
                exit;
            }
        
            if(string_count( "!rememberthat", _message) && _messageData.author.id == creatorID)
            {
                if(irandom(100) > 80)
				{ 
					global.bot.messageSend( objBeelzebot.responseAreaID, "https://c.tenor.com/NcnMXggTODAAAAAC/tenor.gif");
				}
				else
				{
					global.bot.messageSend( objBeelzebot.responseAreaID, "https://c.tenor.com/wiIC-0UE4pQAAAAd/tenor.gif");
				}
				
                
                array_push(global.permaMemory, array_shift(objBeelzebot.messages));
                
                exit;
            }
        
            if(string_count( "!shortwipe", _message) && _messageData.author.id == creatorID)
            {
                global.bot.messageSend( objBeelzebot.responseAreaID, "*Short Term Memory erradicated, but long term memory intact, this may have little effect!*");
                objBeelzebot.messages := [];
                exit;
            }
        
            if(string_count( "!longwipe", _message) && _messageData.author.id == creatorID)
            {
                global.bot.messageSend( objBeelzebot.responseAreaID, "*Long Term Memory erradicated, but short term memory intact, this may help with behavior problems!*");
                global.longTermMemory := [];
                exit;
            }
		
			if(string_count( "!fullwipe", _message) && _messageData.author.id == creatorID)
            {
                global.bot.messageSend( objBeelzebot.responseAreaID, "**HERBIE: FULLY WIPED!**");
				objBeelzebot.messages := [];
                global.longTermMemory := [];
                exit;
            }
		
			//stop with no saving
			if(string_count( "!stop", _message) && _messageData.author.id == creatorID)
            {
                global.bot.messageSend( objBeelzebot.responseAreaID, "**goodbye friends!**");
				game_end();
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
        
		
		///MESSAGES ARE HANDLED HERE GOD DAMN IT
        if((string_count("beelzebot", string_lower(_message)) || string_count(beelzebotID, string_lower(_message)) || objBeelzebot.isMentioned) && _messageData.author.id != beelzebotID)
        {
			
				///if there's an image in the message, hand this over to the vision model
				if(variable_struct_exists(_messageData, "attachments") && array_length(_messageData.attachments) > 0)
				{
					
					var _content_type := _messageData.attachments[0][$ "content_type"];
					
					if( string_count("image/png", _content_type) || string_count("image/jpg", _content_type) || string_count("image/jpeg", _content_type) || string_count("image/webm", _content_type) 
					|| string_count("image/gif", _content_type))
					{
						var _attachment := _messageData.attachments[0];
						var _content_type := _attachment[$ "content_type"];
						var _extension := ".png";
						
						switch(_content_type)
						{
							case "image/png":
							{
								break;
							}
								
							case "image/jpg":
							case "image/jpeg":
							{
								_extension := ".jpeg";
								break;
							}
								
							case "image/webm":
							{
								_extension := ".webm";
								break;
							}
								
							case "image/gif":
							{
								_extension := ".gif";
								break;
							}
						}
						
						objImageHandler.image_type := _extension;
						
						show_debug_message( "Image Processing Log: " + string(_attachment));
						
						objImageHandler.current_image := http_get_file(_attachment[$ "url"], $"images/image{_extension}");
						objImageHandler.message := _message;
					}
					
					
				}
				else 
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
				
					_arrayLength := array_length(global.permaMemory);
					for (var _i = 0; _i < _arrayLength; _i++) 
					{
						array_push(_prompt.messages, global.permaMemory[ _i]);
					}
				
					var _message_name := nameGet(_messageData.author.username);
					array_push(_prompt.messages, new Message("system", $"the following message is from {_message_name}, respond to this with context if you want to: "), _memory);
					
		           
		            
		            
		           objBeelzebot.query := http_post_string( "http://localhost:11434/api/chat?", json_stringify( _prompt));
		           global.bot.triggerTypingIndicator(objBeelzebot.responseAreaID);
				}
           
        }
        
    }
		
    global.bot.gatewayEventCallbacks[$ "THREAD_MEMBER_UPDATE"] := global.bot.gatewayEventCallbacks[$ "MESSAGE_CREATE"]; 
}

