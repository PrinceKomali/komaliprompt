# Komali's Prompt
This is the prompt I use on most of my devices. I use it because it's minimal, yet colorful, and lets me differentiate between what device I'm on (such as when using `ssh`). It spawns no external processes and it's written in D, so it's 🚀 blazing fast 🚀
## Building
Building this project requires a D compiler and `dub`, D's packaging tool. Simply clone the repository and run `dub` or `dub build` to build the executable
## Config
The prompt doesn't have any config but you can specify command line arguments to it:
`---color/-c <field> <ansi>`: Sets the color of the field to the ansi provided (e.g. `38;2;255;0;255`). Keys can be found in `./src/ansi.d`  
`--home/-h`: Set's the home directory to replace with `~` in the path  
`--os/-o <name>`: Changes the OS in the second block
`--user/-u <name>`: Changes the user name in the first block
`--zsh/bash`: Wraps ansi escape codes in `%{ %}` and `\[ \]` respectively
## Usage
Here are the shells I've made it work for:
- zsh
```bash
# ~/.zshrc
precmd()  {
    PROMPT=$(/path/to/prompt --zsh)
}
```
- bash
```bash
# ~/.bashrc
prompt() {
    PS1=$(/path/to/prompt --bash)
}
```
- PowerShell
```ps1
# $Profile
$OutputEncoding  =  [console]::InputEncoding =  [console]::OutputEncoding =  New-Object System.Text.UTF8Encoding
function prompt() {
    path\to\prompt.exe
}
```
Other shells probably work as well, I just haven't tested them yet
