const std = @import("std");
const pdapi = @import("playdate_api_definitions.zig");

var g_playdate_image: *pdapi.LCDBitmap = undefined;

pub export fn eventHandler(playdate: *pdapi.PlaydateAPI, event: pdapi.PDSystemEvent, arg: u32) c_int {
    //TODO: replace with your own code!

    _ = arg;
    switch (event) {
        .EventInit => {
            g_playdate_image = playdate.graphics.loadBitmap("playdate_image", null).?;

            playdate.system.setUpdateCallback(update_and_render, playdate);
        },
        else => {},
    }
    return 0;
}

fn update_and_render(userdata: ?*anyopaque) callconv(.C) c_int {
    //TODO: replace with your own code!

    const playdate = @ptrCast(*pdapi.PlaydateAPI, @alignCast(@alignOf(pdapi.PlaydateAPI), userdata.?));
    const to_draw = "Hello from Zig!";

    const pixel_width = playdate.graphics.drawText(to_draw, to_draw.len, .UTF8Encoding, 0, 0);
    _ = pixel_width;
    playdate.graphics.drawBitmap(g_playdate_image, pdapi.LCD_COLUMNS / 2 - 16, pdapi.LCD_ROWS / 2 - 16, .BitmapUnflipped);

    //returning 1 signals to the OS to draw the frame.
    //we always want this frame drawn
    return 1;
}

