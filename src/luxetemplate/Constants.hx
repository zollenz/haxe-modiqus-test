package luxetemplate;

import luxe.Color;

class Constants
{

	public static function clear(arr:Array<Dynamic>)
	{
#if (cpp||php)
		arr.splice(0, arr.length);
#else
		untyped arr.length = 0;
#end
	}

	// Basic colors
	public static inline var COLOR_BLACK:Int = 0x000000;
	public static inline var COLOR_WHITE:Int = 0xffffff;
	public static inline var COLOR_RED:Int = 0xFF0000;
	public static inline var COLOR_GREEN:Int = 0x00FF00;
	public static inline var COLOR_BLUE:Int = 0x0000FF;	

	// // Game Boy palette, gray 1
	public static inline var COLOR_GB_1_OFF:Int = 0xffffff;
	public static inline var COLOR_GB_1_LIGHT:Int = 0xb2b2b2;
	public static inline var COLOR_GB_1_MEDIUM:Int = 0x757575;
	public static inline var COLOR_GB_1_DARK:Int = 0x000000;

	// Game Boy palette, gray 2
	public static inline var COLOR_GB_2_OFF:Int = 0xefefef;
	public static inline var COLOR_GB_2_LIGHT:Int = 0xb2b2b2;
	public static inline var COLOR_GB_2_MEDIUM:Int = 0x757575;
	public static inline var COLOR_GB_2_DARK:Int = 0x383838;

	// // Game Boy palette, green 1
	public static inline var COLOR_GB_3_OFF:Int = 0x9BBC0F;
	public static inline var COLOR_GB_3_LIGHT:Int = 0x8BAC0F;
	public static inline var COLOR_GB_3_MEDIUM:Int = 0x306230;
	public static inline var COLOR_GB_3_DARK:Int = 0x0F380F;

	// // Game Boy palette, green 2
	public static inline var COLOR_GB_4_OFF:Int = 0xb7dc11;
	public static inline var COLOR_GB_4_LIGHT:Int = 0x88a808;
	public static inline var COLOR_GB_4_MEDIUM:Int = 0x306030;
	public static inline var COLOR_GB_4_DARK:Int = 0x083808;

	// // Game Boy palette, yellow
	public static inline var COLOR_GB_5_OFF:Int = 0xfff77b;
	public static inline var COLOR_GB_5_LIGHT:Int = 0xb5ae4a;
	public static inline var COLOR_GB_5_MEDIUM:Int = 0x6b6931;
	public static inline var COLOR_GB_5_DARK:Int = 0x212010;

	public static var GamepadMappings:Map<String, Map<String, Int>> = 
	[
		"ps3_mac" => 
			[
				"button_cross" => 0,
				"button_circle" => 1,
				"button_square" => 2,
				"button_triangle" => 3,
				"button_select" => 4,
				"button_home" => 5,
				"button_start" => 6,
				"button_left_stick" => 7,
				"button_right_stick" => 8,				
				"button_left_shoulder" => 9,
				"button_right_shoulder" => 10,
				"button_dpad_up" => 11,
				"button_dpad_down" => 12,
				"button_dpad_left" => 13,
				"button_dpad_right" => 14,
				"axis_stick_left_x" => 0,				
				"axis_stick_left_y" => 1,
				"axis_stick_right_x" => 2,
				"axis_stick_right_y" => 3,				
				"axis_trigger_left" => 4,
				"axis_trigger_right" => 5,
			],
		"ps3_web" => 
			[// Firefox
				"button_cross" => 14,
				"button_circle" => 13,
				"button_square" => 12,
				"button_triangle" => 15,
				"button_select" => 0,
				"button_home" => 16,
				"button_start" => 3,
				"button_left_stick" => 1,
				"button_right_stick" => 2,				
				"button_left_shoulder" => 10,
				"button_right_shoulder" => 11,
				"button_dpad_up" => 4,
				"button_dpad_down" => 6,
				"button_dpad_left" => 7,
				"button_dpad_right" => 5,
				"button_trigger_left" => 8,
				"button_trigger_right" => 9,				
				"axis_stick_left_x" => 0,				
				"axis_stick_left_y" => 1,
				"axis_stick_right_x" => 2,
				"axis_stick_right_y" => 3
			],
		"xbox360_mac" => 
			[
				"button_cross" => 0,
				"button_circle" => 1,
				"button_square" => 3,
				"button_triangle" => 2,
				"button_select" => 4,
				"button_home" => 5,
				"button_start" => 6,
				"button_left_stick" => 7,
				"button_right_stick" => 8,				
				"button_left_shoulder" => 9,
				"button_right_shoulder" => 10,
				"button_dpad_up" => 11,
				"button_dpad_down" => 12,
				"button_dpad_left" => 13,
				"button_dpad_right" => 14,
				"axis_stick_left_x" => 0,				
				"axis_stick_left_y" => 1,
				"axis_stick_right_x" => 2,
				"axis_stick_right_y" => 3,				
				"axis_trigger_left" => 4,
				"axis_trigger_right" => 5,
			],
		"xbox360_web" => 
			[// Firefox
				"button_cross" => 11,
				"button_circle" => 12,
				"button_square" => 14,
				"button_triangle" => 13,
				"button_select" => 5,
				"button_home" => 10,
				"button_start" => 4,
				"button_left_stick" => 6,
				"button_right_stick" => 7,				
				"button_left_shoulder" => 8,
				"button_right_shoulder" => 9,
				"button_dpad_up" => 0,
				"button_dpad_down" => 1,
				"button_dpad_left" => 2,
				"button_dpad_right" => 3,
				"axis_stick_left_x" => 0,				
				"axis_stick_left_y" => 1,
				"axis_stick_right_x" => 3,
				"axis_stick_right_y" => 4,				
				"axis_trigger_left" => 2,
				"axis_trigger_right" => 5,
			],
	];
}
