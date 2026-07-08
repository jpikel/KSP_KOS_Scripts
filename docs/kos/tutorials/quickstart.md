> Source: https://ksp-kos.github.io/KOS/tutorials/quickstart.html (mirrored offline copy for local reference)

# Quick Start Tutorial — kOS 1.4.0.0 Documentation

## Quick Start Tutorial

This guide introduces the **Kerbal Operating System** (**kOS**) for those new to the system. It assumes familiarity with Kerbal Space Program basics but not programming experience.

---

## First Example: Hello World

The initial example demonstrates printing "Hello World" to show file management and script execution.

### Step 1: Start a New Sandbox-Mode Game

Using sandbox mode avoids needing researched parts from the tech tree.

### Step 2: Make a Vessel in the Vehicle Assembly Bay

Construct a vessel containing:
- An unmanned command core
- Several hundred units of battery power
- Battery recharging means (such as solar panels)
- The "Comptronix CX-4181 Scriptable Control System" (SCS) part, found in the Control tab

### Step 3: Put the Vessel on the Launchpad

Place the vessel on the launchpad. Engines and liftoff capability are unnecessary for this example.

### Step 4: Invoke the Terminal

Right-click the SCS part and select "Open Terminal." When semi-transparent, the terminal is unselected. Click it to direct keyboard input to the terminal instead of ship control. Click the background to return to manual piloting.

### Step 5: See What an Interactive Command Is Like

Type into the terminal:

```
CLEARSCREEN. PRINT "==HELLO WORLD==".
```

Press ENTER. The system responds with the printed output. Case doesn't matter in kOS.

### Step 6: Creating a Program Script

Enter the command:

```
EDIT HELLO.
```

An editor window appears. Type the following:

```
PRINT "=========================================".
PRINT "      HELLO WORLD".
PRINT "THIS IS THE FIRST SCRIPT I WROTE IN kOS.".
PRINT "=========================================".
```

Click Save, then Exit. Return to the terminal and enter:

```
RUN HELLO.
```

The script executes, displaying the formatted text.

**Note:** You can also use `RUNPATH("hello")` instead of `RUN HELLO`. Both achieve similar results.

### Step 7: Locating the Program

Issue the command:

```
LIST FILES.
```

This displays all files on the current VOLUME. By default, newly launched vessels use VOLUME 1, the local storage on that SCS part. Local volumes have limited storage space and persist only while the vessel exists.

### Step 8: Saving Programs Permanently

Programs stored only on a vessel are lost if that vessel crashes. The **Archive** (also called volume 0) exists as permanent storage. The Archive:
- Is conceptually located at Kerbin Space Center
- Provides infinite storage capacity
- Persists across saved games
- Is located in the `Ships/Script` folder of the main KSP installation

To work with the Archive, use the `SWITCH TO` command:

```
SWITCH TO 0.
EDIT HELLO2. // Creates a new file
LIST FILES.
RUN HELLO2.
SWITCH TO 1.
LIST FILES.
RUN HELLO.
```

Files in the Archive can be edited with external text editors. Ensure all files end with the `.ks` extension.

**Further Reading:**
- Volumes
- File Control
- VolumeFile structure

#### Step 9: Automatic Boot

kOS can automatically run boot files when a vessel launches. This feature is described in more detail in the boot documentation but isn't required for this tutorial.

---

## Second Example: Doing Something Real

This example creates a launch autopilot, progressively adding complexity. Launching represents one of the simpler automation tasks; kOS excels at sensitive operations like landing and docking.

### Step 1: Make a Vessel

Build the vessel shown in the tutorial images, or download the provided `.craft` file (MyFirstRocket.craft).

### Step 2: Make the Start of the Script

Using an external text editor (Notepad, TextEdit, etc.), write:

```
//hellolaunch

//First, we'll clear the terminal screen to make it look nice
CLEARSCREEN.

//This is our countdown loop, which cycles from 10 to 0
PRINT "Counting down:".
FROM {local countdown is 10.} UNTIL countdown \= 0 STEP {SET countdown to countdown \- 1.} DO {
    PRINT "..." + countdown.
    WAIT 1. // pauses the script here for 1 second.
}
```

**Comments** (lines starting with `//`) explain code and don't execute.

