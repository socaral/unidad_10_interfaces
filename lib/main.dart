import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const U10App());
}

class U10App extends StatelessWidget {
  const U10App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unidad 10 - Interfaces Naturales',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DemoHomePage(),
    );
  }
}

class _DemoItem {
  final String title;
  final Widget Function(BuildContext) builder;
  _DemoItem(this.title, this.builder);
}


class DemoHomePage extends StatelessWidget {
  const DemoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Cada _DemoItem tiene: título + función que devuelve el widget de la demo
    final demos = <_DemoItem>[
      //“Una función que recibe un parámetro  y devuelve un widget ”.
      _DemoItem('Gestos básicos', (_) => GestosBasicos()),  
      _DemoItem('Arrastrar (DragDemo)', (_) => DragDemo()),
      _DemoItem('Swipe to delete', (_) => SwipeDemo()),
      _DemoItem('Pinch to Zoom', (_) => ZoomDemo()),
      _DemoItem('Animación implícita', (_) => ImplicitAnimationDemo()),
      _DemoItem('Animación explícita', (_) => ExplicitAnimationDemo()),
      _DemoItem('Hero Animation', (_) => FirstPage()),
      _DemoItem('Feedback visual (InkWell)', (_) => FeedbackVisualDemo()),
      _DemoItem('Feedback háptico', (_) => FeedbackHapticoDemo()),
      _DemoItem('Feedback combinado', (_) => BotonInteractivo()),
      _DemoItem('Botón natural (animación + háptico)', (_) => BotonNaturalDemo()),
      _DemoItem('Ejemplo integrador (gestos + accesibilidad)', (_) => InterfazNaturalPage()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Unidad 10 Demos')),
      body: ListView.separated(
        itemCount: demos.length,
         // Widget que se dibuja entre cada elemento (un separador)
        separatorBuilder: (_, __) => const Divider(height: 0),
        // Obtenemos el demo correspondiente a esta posición
        itemBuilder: (context, index) {
          final item = demos[index];
          return ListTile(
            title: Text(item.title),
            //esa línea pone una flecha a la derecha de
            trailing: const Icon(Icons.chevron_right),
             // Navegar a la pantalla de la demo seleccionada
            onTap: () {
              Navigator.of(context).push(
                // Creamos una nueva ruta (pantalla) con estilo Material
                MaterialPageRoute(builder: (ctx) => item.builder(ctx)),
              );
            },
          );
        },
      ),
    );
  }
}


