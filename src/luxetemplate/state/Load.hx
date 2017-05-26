package luxetemplate.state;

import luxe.Color;
import luxe.Log.*;
import luxe.Parcel;
import luxe.Sprite;
import luxe.Vector;
import luxe.Visual;

import luxe.resource.Resource;

import snow.api.Promise;

import luxetemplate.state.BaseState;

typedef LoadStateOptions = 
{
    > BaseStateOptions,
    @:optional var bar_color:Color;
    @:optional var border_color:Color;
    @:optional var background_color:Color;    
}

class Load extends BaseState 
{
    public var state_to_load:String;

    var progress_bar:Sprite;
    var progress_border:Visual;
    var background:Sprite;

    var width:Float = 0;
    var height:Float = 0;

    var bar_color:Color;
    var border_color:Color;
    var background_color:Color;

    public function new(?_options:LoadStateOptions) 
    {
        _debug("---------- Load.new ----------");

        // Set background color
        Luxe.renderer.clear_color = new Color().rgb(Constants.COLOR_GB_2_DARK);

        state_to_load = "";

        if (_options != null && _options.bar_color != null)
        {
            bar_color = _options.bar_color;
        }
        else
        {
            bar_color = new Color().rgb(Constants.COLOR_GB_2_OFF);
        }

        if (_options != null && _options.border_color != null)
        {
            border_color = _options.border_color;
        }
        else
        {
            border_color = new Color().rgb(Constants.COLOR_GB_2_MEDIUM);
        }

        if (_options != null && _options.background_color != null)
        {
            background_color = _options.background_color;
        }
        else
        {
            background_color = new Color().rgb(Constants.COLOR_GB_2_DARK);
        }

        super({ name : 'load', fade_in_time : 0.2, fade_out_time : 0.2 });
    }

    override function onenter<T>(_:T) 
    {
        _debug("---------- Load.onenter ----------");

        var view_width:Float = Luxe.screen.w;
        var view_height:Float = Luxe.screen.h;

        if (Luxe.camera.size != null) 
        {
            view_width = Luxe.camera.size.x;
            view_height = Luxe.camera.size.y;
        }

        var view_mid_x = Math.floor(view_width / 2);
        var view_mid_y = Math.floor(view_height / 2);

        width = Math.max(Math.floor(view_width * 0.75), 2);
        height = Math.max(Math.floor(view_height * 0.002), 2);

        var ypos = Math.floor(view_height * 0.60);
        var half_width = Math.floor(width / 2);
        var half_height = Math.floor(height / 2);

        background = new Sprite({
            name:"background",           
            size : new Vector(view_width, view_height),
            centered : false,
            color : background_color,
            depth : 100,
            visible: true,
        });

        progress_bar = new Sprite({
            name:"bar",                     
            pos : new Vector(view_mid_x - half_width, ypos - half_height),
            size : new Vector(2, height),
            centered : false,
            color : bar_color,
            depth : 100
        });

        progress_border = new Visual({
            name:"border",
            color : border_color,
            pos : new Vector(view_mid_x - half_width, ypos - half_height),
            geometry : Luxe.draw.rectangle({
                w : width,
                h : height,
                depth : 101
            }),
            depth : 101
        });


        var promise_json:Promise = Luxe.resources.load_json("assets/json/parcel/parcel_" + state_to_load + ".json");
        promise_json.then(load_assets, json_load_failed);
               
        super.onenter(_);       
    }

    override function onleave<T>( _data:T ) 
    {
        _debug("---------- Load.onleave ----------");
        
        // Clean up
        progress_bar = null;
        progress_border = null;
        background = null;

        bar_color = null;
        border_color = null;
        background_color = null;

        super.onleave(_data);
    }

    function load_assets(json:JSONResource) 
    {
        _debug("---------- Load.load_assets ----------");

        var parcel:Parcel = new Parcel();
        parcel.from_json(json.asset.json);

        parcel.on(ParcelEvent.progress, onprogress);
        parcel.on(ParcelEvent.complete, oncomplete);
        
        parcel.load();        
    }

    function json_load_failed(json:JSONResource) 
    {
        _debug("---------- Load.json_load_failed ----------");
        set_progress(1);
        var args = { 
            state : state_to_load, 
            fade_in_time : fade_in_time, 
            fade_out_time : fade_out_time, 
            parcel : null 
        };

        Luxe.events.fire('change_state', args);
    }

    function onprogress(change:ParcelChange ) 
    {
        _debug("---------- Load.onprogress ----------");

        var amount = change.index / change.total;
        set_progress(amount);
    }

    function oncomplete(parcel:Parcel)
    {
        _debug("---------- Load.oncomplete ----------");

        var args = { 
            state : state_to_load, 
            fade_in_time : fade_in_time, 
            fade_out_time : fade_out_time, 
            parcel : parcel 
        };

        Luxe.events.fire('change_state', args);
    }

    function set_progress(amount:Float) 
    {
        _debug("---------- Load.set_progress ----------");

        if(amount < 0) amount = 0;
        if(amount > 1) amount = 1;

        progress_bar.size.x = Math.ceil(width * amount);
    }
}