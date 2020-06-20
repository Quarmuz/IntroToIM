The idea is to expand on the midterm project, adding Arduino controller, overhauling some gameplay features, and possibly do some bug fixes and game expansion. It would allow to deliver an elaborated working project based on Arduino – computer communication.

Points to consider:
- Arduino controller will have two buttons and one motor-sensor (steering wheel)
	- the sensor will be used to rotate the ship
	- one button will be used to add velocity in the direction of motion
	- the other button will be used to fire a bullet
- Player object will need to be overhauled
	- make rotation independent on movement
	- enable Arduino controller inputs
	- no need for aggregating object