/// 2.1 Gestos básicos
class GestosBasicos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestos básicos")),
      body: Center(
        //GestureDetector es un widget invisible que detecta gestos 
        //(toques, doble toque, pulsación larga, etc.) sobre su hijo.
        child: GestureDetector(
          onTap: () => print("Toque simple"), //Callback que se ejecuta cuando el usuario hace un toque simple.
          onDoubleTap: () => print("Doble tap"), //Callback para el gesto de doble toque.
          onLongPress: () => print("Pulsación larga"), //Callback para el gesto de pulsación larga.
          child: Container( //child: el widget sobre el que se detectarán los gestos.
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text( //El contenido del Container es un Text.
              "Tócame",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}

/// 2.2 Gestos de arrastre (Drag & Pan)
class DragDemo extends StatefulWidget {
  @override
  _DragDemoState createState() => _DragDemoState();
}

class _DragDemoState extends State<DragDemo> {
  double x = 0, y = 0; //Variables de posición para el objeto (desplazamiento en X e Y)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Arrastrar objeto")),
      body: GestureDetector(
        onPanUpdate: (details) { // Callback que se ejecuta cada vez que el dedo se mueve sobre la pantalla
          setState(() { // setState: avisa a Flutter de que el estado ha cambiado y hay que redibujar
            x += details.delta.dx; // Sumamos al eje X el desplazamiento horizontal del gesto
            y += details.delta.dy; // Sumamos al eje Y el desplazamiento vertical del gesto
          });
        },
        
        child: Stack(  // Stack: permite posicionar widgets unos sobre otros con posiciones absolutas
          children: [
            Positioned( // Positioned: coloca su hijo en una posición concreta dentro del Stack
              left: x, // Distancia desde el borde izquierdo, controlada por la variable x
              top: y, // Distancia desde la parte superior, controlada por la variable y
              child: Container(  // El widget que vamos a mover: un cuadrado rojo
                width: 100, // Ancho del cuadrado (100 píxeles)
                height: 100, // Alto del cuadrado (100 píxeles)
                color: Colors.red, // Color de fondo del cuadrado: rojo
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 2.3 Swipe to delete con Dismissible
//// Eejemplo de "deslizar para borrar"
class SwipeDemo extends StatelessWidget {
  // Lista inmutable de 10 elementos: "Item 0", "Item 1", ..., "Item 9"
  final items = List.generate(10, (i) => "Item $i"); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Swipe to delete")),
      
      body: ListView.builder(
        itemCount: items.length, //lista desplazable que construye solo los ítems necesarios
        // Función que construye cada fila de la lista según el índice
        itemBuilder: (context, index) {
          return Dismissible( // Dismissible: widget que permite deslizar para "descartar/borrar"
            key: Key(items[index]), // Clave ÚNICA para este Dismissible, basada en el texto del item
            background: Container(color: Colors.red),
            onDismissed: (direction) { // Callback que se ejecuta cuando el usuario termina de deslizar (se descarta)
              print("${items[index]} eliminado"); // Muestra en la consola qué ítem ha sido "eliminado"
            },
             // Contenido visible de la fila (lo que se arrastra)
            child: ListTile(title: Text(items[index])), // Texto de la fila, por ejemplo "Item 3"
          );
        },
      ),
    );
  }
}

/// 2.4 Pinch-to-zoom
//// Ejemplo de gesto de "pellizcar para hacer zoom"
class ZoomDemo extends StatefulWidget {
  @override
  _ZoomDemoState createState() => _ZoomDemoState();
}

class _ZoomDemoState extends State<ZoomDemo> {
  double scale = 1.0; // Variable que indica el nivel de zoom actual (1.0 = tamaño normal)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pinch to Zoom")),
      body: Center(
        child: GestureDetector(
          onScaleUpdate: (details) {// Se ejecuta cada vez que cambia el gesto de escala (al pellizcar/expandir)
            setState(() { // Avisamos a Flutter de que el estado ha cambiado
              scale = details.scale; // Actualizamos la variable 'scale' con el valor de zoom detectado
            });
          },
          child: Transform.scale( // Widget que aplica una transformación de escala a su hijo
            scale: scale,  // Valor de escala que se va a aplicar (viene de la variable 'scale')
            child: Image.network( // Imagen ruta
              "https://picsum.photos/300/200",
              fit: BoxFit.cover, // Ajusta la imagen para que cubra el espacio, recortando si es necesario
            ),
          ),
        ),
      ),
    );
  }
}

/// 3.1 Animación implícita con AnimatedContainer
class ImplicitAnimationDemo extends StatefulWidget {
  @override
  _ImplicitAnimationDemoState createState() => _ImplicitAnimationDemoState();
}

// Clase que guarda y gestiona el estado del widget ImplicitAnimationDemo.
class _ImplicitAnimationDemoState extends State<ImplicitAnimationDemo> { 
  // Variable de estado: indica si el cuadrado está "grande" (true) o "pequeño" (false). 
  bool grande = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Animación Implícita")),
      body: Center(
        child: GestureDetector( // Widget que detecta gestos del usuario (toques, etc.) sobre su hijo.
          onTap: () => setState(() => grande = !grande),
          // Callback que se ejecuta al tocar el cuadrado:
          // - setState avisa a Flutter de que el estado ha cambiado.
          // - grande = !grande invierte el valor: si era false pasa a true y viceversa.

          child: AnimatedContainer(
             //Contenedor que anima automáticamente los cambios de sus propiedades (tamaño, color, etc.).
            duration: const Duration(milliseconds: 500),  // Duración de la animación: 500 milisegundos en pasar de un estado al otro.
            curve: Curves.easeInOut,  // Curva de animación: acelera al inicio y frena al final para que se vea más suave.
            width: grande ? 200 : 100,
            // Anchura del cuadrado:
            // - Si grande es true -> 200 px.
            // - Si grande es false -> 100 px.
            height: grande ? 200 : 100,
            // Altura del cuadrado:
            // - Si grande es true -> 200 px.
            // - Si grande es false -> 100 px.
            color: grande ? Colors.blue : Colors.red,
             // Color del cuadrado:
            // - Si grande es true -> azul.
            // - Si grande es false -> rojo.
          ),
        ),
      ),
    );
  }
}

/// 3.2 Animación explícita con AnimationController + Tween
class ExplicitAnimationDemo extends StatefulWidget {
  @override
  _ExplicitAnimationDemoState createState() => _ExplicitAnimationDemoState();
}

// Clase que gestionará el estado del widget.
class _ExplicitAnimationDemoState extends State<ExplicitAnimationDemo>
  // Mixin que proporciona un "Ticker" (reloj) para controlar la animación (vsync).
    with SingleTickerProviderStateMixin {  
  //Controlador de animación: gestiona el tiempo, inicio, fin, repetición, etc.  
  late AnimationController _controller; 
  // Objeto Animation que dará valores double interpolados (0 → 300 en este caso).
  late Animation<double> _animacion;

  @override
  void initState() {// Sobrescribimos el método initState que se ejecuta una sola vez al crear el State.
    super.initState(); // Llamamos al initState de la clase padre para la inicialización base.
    _controller = AnimationController(// Creamos el AnimationController.
      duration: const Duration(seconds: 2),  // La animación durará 2 segundos.
       // 'this' usa el SingleTickerProviderStateMixin para evitar gastar recursos en segundo plano.
      vsync: this,
    );
      // Definimos un Tween de 0 a 300 y lo convertimos en Animation.
    _animacion = Tween<double>(begin: 0, end: 300).animate(
      // Envolvemos el controlador con una CurvedAnimation para aplicar una curva tipo rebote al final.
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );
    // Iniciamos la animación en dirección adelante (del inicio al final).
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Liberamos los recursos del AnimationController 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Animación Explícita")),
      body: Center(
        child: AnimatedBuilder(// Widget que vuelve a construir su builder cada vez que cambia la animación asociada.
        // Indicamos qué Animation debe escuchar para redibujar (en este caso _animacion).
          animation: _animacion, 
          builder: (context, child) {
            return Container(
              // El ancho del cuadrado depende del valor actual de la animación (0 → 300).
              width: _animacion.value,
              // La altura del cuadrado también usa el mismo valor animado.
              height: _animacion.value,
               // Color fijo verde para el cuadrado.
              color: Colors.green,
            );
          },
        ),
      ),
    );
  }
}

/// 3.3 Hero Animation entre dos pantallas
/// Definimos la clase FirstPage com un widget sin estado
class FirstPage extends StatelessWidget {
  @override
  //camibo
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Primera página")),
      body: Center(
        child: GestureDetector(
          // cuando el usario toca se define lo que va hacer
          onTap: () => Navigator.push(
            context,
            // MaterialPageRoute define una ruta/pantalla nueva con transición tipo Material Design.
            MaterialPageRoute(builder: (_) => SecondPage()),  
          ),
          // Hero widget que permite la animación compartida entre pantallas.
          child: const Hero(  
            tag: "foto",
            child: Image(
              image: NetworkImage("https://picsum.photos/200"),
              width: 100,
            ),
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Segunda página")),
      body: const Center(
        // tag es el mismo que en FirstPage para vincular las dos imágenes en la animación.
        child: Hero(
          tag: "foto",
          child: Image( // carga otra imagen desde la misma URL, pero con tamaño diferente.
            image: NetworkImage("https://picsum.photos/300"),
            width: 300,
          ),
        ),
      ),
    );
  }
}

/// 4.1 Feedback visual con InkWell
class FeedbackVisualDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Feedback Visual")),
      body: Center(
        child: InkWell(
          // onTap define lo que ocurre cuando se toca el área del InkWell (aquí no hace nada).
          onTap: () {},
           // Esquinas redondeadas del efecto “onda” (ripple).
          borderRadius: BorderRadius.circular(12),
          child: Container(
            // Espacio interno alrededor del contenido dentro del contenedor.
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(//Contenido interno del contenedor va a ser un Texto en este ejemplo
              "Tócame",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

/// 4.2 Feedback háptico básico--> 
/// respuesta que nos da la aplicación cuando haces algo (tocar un botón, arrastrar, etc) y que está relacionado con el tacto
class FeedbackHapticoDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Feedback Háptico")),
      body: Center(
        child: Column(
          // mainAxisAlignment controla cómo se distribuyen los hijos en el eje principal (vertical).
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                HapticFeedback.lightImpact(); // vibración ligera
              },
              child: const Text("Ligero impacto"),
            ),
            ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact(); // vibración media
              },
              child: const Text("Impacto medio"),
            ),
            ElevatedButton(
              onPressed: () {
                HapticFeedback.heavyImpact(); // vibración fuerte
              },
              child: const Text("Impacto fuerte"),
            ),
            ElevatedButton(
              onPressed: () {
                HapticFeedback.vibrate(); // vibración genérica
              },
              child: const Text("Vibración estándar"),
            ),
          ],
        ),
      ),
    );
  }
}

