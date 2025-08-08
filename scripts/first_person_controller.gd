extends CharacterBody3D
@onready var camera_3d: Camera3D = %Camera3D
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var gun_ray_casts = %Camera3D/GunRayCasts.get_children()
@onready var bullet_hole = preload("res://scenes/bullet_hole.tscn")
@onready var bullet_hole_particles = preload("res://scenes/bullet_on_wall_particles.tscn")
@onready var face_ray_cast: RayCast3D = %Camera3D/Rig/FaceRayCast
@onready var shoot_sfx: AudioStreamPlayer3D = $ShootSFX
@onready var health: int = 90


enum STATE {GROUNDED, AIR}
var cur_state = STATE.GROUNDED

var mouse_sensitivity = 0.002
var friction = .3
var air_acceleration = .3
var speed = 1

var spread = 8
var totalAmmo = 3 #total ammo you can hold
var ammoCapacity = 3 #how much ammo the shotgun can hold at one time
var currentAmmo = 3 #how much ammo is currently in the gun


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	SignalBus.connect("refillAmmo", refillAmmo)
	SignalBus.connect("playerHit", take_damage)
	SignalBus.connect("lostGame", die)


func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_released("debug_kill"):
		SignalBus.emit_signal("lostGame")
	#velocity -= transform.basis.z
	
	$UI/Velocity.text = str(snapped((velocity.length()), 0.01))
	var input = Input.get_vector('left',"right","forward","back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y) * speed #makes sure the forward is the forward you are facing
	
	if Input.is_action_just_pressed("shoot"):
		if currentAmmo > 0:
			shoot()
		else:
			animation_tree.play_animation('click')
			$DryFireSFX.play()
	
	if Input.is_action_pressed("interact"):
		if face_ray_cast.is_colliding():
			if face_ray_cast.get_collider().is_in_group('interact'):
				face_ray_cast.get_collider().interact(delta)
				
	
	if ( face_ray_cast.is_colliding() and face_ray_cast.get_collider() != null 
	and (face_ray_cast.get_collider().is_in_group('interact') or face_ray_cast.get_collider().is_in_group('single_interact'))):
		face_ray_cast.get_collider().showUI()

	else:
		SignalBus.emit_signal("hideUI")
				
	
	if Input.is_action_just_pressed("interact"):
		if face_ray_cast.is_colliding():
			if face_ray_cast.get_collider().is_in_group('single_interact'):
				face_ray_cast.get_collider().single_interact()
	
	match cur_state:
		STATE.GROUNDED:
			var current_friction: Vector2 = Vector2(velocity.x, velocity.z).rotated(PI) * friction
			var _friction_dir = transform.basis * Vector3(current_friction.x, 0, current_friction.y)
			velocity += Vector3(current_friction.x, 0, current_friction.y)
			velocity += Vector3(movement_dir.x, 0, movement_dir.z)
		STATE.AIR:
			if is_on_wall(): velocity.lerp(Vector3.ZERO, delta * 5)
			sv_airaccelerate(movement_dir, delta)
	
	if is_on_floor(): cur_state = STATE.GROUNDED
	else: cur_state = STATE.AIR
	
	velocity.y -= 9.8 * delta
	
	animation_tree.set_velocity(velocity)
	move_and_slide()

func take_damage():
	health -= 30
	if health <=0:
		SignalBus.emit_signal("lostGame")
		

func sv_airaccelerate(movement_dir, delta):
	var air_strength = 3 
	
	movement_dir = movement_dir * air_strength
	var wish_speed = movement_dir.length()
	
	if wish_speed > 1:
		wish_speed = 1
	
	var current_speed = velocity.dot(movement_dir)
	var add_speed = wish_speed - current_speed
	if add_speed <= 0:
		return
	
	var accel_speed = 10 * 10 * delta
	if accel_speed > add_speed:
		accel_speed = add_speed
	
	velocity += accel_speed * movement_dir
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_3d.rotate_x(-event.relative.y * mouse_sensitivity)


func shoot():
	animation_tree.play_animation('shoot')

	currentAmmo -= 1
	totalAmmo -= 1
	
	shoot_sfx.play()
	for i : RayCast3D in gun_ray_casts:
		i.rotation = Vector3(randf_range(-0.1,0.1), randf_range(-0.1,0.1), 0.0)
		if i.get_collider():
			if i.get_collider().is_in_group('enemy'):
				if i.get_collider().has_method("take_damage"):
					i.get_collider().take_damage(5)
			
			var hole = bullet_hole.instantiate()
			var particles = bullet_hole_particles.instantiate()
			get_tree().get_root().add_child(hole)
			get_tree().get_root().add_child(particles)
			hole.global_position = i.get_collision_point()
			particles.global_position = i.get_collision_point()
			particles.emitting = true

func reload():
	currentAmmo = totalAmmo
	
	animation_tree.play_animation('reload')

func type():
	animation_tree.play_animation('type')

func crank():
	animation_tree.play_animation('crank')
	
func b2i():
	animation_tree.play_animation('b2i')

func refillAmmo():
	totalAmmo = ammoCapacity
	reload()

func die():
	self.queue_free()
