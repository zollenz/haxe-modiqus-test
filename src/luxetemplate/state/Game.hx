package luxetemplate.state;

import luxe.Color;
import luxe.Log.*;
import luxe.Text;
import luxe.Vector;

import luxe.collision.shapes.Polygon;
import luxe.collision.data.ShapeCollision;

import luxe.importers.tiled.TiledMap;
import luxe.importers.tiled.TiledObjectGroup;

import luxe.resource.Resource.AudioResource;

import mint.Button;

import phoenix.Batcher;
import phoenix.Texture;
import phoenix.Texture.FilterType;

import miosis.ui.MiosisButtonRender;
import miosis.ui.MiosisMintRendering;

import luxetemplate.Constants;
import luxetemplate.component.PlayerMovement;
import luxetemplate.component.PlayerPhysics;
import luxetemplate.entity.Player;
import luxetemplate.state.BaseState;

class Game extends BaseState
{
    var player:Player;
    var player_movement:PlayerMovement;    
    var player_physics:PlayerPhysics;
    var player_spawn_pos:Vector;

    var button:Button;

    var map:TiledMap;
    var map_scale:Int = 1;

    var music: AudioResource;
    var music_handle: luxe.Audio.AudioHandle;

	public function new() 
    {
        _debug("---------- GameState.new ----------");
                
        super({ name:'game', fade_in_time:0.5, fade_out_time:0.5 });
    }

	override function onenter<T>(_:T) 
    {
        _debug("---------- GameState.onenter ----------");

        // Set background color
        Luxe.renderer.clear_color = new Color().rgb(Constants.COLOR_GB_2_OFF);
        
        button = new Button({
            parent: Main.canvas, 
            name: 'testbutton', 
            text: 'test',
            rendering: new MiosisMintRendering({ batcher: Luxe.renderer.batcher }),
            x: 0.1 * Luxe.screen.width, y:0.1 * Luxe.screen.height, w:30, h: 20
        });
        
        var labelRenderer:mint.render.luxe.Label = cast button.label.renderer;
        Luxe.scene.add(labelRenderer.text);
        
        var txt:Text = Luxe.scene.get('testbutton.label.text');      
        txt.font = Luxe.resources.font('assets/font/justabit/justabit32.fnt');
        txt.point_size = 16;
        txt.geom.letter_snapping = true;        
        txt.geom.texture = txt.font.pages[0];
        txt.geom.texture.filter_min = nearest;
        txt.geom.texture.filter_mag = nearest;
        txt.color = new Color().rgb(Constants.COLOR_GB_2_DARK);

        create_map();
        create_map_collision();

        Luxe.events.listen('simulation.triggers.collide', ontrigger);

        // Start the simulation
        Main.physics.paused = false;

        // Start music
        music = Luxe.resources.audio('assets/audio/steppin.wav');
        music_handle = Luxe.audio.loop(music.source);

        super.onenter(_);
    }

    override function onleave<T>( _data:T ) 
    {
        // Clean up
        player = null;
        player_movement = null;    
        player_physics = null;
        player_spawn_pos = null;

        button = null;

        map.destroy();
        map = null;

        // music.destroy();
        music = null;
        music_handle = null;

        super.onleave(_data);
    }

