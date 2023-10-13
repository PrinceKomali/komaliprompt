module display;
import std.array;
import std.conv;
import std.datetime;
import std.file;
import std.format;
import ansi;
import env;
import os;

enum BLOCK = "\ue0b0";
enum ARROW = "\u276f";
string pwd() {
    string cwd = getcwd().replace(get_env("HOME"), "~");
    version (Windows) {
        cwd = cwd.replace("\\", "/");
    }
    return cwd;
}

string pretty_pwd() {
    string p = color("path.fg");
    string colored_pwd = p ~ pwd()
        .replace("~", color("path.home") ~ "~" ~ p)
        .replace("/", color("path.slash") ~ "/" ~ p);
    return color("path") ~ colored_pwd ~ encode_ansi("0");
}

string funny_arrow() {
    return encode_ansi("3" ~ to!string(((Clock.currTime() -
            SysTime.fromUnixTime(0))
            .total!"msecs") % 6 + 1)) ~ ARROW ~ encode_ansi("0");
}

string pretty_user() {
    return color("block.user.bg") ~ color("block.user.fg") ~ get_env("USER") ~ color(
        "block.user") ~ fg(color("block.user.bg")) ~ color("block.os.bg") ~ BLOCK ~
        encode_ansi("0");
}

string pretty_os() {
    return color("block.os.bg") ~ color("block.os.fg") ~ get_os() ~ encode_ansi(
        "0") ~ fg(color("block.os.bg")) ~ BLOCK ~ encode_ansi("0");
}
