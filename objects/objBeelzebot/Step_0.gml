///keep his short term memory on the short side
if(array_length(messages) > 32)
{
    array_shift(messages);
}