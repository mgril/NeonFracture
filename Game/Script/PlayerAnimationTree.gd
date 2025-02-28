extends AnimationTree

enum {
	Normal, 
	Airborne, 
	Dead
}

var state

func changeStateToAirBorne():
	if state != Dead:
		state = Airborne
	
func changeStateToNormal():
	if state != Dead:
		state = Normal

func checkIfStateIsAirborne(): 
	return state == Airborne
	
func changeStateToDead():
	state = Dead
