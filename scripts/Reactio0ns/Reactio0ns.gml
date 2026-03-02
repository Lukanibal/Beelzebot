///REACTIONS
function React( _message_data)
{
	var _reactPrompt :=
	{
		model : objBeelzebot.modelName,
		messages : [new Message( "user", $"respond with a comma sperated string of the first 1 to 6 unicode emojis this message makes you think of, no duplicates, please place a \\ before each \" in the string, just the emojis in a csv string:"), new Message("user", _message_data.content, _message_data.author.username)], 
		stream : false
	}
	
	var _rd := new reactionData( _message_data.id, _message_data.channel_id);
	array_push(objBeelzebot.reactingID, _rd);

	objBeelzebot.reactionHandler := http_post_string( "http://localhost:11434/api/chat?", json_stringify( _reactPrompt));
}

function reactionQueue( _reactions, _message_data) constructor 
{
	reactions := _reactions;
	message_data := _message_data;
	
	static send := function()
	{
		repeat(array_length(self.reactions) - 1)
		{
			call_later(10, time_source_units_frames, function()
			{
				global.bot.messageReactionCreate( self.message_data.channel_id, self.message_data.id, array_shift(self.reactions));
			});
		}
	}
	
}

function reactionData( _messageID, _channelID) constructor
{
	id := _messageID;
	channel_id := _channelID;
}

//TODO fix the reaction handlers