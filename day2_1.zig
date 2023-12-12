const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const data = try std.fs.cwd().readFileAlloc(allocator, "day2_data.txt", 66666666);
    std.debug.print("{d}", .{try solution(data)});
}

fn solution(data: []const u8) !u32 {
    var acc: u32 = 0;
    var game: u32 = 0;
    const maxR = 12;
    const maxG = 13;
    const maxB = 14;
    var lines = std.mem.splitScalar(u8, data, '\n');

    lineLoop: while (lines.next()) |line| {
        var part = std.mem.tokenizeAny(u8, line, " :;,");
        _ = part.next() orelse break;
        game = try std.fmt.parseInt(u32, part.next() orelse break, 10);

        while(part.next()) |token| {
            const amount: u32 = try std.fmt.parseInt(u32, token, 10);
            const colour: u8 = (part.next() orelse break :lineLoop)[0];
            if (colour == 'r' and amount > maxR) continue :lineLoop;
            if (colour == 'g' and amount > maxG) continue :lineLoop;
            if (colour == 'b' and amount > maxB) continue :lineLoop;
        }
        acc += game;
    }
    return acc;
}

test {
    try std.testing.expect(try solution(
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
    ) == 8);
}