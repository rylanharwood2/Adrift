# Adrift
Formally spaceShooterPewPew
## Cast and Crew  
Rylan   : Hey thats me :)  
Tyler   : The other developer that hangs around these parts  
Addison : Team lead of the Art Team  
Aidan   : Sole member of the Audio Team  

##### Start Date: Nov 1, 2024  

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
enemy spawn waves are working, Aidan created our main music track, lots of bug fixing, beginning to reorganise scripts.  
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
Tyler updated the boss!  
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
separated bullet classes better  
found several bugs with capos being connected to each other (flash shader going off in unison etc)

### oct 2
main menu is in yay  
implemented a state machine (pause menu, playing, or main menu) to handle race conditions and keep codebase more organized

### oct 17
motivation is at nearly an all time high  

 *Spaget*  
proxy mine is nearly done, currently trying to call on the physics engine to see who's in the blast radius (also uses a state machine!)  
transitioned to using a signal bus as a central point to connect signals to and from, it vastly cleaned up my code and I feel like  
I'm making cracks in the spaghetti code  
also transitioning from the old wave spawner to a new one based in a JSON format that I can change easily and is also easier to read  

 *Style / Fun*  
Thinking about reworking the enemies AI, Tyler suggested a state machine based behavior system where they could either move towards  
the player, run away, find cover?, play from range, etc  just brainstorming for now but I do feel the enemies are a tad boring  
we are going to need to spice them up a bit and figure out how to make the weapons and tools I want to give to the player seem   
necessary and fun to use rather than just wiping through entire suicune populations  

 *Jira*  
we started using Jira for project management, Atono wasn't really what I was looking for, Jira is a little complicated but I am enjoying  
it much more than a giant bullet point google doc so thats fun, I have set up a giant list of most of the things I still want to implement  
incl subtasks for many of them and jobs for art team  
we got in a discord call for a few hours and ironed out some of the remaining features, thinking about what powerups would be cool,  
working list is : forcefield, proxy mine (both already partially in), tbd on rocket launcher (homing missiles?), piercing laser / railgun,   
movement ability (ghost or something else tbd), spreader (contra style) / shotgun  
honestly should kinda rework the main gun  

 *Having Fun :)*  
im watching a lot of godot and gamedev tutorials, I cannot overstate how high motivation is rn, I would love to do a gamejam in 2026,  
also want to start a youtube channel, I don't know if this could be a sustainable form of income but it would be a dream come true  

### oct 20
*Creature Base Class*  
Enemies and the Player are now in a larger Creature class that holds methods like flash() and play_death(), this was because I realized  
I found a bug in the forcefield logic and decided to just finally fix the damage logic for all of my entities. There are still some  
kinks, I need to figure out how to have the capos collision damage work properly but it works correctly for the suicunes.  

*Collision Damage System*  
I fully revamped the on-contact damage system, its a work in progress but the new system has enemies detect the player and call its adjust_health()  
method inherited from the Creature class. This shift from the player detecting enemy collisions has smoothed some issues I was having with  
the player being overly complicated and the enemies kind of just walking towards it. Additionally, it meant that I had to directly go edit  
the enemies health values when creating the proxy mine which I felt a little weird about. Now the proxy mine can use a public facing setter.  

*Proxy Mine*  
That segways us nicely into the finished proxy mine! It's not actually quite finished but once we get a new sprite and an explosion animation  
it will be very close. In debugging, I was using a red circle to signify where the proxy mines "damage" field could see. I made it just a  
ring (not filled in) and now it looks good enough to leave for now as a signifier of how far away you should be. I plan on updating this to a  
radar-like ping animation.  

*Health Packs*
In the process of creating the signal bus and changing the way we are using signals, healthpacks broke. I have now fixed them and updated them
to use the new health updating system for our player.

### oct 23  
*Enemy AI*  
Alright this is a big one! Personally, I think the root goal of games should be being fun, and right now, this game is not. Sooooo, Tyler got  
on a call with me today and we started to overhaul the enemy ai behaviors. A lot of my progress has been focused on making controlling the  
player more enjoyable while the enemies remained stagnant. But we are moving in a straight line no longer, we built out a state machine that  
contained all of the different things the enemies could do (attack, move towards the player, dash, retreat, etc etc) and built out the unique  
behavior for each for the suicunes specifically. Going forwards the capos will also use this system but at the moment melee enemy patterns are  
easier to get started with.  
Every few seconds each enemy will choose a new random action to use. I'm hoping this will solve a few of the main issues I was having with the  
combat; the enemies group up too tightly, they all get in sync, and their behavior is boring and predictable. Right now, we are using a circle  
around the player to have the enemies pathfind to until they get within range to go for the attack, this already helps with the grouping. We also  
created a dash so they don't all move identically and sync up. And lastly, we built a retreat behavior that has them run away at times, including  
when a mine goes off near them.  
I haven't started the system to dynamically change states yet to pick new actions but maybe tomorrow :) I'm also going to have to figure out how  
to fit the capos slightly different playstyle into this system I've built, but already the gameplay is feeling a lot more dynamic.  

