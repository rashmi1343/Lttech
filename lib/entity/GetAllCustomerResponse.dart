class GetAllCustomerResponse {
  GetAllCustomerResponse({
    required this.status,
    required this.data,
  });

  final int? status;
  final GetAllCustomerList? data;

  factory GetAllCustomerResponse.fromJson(Map<String, dynamic> json){
    return GetAllCustomerResponse(
      status: json["status"],
      data: json["data"] == null ? null : GetAllCustomerList.fromJson(json["data"]),
    );
  }

}

class GetAllCustomerList {
  GetAllCustomerList({
    required this.count,
    required this.rows,
  });

  final int? count;
  final List<GetAllCustomerRows> rows;

  factory GetAllCustomerList.fromJson(Map<String, dynamic> json){
    return GetAllCustomerList(
      count: json["count"],
      rows: json["rows"] == null ? [] : List<GetAllCustomerRows>.from(json["rows"]!.map((x) => GetAllCustomerRows.fromJson(x))),
    );
  }

}

class GetAllCustomerRows {
  GetAllCustomerRows({
    required this.customerId,
    required this.companyId,
    required this.customerCompanyName,
    required this.customerNumber,
    required this.firstName,
    required this.lastName,
    required this.emailId,
    required this.phone,
    required this.mobile,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.status,
    required this.name
  });

  final String? customerId;
  final String? companyId;
  final String? customerCompanyName;
  final String? customerNumber;
  final String? firstName;
  final String? lastName;
  final String? emailId;
  final String? phone;
  final String? mobile;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? isDeleted;
  final String? status;
  final String? name;

  factory GetAllCustomerRows.fromJson(Map<String, dynamic> json){
    return GetAllCustomerRows(
      customerId: json["customer_id"],
      companyId: json["company_id"],
      customerCompanyName: json["customer_company_name"],
      customerNumber: json["customer_number"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      emailId: json["email_id"],
      phone: json["phone"],
      mobile: json["mobile"],
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      isDeleted: json["is_deleted"],
      status: json["status"],
      name: json["first_name"] + " " +json["last_name"]
    );
  }

}
