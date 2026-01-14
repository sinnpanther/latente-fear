extends Node
class_name SeedManager

# --------------------------------------------------
# CONFIGURATION
# --------------------------------------------------

# Alphabet Base32 Crockford (lisible humain)
# Pas de I, L, O, U (ambiguïtés)
const CROCKFORD := "0123456789ABCDEFGHJKMNPQRSTVWXYZ"
const SEED_LENGTH := 8

# --------------------------------------------------
# ÉTAT DU RUN
# --------------------------------------------------

# Seed lisible (celle que le joueur voit / partage)
static var run_seed_str: String
static var run_seed_int: int

# RNG principale du run (à utiliser pour dériver les autres)
static var run_rng: RandomNumberGenerator


# --------------------------------------------------
# API PUBLIQUE
# --------------------------------------------------

## Génère une seed lisible par un humain (ex: "9F2MZQ8K")
static func generate_human_seed() -> String:
    var rng := RandomNumberGenerator.new()
    rng.randomize()

    var human_seed := ""
    for i in SEED_LENGTH:
        human_seed += CROCKFORD[rng.randi_range(0, CROCKFORD.length() - 1)]

    return human_seed


## Initialise un run à partir d'une seed lisible
## À appeler au démarrage du jeu ou lors d'un chargement
static func init_run(seed_string: String) -> void:
    run_seed_str = seed_string
    run_seed_int = seed_string_to_int(seed_string)

    run_rng = RandomNumberGenerator.new()
    run_rng.seed = run_seed_int


## Crée une RNG dédiée pour un niveau
## level_index : 0, 1, 2, ...
static func create_level_rng(level_index: int) -> RandomNumberGenerator:
    var rng := RandomNumberGenerator.new()
    rng.seed = run_seed_int + level_index * 1_000
    return rng


## Crée une RNG dédiée pour un ennemi
## enemy_id : identifiant unique dans le niveau
static func create_enemy_rng(enemy_id: int) -> RandomNumberGenerator:
    var rng := RandomNumberGenerator.new()
    rng.seed = run_seed_int + enemy_id * 10_000
    return rng


## Crée une RNG dédiée pour n'importe quel système
## tag : permet de séparer les usages (rooms, puzzles, loot, etc.)
static func create_tagged_rng(tag: String, index: int = 0) -> RandomNumberGenerator:
    var rng := RandomNumberGenerator.new()
    rng.seed = run_seed_int + tag.hash() + index * 100
    return rng


# --------------------------------------------------
# UTILITAIRES INTERNES
# --------------------------------------------------

## Convertit une seed lisible en entier stable
## Suffisant et recommandé pour un roguelike
static func seed_string_to_int(seed_string: String) -> int:
    return seed_string.hash()
