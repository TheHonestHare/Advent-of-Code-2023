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

const alphanum = .{"one","two","three","four","five","six","seven","eight","nine"};
fn isANumber(str: []const u8) u8 {
    inline for (alphanum, 1..) |number, pos| {
        if(std.mem.endsWith(u8, str, number)) {
            return pos;
        }
    }
    return 0;
}

fn solution(data: []const u8) u32 {
    var acc: u32 = 0;
    var isFirst: bool = true;
    var lastDigit: u8 = undefined;
    for (data, 0..) |char, i| {
    
        if (char == '\n' or char == '\x00') {
            acc += lastDigit;
            isFirst = true;
            continue;
        }
        if (char == 'e' or char == 'o' or char == 'r' or char == 'x' or char == 'n' or char == 't') {
            inline for (alphanum, 1..) |number, pos| {
                if(std.mem.endsWith(u8, data[@max(i,4)-4..i+1], number)) {
                    if (isFirst) {
                        acc += @as(u32, pos) * 10;
                        isFirst = false;
                    }
                    lastDigit = pos;
                    break;
                }
                continue;
            }
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

test {
    try std.testing.expect(solution("two1nine\n") == 29);
}