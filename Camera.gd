extends Camera
var dir = {}
var camera
const SENSITIVITY = 0.25
var sprint = false
var ray_length = 1000
var current_object
var pickpos

func _ready():
	camera = $"."
	pickpos = $PickupPosition
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	process_movement(delta)

func process_movement(delta):
	dir = Vector3(0, 0, 0)
	sprint = Input.is_action_pressed('sprint')
	if Input.is_action_pressed('left'):
		dir.x -= 0.1
	if Input.is_action_pressed('right'):
		dir.x += 0.1
	if Input.is_action_pressed('up'):
		dir.y += 0.1
	if Input.is_action_pressed('down'):
		dir.y -= 0.1
	if Input.is_action_pressed('forward'):
		dir.z -= 0.1
	if Input.is_action_pressed("backward"):
		dir.z += 0.1
	if Input.is_action_pressed("reset_scene"):
		get_tree().reload_current_scene()
	if sprint:
		dir *= 2
	if Input.is_action_just_pressed('ray'):
		if $RayCast.get_collider() is RigidBody:
			current_object = $RayCast.get_collider()
			pickpos.global_transform.origin = current_object.global_transform.origin
	
	if Input.is_action_just_released('ray') && current_object:
		var new = $PickupPosition.global_transform.origin-$PickupVelocity.global_transform.origin
		print(new*500)
		current_object.add_force(new*500, Vector3(0, 0, 0))
		current_object = null
	if current_object && Input.is_action_just_released("closer"):
		pickpos.translation *= .95
	if current_object && Input.is_action_just_released("further"):
		pickpos.translation *= 1.05
	if current_object:
		$PickupVelocity.global_transform.origin = current_object.global_transform.origin
		current_object.set_translation(pickpos.global_transform.origin)
		current_object.look_at(translation, Vector3(0, 1, 0))
	translate(dir)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		#current_object_vel += Vector3(event.relative.x*2, -event.relative.y, 0)
		var new = camera.rotation
		new.x -= deg2rad(event.relative.y) * SENSITIVITY
		if new.x < 1.5 && new.x > -1.5:
			camera.rotation.x = new.x
		camera.rotation.y -= deg2rad(event.relative.x) * SENSITIVITY
