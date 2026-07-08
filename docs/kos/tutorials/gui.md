> Source: https://ksp-kos.github.io/KOS/tutorials/gui.html (mirrored offline copy for local reference)

# Creating Reusable GUI Elements

## Overview

This tutorial demonstrates building a TabWidget—a reusable graphical component for creating tabbed interfaces in kOS scripts. The guide follows a design-first approach, showing desired usage patterns before implementation details.

## The End Result

The final TabWidget provides a tabbed interface where users can organize GUI content across multiple labeled tabs.

### How to Use the TabWidget

#### 1. Import Functionality

```
RUNONCEPATH("TabWidget/tabwidget").
```

#### 2. Create a GUI

```
LOCAL my_gui IS GUI(500).
LOCAL tabwidget IS AddTabWidget(my_gui).
```

#### 3. Add Tabs

```
LOCAL page IS AddTab(tabwidget,"One").
page:ADDLABEL("This is page 1").
page:ADDLABEL("Put stuff here!").

LOCAL page IS AddTab(tabwidget,"Two").
page:ADDLABEL("This is page 2").
page:ADDLABEL("Put more stuff here!").

LOCAL page IS AddTab(tabwidget,"Three").
page:ADDLABEL("This is page 3").
page:ADDLABEL("Put even stuff here!").
```

#### 4. Choose Tab Programmatically

```
ChooseTab(tabwidget,1).
```

#### 5. Run the GUI

```
LOCAL close IS my_gui:ADDBUTTON("Close").
my_gui:SHOW().
UNTIL close:PRESSED {
    WAIT(0).
}
my_gui:HIDE().
```

## The Implementation

### 1. Creating the TabWidget

```
DECLARE FUNCTION AddTabWidget
{
        DECLARE PARAMETER box.

        IF NOT box:GUI:SKIN:HAS("TabWidgetTab") {
                LOCAL style IS box:GUI:SKIN:ADD("TabWidgetTab",box:GUI:SKIN:BUTTON).
                SET style:BG TO "TabWidget/images/back".
                SET style:ON:BG to "TabWidget/images/front".
                SET style:TEXTCOLOR TO RGBA(0.7,0.75,0.7,1).
                SET style:HOVER:BG TO "".
                SET style:HOVER_ON:BG TO "".
                SET style:MARGIN:H TO 0.
                SET style:MARGIN:BOTTOM TO 0.
        }
        IF NOT box:GUI:SKIN:HAS("TabWidgetPanel") {
                LOCAL style IS box:GUI:SKIN:ADD("TabWidgetPanel",box:GUI:SKIN:WINDOW).
                SET style:BG TO "TabWidget/images/panel".
                SET style:PADDING:TOP to 0.
        }

        LOCAL vbox IS box:ADDVLAYOUT.
        LOCAL tabs IS vbox:ADDHLAYOUT.
        LOCAL panels IS vbox:ADDSTACK.

        RETURN vbox.
}
```

### 2. Images for Tabs and Panels

Three image files are required in the "TabWidget/images" directory:
- **front.png**: Tab appearance when selected
- **back.png**: Tab appearance when inactive
- **panel.png**: Background for the panel content area

### 3. Adding a Tab

```
DECLARE FUNCTION AddTab
{
        DECLARE PARAMETER tabwidget.
        DECLARE PARAMETER tabname.

        LOCAL hboxes IS tabwidget:WIDGETS.
        LOCAL tabs IS hboxes[0].
        LOCAL panels IS hboxes[1].

        LOCAL panel IS panels:ADDVBOX.
        SET panel:STYLE TO panel:GUI:SKIN:GET("TabWidgetPanel").

        LOCAL tab IS tabs:ADDBUTTON(tabname).
        SET tab:STYLE TO tab:GUI:SKIN:GET("TabWidgetTab").

        SET tab:TOGGLE TO true.
        SET tab:EXCLUSIVE TO true.

        IF panels:WIDGETS:LENGTH = 1 {
                SET tab:PRESSED TO true.
                panels:SHOWONLY(panel).
        } else {
                panel:HIDE().
        }

        TabWidget_alltabs:ADD(tab).
        TabWidget_allpanels:ADD(panel).

        RETURN panel.
}

GLOBAL TabWidget_alltabs TO LIST().
GLOBAL TabWidget_allpanels TO LIST().
```

### 4. Choosing a Specific Tab

```
DECLARE FUNCTION ChooseTab
{
        DECLARE PARAMETER tabwidget.
        DECLARE PARAMETER tabnum.
        LOCAL hboxes IS tabwidget:WIDGETS.
        LOCAL tabs IS hboxes[0].
        SET tabs:WIDGETS[tabnum]:PRESSED TO true.
}
```

### 5. Running the TabWidget

```
WHEN True THEN {
        FROM { LOCAL x IS 0.} UNTIL x >= TabWidget_alltabs:LENGTH STEP { SET x TO x+1.} DO
        {
                IF TabWidget_alltabs[x]:PRESSED AND NOT TabWidget_allpanels[x]:VISIBLE {
                        TabWidget_allpanels[x]:parent:showonly(TabWidget_allpanels[x]).
                }
        }
        PRESERVE.
}
```

### 6. Testing with Communication Delay

To test GUI responsiveness with artificial delays:

```
SET my_gui:EXTRADELAY TO 2.
```

This simulates network latency to ensure the interface remains functional under communication constraints.
