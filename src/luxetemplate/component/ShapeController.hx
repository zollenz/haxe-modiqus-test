package luxetemplate.component;

import luxe.Component;
import luxe.Input;
import luxe.Log.*;
import luxe.Visual;

import luxe.options.ComponentOptions;
import luxe.tween.Actuate;
import luxe.tween.actuators.GenericActuator;
import luxe.utils.Maths;

import modiqus.Modiqus;

typedef ShapeControllerOptions = 
{
    > ComponentOptions,
	var csound_instrument:String;
}

class ShapeController extends Component
{
	private var _visual:Visual;
	private var _delay:Float;
    private var _scale_min:Float;    
    private var _scale_max:Float; 
    private var _tween:IGenericActuator;
    private var _tween_time:Float;
    private var _tween_active:Bool;
    private var _csound_instrument:String;

    public function new(options:ShapeControllerOptions) 
    {
        _debug("---------- ShapeController.new ----------");        

		if (options.name == null)
        {
            options.name = "synthobject";
        }

        _visual = null;
        _delay = -1;
        _scale_min = -1;
        _scale_max = -1;
        _tween = null;
        _tween_time = 0;
        _tween_active = false;
        _csound_instrument = options.csound_instrument; // TODO: check for empty or null        

		Modiqus.setControlChannel(_csound_instrument + ".NoteAmplitude", 0.0);
		Modiqus.sendMessage("i " + _csound_instrument + " 0 -1 1 261.63");         

        super(options);
    }

	public override function init() 
	{
		_debug("---------- ShapeController.init ----------");
		
	    // Bind keys
	    Luxe.input.bind_key('reset', Key.key_r);
	}

	public override function onadded():Void
	{
		_debug("---------- ShapeController.onadded ----------");

    	_visual = cast entity;
		_delay = Math.random() * 2;
        _scale_min = _visual.scale.x;
        _scale_max = _visual.scale.x * (1 + Math.random());
	    _tween = Actuate.tween(_visual.scale, 0.5 + Math.random(), {x : _scale_max * _visual.scale.x, y : _scale_max * _visual.scale.y})
            .reflect()
            .repeat()
            .onRepeat(on_tween_repeat, [])
            .ease(luxe.tween.easing.Elastic.easeIn);
            // .ease(luxe._tween.easing.Linear.easeNone);            
            // .ease(luxe._tween.easing.Cubic.easeIn);
        Actuate.pause(_tween);
	}

	private function on_tween_repeat():Void
    {
        Actuate.pause(_tween);
        _tween_active = false;
        // var color = Color.random();
        // _circles[i].color = color;
    }

	public override function update(dt:Float):Void
	{
		// _debug("---------- ShapeController.update ----------");

        if (_tween_active)
        {
            // Tweak audio params
            // log(_circles[i].scale);
            var amplitude = (_visual.scale.x - _scale_min) / (_scale_max - _scale_min);
            amplitude = Maths.clamp(amplitude, 0, 1);
            amplitude *= 0.5;
            // log("Scale : " + _circles[i].scale);                                
            // log("Amplitude : " + amplitude); 

            Modiqus.setControlChannel(_csound_instrument + ".NoteAmplitude", amplitude);
        }
        else
        {
            _tween_time += dt;                
        }

        if (_tween_time >= _delay)
        {
            Actuate.resume(_tween);
            _tween_time = Math.random() * 8;
            _tween_active = true;
        }

		if(Luxe.input.inputdown('reset')) 
		{
			// Re-initialise
		}
	}
}