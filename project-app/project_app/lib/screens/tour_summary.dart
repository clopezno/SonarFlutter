import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_app/helpers/helpers.dart'; // Importar el archivo de helpers
import 'package:project_app/models/models.dart';
import 'package:project_app/logger/logger.dart'; // Importar logger para registrar eventos
import 'package:project_app/widgets/widgets.dart';
import 'package:project_app/blocs/blocs.dart';

class TourSummary extends StatelessWidget {
  final EcoCityTour tour;

  const TourSummary({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de la pantalla usando MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.9;

    // Log para la creación del resumen del tour
    log.i(
        'TourSummary: Mostrando resumen del EcoCityTour en ${tour.city} con ${tour.pois.length} POIs.');

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Resumen de tu Eco City Tour',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          // Información del EcoCityTour
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Center(
              child: SizedBox(
                width: cardWidth, // Ajustamos el ancho dinámicamente
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ciudad: ${tour.city}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Distancia: ${formatDistance(tour.distance)}',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(
                            'Duración: ${formatDuration(tour.duration.toInt())}', // Eliminamos los decimales
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 4),

                        // Modo de transporte con icono
                        Row(
                          children: [
                            const Text('Medio de transporte:',
                                style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Icon(
                              transportIcons[
                                  tour.mode], // Icono del modo de transporte
                              size: 24,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Preferencias del usuario en formato de iconos
                        Row(
                          children: tour.userPreferences.map((preference) {
                            final iconData =
                                userPreferences[preference]?['icon'];
                            final color = userPreferences[preference]
                                    ?['color'] ??
                                Colors.black;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(iconData, color: color),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Lista de POIs con la opción de eliminar y expandir texto
          Expanded(
            child: ListView.builder(
              itemCount: tour.pois.length,
              itemBuilder: (context, index) {
                final poi = tour.pois[index];

                // Log para cada POI en la lista
                log.i('TourSummary: Mostrando POI ${poi.name} en la lista.');

                return ExpandablePoiItem(
                    poi: poi, tourBloc: BlocProvider.of<TourBloc>(context));
              },
            ),
          ),
        ],
      ),
    );
  }

  String formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;

    if (hours > 0) {
      return '$hours horas $minutes minutos';
    } else {
      return '$minutes minutos';
    }
  }

  String formatDistance(double meters) {
    if (meters >= 1000) {
      double kilometers = meters / 1000;
      return '${kilometers.toStringAsFixed(1)} km';
    } else {
      return '${meters.round()} m';
    }
  }
}
