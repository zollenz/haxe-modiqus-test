package luxetemplate.state;

import luxe.Color;
import luxe.Log.*;
import luxe.Vector;
import luxe.Visual;

import luxetemplate.entity.Circle;
import luxetemplate.entity.Triangle;
import luxetemplate.component.ShapeController;

import modiqus.Modiqus;

class Synth extends BaseState 
{
    var _shapes:Array<Visual>;
    var _circle_count:Int;

	public function new() 
	{
        _debug("---------- Synth.new ----------");

        _circle_count = 4;

        super({ name:'synth', fade_in_time:0.5, fade_out_time:0.5 });
    }

	override function onenter<T>(_:T) 
	{
        _debug("---------- Synth.onenter ----------");

		// Set background color
	    Luxe.renderer.clear_color = new Color().rgb(Constants.COLOR_GB_2_LIGHT);

        _shapes = new Array<Visual>();

        // Create circles
        for (i in 0..._circle_count)
        {
            var circle:Circle = create_circle();
            circle.name += "_" + i;
            
            var shapeController:ShapeController = new ShapeController({
                name : "synth_controller_" + i,
                csound_instrument : "1.00000" + i
                });
            
            circle.add(shapeController);
            _shapes.push(circle);
        }

        // Create triangles

        super.onenter(_);		
    }

    private function create_circle():Circle
    {
        // TODO: use scaleMax when setting position
        var radius = Main.h * 0.05 + Math.random() * Main.h * 0.05;
        // var radius = Main.h * 0.05;        
        radius = Math.ffloor(radius);
        var position:Vector = new Vector();        
        var distance:Float = 0.0;
        var position_found:Bool = false;   

        while (!position_found)
        {
            position.x = radius + Math.random() * (Main.w - 2 * radius);
            position.x = Math.ffloor(position.x);
            position.y = radius + Math.random() * (Main.h - 2 * radius);
            position.y = Math.ffloor(position.y);

            position_found = true;

            for (i in 0..._shapes.length)
            {
                distance = Vector.Subtract(_shapes[i].pos, position).length;

                // log("distance1 -- " + distance);
                // log("distance2 -- " + (_shapes[i].radius + radius));

                if (distance < radius)
                {
                    position_found = false;
                    continue;
                }
            }
        }

        var color = Color.random();
        color.a = 0.5 + Math.random() * 0.2;

        var circle = new Circle({
            pos : position,
            color : color,
            size : new Vector(10, 10)
        });

        return circle;
    }

    private function create_triangle():Triangle
    {
        // TODO: use scaleMax when setting position
        var radius = Main.h * 0.05 + Math.random() * Main.h * 0.05;
        // var radius = Main.h * 0.05;        
        radius = Math.ffloor(radius);
        var position:Vector = new Vector();        
        var distance:Float = 0.0;
        var position_found:Bool = false;   

        while (!position_found)
        {
            position.x = radius + Math.random() * (Main.w - 2 * radius);
            position.x = Math.ffloor(position.x);
            position.y = radius + Math.random() * (Main.h - 2 * radius);
            position.y = Math.ffloor(position.y);

            position_found = true;

            for (i in 0..._shapes.length)
            {
                distance = Vector.Subtract(_shapes[i].pos, position).length;

                // log("distance1 -- " + distance);
                // log("distance2 -- " + (_shapes[i].radius + radius));

                if (distance < radius)
                {
                    position_found = false;
                    continue;
                }
            }
        }

        var color = Color.random();
        color.a = 0.5 + Math.random() * 0.2;

        var triangle = new Triangle({
            pos : position,
            color : color,
            size : new Vector(10, 10)
        });

        return triangle;
    }

    override function onleave<T>( _data:T ) 
    {
        _debug("---------- Synth.onleave ----------");
        
        super.onleave(_data);
    }

    override function post_fade_in()
    {
        _debug("---------- Synth.post_fade_in ----------");
    }

    public override function update(dt:Float) 
    {
    }
}
