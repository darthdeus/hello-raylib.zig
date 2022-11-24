const std = @import("std");
const fs = std.fs;
// const exampleList = @import("src/examples.zig").exampleList;

pub const APP_NAME = "raylib-zig-examples";

const raylibSrc = "src/raylib/raylib/src/";
// const rayguiSrc = "raygui/raygui/src/";
const bindingSrc = "src/raylib/";

pub fn build(b: *std.build.Builder) !void {
    // try promptExample();

    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    std.log.info("building for desktop\n", .{});
    const exe = b.addExecutable(APP_NAME, "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);

    const rayBuild = @import("src/raylib/raylib/src/build.zig");
    const raylib = rayBuild.addRaylib(b, target);
    exe.linkLibrary(raylib);
    exe.addIncludePath(raylibSrc);
    // exe.addIncludePath(rayguiSrc);
    exe.addIncludePath(raylibSrc ++ "extras/");
    exe.addIncludePath(bindingSrc);
    // exe.addIncludePath("src/raygui");
    exe.addCSourceFile(bindingSrc ++ "marshal.c", &.{});
    // exe.addCSourceFile("src/raygui/raygui_marshal.c", &.{"-DRAYGUI_IMPLEMENTATION"});

    switch (raylib.target.getOsTag()) {
        //dunno why but macos target needs sometimes 2 tries to build
        .macos => {
            exe.linkFramework("Foundation");
            exe.linkFramework("Cocoa");
            exe.linkFramework("OpenGL");
            exe.linkFramework("CoreAudio");
            exe.linkFramework("CoreVideo");
            exe.linkFramework("IOKit");
        },
        .linux => {
            exe.addLibraryPath("/usr/lib64/");
            exe.linkSystemLibrary("GL");
            exe.linkSystemLibrary("rt");
            exe.linkSystemLibrary("dl");
            exe.linkSystemLibrary("m");
            exe.linkSystemLibrary("X11");
        },
        else => {},
    }

    exe.linkLibC();
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}

// fn promptExample() !void {
//     prompt: while (true) {
//         var buf: [4069]u8 = undefined;
//         var fba = std.heap.FixedBufferAllocator.init(&buf);
//         defer fba.reset();
//         const output = std.io.getStdOut();
//         var writer = output.writer();
//
//         try writer.writeAll("\n\nExamples:\n--------------------------------------------------\n");
//         for (exampleList) |example, i| {
//             defer fba.reset();
//             try writer.writeAll(try std.fmt.allocPrint(fba.allocator(), "{d}:\t{s}\n", .{ i + 1, example }));
//         }
//         try writer.writeAll("--------------------------------------------------\n\nSelect which example should be built: ");
//
//         const input = std.io.getStdIn();
//         var reader = input.reader();
//
//         const option = reader.readUntilDelimiterOrEofAlloc(fba.allocator(), '\n', buf.len) catch continue;
//         const nr = std.fmt.parseInt(usize, std.mem.trim(u8, option.?, " \t\n\r"), 10) catch |err| {
//             std.log.err("{?} in input: {?s}", .{ err, option });
//             continue;
//         };
//         fba.reset();
//
//         for (exampleList) |example, i| {
//             if (nr == i + 1) {
//                 var load_example = try std.fs.cwd().createFile("src/load_example.zig", .{});
//                 defer load_example.close();
//                 try load_example.writeAll(try std.fmt.allocPrint(fba.allocator(), "pub const name = \"{s}\";\n", .{example}));
//                 break :prompt;
//             }
//         }
//     }
// }
