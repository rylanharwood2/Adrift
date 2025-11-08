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

### oct 20
*Creature Base Class*  
Enemies and the Player are now in a larger Creature class that holds methods like flash() and play_death(), this was because I realized  
I found a bug in the forcefield logic and decided to just finally fix the damage logic for all of my entities. There are still some  
kinks, I need to figure out how to have the capos collision damage work properly but it works correctly for the suicunes.  

*Collision Damage System*  
I fully revamped the on-contact damage system, its a work in progress but the new system has enemies detect the player and call its adjust_health()  
method inheritied from the Creature class. This shift from the player detecting enemy collisions has smoothed some issues I was having with  
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
player more enjoyable while the enemies remained stagnent. But we are moving in a straight line no longer, we built out a state machine that  
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
asteroids as they fly accross the screen. This would allow for the each run to feel unique. I also plan on using a durability system, this  
would force the use of the base gun which would get quickly ignored if the weapons were on a hotkey for example. I currently imagine having  
a homing missile type weapon, a chargable railgun, a shotgun or spreader type weapon, and perhaps something that shoots very quickly?  
In any case, the system still needs some finalization and scope permitting, a rarity system giving each individual gun randomized stats or  
something. My goal is to make getting new weapons and fighting off waves with the different equipment you get each new playthrough to be fun  
and rewarding.

*Wave End Reward System*  
On a wave end I created a pop up menu that you can choose an upgrade from. Currently there are two working reward options as a template. You can  
increase your max health (by 2), though there is currently no way of seeing this value increase in game. Alternatively, you can gain a new ability,  
I set that to the proxy mine which is now locked until you get that upgrade, in the future I need a more modular system for setting flags to access  
those types of hotkey bound abilities. I plan on also implementing a system to upgrade abilities through this reward system, for example increasing  
the forcefield active time, or lowering a cooldown. The details are not finalized, nor is the systems existance a guarentee.

Also the upgrades screen is very ugly.  

### nov 7
*Updated to Godot 4.5.x*
Yeah that's all actually. Not a ton of impactful changes for us on that end.  

*Cooldown Animations*  
I added some placeholder icons and used a progress bar / animation player combo to create a grayed out icon that becomes normal as the cooldown ticks  
down. Hopfully putting some pressure on the art team, the icons suck haha.  

*Item Philosophy pt 2*  
I started the new powerup and weapon system. There is a new clean way to enable powerups as you unlock them, and it is attached to the wave end reward  
screen. I also created some of the weapon system, the base Weapon class and WeaponData resource are in place. Currently in the process of shifting the  
ice powerup logic to apply to generating a random weapon.

Addison made an early railgun animation that I'll look at after the weekend.
