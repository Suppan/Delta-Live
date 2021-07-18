# **Delta-Live**

Application for generating a simple GUI based sample player using [SuperCollider](https://supercollider.github.io/download) and written in tcl-tk

## Why?

SuperCollider is a very stable application for concert situations. Playing soundfiles cued by an instrumental score needs a very simple/save usability when you have to follow the music and trigger the soundfiles via computer keyboard at the same time.


SuperCollider is a text based programming language. Changing things inside the code (i.e. changing a general volume of one soundfile) can easily produce syntax errors. Generating the code via "Delta-Live" prevents this issue.


Input:

- one or more folders with soundfiles (each folder becomes a row in the SuperCollider window)

Output:

- SuperCollider file ('out.scd')


Possible Treatments:

- change/edit volume manually by select and key-command '+'/'-'
- set volume to 0.0 dB by select and key-command '0'

## Download
[Delta-Live](https://github.com/Suppan/Delta-Live/releases/)

## Additional Software  

- [Tcl-Tk](https://www.tcl.tk) Version 8.6.11 (ie. via homebrew)

- [SuperCollider](https://supercollider.github.io/download)

## How to use

- start the application with the terminal command 'wish Main.tcl':
- load a new soundfile directory:

<div align="center"><img src="/resources/icons/app.png" width="800px"</img></div>  



- select a folder/struct (inside the sound folder, or everywhere else):

<div align="center"><img src="/resources/icons/folder-struct.png" width="600px"</img></div>  



- eval/write the SuperCollider patch:

<div align="center"><img src="/resources/icons/Code.png" width="800px"</img></div> 



- start patch in SuperCollider (cmd-a and cmd-return): Pressing the space key to play the first soundfile or move down or up with the arrow keys to select another soundfile for playing.  

<div align="center"><img src="/resources/icons/SC_window.png" width="600px"</img></div> 

*************
This program is free software. It is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY, without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
*************
