package miosis.utility;

import luxe.Log.*;

class MiosisUtilities
{
	public static function clear(arr:Array<Dynamic>)
	{
        #if (cpp || php)
        arr.splice(0, arr.length);
        #else
        untyped arr.length = 0;
        #end
    }

    public static function bitwise_right_circular_shift(value:Int, shift:Int, bit_count:Int):Int
    {
        assert(bit_count <= 64, 'The bit count (${bit_count}) can not be higher than 64');
        assert(shift < bit_count, 'shift (${shift}) can not be higher than the bit count (${bit_count})');

        // TODO: Replace conversions and string mangling with bitwise ops
        var result_string = bitmask_int_to_string(value, bit_count);
        var split_index = result_string.length - shift;
        var overflow_string = result_string.substr(0, split_index);

        result_string = result_string.substr(split_index);
        result_string += overflow_string;

        log(result_string);

        return bitmask_string_to_int(result_string);
    }

    public static function bitmask_int_to_string(value:Int, size:Int = 64, spaced:Bool = false):String
    {
        var str = "";
        var i = size;

        while (i-- > 0)
        {
            if (spaced && i < size - 1 && (i + 1) % 4 == 0) 
            {
                str += " ";
            }

            if ((value & (1 << i)) > 0)
            {
                str += "1";
            }
            else
            {
                str += "0";
            }
        }

        return str;
    }

    public static function bitmask_string_to_int(str:String):Int
    {
        var value = 0;
        var i = 0;

        while (i < str.length)
        {
            if (str.charAt(i) == "1")
            {               
                value = value | (1 << (str.length - i - 1));              
            }

            ++i;
        }

        return value;
    }	
}