const std = @import("std");


pub fn main() !void {
    const file = try std.fs.cwd().openFile("day1_data.txt", .{});
    defer file.close();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    const allocator = gpa.allocator();
    const data = try file.readToEndAlloc(allocator, 66666666);
    defer allocator.free(data);
    std.debug.print("{d}", .{solution(data)});
}

fn solution(data: []const u8) u32 {
    var acc: u32 = 0;
    var isFirst: bool = true;
    var lastDigit: u8 = undefined;
    for (data) |char| {
    
        if (char == '\n' or char == '\x00') {
            acc += lastDigit;
            isFirst = true;
            continue;
        }
        if (char < '0' or char > '9') continue;
        if (isFirst) {
            acc += (char - '0') * 10;
            isFirst = false;
        }
        lastDigit = char - '0';
    }
    return acc;
}