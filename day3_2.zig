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
    //algorithm only works if [0] is not * but idc
    const data = try std.fs.cwd().readFileAlloc(allocator, "day3_data.txt", 1 << 63);
    std.debug.print("{d}", .{try solution(data, allocator)});
}

const Gears = struct {
    first: u32,
    second: u32
};

fn solution(data: []const u8, allocator: std.mem.Allocator) !u32 {
    const length = (std.mem.indexOf(u8, data, "\n") orelse return 0) + 1;
    var num: u32 = 0;
    var gearIndex: ?usize = null;
    var gears = try allocator.alloc(Gears, data.len);
    @memset(gears, .{.first = 0, .second = 0});

    for(data, 0..) |char, i| {
        if (char < '0' or char > '9') continue;
        num = num*10 + char - '0';

        //[0][1][2]
        //[3][*][4]
        //[5][6][7]
        const offsets = .{
            @max(i,length+1)-length-1,
            @max(i,length)-length,
            @max(i,length-1)+1-length,
            @max(i,1)-1,
            @min(i+1,data.len),
            @min(i+length-1,data.len-1),
            @min(i+length,data.len-1),
            @min(i+length+1,data.len-1)
        };
        if (gearIndex == null) gearIndex = 
            if (data[offsets[0]] == '*') offsets[0]
            else if (data[offsets[3]] == '*') offsets[3]
            else if (data[offsets[5]] == '*') offsets[5]
            else null;
            
        if (!std.ascii.isDigit(data[offsets[4]])) {

            if (gearIndex == null) gearIndex = 
                if (data[offsets[1]] == '*') offsets[1]
                else if (data[offsets[2]] == '*') offsets[2]
                else if (data[offsets[4]] == '*') offsets[4]
                else if (data[offsets[6]] == '*') offsets[6]
                else if (data[offsets[7]] == '*') offsets[7]
                else null;

            const gear = gearIndex orelse {num = 0; continue;};
            const currGear = gears[gear];

            if (currGear.first == 0) gears[gear].first = num
            else if (currGear.second == 0) gears[gear].second = num
            else gears[gear] = Gears{.first = 0, .second = 0};

            gearIndex = null;
            num = 0;
        }
    }
    var acc: u32 = 0;
    for (gears) |gear| {
        acc += gear.first * gear.second;
    }
    allocator.free(gears);
    return acc;
}

test {
    try std.testing.expect((try solution(testdata, std.testing.allocator)) == 467835);
}