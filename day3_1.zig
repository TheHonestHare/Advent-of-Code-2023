const std = @import("std");
const testdata = 
        \\467..114..
        \\...*......
        \\..35..633.
        \\......#...
        \\617*......
        \\.....+.58.
        \\..592.....
        \\......755.
        \\...$.*....
        \\.664.598..
        ;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const data = try std.fs.cwd().readFileAlloc(allocator, "day3_data.txt", 1 << 63);
    std.debug.print("{d}", .{solution(data)});
}

fn solution(data: []const u8) u32 {
    const length = (std.mem.indexOf(u8, data, "\n") orelse return 0) + 1;
    var acc: u32 = 0;
    var num: u32 = 0;
    var isPart: bool = false;

    for(data, 0..) |char, i| {
        if (char < '0' or char > '9') continue;
        num = num*10 + char - '0';
        if (!std.ascii.isDigit(data[@min(i+1,data.len-1)])) {
            if (isPart or isSymbol(data[@max(i,length+1)-length-1])
                       or isSymbol(data[@max(i,length)-length]) 
                       or isSymbol(data[@max(i,length-1)+1-length]) 
                       or isSymbol(data[@min(i+1,data.len)]) 
                       or isSymbol(data[@min(i+length-1,data.len-1)]) 
                       or isSymbol(data[@min(i+length,data.len-1)])
                       or isSymbol(data[@min(i+length+1,data.len-1)]) )
            { 
                acc += num;
                isPart = false;
            }
            num = 0;
            continue;

            
        }
        if (isPart) continue;
        isPart = isSymbol(data[@max(i,length+1)-length-1]) or isSymbol(data[@max(i,1)-1]) or isSymbol(data[@min(i+length-1,data.len-1)]);
    }
    return acc;
}

fn isSymbol(char: u8) bool {
    return !(char >= '0' and char <= '9') and char != '.' and char != '\n';
}

test {
    try std.testing.expect(solution(testdata) == 4361);
}