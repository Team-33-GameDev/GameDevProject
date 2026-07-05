## Transcript

**[00:00] Speaker 1:** Alright, recording.

**[00:03] Speaker 2:** So, we've discussed the further concept of the game and decided to develop this concept with more rooms, where each room serves a specific function. This week, we agreed to work on two rooms.

**[00:26] Speaker 2:** These are the factory room and the room with the big button. The factory room. Let me show you the animation now.

**[00:36] Speaker 3:** Okay, go ahead. Is that the one with the five buttons on the wall? Right? Yeah, there it is.

**[00:41] Speaker 2:** And David also made some cool animations there. He's handling all the models. See? Yeah. Anyway, here's a hand coming out of the wall, constantly pressing the button.

**[01:05] Speaker 2:** This is all moved to a separate room, and each one has this little display. You could see it in the screenshot. This display will show how much this hand generates and whether it's currently active. Because the hand can break. And I had another idea—it's pretty hard to tie into the animation, but to have neighboring hands occasionally play rock-paper-scissors.

**[01:36] Speaker 3:** Like, distracting each other. You can just add that as a flex feature later.

**[01:48] Speaker 2:** Anyway, you have to keep an eye on these hands all the time because they either break or get distracted by something else. So this is one of those processes that the player needs to constantly keep in the back of their mind. They'll have to physically run over to this room. It's something like berry buddies.

**[02:09] Speaker 2:** So, we buy them, upgrade them, and they bring us benefits. Next is the room with the big button. Here's what the room with the big button looks like. Exactly. The point is, there's a separate room, and in the center, there's a big button that you need to jump on to reduce your quota.

**[02:37] Speaker 2:** So, let's say you jump five times, play the button press animation, and your quota drops by a certain percentage. This way, the player should understand that if they can't meet the quota by clicking, but they can jump on the button and lower the quota, then they should do that instead.

**[03:11] Speaker 2:** Further on, we also want to make it so you can... Well, actually, this is still up for discussion. We initially thought it would just generate these clicks. But then we figured reducing the quota is more interesting. We could make it so that later you can automate it, and a big hand will extend from the ceiling.

**[03:35] Speaker 2:** Guys, here's a question, I'll throw it out right away.

**[03:36] Speaker 3:** Don't you want to... make a restart up to the last quota. Not a full reset right away, but just a reset to the last cycle.

**[03:57] Speaker 3:** To just tie everything to cycles and make a run. I mean, right now, I think you realize yourselves that to make everything work fully, you'd need to add roguelike elements, add elements of some kind of change. It's expensive, it's... Yeah, yeah.

**[04:15] Speaker 2:** So that's... We've only been working on the core mechanics so far. Probably next week we'll focus on making it look like a full-fledged game, so you can launch it, start it, and play through it, rather than just having a clicker demo, roughly speaking.

**[04:37] Speaker 3:** You'll get that anyway. You can just say that when a character dies, a new employee comes in, but essentially it's just a cycle change. Like, if we look at the same Barony Barbarian, one cycle just ends for you, you level up to the next quota, new things open up, for example, you have a new room.

**[05:00] Speaker 3:** And you go into a new cycle with a new employee if the previous one died. And you present it as if people are constantly dying in your system, and you have to keep it going, keep it going, keep it going. And Egor is simultaneously trying to figure out why he's even doing all this, what the code is for.

**[05:24] Speaker 2:** Yeah, right now, I hope the sound will be audible. Not sure how to set it up. Okay, it might not work. Anyway, I'll show you what we have... how the game looks right now.

**[05:48] Speaker 2:** This is the AI that forces us to work. I'll send you, Vlad, the video you sent. Well, yeah, yeah, yeah, I can just send it, but I'll show it right now. So, there are these eyes on the screen, and they tell us that we need to meet the quota, and this is now our job, a vital necessity.

**[06:13] Speaker 2:** If we don't meet the quotas, we'll just die. The game starts.

**[06:22] Speaker 1:** And if we don't meet the quota, we get transported to this creepy clinic.

**[06:36] Speaker 2:** Yeah, I want to make it so we can create several such events, so that this AI boss periodically addresses us, says something, and, you know, acts like the warden in Prison Architect, something like that.

**[06:55] Speaker 3:** No, that's cool. Great idea. For death, you could also implement it by adding smoke. What to do? For death, you could implement it with some gas appearing.

**[07:12] Speaker 2:** Oh, actually, yeah, yeah. Good. There.

**[07:16] Speaker 3:** Or an option where the floor breaks apart beneath you, and you fall down somewhere.

**[07:21] Speaker 2:** Well, listen, that kind of... I think that was in that other game, we decided not to copy that exactly.

**[07:28] Speaker 4:** Okay, yeah. I think it's cheaper if you just get shot, the screen flashes white, and the sound is the cheapest, in my opinion.

**[07:37] Speaker 5:** That exact sound... It's when you blind a cat with a white flash.