Save the file as `hellolaunch.ks` in the `Ships/Script` folder of your KSP installation. Do **NOT** save it under `GameData/kOS/`. This places the file in your Archive volume.

To verify, issue:

```
SWITCH TO 0.
LIST FILES.
```

Copy the file to your vessel's local drive and run it:

```
SWITCH TO 1.
COPYPATH("0:/HELLOLAUNCH", "").
RUN HELLOLAUNCH.
```

The script counts down from 10 to 0 but doesn't control the vessel yet.

### Step 3: Make the Script Actually Do Something

Append these lines to `hellolaunch.ks`:

```
//Next, we'll lock our throttle to 100%.
LOCK THROTTLE TO 1.0.   // 1.0 is the max, 0.0 is idle.

UNTIL SHIP:MAXTHRUST \> 0 {
    WAIT 0.5. // pause half a second between stage attempts.
    PRINT "Stage activated.".
    STAGE. // same as hitting the spacebar.
}

WAIT UNTIL SHIP:ALTITUDE \> 70000.

// NOTE that it is vital to not just let the script end right away
// here.  Once a kOS script just ends, it releases all the controls
// back to manual piloting so that you can fly the ship by hand again.
// If the program just ended here, then that would cause the throttle
// to turn back off again right away and nothing would happen.
```

Relaunch and run the script:

```
COPYPATH("0:/HELLOLAUNCH", "").
RUN HELLOLAUNCH.
```

The vessel now launches! However, without steering control, it likely tilts over and crashes.

### Step 4: Make the Script Actually Control Steering

Add steering control using the `LOCK STEERING` command. The built-in Direction `UP` always points skyward. Insert this line after the throttle lock:

```
LOCK STEERING TO UP.
```

The complete script now includes:

```
//hellolaunch

//First, we'll clear the terminal screen to make it look nice
CLEARSCREEN.

//Next, we'll lock our throttle to 100%.
LOCK THROTTLE TO 1.0.   // 1.0 is the max, 0.0 is idle.

//This is our countdown loop, which cycles from 10 to 0
PRINT "Counting down:".
FROM {local countdown is 10.} UNTIL countdown \= 0 STEP {SET countdown to countdown \- 1.} DO {
    PRINT "..." + countdown.
    WAIT 1. // pauses the script here for 1 second.
}

//This is the line we added
LOCK STEERING TO UP.

UNTIL SHIP:MAXTHRUST \> 0 {
    WAIT 0.5. // pause half a second between stage attempts.
    PRINT "Stage activated.".
    STAGE. // same as hitting the spacebar.
}

WAIT UNTIL SHIP:ALTITUDE \> 70000.

// NOTE that it is vital to not just let the script end right away
// here.  Once a kOS script just ends, it releases all the controls
// back to manual piloting so that you can fly the ship by hand again.
// If the program just ended here, then that would cause the throttle
// to turn back off again right away and nothing would happen.
```

Copy and run again:

```
SWITCH TO 1.
COPYPATH("0:/HELLOLAUNCH", "").
RUN HELLOLAUNCH.
```

The vessel now maintains an upright orientation. However, it only stages once.

### Step 5: Add Staging Logic

Replace the `UNTIL SHIP:MAXTHRUST > 0` loop with a `WHEN` trigger. This constantly checks for a condition and executes code when it occurs, then resumes the main script:

```
WHEN MAXTHRUST \= 0 THEN {
    PRINT "Staging".
    STAGE.
    PRESERVE.
}.
```

The `PRESERVE` keyword keeps the trigger active after firing. The updated script becomes:

```
//hellolaunch

//First, we'll clear the terminal screen to make it look nice
CLEARSCREEN.

//Next, we'll lock our throttle to 100%.
LOCK THROTTLE TO 1.0.   // 1.0 is the max, 0.0 is idle.

//This is our countdown loop, which cycles from 10 to 0
PRINT "Counting down:".
FROM {local countdown is 10.} UNTIL countdown \= 0 STEP {SET countdown to countdown \- 1.} DO {
    PRINT "..." + countdown.
    WAIT 1. // pauses the script here for 1 second.
}

//This is a trigger that constantly checks to see if our thrust is zero.
//If it is, it will attempt to stage and then return to where the script
//left off. The PRESERVE keyword keeps the trigger active even after it
//has been triggered.
WHEN MAXTHRUST \= 0 THEN {
    PRINT "Staging".
    STAGE.
    PRESERVE.
}.

LOCK STEERING TO UP.

WAIT UNTIL ALTITUDE \> 70000.

// NOTE that it is vital to not just let the script end right away
// here.  Once a kOS script just ends, it releases all the controls
// back to manual piloting so that you can fly the ship by hand again.
// If the program just ended here, then that would cause the throttle
// to turn back off again right away and nothing would happen.
```

