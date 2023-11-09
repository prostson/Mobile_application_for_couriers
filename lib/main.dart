
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

void main() {
  runApp(DeliveryApp());
}

List<String> addresses = [
  'г.Киров, Воровского 117',
  // Добавьте адреса других клиентов
];

class DeliveryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Delivery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DeliveryHomePage(),
    );
  }
}

class DeliveryHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pizza Delivery'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Добро пожаловать в приложение для курьеров доставки пиццы!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Действие при нажатии на кнопку
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderListPage()),
                );
              },
              child: Text('Просмотреть заказы'),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список заказов'),
      ),
      body: ListView(
        children: [
          OrderItem(orderNumber: '123', customerName: 'Иванов', address: 'ул. Пушкина, 10'),
          OrderItem(orderNumber: '456', customerName: 'Петров', address: 'ул. Лермонтова, 5'),
          OrderItem(orderNumber: '789', customerName: 'Сидоров', address: 'ул. Гоголя, 3'),
        ],
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final String orderNumber;
  final String customerName;
  final String address;

  const OrderItem({
    required this.orderNumber,
    required this.customerName,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Заказ №$orderNumber'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Клиент: $customerName'),
          Text('Адрес доставки: $address'),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.check),
        onPressed: () {
          // Действие при нажатии на кнопку
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Заказ выполнен'),
                content: Text('Заказ №$orderNumber выполнен!'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
      onTap: () {
        // Открыть экран с картой и отобразить адрес доставки
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapPage(address: address)),
        );
      },
    );
  }
}

class MapPage extends StatefulWidget {
  final String address;

  const MapPage({required this.address});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  YandexMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Карта'),
      ),
      body: YandexMap(
    onMapCreated: (controller) {
      setState(() {
        _mapController = controller;
      });
    },
    onMapTap: (point) {
      print('Тап по карте: $point');
    },
    onMapLongTap: (point) {
      print('Долгий тап по карте: $point');
    },
    onObjectTap: (objectId) {
      print('Тап по объекту на карте: $objectId');
    },
  ),
);
  }
}