*Visual Tweaks*  
Ok, these are just small things but I added screen shake that I plan on connecting in differing strengths when a mine goes off, when the player  
is hurt, or when the boss does things.  
I also turned off the forcefield rotating while the player is rotating, I think it looks a little better than the pixels rotating with the player,  
and I'm somewhat trying to avoid pixel rotations where it makes sense.  
Lastly, just a small visual improvement, the asteroids spawn their drops while they're still breaking so they don't just look like they appear  
at the end of the animation. This works great for the healthpacks from gray asteroids, and almost works for the ice powerup, I'll fix that bug  
tomorrow.  

### oct 27  
*Item Philosophy*  
Famous last words but I came back last friday (its secretly 11/3 rn) and redesigned my reward system on a call with Tyler to the following:  
I plan on having hotkey bound items, currently the forcefield, the proxy mine, and the ice powerup?. Those will all be attained incrementally,  
through the wave end reward system I'll discuss below. The second half of the system will be weapons. These will be attained by shooting  
asteroids as they fly across the screen. This would allow for each run to feel unique. I also plan on using a durability system, this  
would force the use of the base gun which would get quickly ignored if the weapons were on a hotkey for example. I currently imagine having  
a homing missile type weapon, a chargeable railgun, a shotgun or spreader type weapon, and perhaps something that shoots very quickly?  
In any case, the system still needs some finalization and scope permitting, a rarity system giving each individual gun randomized stats or  
something. My goal is to make getting new weapons and fighting off waves with the different equipment you get each new playthrough to be fun  
and rewarding.

*Wave End Reward System*  
On a wave end I created a pop up menu that you can choose an upgrade from. Currently there are two working reward options as a template. You can  
increase your max health (by 2), though there is currently no way of seeing this value increase in game. Alternatively, you can gain a new ability,  
I set that to the proxy mine which is now locked until you get that upgrade, in the future I need a more modular system for setting flags to access  
those types of hotkey bound abilities. I plan on also implementing a system to upgrade abilities through this reward system, for example increasing  
the forcefield active time, or lowering a cooldown. The details are not finalized, nor is the system's existence a guarantee.

Also the upgrade's screen is very ugly.  

### nov 7
*Updated to Godot 4.5.x*
Yeah that's all actually. Not a ton of impactful changes for us on that end.  

*Cooldown Animations*  
I added some placeholder icons and used a progress bar / animation player combo to create a grayed out icon that becomes normal as the cooldown ticks  
down. Hopefully putting some pressure on the art team, the icons suck haha.  

*Item Philosophy pt 2*  
I started the new powerup and weapon system. There is a new clean way to enable powerups as you unlock them, and it is attached to the wave end reward  
screen. I also created some of the weapon system, the base Weapon class and WeaponData resource are in place. Currently in the process of shifting the  
ice powerup logic to apply to generating a random weapon.

Addison made an early railgun animation that I'll look at after the weekend.

### nov 25
*Leaderboard*  
We found a free leaderboard database (simpleboards.dev) created by a team of indie devs for indie devs, for the current amount of traffic we expect to  
receive, this solution seems fine for now. After a lot of troubleshooting the leaderboard is currently live on the site. Whenever the player finishes  
a run I first send a Javascript function to be run in their browser, it creates a unique code that I store in their browser's localstorage. If this value  
already exists I compare their best time and find the better, otherwise we skip to the next steps: I make an API call to get the leaderboard entries,  
I check through the list and find a matching id. If it exists we do the time comparison and if better, we get a name from the player and enter the new  
time and name into the leaderboard, the id allows us to update their times without clogging the leaderboard with the single best player.  

One other important thing, currently, the leaderboard system is built for the website release due to the javascript injection. If you play in the editor  
or in a pc export you don't create an id but still submit a score. In the future I may come up with a solution without jamming the scores together but  
at the moment most people play online so it's not a huge problem yet.  

