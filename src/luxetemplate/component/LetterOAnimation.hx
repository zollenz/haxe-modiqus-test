package luxetemplate.component;

import luxe.Log.*;

import luxe.options.ComponentOptions;

class LetterOAnimation extends luxe.components.sprite.SpriteAnimation 
{
    public function new(?_options:ComponentOptions) 
    {
        _debug("---------- LetterOAnimation.new ----------");        

        if (_options == null) 
        {
            _options = { name : "animation"};
        } 
        else if (_options.name == null)
        {
            _options.name = "animation";
        }

        super(_options);
    }

    override function init() 
    {
        _debug("---------- LetterOAnimation.init ----------");        

        var anim_json = Luxe.resources.json('assets/json/animation/miosis_anim.json');
        add_from_json_object(anim_json.asset.json);
        animation = 'splash';
        play();
    }

    override function onremoved()
    {
        _debug("---------- LetterOAnimation.onremoved ----------");
    }

    override function ondestroy()
    {
        _debug("---------- LetterOAnimation.ondestroy ----------");
    }
}
