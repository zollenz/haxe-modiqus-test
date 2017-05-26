package luxetemplate.component;

import luxe.Log.*;
import luxe.Sprite;

import luxe.options.ComponentOptions;

class FadeOverlay extends luxe.Component 
{
    private var _sprite:Sprite;

    public function new(?options:ComponentOptions) 
    {
        _debug("---------- FadeOverlay.new ----------");        

        if (options == null) 
        {
            options = { name : "fade"};
        } 
        else if (options.name == null)
        {
            options.name = "fade";
        }

        super(options);
    }

    override function onadded() 
    {
        _debug("---------- FadeOverlay.init ----------");

        _sprite = cast entity;
        _sprite.events.fire('fade_overlay_ready');        
    }

    public function fade_in(?t = 0.15, ?fn:Void->Void) 
    {
        _debug("---------- FadeOverlay.fade_in ----------");

        _sprite.color.tween(t, {a:0}).onComplete(fn);
    }

    public function fade_out(?t = 0.15, ?fn:Void->Void) 
    {
        _debug("---------- FadeOverlay.fade_out ----------");
                
        _sprite.color.tween(t, {a:1}).onComplete(fn);
    }

    override function onremoved()
    {
        _debug("---------- FadeOverlay.onremoved ----------");
        _debug(entity);
    }

    override function ondestroy() 
    {
        _debug("---------- FadeOverlay.ondestroy ----------");
        _debug(entity);        
    }
}
