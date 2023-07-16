---
layout: default
title: Getting started
nav_order: 1
parent: Introduction
---
# Getting started

### Software installation 

**Universal Simulator** comes as an installation package. Just download [Universal Simulator](https://www.ecolmod.org/download/) and afterwards launch the downloaded installation package. It is currently a Windows-only software. Hail me with some encouragement, and I will find time to build a Mac or Linux installation package too.

You will also need **R** software, either stay with the [classic R](https://www.r-project.org/) or put [R Studio](https://www.rstudio.com/products/rstudio/download/) on top of it.

You've already got a pre-installed **text editor** on your computer. Free and not very useful. On Windows, that means Notepad. Improve on that and download [Notepad++](https://notepad-plus-plus.org/downloads/), right away. If you are an experienced power user, you can just keep using your favourite text editor.

If you are an experienced programmer, you may want to download the Universal Simulator source code and the Qt Creator development environment. You can find the details in the [BoxScript Developer](#boxscript-developer) section.

### Hello world!

BoxScript is not a language designed to put text messages on to your screen. Anyway: No programming language without a *Hello world!* example. Here goes

```
// hello_world1.box
Simulation sim {
  .steps = 3
  OutputText {
    &message = "Hello world!"
    .ports = .[message]
  }
}
```

Start up Universal Simulator and type at its prompt:

```
run demo/hello_world1.box
```

After it has successfully completed (we expect nothing but success of this exercise), follow up with this command:

```
head
```

The only surprise you will get is that you will see the happy message four, not three, times. Take it easy. That will be explained in due time:

```
     message iteration step
Hello world!         1    0
Hello world!         1    1
Hello world!         1    2
Hello world!         1    3
```

The output consists of three columns, two more than the message we asked for. Consider the output of this slightly extended boxscript:

```
// hello_world2.box
Simulation sim {
  .iterations = 2
  .steps = 3
  OutputText {
    &message = "Hello world!"
    .ports = .[message]
  }
}
```

The output has now been doubled in length. You'll see two iterations producing four lines each:

```
     message iteration step
Hello world!         1    0
Hello world!         1    1
Hello world!         1    2
Hello world!         1    3
Hello world!         2    0
Hello world!         2    1
Hello world!         2    2
Hello world!         2    3
```

If you just write `head` then you will only see the first 6 lines of the output (mimicking the R `head` function). To see up to, say, 10 lines, you write

```
head 10
```

The `iteration` column counts the iterations starting from 1, while the `step` column counts the steps within each iteration starting from 0. These two loops, steps within iterations, are central to the [computational model](#computational-model) of Universal Simulator.

### Hello R!

While we achieved a quick response from our efforts at the prompt above, it is not very useful for simulation outputs that spans hundreds (or millions, there are no hard-coded limits) of lines. To process larger outputs we make use of R:

```
// hello_world3.box
Simulation sim {
  .iterations = 5
  .steps = 100
  OutputR {
    OutputText {
      &message = "Hello R!"
      .ports = .[message]
    }
  }
}
```

Among the status messages reported by Universal Simulator you will see

```
...
Executable R snippet copied to clipboard!
...
```

So, switch to R and paste the clipboard at the R prompt. There you will get this message reported by R:

```
Simulation output available in data frame 'sim' with 505 rows and 3 columns
```

If you inspect the sim data frame you will find the expected outputs. Look into [Running simulations](#running-simulations) for a demonstration of how simulation outputs can be shown in R plots, or continue your reading here to learn more about the data structures behind the boxscripts.

### Classes

A boxscript arranges objects in the well-known **composite pattern** ([GoF  1995](https://www.pearson.com/en-us/subject-catalog/p/Gamma-Design-Patterns-Elements-of-Reusable-Object-Oriented-Software/P200000009480/9780201633610)).  For this to work, all objects need to be of a class derived from a common base class. In the [BoxScript framework](#boxscript-framework) the common base class is `Node`:

<img src="https://tildeweb.au.dk/au152367/media/getting-started-class-diagram.svg" style="zoom:50%;" />

`Box` and `Port` are classes derived from `Node`. You can use `Box` directly in a boxscript as a simple container for other nodes but, more importantly, it serves as a base class for classes with various behaviours, such as `Simulation` and `OutputText`. You can use this command to see all the standard classes derived from `Box`:

```
help boxes
```

`Port` is a class that allows information to flow in and out of boxes.

### Objects

Object-oriented design invites the use of natural language for very specific meanings. Thus we will use 'node' to mean a `Node` object, 'box' to mean a `Box` object and 'port' to mean a `Port` object. Plural forms mean many such objects, e.g., 'boxes' mean some number of `Box` objects.

In the `hello_world2.box` script above, we created one `Simulation` box called `sim` and one `OutputText` box, which we left unnamed. We consider the latter the **child** of the former, its **parent**. They are both parts of this object diagram:

<img src="https://tildeweb.au.dk/au152367/media/getting-started-object-diagram.svg" style="zoom:50%;" />

The diagram shows five children of the `sim` box and two children of the `OutputText` box. There are three types of ports:

* Input
* Output
* Auxiliary

These different types of ports were not implemented as classes derived from `Port`. There is instead a `type` field in the `Port` class defining the type of the specific port. While the basic `Box` class comes with no ports defined, derived classes will usually be equipped with **input ports** to supply whatever parameters and variables are needed for their functionality. Note that BoxScript does not discern between fixed inputs (in other languages called parameters, constants or settings) and variable inputs (variables). They are all just considered inputs. 

**Output ports** (marked by an ''>'' above), on the other hand, provide access to the state of the box. You won't find all the output ports of all boxes in the boxscript represented as a column in the simulation output. Rather, you tell the `OutputText` box (or any other box providing output, e.g. for R plots) which ports you want included (through its `ports` input port; well, maybe I should have chosen another name for that one). However, the `iteration` and `step` outputs of the `Simulator` box are obligatory in the output, which is how we ended up with three columns in the output above.

You can use the **help** command together with a class name to see the input and output ports belonging to a class:

```
help Simulation
```

`help` will list the ports together with their [type](#port-types), their default value (inputs only), their unit (in brackets, may be unitless) and description. If the port defaults to an [expression](#expressions), the expression will be shown.

If you want to change the default value of an input port, you precede its name by a period and write its value, as seen in the `hello_world2.box` script:

```
Simulation sim {
  .steps = 3
}
```

The right-hand side may be a constant as above or a more complicated [expression](#expressions). Most importantly, you can refer to the value of another port providing a [path](#port-paths) to it:

```
OutputText {
  &message = "Hello world!"
  .ports = .[message]
}
```

The code above also exemplifies how to create an **auxiliary port**. You can equip any box with auxiliary ports of your own choice by preceding the port name with an ampersand `&`.

Shortly on paths: The port name is always written in brackets. If several ports happen to be on the path, you will get a vector of values. The value(s) found on the path will be converted to the type of the receiving input port as needed. Incompatible port types will result in a runtime error. The full description of [paths](#port-paths) and [port types](#port-types) is not overly complicated.

### Models

The complete boxscript describes a  **model** but often a single class or an object in itself defines a model. The [DayDegrees](#daydegrees) class, for example, defines a simple model of physiological development. So, does a concrete object of that class. Thus we may refer to a boxscript, a class or an object as a model. On the other hand, it would be confusing to call the [Calendar](#calendar) class a model, since it only role is to keep track of time.

### Demo boxscripts

First time you run Universal Simulator (or whenever you have installed a new version and the first time you run that), it will give birth to a new folder `UniversalSimulatorHome` inside your home folder. The home folder is easily found on a Mac or in Linux but is well hidden on Windows (where it seemingly doesn't feel right at home). On Windows you will find it inside `C:\users\your_name`.

You are told as much in the Welcome that greets you whenever you start Universal Simulator, here on a Windows computer:

```text
Work folder:
  absolute path 'C:/Users/your_name/UniversalSimulatorHome'
Input folder:
  relative path 'input' resolves to 'C:/Users/your_name/UniversalSimulatorHome/input'
Output folder:
  absolute path 'C:/Users/your_name/Documents/QDev/UniSim2/output'
```

You can also retrieve this information with the  [get folders](#get-folders) command:

```text
get folders
```

For a start, `UniversalSimulatorHome` is set as your *work folder*. Inside the work folder, you've always got two sub-folders, the *input folder* and the *output folder*, aptly named `input` and `output` by default. 

The `UniversalSimulatorHome/input` folder will be filled with all the example boxscripts found on this site and referred to in any publications that used Universal Simulator. You will find them in the `input/demo` and `input/papers` folders, respectively.

### User boxscripts

It is recommended that you create your own *work folder* for your models. Create a folder, maybe as a sub-folder of your `Documents` folder. You can call it, for instance, `BoxModels`. Inside that create a folder called `input`. You've now got these two empty folders:

* `Documents/BoxModels`
* `Documents/BoxModels/input`

Next, you need to tell Universal Simulator that `BoxModels` is your work folder. First, find the absolute path to your work folder. On Windows, use File Explorer: Right-click the `BoxModels` folder, choose Properties on the pop-up menu, select and copy the Location path. Paste this path as an argument to the [set folder work](#set-folder-work) command:

```
> set folder work C:/Users/your_name/Documents/BoxModels
Work folder:
  absolute path 'C:/Users/your_name/Documents/BoxModels'
Input folder:
  relative path 'input' resolves to 'C:/Users/your_name/Documents/BoxModels/input'
Output folder:
  relative path 'output' resolves to 'C:/Users/your_name/Documents/BoxModels/output'
```

Now, you are ready to keep your own boxscripts in the `BoxModels` folder. Create sub-folders inside BoxModels to organize your boxscripts as you wish.

If you need to revert to the default work folder (maybe to find the demo boxscripts more easily), use [HOME](#set-folder-work-home) as a magic folder name:

```
> set folder work HOME
Work folder:
  absolute path 'C:/Users/your_name/UniversalSimulatorHome'
Input folder:
  relative path 'input' resolves to 'C:/Users/your_name/UniversalSimulatorHome/input'
Output folder:
  absolute path 'C:/Users/your_name/Documents/QDev/UniSim2/output'
```

