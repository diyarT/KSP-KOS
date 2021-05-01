CLEARSCREEN.
DELETEPATH("acceleration.txt").
DELETEPATH("time.txt").
DELETEPATH("completetime.txt").
LIST ENGINES IN myVariable.
set getAvailableThrust to 6.
set currentThrust to 0.
set startAcceleration to 0.
set turnOffEngines to AG1.
set turnOnCenterEngine to AG2.
set times to list().
set accelerations to list().
set mass to SHIP:MASS.
set radius to (5/2).

FOR eng IN myVariable {
    if eng:IGNITION {
        eng:Shutdown.
        set AG2 to false.
    }
}.

toggle AG2.

set thrusttime to Time:SECONDS.
LOCK THROTTLE TO 1.0.
until currentThrust >= (getAvailableThrust-5) {
    set getAvailableThrust to 0.
    set currentThrust to 0.

    FOR eng IN myVariable {
        if eng:IGNITION {
            set getAvailableThrust to getAvailableThrust + eng:AVAILABLETHRUSTAT(KERBIN:ATM:ALTITUDEPRESSURE(SHIP:ALTITUDE)).
        }
    }.
    FOR eng IN myVariable {
        set currentThrust to currentThrust + eng:THRUST.
    }.
    print getAvailableThrust at (0,1).
    print currentThrust at (0,2).

    times:ADD(Time:SECONDS- thrusttime).
    accelerations:ADD(currentThrust/mass).

}
set startAcceleration to (getAvailableThrust/mass).

log Time:SECONDS- thrusttime to completeTime.txt.
for time in times{log time to time.txt.}
for acceleration in accelerations{ log acceleration to acceleration.txt.}

LOCK THROTTLE TO 0.0.
UNLOCK STEERING.
UNLOCK THROTTLE.
toggle AG1.
wait 5.
SET calculation TO OPEN("calculation.txt"):READALL:STRING:tonumber().
print "calculation: "+ calculation at (0,3).


print "start".
wait 30.
print "ready".
wait until  ALT:RADAR <3000.
SAS OFF.
BRAKES ON.
toggle AG1.
until ALT:RADAR < 50 {
    set getAvailableThrust to 0.
    FOR eng IN myVariable {
        if eng:IGNITION {
            set getAvailableThrust to getAvailableThrust + eng:AVAILABLETHRUSTAT(KERBIN:ATM:ALTITUDEPRESSURE(SHIP:ALTITUDE)).
        }
    }.
    set currentThrust to 0.
    FOR eng IN myVariable {
        if eng:IGNITION {
            set currentThrust to currentThrust+ eng:THRUST.
        }
    }.
    set speed to SHIP:VELOCITY:SURFACE:MAG.
    set altitude to ALT:RADAR.
    set thrust to getAvailableThrust.
    set mass to SHIP:MASS.
    set acceleration to getAvailableThrust/mass.
    set currentToCompare to acceleration/startAcceleration.
    set additionaldistance to  (calculation*currentToCompare).
    set heigthofVehicle to 46.
    set luftwiderstand to ((((1/2)*(radius*(CONSTANT:PI^2)) * 0.34 * KERBIN:ATM:ALTITUDEPRESSURE(SHIP:ALTITUDE)*(speed^2)))/1000)/mass.
    print "Luftwiderstand: "+ (luftwiderstand/1000)/mass at (0,8).
    print "availableThrust" + getAvailableThrust at (0,0).
    print "currentThrust" + currentThrust at (0,1).
    //print "ratio" +currentToCompare at (0,2).
    print "speed: "+speed at (0,3).
    print "max possible acceleration: " + acceleration at (0,4).
    print "altitude: "+altitude at (0,5).
    print "mass: "+ mass at (0,6).
    set a to (((additionaldistance - ((9.81/2)*(1.3^2)) - (speed*1.3)))).
    set b to (((acceleration *1.3) - (9.81*1.3) - speed)^2)/(2*(acceleration- 9.81 + luftwiderstand )).
    set bremsweg to a+b+heigthofVehicle.
    print "a: " + a at (0,9).
    print "b: " + b at (0,10).
    print "burnheight: " + bremsweg at (0,11).
    if ALT:RADAR < (bremsweg){
        GEAR ON.
        LOCK THROTTLE TO 1.0.
        LOCK STEERING TO  SHIP:SRFRETROGRADE.
    }

    if SHIP:VELOCITY:SURFACE:MAG < 10{
        set Forceaftersuicide to SHIP:MASS * 9.285.//Kraft in kN nach dem suicide burn
        set calculateRatio to ((Forceaftersuicide)/(getAvailableThrust))-0.07.
        print "Ratio:"+calculateRatio at (0,8).
        LOCK THROTTLE TO calculateRatio.
        LOCK STEERING TO UP.
    }
    if SHIP:VELOCITY:SURFACE:MAG < 5{
        set Forceaftersuicide to SHIP:MASS * 9.285.//Kraft in kN nach dem suicide burn
        set calculateRatio to ((Forceaftersuicide)/(getAvailableThrust))-0.03.
        print "Ratio:"+calculateRatio at (0,8).
        LOCK THROTTLE TO calculateRatio.
        LOCK STEERING TO UP.
    }
}

LOCK THROTTLE TO 0.0.
LOCK STEERING TO UP.


wait until SHIP:ALTITUDE = 0.