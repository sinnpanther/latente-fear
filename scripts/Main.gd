#extends Node
#
#@export var lab_theme: GameTheme
#
#func _ready():
    #var human_seed := SeedManager.generate_human_seed()
    #print("SEED : ", human_seed)
    #SeedManager.init_run(human_seed)
#
    #var gen := LevelGenerator2D.new()
    #var world := gen.generate(SeedManager.run_seed_int)
#
    #print("Rooms:", world.rooms.size())
    #for r in world.rooms:
        #print("Room", r.id, r.rect)
