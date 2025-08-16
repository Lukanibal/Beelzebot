///keep his short term memory on the short side
if(array_length(messages) > 32)
{
    array_shift(messages);
}


///new long term memory limit
if(array_length(global.longTermMemory) > 128)
{
    array_shift(global.longTermMemory);
}