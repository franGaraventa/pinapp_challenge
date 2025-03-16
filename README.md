# PinApp Challenge

La intencion de este proyecto es completar el enunciado propuesto para el challenge de PinApp, el enunciado es el siguiente:

Desarrollar una aplicacion Flutter que muestre un listado de posts con un buscador en la parte superior que permita filtrarlo.
Al hacer tap en uno de los posts, se debe abrir una pantalla de detalle que muestre los comentarios asociados a ese post.
Esta pantalla de detalle tambien permite al usuario darle like a un post, este valor se debe reflejar en cada item del listado de posts.

## Estructura de la Aplicacion

La aplicación se desarrolló siguiendo los principios de Clean Architecture y utilizando Bloc para la gestión del estado 
en la capa de presentación. Además, se implementaron las siguientes tecnologías:

- [Flutter Modular](https://pub.dev/packages/flutter_modular) utilizado para manejar la injeccion de dependencias como asi tambien la navegacion.
- Para consumo de servicios del lado de Dart se utilizo el paquete [http](https://pub.dev/packages/http). Para el lado nativo, en android se utilizo [okHttp](https://square.github.io/okhttp/), 
en iOS no fue necesario agregar ninguna dependencia para el manejo de servicios.
- Para el almacenamiento local se utilizo [SharedPreferences](https://pub.dev/packages/shared_preferences).
- Para el manejo de unit test, se utilizo [mockito](https://pub.dev/packages/mockito) y [mocktail](https://pub.dev/packages/mocktail) para la generacion de mocks. Al utilizar anotaciones para la generacion de mocks tambien
se utilizo [build_runner](https://pub.dev/packages/build_runner)

## Pantalla de Posts

Esta pantalla presenta una lista de publicaciones con un buscador superior para filtrado. Cada publicación 
muestra su título, descripción y un icono que indica si ha sido marcada como favorita.

| Android                                                                                   | iOS                                                                                       |
|-------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|
| ![Image](https://github.com/user-attachments/assets/7fb2b4fc-2af4-40d2-9353-c8e95e745870) | ![Image](https://github.com/user-attachments/assets/393f0e80-8db3-4388-a58b-1ace579e0498) |

El filtro superior implementa una búsqueda local sobre los datos obtenidos del endpoint '/posts', filtrando por el título de la publicación. En caso de no encontrar coincidencias, se muestra un estado de resultados vacíos.

| Android                                                                                   | iOS                                                                                       |
|-------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|
| ![Image](https://github.com/user-attachments/assets/83f66a11-41d6-40ea-9340-3e04a45f3814) | ![Image](https://github.com/user-attachments/assets/bc3188e3-a745-4c17-a46b-619ab0eb2cbf) |
| ![Image](https://github.com/user-attachments/assets/6b8e546c-3e3b-45fc-b1ef-35ae2d595a1f) | ![Image](https://github.com/user-attachments/assets/1ef49b96-b5c7-473e-b0bf-e0422c1c7f48) |

Si la aplicación se inicia sin conexión a internet, se mostrará una pantalla de error con la opción de reintentar la carga de las publicaciones.

| Android                                                                         | iOS                                                                             |
|---------------------------------------------------------------------------------|---------------------------------------------------------------------------------|
| https://github.com/user-attachments/assets/0c242fff-91b1-43d7-8a67-32d2ca5ffbca | https://github.com/user-attachments/assets/9d15b662-b78a-43e1-88ec-595c92c69d00 |

## Pantalla de Detalle

Esta pantalla presenta una lista de comentarios basado en un post previamente seleccionado. Cada comentario
muestra su título, email del usuario que realizo el comentario y una descripcion. Dentro del detalle podremos elegir el post y almacenarlo como favorito.
Para obtener el detalle del post se consumio el servicio ```/comments?postId=${postId}```.

| Android                                                                                   | iOS                                                                                       |
|-------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|
| ![Image](https://github.com/user-attachments/assets/c74bbf12-a675-4199-9d42-6d11b681e1bc) | ![Image](https://github.com/user-attachments/assets/a492d736-e2aa-47ea-aeb8-337de97a38e9) |

La funcionalidad de marcar posts como favoritos se implementó utilizando ```SharedPreferences```. Esta elección se basa en la simplicidad de almacenar los IDs de los posts, representados como enteros, 
lo cual se adapta perfectamente a las capacidades de SharedPreferences.

### Consumo de Servicios en Nativo (Android/iOS)

En ambas implementaciones, se estableció un ```FlutterMethodChannel``` como mecanismo principal para la comunicación bidireccional entre Flutter y el código nativo (Kotlin/Swift).

En Kotlin, para la interacción con el servicio, se empleó un hilo secundario (thread) mediante la función ```getDataFromUrl(this)```. Esta estrategia asíncrona evita el bloqueo del hilo principal, optimizando la capacidad de respuesta de la aplicación. 
Adicionalmente, se utilizó ```runOnUiThread``` para regresar al hilo principal y enviar los resultados a Flutter, asegurando que las operaciones de la interfaz de usuario se realicen de manera segura.

En Swift, se utilizó ```URLSession.shared.dataTask(with: url)``` para realizar la llamada a la URL de forma asíncrona. Similarmente, esta técnica previene el bloqueo del hilo principal, mejorando la experiencia del usuario al mantener la aplicación receptiva.

Se decidió que el mapeo de la respuesta del servicio se realizara en Flutter, en lugar del código nativo (Kotlin/Swift). Esta elección estratégica minimiza el riesgo de conflictos entre los mapeadores de datos, ya que centraliza la lógica de transformación de datos en un único punto de la aplicación.

## Test

La robustez y fiabilidad de esta aplicación Flutter se han garantizado mediante un exhaustivo conjunto de pruebas unitarias y de widgets testing. Se realizó un esfuerzo significativo para abarcar la mayor cantidad posible de escenarios, logrando una cobertura del 92%. 
Este alto porcentaje de cobertura refleja el compromiso con la calidad y la estabilidad del producto.

Siguiendo los principios de Clean Architecture, se implementaron pruebas en cada capa de la aplicación:

- Dominio: Se verificó la lógica de negocio, asegurando que los casos de uso funcionen correctamente.
- Datos: Se validó la interacción con las fuentes de datos, incluyendo repositorios y servicios externos.
- Presentación: Se probaron los widgets y la lógica de la interfaz de usuario, garantizando una experiencia de usuario fluida y sin errores.

La implementación de pruebas en cada capa, guiada por Clean Architecture, facilita la detección temprana de errores, mejora la mantenibilidad del código y asegura que cada componente funcione según lo esperado. 
Este enfoque integral de pruebas es fundamental para entregar una aplicación de alta calidad y confianza.

![Image](https://github.com/user-attachments/assets/334d399a-4c86-4afd-b0d3-9249a01d5c89)

## Demo

| Android                                                                         | iOS                                                                             |
|---------------------------------------------------------------------------------|---------------------------------------------------------------------------------|
| https://github.com/user-attachments/assets/cc118d8e-cef6-40d7-9f0d-1525df11d916 | https://github.com/user-attachments/assets/e5a7acb8-ddf0-4927-a19b-b1e68e440e5d |
