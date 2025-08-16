Beelzebot is powered by the GM Discord extension made by Ches Rowe here: https://github.com/chesrowe/GMDiscord  
He's also powered by llama3.1:8b via ollama running on a local machine, more on that here: https://github.com/ollama  

He's currently able to:  
-Send insane messages to chat  
-React to messages with the best emotes  
-Remember messages and users  

Beelzebot has a few user commands, and several admin commands for managing his behaviour,  
Each command must also be in a message containing a ping to the bot or his name, Beelzebot:  
`!iconsent` will authorize him to remember your messages between runs.  
`!idonotconsent` or his name Beelzebot, will revoke that consent.  
`!deleteme` will delete all of your messages from his long term memory, but they may stay in short term memory.   

Admin Commands are as follows:  
`!forget` will erase his long and short term memories from ram, but not from disk in the case of long term memory.  
`!shortwipe` will clear his short term memory.  
`!longwipe` will clear his long term memory from ram, but not from disk.  
`!goodnight` will save his memories to disk and shut his processes down.  

Commands will not erase the file on disk, as Beelzebot will overwrite the file every minute or so anyway when he saves long term memory to disk.
