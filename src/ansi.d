module ansi;
import std.array;
import env;
import std.stdio;
string encode_ansi(string s) {
    string mode = get_shell_mode();
    string ansi_raw = "\x1b[" ~ s ~ "m";
    if (mode == "zsh")
        return "%{" ~ ansi_raw ~ "%}";
    if (mode == "bash")
        return "\\[" ~ ansi_raw ~ "\\]";
    return ansi_raw;
}
string fg(string c) {
    // if(c[$-1] == 'm') c = c[0..$-1];
    string[] parsed = [];
    foreach(string part; c.split(";")) {
        if(part.length == 2 && part[0] == '4') part = "3" ~ part[1];
        parsed ~= part;
    }
    return parsed.join(";");
}
string color(string s) { return color(s, false); }
string color(string s, bool switch_fg) {
    string col = "";
    string col_env = get_env("color." ~ s);
    if(col_env != "") col = col_env;
    else switch (s) {
    case "block.user.bg":
        col = "48;5;208";
        break;
    case "block.user.fg":
        col = "37;1";
        break;
    case "block.os.bg":
        col = "46";
        break;
    case "block.os.fg":
        col = "38;2;100;100;100;1";
        break;
    case "path.fg":
        col = "0;38;5;195";
        break;
    case "path.bg":
        col = "48";
        break;
    case "path.slash":
        col = "34;1";
        break;
    case "path.home":
        col = "32;1";
        break;
    default:
        col = "0";
        break;
    }
    if(switch_fg) col = fg(col);
    return encode_ansi(col);
}
