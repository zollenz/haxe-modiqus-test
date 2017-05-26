package luxetemplate.entity;

import luxe.Color;
import luxe.Log.*;
import luxe.Sprite;
import luxe.Vector;
import luxe.Visual;

import luxe.options.VisualOptions;

// typedef TriangleOptions = 
// {
//     > VisualOptions,
//     var radius:String;
// }

class Triangle extends Visual 
{
    public function new(?options:VisualOptions) 
    {   
        _debug("---------- Triangle.new ----------");

        if (options == null) 
        {
            options = { 
                name : "Triangle",
                pos : new Vector(0.5 * Main.w, 0.5 * Main.h),
                color : new Color(1, 1, 1, 1)
            };
        } 
        else if (options.name == null)
        {
            options.name = "triangle";
        }

        options.geometry = Luxe.draw.ngon({
            sides : 3,
            color : new Color(1, 0, 1, 0.8),
            x : Main.w, 
            y : Main.h,
            r : options.size.x * 0.5            
        });   

        super(options);
    }
}
