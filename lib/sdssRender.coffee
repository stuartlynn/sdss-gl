$ ->
  particles = new THREE.Geometry()


  coordTransform = (ra,dec,redshift)=>
    x = redshift * Math.sin(dec)*Math.cos(ra)
    y = redshift * Math.sin(dec)*Math.sin(ra)
    z = redshift * Math.cos(dec)
    [x,y,z]

  WIDTH = 1024
  HEIGHT = 768
    
  VIEW_ANGLE = 45
  ASPECT = WIDTH / HEIGHT
  NEAR = 0.1
  FAR = 10000

  renderer = new THREE.WebGLRenderer()
  camera = new THREE.Camera(  VIEW_ANGLE, ASPECT, NEAR, FAR  )
  scene = new THREE.Scene()

  element = $("#canvas")

  camera.position.z=300

  renderer.setClearColor new THREE.Color(0,1)
  renderer.setSize WIDTH, HEIGHT

  element.append renderer.domElement

  pMaterial = new THREE.ParticleBasicMaterial
    color : 0xFFFFF
    size  : 0.5

  # pMaterial = new THREE.ParticleBasicMaterial
  #   color: 0xFFFFFF
  #   size: 20
  #   map: THREE.ImageUtils.loadTexture( "images/particle.png")
  #   blending: THREE.AdditiveBlending
  #   transparent: true
  

  for particle in sdssData
    pos = coordTransform particle[0], particle[1], particle[2]
    particleVertex = new THREE.Vertex ( new THREE.Vector3 pos[0]*200, pos[1]*200,pos[2]*200)
    particles.vertices.push particleVertex

  particleSystem =  new THREE.ParticleSystem particles, pMaterial
  
  update = =>
    particleSystem.rotation.y += 0.01
    renderer.render scene, camera
    requestAnimFrame update


  scene.addChild particleSystem

  renderer.render(scene, camera);
  requestAnimFrame(update);