*The Heap & Homing Missiles*  
I began by creating a homing missile following a tutorial by kidscancode.org. Instead of choosing an enemy at random like suggested, I instead created  
a min-heap that tracks each enemy as they enter the scene tree, and purges them when they are killed in game. I store their distance to the player with  
their reference. I update the heap every 1/10 of a second so I am able to just look at the top value of the heap to find the closest enemy to the player  
and set that as the target for the missile. This heap implementation is partially a template that I plan on using elsewhere in the project but for the  
time being it works 90% of the time. Sometimes, it tries to access an enemies position from the heap after it has been freed in game. This causes a full  
crash, I was going to add guard cases to avoid this but I am going to try to find the problem first and hopefully avoid it entirely. As I am writing  
this I am considering creating a filtering system instead that removes dead nodes instead of removing them when an enemy dies, I would only resort to  
that because I am worried the problem stems from the order things fire in the signal order. The missile may try to find a target before the heap has  
had time to reorder itself but after the enemy has been removed from the scene tree.  

*Project Reorganization YAY*  
This one's really exciting. I finally went through and reorganized the entire file system in a function-first hierarchy. This means no more scenes folder  
and scripts folder. We have organized into data, plugins, assets, game, and so on down the tree. This means you can find everything related to the player  
in the player folder. In the future I plan on including the assets in these folders but for right now the are still in a seperate side of the tree.  
I also heard someone say that forming your file system like this makes it very portable or modular, a folder like asteroids can do all of the work for  
itself, from spawning, to containing it's own assets, to handling it's drops and so on. I haven't gotten it fully figured out but it's a step in the  
right direction.

*Victory Screen Flow Debacle*  
This is more of a story than an update but getting the leaderboard and end of run flow was something of a hassle. After several iterations, don't write
big ideas tired, I figured out how my flow was actually going to function. At the end of the final wave, game sends a signal that tells my victory screen  
ui that the game is over. It emits a signal asking for verification of the players run, Leaderboard hears that and calls simpleboards. Leaderboard then  
compares the current run time (received from the HUD_timer_ui) with any run in the leaderboard the player has already submitted. Leaderboard then sends  
a response back to the victory screen as a boolean denoting whether the run was a personal best. If it was victory screen displays an input field to  
enter a name for the entry. That name is sent back to Leaderboard who submits the new time with the name and the players id that it's getting from the  
browser while the player is entering their name. Next I just need to clean up that victory screen ui, and add a button that links back to the leaderboard.  

The leaderboard is currently visible from a button in the main menu. Easy peasy :)

*The game isn't fun*  
Alright, this is the big one. I play this game quite a bit, and I have a problem. It's kind of twofold. The buttons aren't fun to press. That kind of  
speaks to all of them but specifically, the powerups (forcefield, proxy mine, and the ice powerup) all are rather unsatisfying to push, and the reward  
isn't high enough to validate that. Part B is that the game is wayy to hard. Everyone who play tests it has a hard time making it very far, especially  
once the capos come out. I had been feeling some dread over these two facts for some time now but I was continuing to push on thinking if I just added  
more features the game would magically become more interesting but the flow just wasn't firing for me. In the end the last straw was when Tyler released  
his game Die by Dice on our website and our circle of friends latched onto it immediately. I realized something must be actually wrong with my play  
experience.  

One call with Addison later, we have diagnosed the problems and created some steps to solve them. First and foremost, I did a quick numbers only balance  
pass to slow down the suicunes, make the capos a little less tanky and shoot slower, and speed the players turn up a little. Hopefully, that will solve  
part of the difficulty issues for now. We are also adding some arrows on the edge of the screen that point to where the enemies are off screen, this is  
in an effort to help allieviate the feeling of getting sniped by a capo off screen or to keep track of the hordes of suicunes. Unfortunately, the biggest  
change I knew I had to make is yet to come. After all my brainstorming a few weeks ago, I ended up doing the powerup and weapon system backwards. The  
powerups certainly need to come out of the asteroids, and the weapons need to be on the hotkeys and be attained by completing waves in the reward screen,  
or perhaps even gained automatically every x levels. This allows the powerups to not need to feel as impactful, my plan is for the ice powerup to activate  
instantly on hitting the pickup, the forcefield to apply to the next instance of damage you take or maybe just activate for the next 5 seconds or something.  
Lastly, in the spirit of making the powerups non-button activated, I think the mine will just drop from the asteroid and activate in place automatically.  

The weapons, whether attained through the wave end reward screen or at set intervals, can still have random attributes. Higher attack speed, higher damage,  
or a bigger hitbox, perhaps gained in upgrades in that reward screen. That might never see the light of day to be honest. Regardless, this is going to be at  
least a couple weeks of work for both myself and Addison to redesign several icons and animations. However, I hope it will significantly improve the game's  
feel when playing and make pushing buttons feel rewarding and shooting asteroids feel less necessary and more of a bonus for skilled play.

Anyway it's all speculative, I'll see you sometime in December!
