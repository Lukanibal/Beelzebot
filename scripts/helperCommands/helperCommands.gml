function loadToken( _tokenFile)
{
    if(file_exists( _tokenFile))
    {
        var  _file := file_text_open_read( _tokenFile);
        objBeelzebot.bottoken := file_text_read_string( _file);
        file_text_readln( _file);
        objBeelzebot.testServerID :=  file_text_read_string(_file);
        file_text_readln( _file);
        objBeelzebot.testChannelID :=  file_text_read_string(_file);
        file_text_readln( _file);
        objBeelzebot.productionServerID :=  file_text_read_string(_file);
        file_text_readln( _file);
        objBeelzebot.productionChannelID :=  file_text_read_string(_file);
        file_text_readln( _file);
        
        file_text_close( _file);
        global.bot := new discordBot( objBeelzebot.bottoken, objBeelzebot.productionServerID, true);
    }
    else 
    {
        show_debug_message("Not token file, aborting");
        game_end();
    }
}

function ShortTermMemory( _role, _content, _name = "") constructor 
{
    role := _role;
    content := _content;
    if(_name != "") 
    {
        name := _name;
    }
}

function Message( _role, _content, _name = "") constructor 
{
    role := _role;
    content := _content;
    if(_name != "") 
    {
        name := _name;
    }
}