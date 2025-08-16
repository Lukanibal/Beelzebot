///This is where I will desperately try to have some semblance of long term personalized memory

///long term memory is never truncated, so GM will crash before he runs out of memory
//False, long term memory is now 128 memories long, the boy breaks otherwise
global.longTermMemory := [];
global.memoryPrompt := {};
global.users := {};

global.permaMemory := [];///these are controlled entirely by me, and can be accessed at will, should try to not have too many of them though


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
        ///TODO - finish implementing this new memory management system, it will hopefully reduce the memory strain on the LLM
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
    
    ///TODO for each user, load their data into the GM side of memory, only feed to trhe LLM when required
    
    array_foreach( global.consent, function( _element, _index)
    {
        if(file_exists( $"{_element}.json"))
        {
            global.users[$ _element] := {};
            global.users[$ _element][$ "data"] := json_parse( fileRead( $"{_element}.json"));
        }
        else 
        {
            global.users[$ _element] := {};
            global.users[$ _element][$ "data"] := {};
        }
        
    });
    
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
    
    array_foreach( global.consent, function( _element, _index)
    {
        var _file := file_text_open_write( $"{_element}.json");
        file_text_write_string( _file, json_stringify( global.users[$ _element]));
        file_text_writeln( _file);
        file_text_close( _file);
    });
   
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

function updateName( _user, _newName)
{
    //global.users[$ _user][$ "nickname"] := _newName;
    struct_set( global.users[$ _user], "nickname", _newName);
}

function nameGet( _user)
{
    if(variable_struct_exists(global.users, _user) && variable_struct_exists(global.users[$ _user], "nickname"))
    {
        return global.users[$ _user][$ "nickname"];
    }
    else 
    {
    	return _user;
    }
}








