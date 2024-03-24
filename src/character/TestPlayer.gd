extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -575.0
const INITIAL_LIFETIME = 180.0

var PlayerID: int

@export var lifetime: float = INITIAL_LIFETIME
var time_multiplier: float = 1.0
@onready var active_attack_hitbox = $AttackHitboxRight

@onready var anim = get_node("AnimationPlayer")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	PlayerID = multiplayer.get_unique_id()
	
	$PlayerHitbox.monitoring = true
	$AttackHitboxLeft.monitoring = true
	$AttackHitboxRight.monitoring = true

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() != PlayerID:
		return
		
	lifetime -= delta * time_multiplier
	var direction = Input.get_axis("Left", "Right")
		
	if not is_on_floor():
		velocity.y += gravity * delta * (time_multiplier ** 2)
		
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
		active_attack_hitbox = $AttackHitboxLeft
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
		active_attack_hitbox = $AttackHitboxRight
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY * time_multiplier 

	if Input.is_action_just_pressed("Attack") and is_on_floor():
		anim.play("Attack")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = direction * SPEED * time_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		anim.play("Idle")
	
	
		
	if velocity.y != 0:
		if velocity.y < 0:
			anim.play("Jump")
		else:
			anim.play("Fall")
	else:
		if velocity.x == 0:
			anim.play("Idle")
		else:
			anim.play("Run")
			
	move_and_slide()

func on_time_multiplier_changed(new_time_multiplier):
	time_multiplier = new_time_multiplier
	anim.speed_scale = time_multiplier
