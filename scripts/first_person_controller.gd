extends CharacterBody3D
@onready var camera_3d: Camera3D = %Camera3D
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var gun_ray_casts = %Camera3D/GunRayCasts.get_children()
@onready var bullet_hole = preload("res://scenes/bullet_hole.tscn")
@onready var bullet_hole_particles = preload("res://scenes/bullet_on_wall_particles.tscn")
@onready var face_ray_cast: RayCast3D = %Camera3D/Rig/FaceRayCast
@onready var shoot_sfx: AudioStreamPlayer3D = $ShootSFX
@onready var health: int = 90

@onready var dying_animation: AnimationPlayer = $DyingAnimation
@onready var fade_animation: AnimationPlayer = $FadeAnimation


@onready var blood_border_light: Sprite2D = $UI/bloodBorderLight
@onready var blood_border_heavy: Sprite2D = $UI/bloodBorderHeavy
@onready var blood_border: Sprite2D = $UI/bloodBorder

@onready var smoke_effect: PackedScene = preload("res://scenes/smoke_effect.tscn")
@onready var smoke_marker: Marker3D = %SmokeMarker

@onready var skeleton_3d: Skeleton3D = $Offset/Camera3D/Rig/ViewmodelStuff/ARMS_SK/Skeleton3D

var is_reloading = false

enum STATE {GROUNDED, AIR}
var cur_state = STATE.GROUNDED

var mouse_sensitivity = 0.002
var friction = .3
var air_acceleration = .3
var speed = 1
var _delta = 0

var spread = 8
var totalAmmo = 3 #total ammo you can hold
var ammoCapacity = 3 #how much ammo the shotgun can hold at one time
var currentAmmo = 3 #how much ammo is currently in the gun

var dying = false
var current_interact = null

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	SignalBus.connect("refillAmmo", refillAmmo)
	SignalBus.connect("playerHit", take_damage)
	#SignalBus.connect("lostGame", die)
	SignalBus.connect('wonGame', win)

	SignalBus.connect("set_crank", crank)
	SignalBus.connect("set_type", type)

func _physics_process(delta: float) -> void:
	if is_reloading:
		face_ray_cast.enabled = false
	else:
		face_ray_cast.enabled = true
	if Input.is_action_just_released("debug_kill"):
		die()
	#velocity -= transform.basis.z
	
	#$UI/Velocity.text = str(snapped((velocity.length()), 0.01))
	
	var input
	var movement_dir
	
	if dying:
		input = Vector3.ZERO
		movement_dir = transform.basis * Vector3(input.x, 0, input.y) * speed #makes sure the forward is the forward you are facing
	#region: skips if dying
	else:
		input = Input.get_vector('left',"right","forward","back")
		movement_dir = transform.basis * Vector3(input.x, 0, input.y) * speed #makes sure the forward is the forward you are facing
		
		if Input.is_action_just_pressed("shoot") and !is_reloading:
			if currentAmmo > 0:
				shoot()
			else:
				animation_tree.play_animation('click')
				$DryFireSFX.play()
	
		if Input.is_action_pressed("interact") and !is_reloading:
			if face_ray_cast.is_colliding():
				if face_ray_cast.get_collider().is_in_group('interact'):
					face_ray_cast.get_collider().interact(delta)
		
		
		if ( face_ray_cast.is_colliding() and face_ray_cast.get_collider() != null 
		and (face_ray_cast.get_collider().is_in_group('interact') or face_ray_cast.get_collider().is_in_group('single_interact'))):
			face_ray_cast.get_collider().showUI()

		else:
			SignalBus.emit_signal("hideUI")
					
		
		if Input.is_action_just_pressed("interact") and !is_reloading:
			if face_ray_cast.is_colliding():
				if face_ray_cast.get_collider().is_in_group('single_interact'):
					face_ray_cast.get_collider().single_interact()
	#endregion: skips if dying
	
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
	if dying: return

	health -= 30
	if health <=0:
		
		die()
	elif health > 70:
		blood_border_light.visible = false
		blood_border_heavy.visible = false
		blood_border.visible = false
	elif health <= 70 && health > 40:
		blood_border_light.visible = true
		blood_border_heavy.visible = false
		blood_border.visible = false
	elif health <= 40 && health > 10:
		blood_border_light.visible = false
		blood_border_heavy.visible = false
		blood_border.visible = true
	elif health <= 10:
		blood_border_light.visible = false
		blood_border_heavy.visible = true
		blood_border.visible = false
	
	$HurtSFX.play()

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
	if dying: return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_3d.rotate_x(-event.relative.y * mouse_sensitivity)


func shoot():
	animation_tree.play_animation('shoot')
	createSmoke()
	animation_tree.set("parameters/StateMachine/shoot/TimeSeek/seek_request", 0.0)
	%MuzzleFlare.show()
	%MuzzleFlareTimer.start()
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

func type(state):
	if state == true:
		animation_tree.play_animation('type')
	else:
		animation_tree.play_animation('b2i')

func crank(state):
	if state == true:
		animation_tree.play_animation('crank')
	else:
		animation_tree.play_animation('b2i')


func refillAmmo():
	totalAmmo = ammoCapacity
	reload()

func die():
	
	dying_animation.play("die")
	await get_tree().create_timer(2.24).timeout
	dying = true
	await dying_animation.animation_finished
	fade_animation.play('fade')
	await fade_animation.animation_finished
	SignalBus.emit_signal("lostGame")
	self.queue_free()

func win():
	fade_animation.play('fade')

func createSmoke(): #time for big smoke
	var newSmoke  = smoke_effect.instantiate()
	smoke_marker.add_child(newSmoke)
	newSmoke.emitting = true
	
	await get_tree().create_timer(newSmoke.lifetime).timeout
	newSmoke.queue_free()
