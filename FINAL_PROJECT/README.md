## FINAL ASSIGNMENT

### RATIONALE



### Arduino setup

- circuit scheme\
![](a1.png)

- the controller\
![](a2.png)


### Results

- Player, Meteorite (actually an energy sphere) and a black (actually a dark celadon) hole\
![](1.png)

- pressing the red button charges the engine (red line)\
![](2.png)

- releasing the button adds forward velocity proportional to the charge\
![](3.png)

- rotor input changes the direction. direction also changes upon collissions\
![](4.png)

- blue button shoots bullets\
![](5.png)

- unce the meteorite is removed the victory massage appears\
![](6.png)

- and onto the next stage!\
![](7.png)

- sometimes things go wrong\
![](8.png)

- few stages pass and suddenly the music changes\
![](9.png)

- a boss fight...\
![](10.png)

- ...continues\
![](11.png)


### VIDEO

(couldn't embed, for the video consult final.mp4 file. sorry for low quality, Github wouldn't allow allow upload without reduction.)


### CODE

For the code consult the code.pde file, because with documentation it is over 1000 lines.


### EXTERNAL SOURCES

  - The basis for the electric scheme for rotor input (for positive and negative voltage) was taken from StackExchange
    - source: https://electronics.stackexchange.com/questions/108320/read-positive-and-negative-voltage-in-arduino
    - the basic idea was modified and adjusted according to the aviable resources
  - All images are sourced from google images
    - Lego Star Wars Millenium Falcon model was used as the Player object texture. The choice was made due its roundish shape
    - common pngs were used for meteorite/bullet and black hole textures
    - png of Cromulon from Rick and Morty show was used for the Boss and BossBullet objects, as the author deemed its characteristics fitting for the overall feel of the game
  - Sounds were either composed, sourced from soundfile storage sites or converted from youtube
    - the main music was composed by author using MuseScore a longer while ago, independently of the project
    - Nightcore My Demons was used for boss music due its faster and more aggresive pace, converted from youtube
    - the laser sound effect was taken from Soundfishing website
    - the boss quotes played at start or conclusion of the boss stage were converted from youtube and are associated with the same show as the boss texture


### CHANGES SINCE MIDTERM

- Arduino controller was added
  - the basic controlls and gameplay were changed accrdingly
  - the old keyboard input was disabled, as it did no longer fit in the new rotatory controlls
  - tension, friction and maximum velocity coefficients were reviewed to adjust the gameplay to the new cntroller mode
- Arduino controller mode fixes
  - several changes and fixes were made to allow proceeding between screens (win -> next stage -> play; lose -> restart and play) using Arduino buttons
    - fixed issue when prolonged press of the button would cause to skip multiple screens (skipping from win to play without signaling next stage)
  - fixed issue with bullets by rewriting shoot() function in Player in terms of the place bullets were created
    - now utilises PVector more effectively
    - avoids situations when emerging bullet would instantly collide with the Player object causing it to bounce backwards
  - several minor fixes and adjustments
- rebalancing
  - the minimum size of generated pucks and holes was increased to avoid non-rewarding situations
  - several minor fixes, adjustments and code aesthetics
- music
  - both regular music and boss music are now called by loop() function, resolving the problem where the gameplay in given stage(s) would last longer then music time (~4mins)


### FURTHER DEVELOPMENT
- hybrid input
  - redefining new keyboard controlls to allow keyboard input for the new rotary mode
- restructurisation
  - as suggested in June 3 and midterm assignment submissions, embracing more suitable OOP patterns, such as decorator, will make the overall structure more flexible and allow for more efficient addition of the functionalities.
  - keeping the object functions, such as collission effects or movement capabilities independent rather then aggregated within given type will allow to create specific objects with desired functionality packages, going beyond the limits of Player-Puck-Hole-Bullet design.
  - This in turn would add more variety among the stages
- rebalancing
  - adding more variety to the bosses, such as player-directed movement or gravity-pull, could make the fights less repetetive and more challenging.
- bug fixes
  - the issue of self-fueling collisions occuring when object boundaries intersect in between frames was not fully resolved
    - although it appears somehow less frequent on the Arduino controller
    - the character of the player-computer comunication and thus overall way player approaches the game changes, accidentally involving less situations the glitch appears (?)
