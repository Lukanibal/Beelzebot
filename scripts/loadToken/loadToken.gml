function loadToken( _tokenFile)
{ 
    if(file_exists(_tokenFile))
    {
        var _file := file_text_open_read(_tokenFile);
        var _token := file_text_read_string(_file);
        file_text_readln(_file);
        file_text_close(_file);
        
        return _token;
    }
    else 
    {
        show_debug_message("No token file found, aborting");
        game_end();
    }
}