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

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  List<OrderItem> orders = [];

  @override
  void initState() {
    super.initState();
    orders = [
      OrderItem(orderNumber: '123', customerName: 'Иванов', address: 'ул. Пушкина, 10', onOrderComplete: removeOrder),
      OrderItem(orderNumber: '456', customerName: 'Петров', address: 'ул. Лермонтова, 5', onOrderComplete: removeOrder),
      OrderItem(orderNumber: '789', customerName: 'Сидоров', address: 'ул. Гоголя, 3', onOrderComplete: removeOrder),
    ];
  }

  void removeOrder(String orderNumber) {
    setState(() {
      orders.removeWhere((order) => order.orderNumber == orderNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список заказов'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return orders[index];
        },
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final String orderNumber;
  final String customerName;
  final String address;
  final Function(String) onOrderComplete;

  const OrderItem({
    required this.orderNumber,
    required this.customerName,
    required this.address,
    required this.onOrderComplete,
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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Заказ выполнен'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Заказ №$orderNumber выполнен!'),
                    SizedBox(height: 8),
                    Text('Показать адрес на карте?'),
                  ],
                ),
                actions: [
                  TextButton(
                    child: Text('Да'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapScreen(address: address),
                        ),
                      );
                    },
                  ),
                  TextButton(
                    child: Text('Нет'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onOrderComplete(orderNumber);
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  final String address;

  const MapScreen({required this.address});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Карта адреса'),
      ),
      body: Center(
        child: YandexMap(
          onMapCreated: (YandexMapController controller) {
            // You can use the controller to interact with the map
            // Set up a marker at the specified address
            controller.addPlacemark(Placemark(
              point: Point(latitude, longitude), // Use the actual coordinates of the address
              style: PlacemarkStyle(
                iconName: 'assets/marker.png', // Add a custom marker icon if desired
              ),
            ));
          },
        ),
      ),
    );
  }
}