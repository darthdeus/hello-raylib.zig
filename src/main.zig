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