    function create_map() 
    {    
        _debug("---------- Game.create_map ----------");

        var map_data = Luxe.resources.text('assets/text/simple_160x144_8x8_map.tmx').asset.text;
        
        assertnull(map_data, 'Resource not found!');  

        map = new TiledMap({
            asset_path:"assets/img/",
            format:'tmx', 
            tiled_file_data: map_data });
        map.display({ scale:map_scale, filter:FilterType.nearest });

        for(_group in map.tiledmap_data.object_groups) 
        {
            if (_group.name == 'markers')
            {
                for(_object in _group.objects) 
                {
                    switch(_object.type) 
                    {
                        case 'spawn': 
                        {
                            //The spawn position is set from the map
                            player_spawn_pos = new Vector(_object.pos.x, _object.pos.y);
                            log('spawn pos: ${player_spawn_pos}');

                            //We use it to move the collider,
                            Main.physics.player_collider.position.copy_from(player_spawn_pos);

                            player = new Player();

                            // No physics
                            // player_movement = new PlayerMovement();
                            // player.add(player_movement);

                            // // Custom physics
                            player_physics = new PlayerPhysics();
                            player.add(player_physics);
                            player.pos.copy_from(player_spawn_pos); // Do we have to clone??
                        } //spawn
                        case 'exit': 
                        {
                            // var _y = _object.pos.y;

                            //     //create the exit collectible sprite
                            // exit = new Sprite({
                            //     centered:false, depth:8,
                            //     pos: new Vector(_object.pos.x, _y+2),
                            //     texture:Luxe.resources.texture('assets/exit.png')
                            // });

                            //     //Bounce the exit collectible sprite up and down
                            // luxe.tween.Actuate.tween(exit.pos, 1.5, { y:_y }).reflect().repeat();

                            // var shape = Polygon.rectangle(
                            //     _object.pos.x * map_scale,
                            //     _object.pos.y * map_scale,
                            //     _object.width * map_scale,
                            //     _object.height * map_scale,
                            //     false
                            // );

                            //     //set the type tag on the collider
                            // shape.tags.set('type', 'exit');

                            //     //store it in the list of triggers
                            // sim.trigger_colliders.push(shape);

                        } //exit
                        case 'portal': 
                        {
                            //     //create the portal map if its not yet created
                            // if(portals == null) portals = new Map();

                            //     //store the position of the portal for when we teleport
                            // portals.set(_object.id, _object.pos);

                            //     //create the portal collision shape
                            // var shape = Polygon.rectangle(
                            //     _object.pos.x * map_scale,
                            //     _object.pos.y * map_scale,
                            //     _object.width * map_scale,
                            //     _object.height * map_scale,
                            //     false
                            // );

                            //     //fetch the information from tiled object property for the target teleporter
                            // var target_id = Std.parseInt(_object.properties.get('target'));
                            //     //store it on the collider
                            // shape.data = { target:target_id };
                            //     //and add a tag for the type of collider
                            // shape.tags.set('type', 'portal');

                            //     //and finally add it to the list of triggers
                            // sim.trigger_colliders.push(shape);

                        } //portal
                    } //switch type
                } //each object
            }
        } //each object group
    }

    function create_map_collision() 
    {
        _debug("---------- Game.create_map_collision ----------");
        var layerTiles = map.layer('collision');
        assertnull(layerTiles, 'Map layer _collision_ not found!');

        var bounds = layerTiles.bounds_fitted();

        for(bound in bounds) 
        {
            bound.x *= map.tile_width * map_scale;
            bound.y *= map.tile_height * map_scale;
            bound.w *= map.tile_width * map_scale;
            bound.h *= map.tile_height * map_scale;

            Main.physics.obstacle_colliders.push(Polygon.rectangle(bound.x, bound.y, bound.w, bound.h, false));
        }
    }

    function ontrigger(collisions:Array<ShapeCollision>) 
    {
        // if(collisions.length == 0) 
        // {
        //     teleport_disabled = false;
        // }

        // for(collision in collisions) {

        //     var _type = collision.shape2.tags.get('type');

        //     switch(_type) {
        //         case 'portal':
        //                 //can we teleport?
        //             if(!teleport_disabled) {

        //                 var _destination = portals.get(collision.shape2.data.target);

        //                     //add 4 so that we are no longer colliding
        //                 sim.player_collider.position.x = _destination.x;
        //                 sim.player_collider.position.y = _destination.y + 4;

        //                 teleport_disabled = true;

        //             } //if

        //         case 'exit':

        //         case _:
            
        //     } //switch type

        // } //each collision

    }  
}