Relaunch, copy, and run. The vessel now stages correctly through all stages.

### Step 6: Now to Make It Turn

The script currently launches straight up. A gravity turn approximates proper ascent:

- Fly straight up until reaching 100 m/s velocity
- Pitch 10 degrees toward the East
- Pitch 10 degrees down for each additional 100 m/s of velocity

The `HEADING` function creates a Direction oriented by:
- Compass heading (0-360)
- Pitch angle above horizon

For example, `HEADING(90,45)` aims northeast, 45 degrees above the horizon.

Implement the turn with an `UNTIL` loop and `IF` statements:

```
//This will be our main control loop for the ascent. It will
//cycle through continuously until our apoapsis is greater
//than 100km. Each cycle, it will check each of the IF
//statements inside and perform them if their conditions
//are met
SET MYSTEER TO HEADING(90,90).
LOCK STEERING TO MYSTEER. // from now on we'll be able to change steering by just assigning a new value to MYSTEER
UNTIL SHIP:APOAPSIS \> 100000 { //Remember, all altitudes will be in meters, not kilometers

    //For the initial ascent, we want our steering to be straight
    //up and rolled due east
    IF SHIP:VELOCITY:SURFACE:MAG < 100 {
        //This sets our steering 90 degrees up and yawed to the compass
        //heading of 90 degrees (east)
        SET MYSTEER TO HEADING(90,90).

    //Once we pass 100m/s, we want to pitch down ten degrees
    } ELSE IF SHIP:VELOCITY:SURFACE:MAG \>= 100 AND SHIP:VELOCITY:SURFACE:MAG < 200 {
        SET MYSTEER TO HEADING(90,80).
        PRINT "Pitching to 80 degrees" AT(0,15).
        PRINT ROUND(SHIP:APOAPSIS,0) AT (0,16).
    }.
}.
```

The `PRINT AT()` command prints at specific screen coordinates, preventing repeated lines.

Relaunch, copy, and run. The vessel pitches down at 100 m/s and continues pitching as velocity increases.

### Step 7: Putting It All Together

Extend the `IF` statements to handle the entire ascent with 100 m/s velocity blocks, each pitching the nose down 10 degrees further:

