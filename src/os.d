module os;
import std.algorithm;
import std.conv;
import std.file;
import std.math : floor;
import std.process;
import std.stdio;
import std.string;
import env;

string get_os() {
    string env_os = get_env("_os");
    if(env_os != "") return env_os;
    version (Windows) {
        string arch = environment.get("PROCESSOR_ARCHITECTURE");
        return "Win" ~ (arch == "AMD64" ? "64" : "32");
    }
    version (linux) {
        string proc_version = to!string(read("/proc/version"));
        if (proc_version.findSplit("Microsoft"))
            return "WSL";
        string os_release = to!string(read("/etc/os-release"));
        string pretty_name = os_release.split("\n")[1]
            .replace("PRETTY_NAME=", "").split("\"")[1];
        string dist = pretty_name
            .replace("GNU/Linux", "")
            .replace("Linux", "")
            .strip();
        return dist;
    }
    version (OSX) {
        string system_version =
            to!string(read("/System/Library/CoreServices/SystemVersion.plist"))
            .split("<key>ProductVersion</key>")[1].split("<string>")[1].split("</string>")[0];
        string[] version_parts = system_version.split(".");
        float version_f = to!float(version_parts[0] ~ "." ~ version_parts[1]);
        if (version_f < 10.12)
            return "OS X";
        if (version_f > 11)
            version_f = floor(version_f);
        if(version_f > 14) /* ??? */ return "macOS";
        string[float] versions = [
            10.12: "Sierra",
            10.13: "High Sierra",
            10.14: "Mojave",
            10.15: "Catalina",
            10.16: "Big Sur",
            11: "Big Sur",
            12: "Monterey",
            13: "Ventura",
            14: "Sonoma"
        ];
        if(version_f in versions) return versions[version_f];
        return "macOS";
    }
    assert(0); // gdc complains if this isn't here but it shouldn't matter
}
