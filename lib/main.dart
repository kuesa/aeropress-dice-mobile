import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Aeropress Recipe Generator', home: RandomRecipe());
  }
}

class RandomRecipeState extends State<RandomRecipe> {
  @override
  Widget build(BuildContext context) {
    const COFFEE_WATER_RATIOS = [
      {'coffee': 23, 'water': 200},
      {'coffee': 18, 'water': 250},
      {'coffee': 15, 'water': 250},
      {'coffee': 12, 'water': 200}
    ];

    const GRIND_BREWTIME_RATIOS = [
      {'grind': 'fine', 'time': 60},
      {'grind': 'medium', 'time': 90},
      {'grind': 'coarse', 'time': 120}
    ];

    const BLOOM_SECONDS = [20, 30, 40];
    const BLOOM_WATER_G = [30, 60];
    const BREW_TEMP_C = [80, 85, 90, 95];
    const CLOCKWISE_STIR_TIMES = [0, 1, 2];

    var rng = new Random();

    // Is inverted?
    var inverted = rng.nextBool();

    // Bloom seconds
    var bloomSeconds = BLOOM_SECONDS[rng.nextInt(2)];

    // Amount of bloom water (in grams)
    var bloomWaterG = BLOOM_WATER_G[rng.nextInt(1)];

    // Brew temp (in non-freedom units)
    var brewTempC = BREW_TEMP_C[rng.nextInt(3)];

    // Coffee-to-water ratio
    var coffeeWaterRatio = COFFEE_WATER_RATIOS[rng.nextInt(3)];

    // Grind-to-time ratio
    var grindBrewTime = GRIND_BREWTIME_RATIOS[rng.nextInt(2)];

    // Clockwise stir amount
    var clockwiseStirTimes = CLOCKWISE_STIR_TIMES[rng.nextInt(2)];

    // Do anticlockwise stir?
    var anticlockwiseStir = rng.nextBool();

    // Initial step (heating water)
    var finalText =
        "1. Heat __${coffeeWaterRatio['water']}g__ of water to __$brewTempC°C__ / __${toFarenheit(brewTempC)}°F__ .\n";

    // Grind step
    finalText +=
        "2. Grind __${coffeeWaterRatio['coffee']}g__ of coffee to a ${grindBrewTime['grind']} grind.\n";

    // Different outputs for inversion or regular orientation
    if (inverted) {
      finalText += "3. Invert the aeropress\n";
    } else {
      finalText +=
          "3. Place the aeropress normally, with the rinsed filter and cap on.\n";
    }

    // Pour coffee step
    finalText += "4. Pour in the ground coffee.\n";

    // Bloom step
    if (bloomWaterG > 0) {
      finalText +=
          "5. Add __${bloomWaterG}g__ of water and wait __${bloomSeconds}__ seconds for the coffee to bloom.\n";
    }

    // Water step
    if (bloomWaterG > 0) {
      finalText +=
          "6. Add the remaining __${coffeeWaterRatio['water'] - bloomWaterG}g__ of water.\n";
    }

    // Stir step
    if (clockwiseStirTimes > 0) {
      finalText +=
          "7. Stir ${formatTimeEnglish(clockwiseStirTimes)} in one direction.";
      if (anticlockwiseStir) {
        finalText += " Repeat in the other direction.";
      }
      finalText += "\n";
    }

    // Brew step
    finalText += "8. Wait __${grindBrewTime['time']}s__ to brew.\n";

    // End invert step
    if (inverted) {
      finalText +=
          "9. Wet the paper filter, and put the cap on. Place the mug upside-down on the aeropress and invert them.\n";
    }

    // Press
    finalText += "10. Press.";

    return Scaffold(
        appBar: AppBar(
          title: Text('Aeropress Recipe Generator'),
          /* TODO: Properly imlement about page
            actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (String result) {
                setState(() {});
              },
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                    const PopupMenuItem<String>(
                        value: "About", child: Text("About")),
                  ],
            )
          ],*/
        ),
        body: new Markdown(data: finalText),
        floatingActionButton: new FloatingActionButton.extended(
            elevation: 0.0,
            label: Text("Generate"),
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {});
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  // Turn number of times in an integer value into English words
  formatTimeEnglish(times) {
    if (times == 1) {
      return "once";
    } else {
      return "$times times";
    }
  }

  // Convert celsius to freedom units
  toFarenheit(celsius) {
    return (celsius * 9 / 5) + 32;
  }
}

class RandomRecipe extends StatefulWidget {
  @override
  RandomRecipeState createState() => new RandomRecipeState();
}
