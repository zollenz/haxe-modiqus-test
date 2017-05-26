package luxetemplate.component;

import luxe.Component;
import luxe.Input;
import luxe.Log.*;
import luxe.Sprite;
import luxe.Vector;

import luxe.options.ComponentOptions;

class PlayerMovement extends Component
{
	public var movement_vector:Vector;
	public var sprite:Sprite;
	public var half_size:Float;

    public function new(?_options:ComponentOptions) 
    {
        _debug("---------- PlayerMovement.new ----------");        

        if (_options == null) 
        {
			_options = { name : "movement"};
        } 
        else if (_options.name == null)
        {
            _options.name = "movement";
        }

        super(_options);
    }

	public override function init() 
	{
		_debug("---------- PlayerMovement.init ----------");        
		
		movement_vector = new Vector();
		sprite = cast entity;

	    // Bind keys
	    Luxe.input.bind_key('left', Key.key_a);
	    Luxe.input.bind_key('left', Key.left);
	    Luxe.input.bind_key('right', Key.key_d);
	    Luxe.input.bind_key('right', Key.right);
		Luxe.input.bind_key('up', Key.key_w);
	    Luxe.input.bind_key('up', Key.up);
		Luxe.input.bind_key('down', Key.key_s);
	    Luxe.input.bind_key('down', Key.down);
	}

	public override function update(dt:Float) 
	{
		movement_vector.set_xyz(0, 0, 0); // Reset

		if(Luxe.input.inputdown('left')) 
		{
			movement_vector.x = -1;
		}

		if(Luxe.input.inputdown('right')) 
		{
			movement_vector.x = 1;
		}

		if(Luxe.input.inputdown('up')) 
		{
			movement_vector.y = -1;
		}

		if(Luxe.input.inputdown('down')) 
		{
			movement_vector.y = 1;
		}

		movement_vector.normalize();
		pos.add(movement_vector);

		if (pos.x < half_size) 
		{
			pos.x = half_size;
		}

		if (pos.x > (Main.w - half_size)) 
		{
			pos.x = Main.w - half_size;
		}

		if (pos.y < half_size) 
		{
			pos.y = half_size;
		}

		if (pos.y > (Main.h - half_size)) 
		{
			pos.y = Main.h - half_size;
		}
	}
}
