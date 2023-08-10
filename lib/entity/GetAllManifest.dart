import 'dart:convert';

GetAllManifestResponse getAllManifestResponseFromJson(String str) =>
    GetAllManifestResponse.fromJson(json.decode(str));

class GetAllManifestResponse {
  GetAllManifestResponse({
    required this.status,
    required this.data,
  });

  final int? status;
  final GetAllManifestData? data;

  factory GetAllManifestResponse.fromJson(Map<String, dynamic> json) {
    return GetAllManifestResponse(
      status: json["status"],
      data: json["data"] == null ? null : GetAllManifestData.fromJson(json["data"]),
    );
  }
}

class GetAllManifestData {
  GetAllManifestData({
    required this.count,
    required this.rows,
  });

  final int? count;
  final List<GetAllManifestRows> rows;

  factory GetAllManifestData.fromJson(Map<String, dynamic> json) {
    return GetAllManifestData(
      count: json["count"],
      rows: json["rows"] == null
          ? []
          : List<GetAllManifestRows>.from(json["rows"]!.map((x) => GetAllManifestRows.fromJson(x))),
    );
  }
}

class GetAllManifestRows {
  GetAllManifestRows({
    required this.manifestId,
    required this.companyId,
    required this.title,
    required this.manifestNumber,
    required this.carrier,
    required this.phone,
    required this.palletDkt,
    required this.dispatchDate,
    required this.createdAt,
    required this.isDeleted,
    required this.status,
    required this.manifestDetail,
  });

  final String? manifestId;
  final String? companyId;
  final String? title;
  final String? manifestNumber;
  final String? carrier;
  final String? phone;
  final String? palletDkt;
  final DateTime? dispatchDate;
  final DateTime? createdAt;
  final String? isDeleted;
  final String? status;
  final List<ManifestDetail> manifestDetail;

  factory GetAllManifestRows.fromJson(Map<String, dynamic> json) {
    return GetAllManifestRows(
      manifestId: json["manifest_id"],
      companyId: json["company_id"],
      title: json["title"],
      manifestNumber: json["manifest_number"],
      carrier: json["carrier"],
      phone: json["phone"],
      palletDkt: json["pallet_dkt"],
      dispatchDate: DateTime.tryParse(json["dispatch_date"] ?? ""),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      isDeleted: json["is_deleted"],
      status: json["status"],
      manifestDetail: json["manifest_detail"] == null
          ? []
          : List<ManifestDetail>.from(
              json["manifest_detail"]!.map((x) => ManifestDetail.fromJson(x))),
    );
  }
}

class ManifestDetail {
  ManifestDetail({
    required this.pallets,
    required this.spaces,
  });

  final String? pallets;
  final String? spaces;

  factory ManifestDetail.fromJson(Map<String, dynamic> json) {
    return ManifestDetail(
      pallets: json["pallets"],
      spaces: json["spaces"],
    );
  }
}
