

import 'dart:convert';

AuthenticationResponse authFromJson(String strauth) =>
    AuthenticationResponse.fromJson(json.decode(strauth));

String authToJson(AuthenticationResponse authdata) =>
    json.encode(authdata.toJson());


class AuthenticationResponse {
  String? accessToken;
  int? expiresIn;
  int? refreshExpiresIn;
  String? refreshToken;
  String? tokenType;
  int? notBeforePolicy;
  String? sessionState;
  String? scope;

  AuthenticationResponse(
      {this.accessToken,
        this.expiresIn,
        this.refreshExpiresIn,
        this.refreshToken,
        this.tokenType,
        this.notBeforePolicy,
        this.sessionState,
        this.scope});

  AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    expiresIn = json['expires_in'];
    refreshExpiresIn = json['refresh_expires_in'];
    refreshToken = json['refresh_token'];
    tokenType = json['token_type'];
    notBeforePolicy = json['not-before-policy'];
    sessionState = json['session_state'];
    scope = json['scope'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['expires_in'] = expiresIn;
    data['refresh_expires_in'] = refreshExpiresIn;
    data['refresh_token'] = refreshToken;
    data['token_type'] = tokenType;
    data['not-before-policy'] = notBeforePolicy;
    data['session_state'] = sessionState;
    data['scope'] = scope;
    return data;
  }
}