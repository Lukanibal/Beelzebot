///This is where I will desperately try to have some semblance of long term personalized memory

///long term memory is never truncated, so GM will crash before he runs out of memory
global.longTermMemory := [];
global.memoryPrompt := {};
global.users := {};

function LongTermMemory( _role, _content, _name) constructor 
{
    role := _role;
    content := _content;
    //unlike short term, long term memories require a name association, for now I'll just use usernames, and possibly add the user ID later
    name := _name;
}

global.consent := [];

function fetchConsents()
{
    if( file_exists( "memory.consent"))
    {
        var _file := file_text_open_read( "memory.consent");
        var _json := "";
        
        while(!file_text_eof( _file))
        {
            _json += file_text_read_string( _file);
            file_text_readln( _file);
        }
        
        file_text_close( _file);
        global.consent := json_parse( _json);
        ///create the new user specific memory manager
        ///TODO - finish iomplementing this new memory management system, it will hopefully reduce the memory strain on the LLM
        array_foreach(global.consent, function(_element, _index)
        {
            global.users[$ _element] := [];
        });
    }
    else 
    {
    	show_debug_message( "Memory Consent file not found, only using short term memory!!!");
    }
};
fetchConsents();

function loadMemories()
{
    if( file_exists( "memories.file"))
    {
        var _file := file_text_open_read( "memories.file");
        var _json := "";
        
        while(!file_text_eof( _file))
        {
            _json += file_text_read_string( _file);
            file_text_readln( _file);
        }
        
        file_text_close( _file);
        
        show_debug_message( $"memory stream: {_json}");
        global.longTermMemory := json_parse( _json);
        global.memoryPrompt := new Message( "system", $"The following messages are your long term memories from all previous conversations: {global.longTermMemory}");
          
    }
    else 
    {
    	show_debug_message( "No memories found, make some!");
    }
};

function saveMemories()
{
    var _file := file_text_open_write( "memories.file");
    file_text_write_string( _file, json_stringify(global.longTermMemory));
    file_text_writeln( _file);
    file_text_close( _file);
    
    _file := file_text_open_write( "memory.consent");
    file_text_write_string( _file, json_stringify(global.consent));
    file_text_writeln( _file);
    file_text_close( _file);
    
    
    
    ///make sure it gets called again
    call_later( 60, time_source_units_seconds, saveMemories);
};

function wipeMemories()
{
    global.longTermMemory := [];
    objBeelzebot.messages := [];
}

///SHORT TERM STUFF BELOW
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

