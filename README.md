# Mandelbulb-Fractal-Rendering
An OS based 3D fractal visualization app that renders hypercomplex fractals specifically the mandelbulb, with depth perception.
The app makes use of metal, an API used for low level interactions with the GPU, in order to render the object in a time efficient manner being mindful that the application generates close to 8 million points for the average fractal.

The app uses a convergence test to check if a point is a part of the object based on the object's paramters and field's (the mandelbulb's power and the generation functions) in order to produce different and interesting forms of the object. The app also uses distance based shading to add depth perception to the rendered images.
