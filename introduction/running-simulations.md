---
layout: default
title: Running simulations
nav_order: 2
parent: Introduction
---
# Running simulations

## Running simulations

### Loading a boxscript

You load a boxscript like this

```text
> load demo/butterfly1.box
Constructing...
Amending...
17 boxes created
```

In response to reading the boxscript, Universal Simulator will construct and amend all the boxes needed to run the boxscript. In this case 17 boxes were created. The difference between constructing and amending only becomes important, once you get to the advanced stage of developing your own boxes in C++ (as `Box`-derived classes).

If you'd rather not type out the full path to the boxscript, you simple type `<Ctrl+space bar>`:

```text
load <Ctrl+space bar>
```

This will bring up a file picker, which will allow you to point and click all the way to the wanted boxscript. The file picker will start out in the same folder as the latest boxscript that you loaded.

When a boxscript has been loaded successfully (any lack of success will be obvious from error messages), you have in effect loaded a *model*, ready to be run. You can only have one model loaded at a time. If you load another model (i.e. if you load another boxscript), it will replace the current model.

### Running a model

When you run a model, it means you carry out a *simulation* as defined by the model. You can run the current model (i.e. the one defined by your latest loaded boxscript) like this

```text
> run
Constructing...
Amending...
17 boxes created
Initializing...
Resetting...
Updating...
Cleaning up...
Debriefing...
R script written to 'C:/Users/your_name/UniversalSimulatorHome/output/butterfly1_0010.R'
Executable R snippet copied to clipboard
Data frame written to 'C:/Users/your_name/UniversalSimulatorHome/output/butterfly1_0010.txt'
Finished after 266 msecs in step 152/152
```

From the output you can see that a `run` actually always carries out an initial `load` (the 17 boxes were created anew). This means that if you are in a hurry you can run a specific model directly:

```text
> run demo/butterfly1.box
...	
```

The simulation goes through specific stages, which reflect the logic of how box behaviour is defined in C++. Finally, you get a report of the three specific outputs produced by the simulation:

* an R script written to a file
* an R snippet copied to the clipboard
* a data frame written to a text file

Two files are written to the output folder. Every time you run a simulation, an additional two files will be written there. You should empty the output folder now and then to get rid of all these files.

The R snippet (a 'code snippet' is a few lines of code) in the clipboard is meant to be pasted directly at the *R prompt*. As you deftly switch (by `<Alt+Tab>` or `<Command+Tab>`) from the Universal Simulator prompt to the R prompt, where you paste (by`<Ctrl+V>` or `<Command+V>`), you are rewarded immediately by plots showing the simulation results:

