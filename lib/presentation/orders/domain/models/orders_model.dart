class OrdersModel {
  final bool? success;
  final Data? data;

  OrdersModel({this.success, this.data});

  factory OrdersModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return OrdersModel(
      success: json['success'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data?.toJson()};
  }
}

class Data {
  final List<Orders?>? orders;
  final num? total;
  final num? limit;
  final num? offset;

  Data({this.orders, this.total, this.limit, this.offset});

  factory Data.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Data(
      orders: json['orders'] != null
          ? List<Orders>.from(json['orders'].map((item) => Orders.fromJson(item)))
          : null,
      total: json['total'],
      limit: json['limit'],
      offset: json['offset'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': orders?.map((item) => item?.toJson()).toList(),
      'total': total,
      'limit': limit,
      'offset': offset,
    };
  }
}

class Orders {
  final num? id;
  final String? name;
  final String? state;
  final String? stateLabel;
  final String? dateOrder;
  final num? amountUntaxed;
  final num? amountTax;
  final num? amountTotal;
  final String? currency;
  final String? currencySymbol;
  final num? itemsCount;

  Orders({
    this.id,
    this.name,
    this.state,
    this.stateLabel,
    this.dateOrder,
    this.amountUntaxed,
    this.amountTax,
    this.amountTotal,
    this.currency,
    this.currencySymbol,
    this.itemsCount,
  });

  factory Orders.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Orders(
      id: json['id'],
      name: json['name'],
      state: json['state'],
      stateLabel: json['state_label'],
      dateOrder: json['date_order'],
      amountUntaxed: json['amount_untaxed'],
      amountTax: json['amount_tax'],
      amountTotal: json['amount_total'],
      currency: json['currency'],
      currencySymbol: json['currency_symbol'],
      itemsCount: json['items_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'state_label': stateLabel,
      'date_order': dateOrder,
      'amount_untaxed': amountUntaxed,
      'amount_tax': amountTax,
      'amount_total': amountTotal,
      'currency': currency,
      'currency_symbol': currencySymbol,
      'items_count': itemsCount,
    };
  }
}
