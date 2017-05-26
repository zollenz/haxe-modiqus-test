package miosis.ui;

import luxe.Log.*;

import mint.Control;
import mint.Panel;
import mint.Slider;

import mint.types.Types;
import mint.core.Signal;
import mint.types.Types.Helper;
import mint.core.Macros.*;

@:allow(mint.render.Renderer)
class MiosisSliderControl extends mint.Control 
{
    var options: SliderOptions;

    public var bar_margin : Float = 1;
    public var min : Float = 0;
    public var max : Float = 1;
    public var value  (default, set): Float = 1;
    public var percent : Float = 1;
    public var step : Null<Float>;
    public var vertical : Bool = false;
    public var invert : Bool = false;

    var bar_x : Float = 2.0;
    var bar_y : Float = 2.0;
    var bar_w : Float = 0.0;
    var bar_h : Float = 0.0;

    public var onchange: Signal<Float->Float->Void>;

    public function new(_options:SliderOptions, _bar_margin:Float = 1) {

        options = _options;

        def(options.name, 'slider');
        def(options.mouse_input, true);

        bar_margin = _bar_margin;
        max = def(options.max, 1);
        min = def(options.min, 0);
        value = def(options.value, max);
        vertical = def(options.vertical, false);
        invert = def(options.invert, false);
        step = options.step;

        bar_x = x + bar_margin;
        bar_y = y + bar_margin;        

        super(options);

        onchange = new Signal();

        renderer = rendering.get(MiosisSliderControl, this);

        oncreate.emit();

        update_value(value);

    } //new

    public function refresh():Void
    {
        update_value(value);
    }


    var dragging = false;

    override function mousedown(e:MouseEvent) {

        super.mousedown(e);

        dragging = true;
        focus();
        update_value_from_mouse(e);

    } //mousedown

    inline function get_range() return max-min;

    var ignore_set = true;

    public inline function update_value(_value:Float) {

        _value = Helper.clamp(_value, min, max);

        if(step != null) 
        {
            _value = Math.round(_value / step) * step;
        }

        var bar_max_w = w - 2 * bar_margin;
        var bar_max_h = h - 2 * bar_margin;        

        if(vertical) 
        {
            bar_w = bar_max_w;
            bar_h = bar_max_h * (_value - min) / get_range();
            bar_h = Helper.clamp(bar_h, 0, bar_max_h);

            if (invert)
            {
                bar_y = bar_margin;
            }
            else
            {
                bar_y = (h - (bar_max_h * (_value - min) / get_range())) - bar_margin;
            }
        } 
        else 
        {
            bar_h = bar_max_h;
            bar_w = bar_max_w * (_value - min) / get_range();
            bar_w = Helper.clamp(bar_w, 0, bar_max_w);

            if (invert)
            {
               bar_x = (w - (bar_max_w * (_value - min) / get_range())) - bar_margin;
            }
            else
            {
                bar_x = bar_margin;
            }
        }

        percent = _value / get_range();

        ignore_set = true;
        value = _value;
        ignore_set = false;

        onchange.emit(value, percent);

    } // update_bar
    
    inline function set_value(_value:Float):Float {

        if(ignore_set) return value = _value;

        update_value(_value);

        return value;

    } // set_value

    inline function update_value_from_mouse(e:MouseEvent) 
    {
        if(vertical) 
        {
            var _dy = invert ? e.y - y : h - e.y + y;
            _dy = Helper.clamp(_dy, 0, h);
            var _v:Float = (_dy / h) * get_range() + min;

            update_value(_v);
        } 
        else 
        {
            var _dx = invert ? w - e.x + x : e.x - x;
            _dx = Helper.clamp(_dx, 0, w);
            var _v:Float = (_dx / w) * get_range() + min;

            update_value(_v);            
        }
    }

    override function mousemove(e:MouseEvent) {

        if(dragging) {

            update_value_from_mouse(e);

        } //dragging

    } //mousemove

    override function mouseup(e:MouseEvent) {

        dragging = false;
        unfocus();

        super.mouseup(e);

    } //mouseup
}
