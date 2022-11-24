const std = @import("std");
const raylib = @import("raylib/raylib.zig");

pub fn main() !void {
    raylib.InitWindow(800, 800, "hello");
    raylib.SetConfigFlags(.FLAG_WINDOW_RESIZABLE);

    defer raylib.CloseWindow();

    while (!raylib.WindowShouldClose()) {
        raylib.BeginDrawing();
        defer raylib.EndDrawing();

        raylib.ClearBackground(raylib.BLACK);
        raylib.DrawText("ZigZigZig", 100, 100, 30, raylib.YELLOW);
        raylib.DrawFPS(10, 10);
    }
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
