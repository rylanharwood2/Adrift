# spaceShooterPewPew

##### Start date: Nov 1, 2024

### nov 1 
first player/shooting iteration  
### nov 4 
first enemy iteration
### nov 10 
enemy sprites exist, flying is smooth, preliminary background is in
### nov 11
wave spawner works! I need to add some variance to the enemy pathing. boost is in early development
### nov 28
basic design pieces are there, boss sprites are in, enemies display a flash shader when shot
### dec 9
pause menu and basic sounds

*2024*  
winter break  -> end of april  motivation is low oof  
*2025*  

### may 1 -> may 24  
enemy spawn waves are working, improved music, lots of bug fixing, beginning to reorganise scripts.  
trying to be mostly done with core features by graduation    lmao 6/4/25
### may 4 
health packs work - I am making progress w signals
### may 5 
capos bullets work properly for now, can also be spawned like the suicunes in code. figured out classes + extending

### may  -> june 23 
##### forgot to update there for a while, lots of progress
lots of system organisation, bullets are separate now via classes (capo bullet, player bullet, exploding bullet?, etc)  
boss is officially in game w a spin attack, his name is Helheim, he doesn't do much  
capo death animation + new laser bullet almost plays animation properly  
bugfix: enemies can hit you multiple times while attached  

holy crap! we're on the internet, check out pumpkin-gaming.com(edit: pumpkingames.net) for a live version  
online mobile controls partially integrated  

### july
tyler got the boss updated!  
he now does the turn and launch, he does not yet spin when he gets to you  
very bull fighting y  

### july 31
went on a backpacking trip - check out our post!  
discussed names for the game including Adrift and Gates of Helheim  
just got the forcefield working visually, still have to make it push enemies back  

### aug 2
began work on highscore menu and in game time  
looking into storing leaderboard info in a file kept between runs locally  

### sep 23
changed project name to Adrift  
looked into using Atono for project management  

### oct 1
seperated bullet classes better  
found several bugs with capos being connected to each other (flash shader going off in unison etc)

### oct 2
main menu is in yay  
implemented a state machine (pause menu, playing, or main menu) to handle race conditions and keep codebase more organized

### oct 17
motivation is at nearly an all time high  

 *Spaget*  
proxy mine is nearly done, current trying to call on the physics engine to see whos in the blast radius (also uses a state machine!)  
transitioned to using a signal bus as a central point to connect signals to and from, it vastly cleaned up my code and I feel like  
im making cracks in the spaghetti code  
also transitioning from the old wave spawner to a new one based in a JSON format that I can change easily and is also easier to read  

 *Style / Fun*  
Thinking about reworking the enemies AI, tyler suggested a state machine based behavior system where they could either move towards  
the player, run away, find cover?, play from range, etc  just brainstorming for now but I do feel the enemies are a tad boring  
we are going to need to spice them up a bit and figure out how to make the weapons and tools I want to give to the player seem   
necassary and fun to use rather than just wiping through entire suicune populations  

 *Jira*  
we started using Jira for project managment, Atono wasn't really what I was looking for, Jira is a little complicated but I am enjoying  
it much more than a giant bullet point google doc so thats fun, I have set up a giant list of most of the things I still want to implement  
incl subtasks for many of them and jobs for art team  
we got in a discord call for a few hours and ironed out some of the remaining features, thinking about what powerups would be cool,  
working list is : forcefield, proxy mine (both already partially in), tbd on rocket launcher (homing missiles?), piercing laser / railgun,   
movement ability (ghost or something else tbd), spreader (contra style) / shotgun  
honestly should kinda rework the main gun  

 *Having Fun :)*  
im watching a lot of godot and gamedev tutorials, I cannot overstate how high motivation is rn, I would love to do a gamejam in 2026,  
also want to start a youtube channel, I dont know if this could be a sustainable form of income but it would be a dream come true  