```
//hellolaunch

//First, we'll clear the terminal screen to make it look nice
CLEARSCREEN.

//Next, we'll lock our throttle to 100%.
LOCK THROTTLE TO 1.0.   // 1.0 is the max, 0.0 is idle.

//This is our countdown loop, which cycles from 10 to 0
PRINT "Counting down:".
FROM {local countdown is 10.} UNTIL countdown \= 0 STEP {SET countdown to countdown \- 1.} DO {
    PRINT "..." + countdown.
    WAIT 1. // pauses the script here for 1 second.
}

//This is a trigger that constantly checks to see if our thrust is zero.
//If it is, it will attempt to stage and then return to where the script
//left off. The PRESERVE keyword keeps the trigger active even after it
//has been triggered.
WHEN MAXTHRUST \= 0 THEN {
    PRINT "Staging".
    STAGE.
    PRESERVE.
}.

//This will be our main control loop for the ascent. It will
//cycle through continuously until our apoapsis is greater
//than 100km. Each cycle, it will check each of the IF
//statements inside and perform them if their conditions
//are met
SET MYSTEER TO HEADING(90,90).
LOCK STEERING TO MYSTEER. // from now on we'll be able to change steering by just assigning a new value to MYSTEER
UNTIL SHIP:APOAPSIS \> 100000 { //Remember, all altitudes will be in meters, not kilometers

    //For the initial ascent, we want our steering to be straight
    //up and rolled due east
    IF SHIP:VELOCITY:SURFACE:MAG < 100 {
        //This sets our steering 90 degrees up and yawed to the compass
        //heading of 90 degrees (east)
        SET MYSTEER TO HEADING(90,90).

    //Once we pass 100m/s, we want to pitch down ten degrees
    } ELSE IF SHIP:VELOCITY:SURFACE:MAG \>= 100 AND SHIP:VELOCITY:SURFACE:MAG < 200 {
        SET MYSTEER TO HEADING(90,80).
        PRINT "Pitching to 80 degrees" AT(0,15).
        PRINT ROUND(SHIP:APOAPSIS,0) AT (0,16).

    //Each successive IF statement checks to see if our velocity
    //is within a 100m/s block and adjusts our heading down another
    //ten degrees if so
    } ELSE IF SHIP:VELOCITY:SURFACE:MAG \>= 200 AND SHIP:VELOCITY:SURFACE:MAG < 300 {
        SET MYSTEER TO HEADING(90,70).
        PRINT "Pitching to 70 degrees" AT(0,15).
        PRINT ROUND(SHIP:APOAPSIS,0) AT (0,16).

    } ELSE IF SHIP:VELOCITY:SURFACE:MAG \>= 300 AND SHIP:VELOCITY:SURFACE:MAG < 400 {
        SET MYSTEER TO HEADING(90,60).
        PRINT "Pitching to 60 degrees" AT(0,15).
        PRINT ROUND(SHIP:APOAPSIS,0) AT (0,16).

    } ELSE IF SHIP:VELOCITY:SURFACE:MAG \>= 400 AND SHIP:VELOCITY:SURFACE:MAG < 500 {
        SET MYSTEER TO HEADING(90,50).
        PRINT "Pitching to 50 degrees" AT(0,15).
        PRINT ROUND(SHIP:APOAPSIS,0) AT (0,16).

    } ELSE IF SHIP:VELOCITY:SURFACE:MAG \>= 500 AND SHIP:VELOCITY:SURFACE:MAG < 600 {
        SET MYSTEER TO HEADING(90,40).
        PRINT "Pitching to 40 degrees" AT(0,15).
        PRINT ROUND(SHIP:APOAPSIS,0) AT (0,16).

    } ELSE IF SHIP:VELOCITY:SURFACE:MAG \>= 600 AND SHIP:VELOCITY:SURFACE:MAG < 700 {
        SET MYSTEER TO HEADING(90,30).
        PRINT "Pitching to 30 degrees" AT(0,15).
        PRINT ROUND(SHIP:APOAPSIS,0) AT (0,16).

    } ELSE IF SHIP:VELOCITY:SURFACE:MAG \>= 700 AND SHIP:VELOCITY:SURFACE:MAG < 800 {
        SET MYSTEER TO HEADING(90,11).
        PRINT "Pitching to 20 degrees" AT(0,15).
        PRINT ROUND(SHIP:APOAPSIS,0) AT (0,16).

    //Beyond 800m/s, we can keep facing towards 10 degrees above the horizon and wait
    //for the main loop to recognize that our apoapsis is above 100km
    } ELSE IF SHIP:VELOCITY:SURFACE:MAG \>= 800 {
        SET MYSTEER TO HEADING(90,10).
        PRINT "Pitching to 10 degrees" AT(0,15).
        PRINT ROUND(SHIP:APOAPSIS,0) AT (0,16).

    }.

}.

PRINT "100km apoapsis reached, cutting throttle".

//At this point, our apoapsis is above 100km and our main loop has ended. Next
//we'll make sure our throttle is zero and that we're pointed prograde
LOCK THROTTLE TO 0.

//This sets the user's throttle setting to zero to prevent the throttle
//from returning to the position it was at before the script was run.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
```

Run this final version. The vessel executes a full gravity turn, reaching approximately 100 km apoapsis.

**Possible Enhancements:**
- Implement a smooth gravity turn using mathematical formulas rather than discrete pitch angles
- Dynamically adjust throttle to prevent excessive atmospheric heating
- Add circularization logic using orbital velocity calculations
- Support sophisticated staging methods
- Create advanced terminal status displays using `PRINT AT` commands
