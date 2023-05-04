extends Node3D

@export var zoom_factor: float = 1.0
@export var default_zoom: float = 5.0
@export var mouse_sens: float = 0.01

var zoom: float = default_zoom
var theta: float = 0.0
var phi: float = 0.0


@onready var CamPos = $CameraPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _physics_process(_delta):
	CamPos.transform.origin = Vector3(0,0,zoom)
	transform.basis = Basis(Quaternion.from_euler(Vector3(phi,theta,0)))
	#transform.basis = from_euler

func _unhandled_input(event):
	if (Input.is_action_pressed("ZoomIn")):
		zoom-=zoom_factor
		zoom = max(zoom,1.0)
	elif (Input.is_action_pressed("ZoomOut")):
		zoom+=zoom_factor
		zoom = min(zoom,20.0)
	elif (Input.is_action_pressed("MoveCamera")):
		if(event is InputEventMouseMotion):
			theta-=event.relative.x*mouse_sens
			phi-=event.relative.y*mouse_sens
			theta = fmod(theta, 2*PI)
			phi = clamp(phi,-(PI-0.2)/2,(PI-0.2)/2)
	
