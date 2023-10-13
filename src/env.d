module env;
import std.algorithm;
import std.array;
import std.process;
import std.stdio;

string[string] cli_env;
immutable string[string] win_equivs;
shared static this() {
    win_equivs["USER"] = "USERNAME";
    win_equivs["HOME"] = "USERPROFILE";
}

string mode = "";
string get_shell_mode() {
    return mode;
}

string get_env(string var) {
    if (var in cli_env)
        return cli_env[var];
    version (Windows)
        if (var in win_equivs)
            var = win_equivs[var];
    return environment.get(var);
}

void parse_args(string[] argv) {
    string[] args = [];
    foreach (string arg; argv) {
        if (arg.startsWith("--"))
            args ~= arg[2 .. $];
        else if (arg.startsWith("-")) {
            foreach (string a; arg[1 .. $].split("")) {
                args ~= a;
            }
        } else
            args ~= arg;
    }
    args.popFront(); // get rid of exe
    while (args.length > 0) {
        string arg = args[0];
        args.popFront();
        switch (arg) {
            // shells
        case "bash":
            mode = "bash";
            break;
        case "zsh":
            mode = "zsh";
            break;
        case "color":
        case "c":
            if (args.length < 2) {
                writeln("Need 2 arguments for --color");
                break;
            }
            cli_env["color." ~ args[0]] = args[1];
            args.popFront();
            args.popFront();
            break;
        case "home":
        case "h":
            if (args.length < 1) {
                writeln("Need another argument for --home");
                break;
            }
            cli_env["HOME"] = args[0];
            args.popFront();
            break;
        case "user":
        case "u":
            if (args.length < 1) {
                writeln("Need another argument for --user");
                break;
            }
            cli_env["USER"] = args[0];
            args.popFront();
            break;
        case "os":
        case "o":
            if (args.length < 1) {
                writeln("Need another argument for --user");
                break;
            }
            cli_env["_os"] = args[0];
            args.popFront();
            break;
        default:
            writeln("Unknown argument: " ~ arg);
            break;
        }
    }
}
