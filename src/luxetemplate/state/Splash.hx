package luxetemplate.state;

import luxe.Color;
import luxe.Log.*;
import luxe.Sprite;
import luxe.Vector;

import luxe.components.sprite.SpriteAnimation;

import luxetemplate.component.LetterOAnimation;

class Splash extends BaseState 
{
	var o_anim:SpriteAnimation;
	var letters:Array<Sprite>;

	public function new() 
	{
        _debug("---------- Splash.new ----------");

        super({ name:'splash', fade_in_time:0.0, fade_out_time:0.5 });
        letters = new Array<Sprite>();
    }

	override function onenter<T>(_:T) 
	{
        _debug("---------- Splash.onenter ----------");

		// Set background color
	    Luxe.renderer.clear_color = new Color().rgb(Constants.COLOR_GB_2_DARK);
               
        super.onenter(_);		
    }

    override function onleave<T>( _data:T ) 
    {
        _debug("---------- Splash.onleave ----------");

        o_anim = null;

        for (i in 0 ... letters.length)
        {
            letters[i] = null;              
        }

        letters = null;
        
        super.onleave(_data);
    }

    override function post_fade_in()
    {
        _debug("---------- Splash.post_fade_in ----------");
        
        // Compute character sprite positions
        var halfscreen_width = Main.w * 0.5;
        var distance = 4;
        var width_total = 3 * 16 + 2 * 4 + 32 + 5 * distance;
        var width_total_half = 0.5 * width_total;

        // M
        var pos_x = halfscreen_width - width_total_half + 8;

        letters.push(new Sprite({
            name:'miosis_m',
            texture:Luxe.resources.texture('assets/img/logo/miosis_m.png'),
            pos:new Vector(pos_x, Main.h * 0.5),
            color: new Color().rgb(Constants.COLOR_GB_2_OFF),
            depth:4
        }));

        // I
        pos_x += 8 + distance + 2;

        letters.push(new Sprite({
            name:'miosis_i1',            
            texture:Luxe.resources.texture('assets/img/logo/miosis_i.png'),
            pos:new Vector(pos_x, Main.h * 0.5),
            color: new Color().rgb(Constants.COLOR_GB_2_OFF),
            depth:4
        }));

        // O
        pos_x += 2 + distance + 16;

        letters.push(new Sprite({
            name:'miosis_o',                        
            texture:Luxe.resources.texture('assets/img/logo/miosis_o.png'),
            pos:new Vector(pos_x, Main.h * 0.5),
            color: new Color().rgb(Constants.COLOR_GB_2_OFF),
            depth:4,
            size: new Vector(32, 32)
        }));

        // S
        pos_x += 16 + distance + 8;

        letters.push(new Sprite({
            name:'miosis_s',                        
            texture:Luxe.resources.texture('assets/img/logo/miosis_s.png'),
            pos:new Vector(pos_x, Main.h * 0.5),
            color: new Color().rgb(Constants.COLOR_GB_2_OFF),
            depth:4
        }));

        // I
        pos_x += 8 + distance + 2;

        letters.push(new Sprite({
            name:'miosis_i2',                        
            texture:Luxe.resources.texture('assets/img/logo/miosis_i.png'),
            pos:new Vector(pos_x, Main.h * 0.5),
            color: new Color().rgb(Constants.COLOR_GB_2_OFF),
            depth:4
        }));

        // S
        pos_x += 2 + distance + 8;

        letters.push(new Sprite({
            name:'miosis_s2',                        
            texture:Luxe.resources.texture('assets/img/logo/miosis_s.png'),
            pos:new Vector(pos_x, Main.h * 0.5),
            color: new Color().rgb(Constants.COLOR_GB_2_OFF),
            depth:4
        }));

        o_anim = letters[2].add(new LetterOAnimation({ name:'anim'}));
        o_anim.entity.events.listen('animation.splash.end', on_anim_done);
    }

    function on_anim_done(e)
    {
        _debug("---------- Splash.on_anim_done ----------");

        o_anim.entity.events.unlisten('animation.splash.end');
        Luxe.events.fire('change_state', { state : 'load', fade_in_time : fade_in_time, fade_out_time : fade_out_time });
    }
}
