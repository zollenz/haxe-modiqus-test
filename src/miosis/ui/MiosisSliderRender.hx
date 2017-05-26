package miosis.ui;

import luxe.Vector;
import mint.types.Types;
import mint.render.Rendering;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import phoenix.geometry.QuadGeometry;
import luxe.Color;
import luxe.Log.*;

import miosis.ui.MiosisSliderControl;

private typedef LuxeMintSliderOptions = {
    var color: Color;
    var color_bar: Color;
}

class MiosisSliderRender extends mint.render.Render {

    public var slider : MiosisSliderControl;

    public var visual : QuadGeometry;
    public var bar : QuadGeometry;

    public var color: Color;
    public var color_bar: Color;

    var render: LuxeMintRender;

    public function new( _render:LuxeMintRender, _control:MiosisSliderControl ) {

        slider = _control;
        render = _render;

        super(render, _control);

        var _opt: LuxeMintSliderOptions = slider.options.options;

        color = def(_opt.color, new Color().rgb(0x373739));
        color_bar = def(_opt.color_bar, new Color().rgb(0x9dca63));

        visual = Luxe.draw.box({
            id: control.name+'.visual',
            batcher: render.options.batcher,
            x:control.x,
            y:control.y,
            w:control.w,
            h:control.h,
            color: color,
            depth: render.options.depth + control.depth,
            visible: control.visible,
            clip_rect: Convert.bounds(control.clip_with)
        });

        bar = Luxe.draw.box({
            id: control.name+'.bar',
            batcher: render.options.batcher,
            x:control.x + slider.bar_x,
            y:control.y + slider.bar_y,
            w:slider.bar_w,
            h:slider.bar_h,
            color: color_bar,
            depth: render.options.depth + control.depth + 1,
            visible: control.visible,
            clip_rect: Convert.bounds(control.clip_with)
        });

        slider.onchange.listen(onchange);

    } //new

    function onchange(value:Float, prev_value:Float) {

        bar.transform.pos.set_xy(slider.x+slider.bar_x, slider.y+slider.bar_y);
        bar.resize_xy(slider.bar_w, slider.bar_h);

    } //onchange

    override function ondestroy() {

        visual.drop();
        bar.drop();
        visual = null;
        bar = null;

    } //ondestroy

    override function onbounds() {
        visual.transform.pos.set_xy(control.x, control.y);
        visual.resize_xy(control.w, control.h);
        bar.transform.pos.set_xy(slider.x+slider.bar_x, slider.y+slider.bar_y);
        bar.resize_xy(slider.bar_w, slider.bar_h);
    }

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        if(_disable) {
            visual.clip_rect = bar.clip_rect = null;
        } else {
            visual.clip_rect = bar.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
        }
    } //onclip

    override function onvisible( _visible:Bool ) {
        visual.visible = _visible;
        bar.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        visual.depth = render.options.depth + _depth;
        bar.depth = visual.depth + 0.001;
    } //ondepth

} //Slider
