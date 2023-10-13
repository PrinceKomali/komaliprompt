import std.format;
import std.stdio;
import env;
import display;
import os;

void main(string[] argv) {
    version (Windows) {
        import core.sys.windows.windows : SetConsoleOutputCP;

        SetConsoleOutputCP(65_001);
    }
    parse_args(argv);
    write(format("%s%s:%s %s ", pretty_user(), pretty_os(), pretty_pwd(), funny_arrow()));
    stdout.flush();
}
