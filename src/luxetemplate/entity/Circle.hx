package luxetemplate.entity;

import luxe.Color;
import luxe.Log.*;
import luxe.Sprite;
import luxe.Vector;
import luxe.Visual;

import luxe.options.VisualOptions;

class Circle extends Visual 
{
    public function new(?options:VisualOptions) 
    {   
        _debug("---------- Circle.new ----------");

        if (options == null) 
        {
            options = { 
                name : "circle",
                pos : new Vector(0.5 * Main.w, 0.5 * Main.h),
                color : new Color(1, 1, 1, 1)
            };
        } 
        else if (options.name == null)
        {
            options.name = "circle";
        }

        options.geometry = Luxe.draw.circle({
            r : options.size.x * 0.5,
            color : options.color
        });   

        super(options);
    }
}