/// 4.3 Feedback combinado (visual + háptico)
class BotonInteractivo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Feedback Combinado")),
      body: Center(
        child: GestureDetector(
          // onLongPress define lo que ocurre cuando se mantiene pulsado (pulsación larga) sobre el hijo.
          onLongPress: () {
            // Provoca una vibración de intensidad media en el dispositivo (feedback háptico).
            HapticFeedback.mediumImpact();
             // Muestra un SnackBar (mensaje flotante) en la parte inferior de la pantalla.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Acción confirmada")),
            );
          },
          // child es el contenido visual sobre el que se detectan los gestos (pulsación larga).
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "Mantén presionado",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

/// Botón Natural: animación + feedback háptico + SnackBar
class BotonNaturalDemo extends StatefulWidget {
  @override
  _BotonNaturalDemoState createState() => _BotonNaturalDemoState();
}

class _BotonNaturalDemoState extends State<BotonNaturalDemo>
  // Mixin que provee un Ticker para animaciones (necesario para AnimationController.vsync).
    with SingleTickerProviderStateMixin {
  // Declaramos un AnimationController que controlará el tiempo y los valores de la animación.
  late AnimationController _controller;
  // Declaramos una animación de tipo double que usaremos para escalar (hacer más grande/pequeño) el botón.
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animación para el efecto de "presionado"
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
       // vsync: this usa el Ticker proporcionado por el mixin para optimizar la animación.
      vsync: this,
      // lowerBound es el valor mínimo de la animación (escala 0.9 → ligeramente más pequeño).
      lowerBound: 0.9,
      // upperBound es el valor máximo de la animación (escala 1.0 → tamaño normal).
      upperBound: 1.0,
    );
   
    // Creamos una animación curva (suavizada) a partir del controlador.
    _scaleAnimation = CurvedAnimation(
      // parent indica qué AnimationController se usará como base.
      parent: _controller,
      // curve define cómo cambia la animación en el tiempo (easeInOut: acelera y frena suavemente).
      curve: Curves.easeInOut,
    );

    // empezamos en el estado "normal"
    _controller.forward();
  }

  @override
  void dispose() {// Liberamos los recursos
    _controller.dispose();
    super.dispose();
  }

  void _accionBoton(BuildContext context) {
    // Dispara una vibración ligera en el dispositivo como feedback háptico.
    HapticFeedback.lightImpact(); // Vibración ligera
    // Muestra un SnackBar en la parte inferior con un mensaje de éxito.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("¡Acción ejecutada con éxito!"),
        // La duración que el SnackBar permanecerá visible (2 segundos).
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Botón Natural")),
      body: Center(
        child: GestureDetector(
          //onTapDown se ejecuta cuando el usuario empieza a tocar (presiona) el botón.
          onTapDown: (_) => _controller.reverse(), // Efecto presionar
          // onTapUp se ejecuta cuando el usuario levanta el dedo después del toque.
          onTapUp: (_) {
            _controller.forward(); // Regresar al estado normal
            _accionBoton(context);
          },
          // onTapCancel se ejecuta si el gesto se cancela (por ejemplo, el dedo se mueve fuera del botón).
          onTapCancel: () => _controller.forward(),
          // child es el contenido visual sobre el que aplicamos los gestos de pulsación.
          child: ScaleTransition(
            // scale es la animación de escala que se aplicará al hijo (efecto de agrandar/encoger).
            scale: _scaleAnimation,
            //widget al que se le aplica el efecto de escala.
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: //añade espacio interno vertical y horizontal
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow( //lista de sombras para dar efecto de elevación.
                    color: Colors.black26,
                    //indica difuminada que está la sombra.
                    blurRadius: 10,
                    // offset indica el desplazamiento de la sombra (0 en X, 5 en Y).
                    offset: Offset(0, 5),
                  )
                ],
              ),
              child: const Text(
                "Presióname",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 6. Ejemplo integrador: gestos + animación + accesibilidad
class InterfazNaturalPage extends StatefulWidget {
  @override
  _InterfazNaturalPageState createState() => _InterfazNaturalPageState();
}

class _InterfazNaturalPageState extends State<InterfazNaturalPage> {
  double _cardScale = 1.0;
  Color _cardColor = Colors.blueAccent;

  void _onCardTap() {
    setState(() {
      _cardScale = 0.95;
      _cardColor =
          _cardColor == Colors.blueAccent ? Colors.greenAccent : Colors.blueAccent;
    });

    // Feedback háptico ligero
    HapticFeedback.lightImpact();

    // Restaurar tamaño después de un momento
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() => _cardScale = 1.0);
    });
  }

  void _onButtonPressed(BuildContext context) {
    HapticFeedback.mediumImpact(); // Vibración más fuerte
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("¡Formulario enviado con éxito! ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ejemplo Integrador")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tarjeta interactiva con animación y gestos
            GestureDetector(
              onTap: _onCardTap,
              child: Semantics(
                label: "Tarjeta interactiva",
                hint: "Tócala para cambiar de color",
                child: AnimatedScale(
                  scale: _cardScale,
                  duration: const Duration(milliseconds: 200),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 200,
                    height: 120,
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Tócame 👆",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Botón accesible con feedback háptico
            Semantics(
              label: "Botón de enviar formulario",
              hint: "Presiona para enviar la información",
              button: true,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text("Enviar"),
                onPressed: () => _onButtonPressed(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
