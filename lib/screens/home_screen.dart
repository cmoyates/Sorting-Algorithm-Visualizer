import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sorting_algorithm_visualizer/widgets/sorting_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalBarNum = 20;
  double _totalBarNum = 20;
  int timeScale = 50;
  double _timeScale = 50;
  static bool running = false;
  static bool sorted = false;
  List<SortingBar> bars = [];
  List<double> barVals = [];
  List<SortingBar> barsTemp = [];
  List<double> barValsTemp = [];
  static List<String> algorithms = [
    "Selection Sort",
    "Bubble Sort",
    "Insertion Sort",
    "Merge Sort",
    "Quick Sort",
    "Heap Sort"
  ];
  String usedAlgorithm = algorithms[0];

  Future<void> SelectionSort() async {
    int len = barVals.length;
    for (var i = 0; i < len; i++) {
      int minIndex = i;
      for (var j = i + 1; j < len; j++) {
        if (barVals[j] < barVals[minIndex]) {
          minIndex = j;
        }
      }

      double tempVal = barVals[i];
      barVals[i] = barVals[minIndex];
      barVals[minIndex] = tempVal;

      SortingBar tempBar = bars[i];
      bars[i] = bars[minIndex];
      bars[minIndex] = tempBar;

      setState(() {});
      await Future.delayed(Duration(
        milliseconds: timeScale,
      ));
    }
    sorted = true;
    return;
  }

  Future<void> BubbleSort() async {
    int len = bars.length;
    for (var i = 0; i < len; i++) {
      for (var j = 0; j < (len - i - 1); j++) {
        if (barVals[j] > barVals[j + 1]) {
          double tempVal = barVals[j];
          barVals[j] = barVals[j + 1];
          barVals[j + 1] = tempVal;

          SortingBar tempBar = bars[j];
          bars[j] = bars[j + 1];
          bars[j + 1] = tempBar;
          setState(() {});
          await Future.delayed(Duration(milliseconds: timeScale));
        }
      }
    }
  }

  Future<void> InsertionSort() async {
    int len = bars.length;
    for (var i = 0; i < len; i++) {
      double tempVal = barVals[i];
      SortingBar tempBar = bars[i];
      int j = i - 1;
      while (j >= 0 && tempVal < barVals[j]) {
        barVals[j + 1] = barVals[j];
        bars[j + 1] = bars[j];
        j -= 1;
        setState(() {});
        await Future.delayed(Duration(milliseconds: timeScale));
      }
      barVals[j + 1] = tempVal;
      bars[j + 1] = tempBar;
      setState(() {});
      await Future.delayed(Duration(milliseconds: timeScale));
    }
  }

  Future<void> MergeSort(List<double> valList, List<SortingBar> barList, int startingIndex) async {
    int len = valList.length;
    if (len > 1) {
      int mid = (len / 2).floor();
      List<double> valL = valList.sublist(0, mid);
      List<double> valR = valList.sublist(mid, len);
      List<SortingBar> barL = barList.sublist(0, mid);
      List<SortingBar> barR = barList.sublist(mid, len);
      await MergeSort(valL, barL, startingIndex);
      await MergeSort(valR, barR, startingIndex + mid);

      valList.clear();
      barList.clear();
      int counter = 0;
      while (valL.length > 0 && valR.length > 0) {
        if (valL[0] <= valR[0]) {
          valList.add(valL[0]);
          barList.add(barL[0]);
          valL.removeAt(0);
          barL.removeAt(0);
        } else {
          valList.add(valR[0]);
          barList.add(barR[0]);
          valR.removeAt(0);
          barR.removeAt(0);
        }

        int ind = barVals.indexOf(valList.last);
        if (!(ind == startingIndex+counter)) {
          barVals.removeAt(ind);
          bars.removeAt(ind);
          barVals.insert(startingIndex+counter, valList.last);
          bars.insert(startingIndex+counter, barList.last);
          setState(() {});
          await Future.delayed(Duration(milliseconds: timeScale));
        }
        counter++;
      }

      for (var i = 0; i < valL.length; i++) {
        valList.add(valL[i]);
        barList.add(barL[i]);
        int ind = barVals.indexOf(valList.last);
        if (!(ind == startingIndex+counter)) {
          barVals.removeAt(ind);
          bars.removeAt(ind);
          barVals.insert(startingIndex+counter, valList.last);
          bars.insert(startingIndex+counter, barList.last);
          setState(() {});
          await Future.delayed(Duration(milliseconds: timeScale));
        }
        counter++;
      }
      for (var i = 0; i < valR.length; i++) {
        valList.add(valR[i]);
        barList.add(barR[i]);
        int ind = barVals.indexOf(valList.last);
        if (!(ind == startingIndex+counter)) {
          barVals.removeAt(ind);
          bars.removeAt(ind);
          barVals.insert(startingIndex+counter, valList.last);
          bars.insert(startingIndex+counter, barList.last);
          setState(() {});
          await Future.delayed(Duration(milliseconds: timeScale));
        }
        counter++;
      }
    }
  }

  Future<int> Partition(List<double> v, List<SortingBar> b, int low, int high) async {
    int i = low - 1;
    double pivot = v[high];

    for (var j = low; j < high; j++) {
      if (v[j] < pivot) {
        i += 1;

        double tempVal = v[i];
        v[i] = v[j];
        v[j] = tempVal;
        SortingBar tempBar = b[i];
        b[i] = b[j];
        b[j] = tempBar;

        setState(() {});
        await Future.delayed(Duration(
          milliseconds: timeScale,
        ));
      }
    }

    double tempVal = v[i + 1];
    v[i + 1] = v[high];
    v[high] = tempVal;
    SortingBar tempBar = b[i + 1];
    b[i + 1] = b[high];
    b[high] = tempBar;

    setState(() {});
    await Future.delayed(Duration(
      milliseconds: timeScale,
    ));

    return (i + 1);
  }

  Future<void> QuickSort(List<double> v, List<SortingBar> b, int low, int high) async {
    if (low < high) {
      int pi = await Partition(v, b, low, high);
      QuickSort(v, b, low, pi - 1);
      QuickSort(v, b, pi + 1, high);
    }
  }

  Future<void> Heapify(List<double> v, List<SortingBar> b, int n, int i) async {
    int largest = i;
    int l = 2 * i + 1;
    int r = 2 * i + 2;

    if (l < n && v[l] > v[largest]) {
      largest = l;
    }
    if (r < n && v[r] > v[largest]) {
      largest = r;
    }

    if (largest != i) {
      double tempVal = v[i];
      v[i] = v[largest];
      v[largest] = tempVal;
      SortingBar tempBar = b[i];
      b[i] = b[largest];
      b[largest] = tempBar;

      setState(() {});
      await Future.delayed(Duration(
        milliseconds: timeScale,
      ));

      await Heapify(v, b, n, largest);
    }
  }

  Future<void> HeapSort(List<double> v, List<SortingBar> b) async {
    int n = v.length;

    for (int i = ((n / 2).round() - 1); i >= 0; i--) {
      await Heapify(v, b, n, i);
    }

    for (int i = (n - 1); i > 0; i--) {
      double tempVal = v[0];
      v[0] = v[i];
      v[i] = tempVal;
      SortingBar tempBar = b[0];
      b[0] = b[i];
      b[i] = tempBar;

      setState(() {});
      await Future.delayed(Duration(
        milliseconds: timeScale,
      ));

      await Heapify(v, b, i, 0);
    }
  }

  void Randomize(context) {
    barVals.clear();
    bars.clear();
    barValsTemp.clear();
    barsTemp.clear();
    for (var i = 0; i < totalBarNum; i++) {
      double val = num.parse(Random().nextDouble().toStringAsFixed(2));
      if (!barVals.contains(val)) {
        barVals.add(val);
        barValsTemp.add(val);
      } else {i--;}
    }
    for (var val in barVals) {
      bars.add(SortingBar(
        val: val,
        color: Colors.blueAccent,
        totalBarNum: barVals.length,
      ));
      barsTemp.add(SortingBar(
        val: val,
        color: Colors.blueAccent,
        totalBarNum: barVals.length,
      ));
    }
    setState(() {
      sorted = false;
    });
    return;
  }

  @override
  void initState() {
    super.initState();
    Randomize(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sorting Algorithm Visualizer"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Flexible(
                flex: 5,
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: bars,
                      ),
                    ],
                  ),
                )),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                color: Colors.grey[800],
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      color: Colors.blueAccent,
                      padding: EdgeInsets.all(10),
                      child: DropdownButton<String>(
                        value: usedAlgorithm,
                        dropdownColor: Colors.blueAccent,
                        focusColor: Colors.lightBlueAccent,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 30,
                        elevation: 16,
                        items: algorithms.map((String dropDownItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownItem,
                            child: Text(
                              "$dropDownItem",
                              textScaleFactor: 2,
                              ),
                          );
                        }).toList(),
                        onChanged: (String selectedValue) {
                          setState(() {
                            usedAlgorithm = selectedValue;
                          });
                        },
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "Number of Bars",
                          textScaleFactor: 2.3,
                        ),
                        Slider(
                          value: _totalBarNum,
                          divisions: 45,
                          onChanged: (value) {
                            setState(() {
                              _totalBarNum = value;
                            });
                          },
                          onChangeEnd: (value) {
                            setState(() {
                              totalBarNum = _totalBarNum.round();
                            });
                            Randomize(context);
                          },
                          label: "$_totalBarNum",
                          min: 5,
                          max: 50,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Time Scale",
                          textScaleFactor: 2.3,
                        ),
                        Slider(
                          value: _timeScale,
                          divisions: 10,
                          onChanged: (value) {
                            setState(() {
                              _timeScale = value;
                            });
                          },
                          onChangeEnd: (value) {
                            setState(() {
                              timeScale = _timeScale.round();
                            });
                          },
                          label: "$_timeScale",
                          min: 0,
                          max: 100,
                        ),
                      ],
                    ),
                    RaisedButton(
                      padding: EdgeInsets.all(10),
                        child: Text(
                          "Run",
                          textScaleFactor: 2.3,
                          ),
                        onPressed: () async {
                          if (running || sorted) {
                            return;
                          }
                          running = true;
                          switch (usedAlgorithm) {
                            case "Selection Sort":
                              {
                                await SelectionSort();
                              }
                              break;
                            case "Bubble Sort":
                              {
                                await BubbleSort();
                              }
                              break;
                            case "Insertion Sort":
                              {
                                await InsertionSort();
                              }
                              break;
                            case "Merge Sort":
                              {
                                await MergeSort(barValsTemp, barsTemp, 0);
                              }
                              break;
                            case "Quick Sort":
                              {
                                await QuickSort(
                                    barVals, bars, 0, (totalBarNum - 1));
                              }
                              break;
                            case "Heap Sort":
                              {
                                await HeapSort(barVals, bars);
                              }
                              break;
                          }
                          running = false;
                        }),
                    RaisedButton(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Randomize",
                        textScaleFactor: 2.3,
                        ),
                      onPressed: () {
                        if (running) {
                          return;
                        }
                        running = true;
                        Randomize(context);
                        running = false;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
