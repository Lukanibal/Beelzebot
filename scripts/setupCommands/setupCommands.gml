function setupCommands()
{ 

    // Create a simple slash command where the user types /ping
    var _guildId = "1374933575131992186";
    var _testGuildCommand = new discordGuildCommand("speak", "Make Beelzebot say something", DISCORD_COMMAND_TYPE.chatInput );
    
    var _callback = function() 
    {
        var _prompt :=
        {
            model: "llama3.2",
            prompt: "say something insane"
        }
        show_debug_message("making him speak")
        objBeelzebot.query := http_post_string( "http://localhost:11434/api/generate?", json_stringify(_prompt));
    }
    
    global.bot.guildCommandCreate(_guildId, _testGuildCommand);
}