**[07:45] Speaker 2:** Yeah, yeah, yeah, something like that. Or, well, right now we just have this effect, like in Minecraft, where they just made a mod where when you die, and you don't have the respawn screen, you just instantly appear on the bed, something like that. So, a surprise effect.

**[08:06] Speaker 2:** There. Also, David suggested, we currently have this door here that leads to another room. Well, there's no room yet, but let's say it's the factory room. So we'll need to first complete some amount of code, do all our tasks, and then we can buy a crowbar.

**[08:27] Speaker 2:** Not the room itself, but the crowbar. And we'll break these boards and be able to move forward. So, we can do the same to open the next room. That's all regarding 3D models and everything else right now.

**[08:49] Speaker 2:** Yaroslav worked on the shop system. We haven't managed to synchronize everything yet, to integrate one system into another. We'll work on that today. But I think Yaroslav will talk about the shop system. Not the shop system, but the upgrade system.

**[09:21] Speaker 2:** Yaroslav, how are you?

**[09:23] Speaker 4:** I built it, so I'll tell you what's in there. I can even show it overall. I'll turn on the demo now. So, overall we have factories, and so far 5 types of upgrades.

**[09:54] Speaker 4:** Factories work on clicks, on ticks, meaning not once a period, well, not once a period, but at a specific tick. There are certain upgrades, an upgrade for HP amount, HP increases the click. Yeah, this is HP.

**[10:17] Speaker 4:** It increases it by one. There's damage, there's click. There's HP recovery, meaning the factory breaks. When it breaks, it won't transfer anything. It needs to be repaired. That works too.

**[10:39] Speaker 4:** And the amount of damage dealt... Okay, need to restart. Also, we implemented that we can't buy the next factories until we buy the previous ones. So I can't buy factory 2 or factory 1 before I buy factory 0. After I buy it, I can buy all this too.

**[11:03] Speaker 4:** And their info will be separate. There was also some refinement, so now they have a common timer, not a local one, which should increase performance many times over.

**[11:15] Speaker 3:** So, the upgrade system is currently more functional. Actually, it's not even functional. In the sense that will you upgrade the visual of the PGS? Because often, basically, you change parameters through buttons, and that's overly complex, overly boring for a clicker.

**[11:42] Speaker 3:** Well, if we leave it exactly like this.

**[11:45] Speaker 2:** So, we'll have a room with these... a room with factories. There will be a little display with some numbers, indicators, stats. And the hand itself will also change. So the first level is a wooden hand. Then there will be a copper hand.

**[12:06] Speaker 2:** Then an iron hand, a silver hand, a gold hand. And this way it will change visually, and it will tap the button faster.

**[12:20] Speaker 3:** Take the meta element from Baby Bash and make the player collect another resource so they can upgrade the factories. Oh, I see... Is that more interesting? Uh-huh. Well, you see, there were just stars there.

**[12:41] Speaker 3:** Yeah, in Baby Bash there was a star system. The reason it created interest was that you moved a scoop, collected elements, solved puzzles, got stars. You hid the stars for buddies, buddies leveled up. And it wasn't tied to just one upgrade element through coins. Think in that same direction so it doesn't overlap, so the progression feels stronger.

**[13:20] Speaker 2:** As for new features, Bogdan implemented the audio system. Now you can easily add sounds and music to the game. Well, that's what we managed to do this week.

**[13:45] Speaker 3:** Okay. Overall, yeah. Overall, everything is good. The question is, what do you plan to do next week, right now?

**[13:55] Speaker 2:** Finish implementing, improve, and polish everything we've done now, so it's cohesive, so you can comfortably play it and it's interesting. Do you want to make it before the session?

**[14:32] Speaker 3:** Well, in the sense of between sessions, when you die? I apologize, my network just dropped. The question is, how do you plan to do the screen progression? Oh, in terms of... Didn't get the question. Well, the crowbar, for example, buying new items, objects, getting them, where will they be?

**[14:58] Speaker 3:** Well, besides what was just said about the factory, I mean acquiring the most basic, the most key things.

**[15:07] Speaker 2:** We haven't fully worked out the idea of buying items yet, but we'll have purchasing in the phase when we're in the room and clicking, there's a vending machine, a little shop, standing there. And we'll also have some item purchasing in the death phase, when we end up in this black room.

**[15:28] Speaker 2:** Yaroslav and Bogdan had some good ideas there, I haven't fully grasped them yet. Maybe Yaroslav will tell us now.

**[15:37] Speaker 3:** I want to see them already next year. Hooray, I have sound, right?

**[15:43] Speaker 4:** I have sound, I can hear. Yeah, there's sound. We had an idea that there are some temporary upgrades you can buy. But the catch is they aren't open right away, but like in all good roguelikes, they unlock gradually. So you can buy them, and then on subsequent runs they'll be available to you.

**[16:08] Speaker 4:** For example, on this run you saved up, bought it, and now it will start appearing. We can do it that way. The temporary upgrade system is already ready via decorators. It can be implemented for both clickers and regular clicks.

**[16:26] Speaker 1:** This will be a system that will add gameplay.
