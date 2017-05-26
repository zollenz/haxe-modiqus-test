package luxetemplate.component;

import luxe.Component;
import luxe.Input;
import luxe.Log.*;
import luxe.Sprite;
import luxe.Vector;

import luxe.utils.Maths;

import luxe.options.ComponentOptions;

class PlayerPhysics extends Component
{
    var move_speed:Int;
    var jump_force:Int;
	var max_velocity:Int;
    var air_velocity:Int;
    var jumps_available:Int;
    var damp:Float;
    var damp_air:Float;

	var movement_vector:Vector;
	var sprite:Sprite;

    public function new(?_options:ComponentOptions) 
    {
        _debug("---------- PlayerPhysics.new ----------");        

        if (_options == null) 
        {
            _options = { name : "physics"};
        } 
        else if (_options.name == null)
        {
            _options.name = "physics";
        }

        super(_options);
    }

	public override function init() 
	{
		_debug("---------- PlayerPhysics.init ----------");
		
		movement_vector = new Vector();
		sprite = cast entity;

		// Variables
		max_velocity = 50;
		air_velocity = 60;
		move_speed = 600;
		jump_force = 200;
		damp = 0.72;
		damp_air = 0.9;
		jumps_available = 0;

	    // Key bindings
	    Luxe.input.bind_key('left', Key.key_a);
	    Luxe.input.bind_key('left', Key.left);
	    Luxe.input.bind_key('right', Key.key_d);
	    Luxe.input.bind_key('right', Key.right);
        Luxe.input.bind_key('jump', Key.key_w);
        Luxe.input.bind_key('jump', Key.up);
        Luxe.input.bind_key('jump', Key.space);

        // Gamepad bindings
		#if web
	        Luxe.input.bind_gamepad('jump', Constants.GamepadMappings.get("ps3_web").get("button_cross"));
	        Luxe.input.bind_gamepad('jump', Constants.GamepadMappings.get("xbox360_web").get("button_cross"));
		#end

		#if mac
	        Luxe.input.bind_gamepad('jump', Constants.GamepadMappings.get("ps3_mac").get("button_cross"));
			Luxe.input.bind_gamepad('jump', Constants.GamepadMappings.get("xbox360_mac").get("button_cross"));	        
		#end

	}

	public override function ongamepaddown( event:GamepadEvent ) 
	{
		// if (event.button >= 4)
			// log(event);
	}

    public override function ongamepadaxis( event:GamepadEvent )
    {
   //  	if (Math.abs(event.value) > 0.2)
			// log(event);
    }

	public override function update(dt:Float) 
	{
		movement_vector.set_xyz(0, 0, 0); // Reset

		if (Luxe.input.inputdown('left')) 
		{
            Main.physics.player_velocity.x -= move_speed * dt;
		}
		else if (Luxe.input.inputdown('right')) 
		{
            Main.physics.player_velocity.x += move_speed * dt;
		}
		else
		{
            if (Main.physics.player_can_jump) 
            {
                Main.physics.player_velocity.x *= damp;
            } 
            else 
            {
                Main.physics.player_velocity.x *= damp_air;
            }
		}

		if (Main.physics.player_can_jump) 
		{
            jumps_available = 2;
        }

        if (jumps_available > 0 && Luxe.input.inputpressed('jump')) 
        {
            Main.physics.player_velocity.y = -jump_force;
            --jumps_available;
        }

		Main.physics.player_collider.position.x = Maths.clamp(Main.physics.player_collider.position.x, 4, 256 - 4);
        pos.copy_from(Main.physics.player_collider.position);

        var _max_vel = (Main.physics.player_can_jump) ? max_velocity : air_velocity;
        Main.physics.player_velocity.x = Maths.clamp(Main.physics.player_velocity.x, -_max_vel, _max_vel);
	}
}