![](https://tildeweb.au.dk/au152367/media/demo/butterfly1.png)

As you might have guessed, the R snippet makes clever use of the two output files to create the plots defined in the boxscript: The text file is read and ends up in an R data frame called `sim`. This data frame contains that data needed to produce the plots.

After celebrating your success, you can switch back to the Universal Simulator prompt to run an other simulation.

### Seeing and editing a boxscript

To have a look at the current boxscript simply type

```text
edit
```

This will show the boxscript code in the editor set up to edit boxscripts. First time off, no editor has been set up, so your operating system (Windows/OS X/Linux) will prompt you to choose an editor for this purpose. Any pure text editor will work (e.g., on Windows Notepad, or even better, [Notepad++](https://notepad-plus-plus.org/) but do not choose a word processor. Here, is the BoxScript code that you will see for the `butterfly1` boxscript:

```
// butterfly1.box
Simulation sim {
  Calendar calendar {
    .begin = 01/05/2009
    .end   = 30/09/2009
  }  
  Records weather {
    .fileName = "weather/flakkebjerg 2009.txt"
  }
  Box butterfly {
    Stage egg {
      .initial = 100 
      .duration = 140
      .timeStep = ./time[step]
      DayDegrees time {
        .T0 = 5
        .T = weather[Tavg]
      }
    }
    Stage larva {
      .inflow = ../egg[outflow]
      .duration = 200
      .timeStep = ./time[step]
      DayDegrees time {
        .T0 = 8
        .T = weather[Tavg]
      }
    }
    Stage pupa {
      .inflow = ../larva[outflow]
      .duration = 100
      .timeStep = ./time[step]
      DayDegrees time {
        .T0 = 10
        .T = weather[Tavg]
      }
    }
    Stage adult {
      .inflow = ../pupa[outflow]
      .duration = 28
      .timeStep = 1
    }
  }
  OutputR {
    PageR {
      .xAxis = calendar[date]
      .ncol = 2
      PlotR {
        .ports = *[content]
        .ggplot = "scale_x_datetime(
                     breaks = date_breaks('months'), 
                     labels = date_format('%b')
                   )" 
      }
      PlotR {
        .ports = *[outflowTotal]
        .ggplot = "scale_x_datetime(
                     breaks = date_breaks('months'), 
                     labels = date_format('%b')
                   )" 
      }
    }
  }
}
```

Fell free to change the code, save the file, and  run the script again to see what change it made to the simulation output. Or, on second thought, save your changed boxscript under another name and then run *that* boxscript.

### Listing a boxscript

The list command is a powerful tool to inspect the *structure* and *state* of your currently loaded model. The structure will remain unaltered after you have loaded the boxscript but the state will have changed after you have run a simulation. 

First you can simply list all the boxes which together constitute the model:

```text
> list
Simulation sim
  Calendar calendar
  Records weather
  Box butterfly
    Stage egg
      DayDegrees time
    Stage larva
      DayDegrees time
    Stage pupa
      DayDegrees time
    Stage adult
  OutputR 
    PageR 
      PlotR 
      PlotR 
  OutputWriter outputWriter
    OutputSelector selector
```

The hierarchy of boxes is shown by identation. Each box is designated by its *class* (e.g. `Records`) and its *name* (e.g. `weather`), unless it is nameless (e.g. the `PlotR` boxes). Class names must correspond to a name defined in the Universal Simulator toolbox, while box names can be chosen freely albeit according to custom, they should start with a lowercase letter (telling those in the know that they are actually *object names*).

You can list a particular box and all its descendents by giving its name followed by the `r` option, which stands for *recurse*:

```text
> list butterfly r
Box butterfly
  Stage egg
    DayDegrees time
  Stage larva
    DayDegrees time
  Stage pupa
    DayDegrees time
  Stage adult
```

To inspect the ports, you add the `p` option:

```
> list calendar p
Calendar calendar
  .latitude = 52.0 [-90,90]
  .longitude = 11.0 [-180,180]
  .timeZone = 1 h
  .begin = 2009/05/01T00:00:00 DateTime
  .end = 2009/09/30T00:00:00 DateTime
  .timeStep = 1 int>0
  .timeUnit = "d" y|d|h|m|s
  >steps = 0
  >date =  d/m/y
  >time =  h:m:s
  >dateTime = T d/m/y h:m:s
  >timeStepSecs = 0.0 s
  >timeStepDays = 0.0 d
  >totalTimeSteps = 0 int
  >totalTime = 0 int
  >totalDays = 0.0 d
  >dayOfYear = 0 [1;366]

```

Here, the input ports are preceded by a period `.` and the output ports by a `>`. For each port you see its current value, often follow by its type or an indication of its legal values. The command above was issued just after loading the `butterfly1` boxscript. That's why the output ports carry their initial values, and the date, time and dateTime ports even appear empty (because their values are yet undefined). If we run the model and repeat the command, we get

```text
> list calendar p
Calendar calendar
  .latitude = 52.0 [-90,90] const
  .longitude = 11.0 [-180,180] const
  .timeZone = 1 h const
  .begin = 2009/05/01T00:00:00 DateTime const
  .end = 2009/09/30T00:00:00 DateTime const
  .timeStep = 1 int>0 const
  .timeUnit = "d" y|d|h|m|s const
  >steps = 152
  >date = 2009/09/30 d/m/y
  >time = 00:00:00 h:m:s
  >dateTime = 2009/09/30T00:00:00 d/m/y h:m:s
  >timeStepSecs = 86400.0 s
  >timeStepDays = 1.0 d
  >totalTimeSteps = 152 int
  >totalTime = 152 int
  >totalDays = 152.0 d
  >dayOfYear = 273 [1;366]
```

The output ports have now been updated and maintain their final values in the simulation. You will also note that all the inputs have been marked `const`. That's because they have been identified as being constant throughtout the simulation. This speeds up the execution. We can find examples of inputs that are not constant in one of the `DayDegrees` boxes:

```text
> list butterfly/egg/time p
DayDegrees time
  .T = 10.5 <- sim/weather[Tavg]
  .timeStepDays = 1.0 <- sim/calendar[timeStepDays]
  .resetTotal = FALSE const
  .isTicking = TRUE const
  .T0 = 5.0 const
  .Topt = 100.0 const
  .Tmax = 100.0 const
  >step = 5.5 PTU
  >total = 1605.7 PTU

```

First of all, you can see how to specify the *path* two a specific box `butterfly/egg/time`. Here you can read  [more about paths](#port-paths).

The two non-constant input ports are `T` and `timeStepDays`. You can see from which output ports they fetch their inputs and you can see their  current (final, if we just ran the model) values. This was set up in the boxscript like this

```
Stage egg {
  .initial = 100 
  .duration = 140
  .timeStep = ./time[step]
  DayDegrees time {
    .T0 = 5
    .T = weather[Tavg]
  }
}
```

Note: If `timeStep` is followed all the way back to its source, it turns out to remain constant during the simulation since it ultimately relies only on inputs that are all constant. Currently, Universal Simulator marks as constant only those ports that are immediately constant. More intelligent resolution of constants can be expected in future versions (to speed up the execution even more).

The options can be combined. Here are a few combinations (output not shown):

```
> list butterfly/egg pr
...
> list sim pr
...
```

Maybe after that, it will be nice to know that `clear` command clears the prompt dialog. It's so often called for that the `<Ctrl+L>` shortcut achieves the same. Bonus info: <Ctrl+L> also works on the R prompt. And, at the Linux prompt (but if you use Linux, you already knew that).

In the reference manual, you can find are even [more options](#list) for the list command.

### R integration

When you paste the clipboard at the R prompt, a snippet of pre-cooked R code is executed corresponding to your boxscript. However, you can also define you own R script (or R scripts) to be carried out. Here is an example of a boxscript, which does not carry out a proper simulation but rather demonstrates the curve shapes produced by to kinds of boxes, `DayDegrees` and `Briere`:

```
// briere1.box
Simulation sim {
  .steps = temperature[steps]
  SequenceByStep temperature {
    .min = 12
    .max = 37
    .by = 0.2
  }
  DayDegrees dayDegrees {
    .timeStepDays = 1
    .T0 = 14.2
    .Topt = 29
    .Tmax = 35
    .T = temperature[value]
  }
  Briere briere {
    .timeStepDays = 1
    .T0 = 14.2
    .Tmax = 35
    .a = 2.836e-5
    .T = temperature[value]
  }
  
  OutputR {
    .scripts = "briere1.R"
    OutputText {
      .ports = temperature[value] | dayDegrees[step] | briere[step]
    }
  }
}
```

The output is stated as an `OutputText`, which simple produced an output text file. You specify the R script(s)—supposedly to work on that output but, in fact the R script(s) could do anything—in the `scripts` port of the `OutputR` box. This port takes a vector of strings, so you could also write:

```
.scripts = c("briere1.R", "briere2.R", "briere3.R")
```

The R scripts can be placed in the same folder as the boxscript, or you can put them in a folder, which you can refer to by a path relative to the folder of the boxscript, for example:

```
.scripts = c("general/setup.R", "analysis/briere.R", "figures/briere3.R")
```

The R scripts will be carried out (in the given order) when you paste the clipboard at the R prompt after having run your boxscript.

Before your R scripts, another R script has been executed providing you with useful *hooks* to the output produced by your script. This script is the `begin.R`, which is one of the standard scripts  residing in the `inputs/scripts` folder of the Universal Simulator home folder. It sets up the following *variables*:

* Colours named `red`, `blue`, `green`, `violet`, `orange`, `brown`, `pink`, `grey`. These colours can be used individually but they have also been set up to replace the default colour scales of *ggplot*.
* A data frame `sim` with all outputs from the boxscript.
* The name of the columns in the data frame containing the iteration counter (`iterationColumn`) and step counter (`stepColumn`).
* The absolute path to the folder that holds the boxscript (`box_script_folder`).
* The the full path (absolute path and file name) to the file holding the boxscript output (`output_file_name`), i.e. the text file read into the `sim` data frame. 

In addition, you will have access to these *functions*:

* `ggplot_theme(font_size)` returns a *ggplot* theme adjusted to the given `font_size`.
* `output_file_folder()` returns the absolute path to the output folder, i.e. the path part of `output_file_name`.
* `output_file_base_name()` returns the base file name of the output folder, i.e. the base file name part of `output_file_name`. The base file name is the file name without the suffix, in this case with out the `.txt` suffix.
* *open_plot_window(width=7, height=7)* opens a pop-up window to show you plot. It uses different methods to create the windows depending on the platform (Mac, Windows or Linux).

Here is the full *briere1.R* script referred to in the boxscript above. It demonstrates how to compare boxscript outputs with observations:

```R
# briere1.R
sim = sim[1:3]
colnames(sim) = c("Temperature", "DayDegrees", "Briere")
sim$DayDegrees = sim$DayDegrees/472.1

obs = data.frame(
  Temperature = c(15,17,20,25,27,30,33,35),
  L = c(Inf, 
        121.5, 
        (83.68+78.46)/2,
        (47.97+41.32)/2,
        (38.92+34.42)/2,
        (35.05+32.41)/2,
        (38.33+37)/2,
        Inf)
)
obs$DevRate = 1/obs$L

model = lm(DevRate~Temperature, data=obs[1:5,])
icept = coef(model)[1]
slope = coef(model)[2]
T0 = -icept/slope
duration = 1/slope

open_plot_window(6,3.5)
M = melt(sim, id.vars="Temperature", value.name="DevRate", variable.name="Model")
P = ggplot(M, aes(x=Temperature, y=DevRate, colour=Model)) +
  geom_abline(intercept=icept, slope=slope, colour=brown, size=3, alpha=0.6) +
  geom_line(size=1) +
  geom_point(data=obs, colour=red, size=3) +
  geom_vline(xintercept=T0) +
  geom_hline(yintercept=0) +
  scale_color_manual(values=c(green,blue)) +
  scale_x_continuous(breaks=c(T0,20,25,30,35), labels=c(round(T0,1), 20,25,30,35)) +
  labs(x="Temperature (oC)", y="1/L (per day)")
print(P)
```

Here is the resulting plot:

![](https://tildeweb.au.dk/au152367/media/demo/briere1.png)
