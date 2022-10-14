import 'package:json_annotation/json_annotation.dart';
import 'package:mobidax_redux/exchange/exchange_state.dart';

part 'account_state.g.dart';

@JsonSerializable(nullable: false)
class AccountUserState {
  final bool isAuthourized;
  final UserSessionState userSession;
  final int selectedIndex;
  final List<UserBalanceItemState> balances;
  final List<Beneficiary> beneficiaries;
  final List<TradeItem> tradeHistory;
  final List<OrderItem> ordersHistory;
  final List<ApiKey> userApiKey;
  final UserState user;
  final List<UserActivity> activities;
  @JsonKey(ignore: true)
  final Exception error;
  @JsonKey(ignore: true)
  final String success;

  AccountUserState(
      {this.isAuthourized,
      this.selectedIndex,
      this.userSession,
      this.balances,
      this.beneficiaries,
      this.tradeHistory,
      this.ordersHistory,
      this.error,
      this.success,
      this.user,
      this.userApiKey,
      this.activities});

  AccountUserState copy(
          {isAuthourized,
          selectedIndex,
          userSession,
          balances,
          beneficiaries,
          tradeHistory,
          ordersHistory,
          userApiKey,
          user,
          success,
          activities,
          error}) =>
      AccountUserState(
          isAuthourized: isAuthourized ?? this.isAuthourized,
          selectedIndex: selectedIndex ?? this.selectedIndex,
          userSession: userSession ?? this.userSession,
          balances: balances ?? this.balances,
          beneficiaries: beneficiaries ?? this.beneficiaries,
          tradeHistory: tradeHistory ?? this.tradeHistory,
          ordersHistory: ordersHistory ?? this.ordersHistory,
          activities: activities ?? this.activities,
          userApiKey: userApiKey ?? this.userApiKey,
          error: error,
          success: success,
          user: user ?? this.user);

  static AccountUserState initialState() => AccountUserState(
      isAuthourized: false,
      selectedIndex: 1,
      userSession: UserSessionState.initialState(),
      balances: [],
      beneficiaries: [],
      tradeHistory: [],
      ordersHistory: [],
      userApiKey: [],
      activities: [],
      error: null,
      success: "",
      user: UserState.initialState());

  factory AccountUserState.fromJson(Map<String, dynamic> json) =>
      _$AccountUserStateFromJson(json);

  Map<String, dynamic> toJson() => _$AccountUserStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountUserState &&
          runtimeType == other.runtimeType &&
          isAuthourized == other.isAuthourized &&
          selectedIndex == other.selectedIndex &&
          userSession == other.userSession &&
          balances == other.balances &&
          success == other.success &&
          beneficiaries == other.beneficiaries &&
          tradeHistory == other.tradeHistory &&
          ordersHistory == other.ordersHistory &&
          userApiKey == other.userApiKey &&
          error == other.error &&
          user == other.user;

  @override
  int get hashCode =>
      isAuthourized.hashCode ^
      selectedIndex.hashCode ^
      userSession.hashCode ^
      balances.hashCode ^
      beneficiaries.hashCode ^
      tradeHistory.hashCode ^
      ordersHistory.hashCode ^
      error.hashCode ^
      userApiKey.hashCode ^
      success.hashCode ^
      user.hashCode;
}

@JsonSerializable(nullable: false)
class UserSessionState {
  @JsonKey(name: '_barong_session')
  final String barongSession;
  @JsonKey(name: '_barong_session_expires')
  final String barongSessionExpires;

  UserSessionState({
    this.barongSession,
    this.barongSessionExpires,
  });

  UserSessionState copy({
    barongSession,
    barongSessionExpires,
  }) =>
      UserSessionState(
        barongSession: barongSession ?? this.barongSession,
        barongSessionExpires: barongSessionExpires ?? this.barongSessionExpires,
      );

  static UserSessionState initialState() =>
      UserSessionState(barongSession: "", barongSessionExpires: "");

  factory UserSessionState.fromJson(Map<String, dynamic> json) =>
      _$UserSessionStateFromJson(json);

  Map<String, dynamic> toJson() => _$UserSessionStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSessionState &&
          runtimeType == other.runtimeType &&
          barongSession == other.barongSession &&
          barongSessionExpires == other.barongSessionExpires;

  @override
  int get hashCode => barongSession.hashCode ^ barongSessionExpires.hashCode;
}

@JsonSerializable(nullable: false)
class UserBalanceItemState {
  final CurrencyItemState currency;
  final double balance;
  final double locked;

  UserBalanceItemState({this.balance, this.currency, this.locked});

  UserBalanceItemState copy({balance, currency, locked}) =>
      UserBalanceItemState(
          balance: balance ?? this.balance,
          currency: currency ?? this.currency,
          locked: locked ?? this.locked);

  static UserBalanceItemState initialState() => UserBalanceItemState(
      balance: 0, locked: 0, currency: CurrencyItemState.initialState());

  factory UserBalanceItemState.fromJson(Map<String, dynamic> json) =>
      _$UserBalanceItemStateFromJson(json);

  Map<String, dynamic> toJson() => _$UserBalanceItemStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserBalanceItemState &&
          runtimeType == other.runtimeType &&
          balance == other.balance &&
          locked == other.locked &&
          currency == other.currency;

  @override
  int get hashCode => balance.hashCode ^ locked.hashCode ^ currency.hashCode;
}

@JsonSerializable(nullable: false)
class CurrencyItemState {
  final String name;
  final String id;
  final String symbol;
  final String type;
  @JsonKey(name: 'icon_url')
  final String iconUrl;
  final int precision;
  @JsonKey(name: 'withdraw_fee', nullable: true)
  final double withdrawFee;
  final double min_withdraw_amount;
  @JsonKey(name: 'explorer_transaction', nullable: true)
  final String explorerTransaction;
  @JsonKey(nullable: true, name: 'deposit_address')
  final String depositAddress;
  @JsonKey(name: 'deposit_enabled')
  final bool depositEnabled;
  @JsonKey(name: 'withdrawal_enabled')
  final bool withdrawalEnabled;

  CurrencyItemState(
      {this.name,
      this.id,
      this.symbol,
      this.type,
      this.withdrawFee,
      this.iconUrl,
      this.precision,
      this.min_withdraw_amount,
      this.explorerTransaction,
      this.depositEnabled,
      this.withdrawalEnabled,
      this.depositAddress});

  CurrencyItemState copy(
          {name,
          id,
          symbol,
          iconUrl,
          precision,
          depositAddress,
          explorerTransaction,
          depositEnabled,
          min_withdraw_amount,
          withdrawalEnabled}) =>
      CurrencyItemState(
          name: name ?? this.name,
          id: id ?? this.id,
          symbol: symbol ?? this.symbol,
          type: type ?? this.type,
          depositEnabled: depositEnabled ?? this.depositEnabled,
          withdrawalEnabled: withdrawalEnabled ?? this.withdrawalEnabled,
          explorerTransaction: explorerTransaction ?? this.explorerTransaction,
          withdrawFee: withdrawFee ?? this.withdrawFee,
          iconUrl: iconUrl ?? this.iconUrl,
          min_withdraw_amount: min_withdraw_amount ?? this.min_withdraw_amount,
          precision: precision ?? this.precision,
          depositAddress: depositAddress ?? this.depositAddress);

  static CurrencyItemState initialState() => CurrencyItemState(
      symbol: "",
      id: "",
      name: "",
      type: "",
      withdrawFee: 0.0,
      min_withdraw_amount: 0.0,
      iconUrl: "",
      depositEnabled: true,
      explorerTransaction: null,
      withdrawalEnabled: true,
      precision: 0,
      depositAddress: null);

  factory CurrencyItemState.fromJson(Map<String, dynamic> json) =>
      _$CurrencyItemStateFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyItemStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyItemState &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id &&
          type == other.type &&
          withdrawFee == other.withdrawFee &&
          symbol == other.symbol &&
          precision == other.precision &&
          depositAddress == other.depositAddress &&
          depositEnabled == other.depositEnabled &&
          min_withdraw_amount == other.min_withdraw_amount &&
          explorerTransaction == other.explorerTransaction &&
          withdrawalEnabled == other.withdrawalEnabled &&
          iconUrl == other.iconUrl;

  @override
  int get hashCode =>
      name.hashCode ^
      id.hashCode ^
      type.hashCode ^
      withdrawFee.hashCode ^
      symbol.hashCode ^
      precision.hashCode ^
      explorerTransaction.hashCode ^
      depositAddress.hashCode ^
      depositEnabled.hashCode ^
      min_withdraw_amount.hashCode ^
      withdrawalEnabled.hashCode ^
      iconUrl.hashCode;
}

@JsonSerializable(nullable: false)
class UserState {
  final String uid;
  final String email;
  final String role;
  final int level;
  final bool otp;
  final String state;
  @JsonKey(name: 'referral_uid')
  final String referralUID;
  final List<UserLabel> labels;
  final String data;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  final List<UserPhone> phones;
  @JsonKey(nullable: true)
  final UserProfile profile;

  UserState(
      {this.uid,
      this.email,
      this.role,
      this.level,
      this.otp,
      this.state,
      this.referralUID,
      this.labels,
      this.data,
      this.createdAt,
      this.updatedAt,
      this.phones,
      this.profile});

  UserState copy(
          {uid,
          email,
          role,
          level,
          otp,
          state,
          referralUID,
          labels,
          data,
          createdAt,
          updatedAt,
          phones,
          profile}) =>
      UserState(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        role: role ?? this.role,
        level: level ?? this.level,
        otp: otp ?? this.otp,
        state: state ?? this.state,
        referralUID: referralUID ?? this.referralUID,
        labels: labels ?? this.labels,
        data: data ?? this.data,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        phones: phones ?? this.phones,
        profile: profile ?? this.profile,
      );

  static UserState initialState() => UserState(
        uid: "",
        email: "",
        role: "",
        level: 0,
        otp: false,
        state: "",
        referralUID: "",
        labels: [],
        data: "",
        createdAt: "",
        updatedAt: "",
        phones: [],
        profile: UserProfile.initialState(),
      );

  factory UserState.fromJson(Map<String, dynamic> json) =>
      _$UserStateFromJson(json);

  Map<String, dynamic> toJson() => _$UserStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserState &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          email == other.email &&
          role == other.role &&
          level == other.level &&
          otp == other.otp &&
          state == other.state &&
          referralUID == other.referralUID &&
          labels == other.labels &&
          data == other.data &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          phones == other.phones &&
          profile == other.profile;

  @override
  int get hashCode =>
      uid.hashCode ^
      email.hashCode ^
      role.hashCode ^
      level.hashCode ^
      otp.hashCode ^
      state.hashCode ^
      referralUID.hashCode ^
      labels.hashCode ^
      data.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      phones.hashCode ^
      profile.hashCode;
}

@JsonSerializable(nullable: false)
class UserLabel {
  final String key;
  final String value;
  final String scope;

  UserLabel({this.key, this.value, this.scope});

  UserLabel copy(key, value, scope) => UserLabel(
      key: key ?? this.key,
      value: value ?? this.value,
      scope: scope ?? this.scope);

  static UserLabel initialState() => UserLabel(
        key: "",
        value: "",
        scope: "",
      );

  factory UserLabel.fromJson(Map<String, dynamic> json) =>
      _$UserLabelFromJson(json);

  Map<String, dynamic> toJson() => _$UserLabelToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLabel &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          value == other.value &&
          scope == other.scope;

  @override
  int get hashCode => key.hashCode ^ value.hashCode ^ scope.hashCode;
}

@JsonSerializable(nullable: false)
class UserPhone {
  final String country;
  final String number;
  @JsonKey(name: 'validated_at')
  final String validatedAt;

  UserPhone({this.country, this.validatedAt, this.number});

  UserPhone copy(country, number, validatedAt) => UserPhone(
      country: country ?? this.country,
      number: number ?? this.number,
      validatedAt: validatedAt ?? this.validatedAt);

  static UserPhone initialState() => UserPhone(
        country: "",
        number: "",
        validatedAt: "",
      );

  factory UserPhone.fromJson(Map<String, dynamic> json) =>
      _$UserPhoneFromJson(json);

  Map<String, dynamic> toJson() => _$UserPhoneToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPhone &&
          runtimeType == other.runtimeType &&
          country == other.country &&
          number == other.number &&
          validatedAt == other.validatedAt;

  @override
  int get hashCode => country.hashCode ^ number.hashCode ^ validatedAt.hashCode;
}

@JsonSerializable(nullable: false)
class UserProfile {
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String dob;
  final String address;
  final String postcode;
  final String city;
  final String country;
  final String state;
  final String metadata;

  UserProfile(
      {this.firstName,
      this.lastName,
      this.dob,
      this.address,
      this.postcode,
      this.city,
      this.country,
      this.state,
      this.metadata});

  UserProfile copy(firstName, lastName, dob, address, postcode, city, country,
          state, metadata) =>
      UserProfile(
          firstName: firstName ?? this.firstName,
          lastName: lastName ?? this.lastName,
          dob: dob ?? this.dob,
          address: address ?? this.address,
          postcode: postcode ?? this.postcode,
          city: city ?? this.city,
          country: country ?? this.country,
          state: state ?? this.state,
          metadata: metadata ?? this.metadata);

  static UserProfile initialState() => UserProfile(
      firstName: "",
      lastName: "",
      dob: "",
      address: "",
      postcode: "",
      city: "",
      country: "",
      state: "",
      metadata: "");

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          dob == other.dob &&
          address == other.address &&
          postcode == other.postcode &&
          city == other.city &&
          country == other.country &&
          state == other.state &&
          metadata == other.metadata;

  @override
  int get hashCode =>
      firstName.hashCode ^
      lastName.hashCode ^
      dob.hashCode ^
      address.hashCode ^
      postcode.hashCode ^
      city.hashCode ^
      country.hashCode ^
      state.hashCode ^
      metadata.hashCode;
}

@JsonSerializable(nullable: false)
class ApiKey {
  final String kid;
  final String algorithm;
  final String scope;
  final bool enabled;
  final String secret;
  final bool createApiKey;

  ApiKey(
      {this.kid,
      this.algorithm,
      this.scope,
      this.enabled,
      this.secret,
      this.createApiKey});

  ApiKey copy(kid, algorithm, scope, state, secret, createApiKey) => ApiKey(
      kid: kid ?? this.kid,
      algorithm: algorithm ?? this.algorithm,
      scope: scope ?? this.scope,
      enabled: state ?? this.enabled,
      secret: secret ?? this.secret,
      createApiKey: createApiKey ?? this.createApiKey);

  static ApiKey initialState() => ApiKey(
      kid: "",
      algorithm: "",
      scope: "",
      enabled: false,
      secret: "",
      createApiKey: false);

  factory ApiKey.fromJson(Map<String, dynamic> json) => _$ApiKeyFromJson(json);

  Map<String, dynamic> toJson() => _$ApiKeyToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiKey &&
          kid == other.kid &&
          algorithm == other.algorithm &&
          scope == other.scope &&
          enabled == other.enabled &&
          secret == other.secret &&
          createApiKey == other.createApiKey;

  @override
  int get hashCode =>
      kid.hashCode ^
      algorithm.hashCode ^
      scope.hashCode ^
      enabled.hashCode ^
      secret.hashCode ^
      createApiKey.hashCode;
}

@JsonSerializable(nullable: false)
class Beneficiary {
  final int id;
  final String currency;
  final String name;
  final String address;
  final String description;
  final String state;

  Beneficiary(
      {this.id,
      this.currency,
      this.name,
      this.address,
      this.description,
      this.state});

  Beneficiary copy(id, currency, name, description, address, state) =>
      Beneficiary(
          id: id ?? this.id,
          currency: currency ?? this.currency,
          name: name ?? this.name,
          address: address ?? this.address,
          description: description ?? this.description,
          state: state ?? this.state);

  static Beneficiary initialState() => Beneficiary(
      id: 0, currency: "", name: "", address: "", description: "", state: "");

  factory Beneficiary.fromJson(Map<String, dynamic> json) =>
      _$BeneficiaryFromJson(json);

  Map<String, dynamic> toJson() => _$BeneficiaryToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Beneficiary &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          currency == other.currency &&
          name == other.name &&
          description == other.description &&
          address == other.address &&
          state == other.state;

  @override
  int get hashCode =>
      id.hashCode ^
      currency.hashCode ^
      name.hashCode ^
      description.hashCode ^
      address.hashCode ^
      state.hashCode;
}

@JsonSerializable(nullable: false)
class UserActivity {
  final int id;
  @JsonKey(name: 'user_id')
  final int userID;
  @JsonKey(name: 'target_uid')
  final String targetUID;
  final String category;
  @JsonKey(name: 'user_ip')
  final String userIP;
  @JsonKey(name: 'user_agent')
  final String userAgent;
  final String topic;
  final String action;
  final String result;
  final String data;
  @JsonKey(name: 'created_at')
  final String createdAt;

  UserActivity(
      {this.id,
      this.userID,
      this.targetUID,
      this.category,
      this.userIP,
      this.userAgent,
      this.topic,
      this.action,
      this.result,
      this.data,
      this.createdAt});

  UserActivity copy(id, userID, targetUID, category, userIP, userAgent, topic,
          action, result, data, createdAt) =>
      UserActivity(
          id: id ?? this.id,
          userID: userID ?? this.userID,
          targetUID: targetUID ?? this.targetUID,
          category: category ?? this.category,
          userIP: userIP ?? this.userIP,
          userAgent: userAgent ?? this.userAgent,
          topic: topic ?? this.topic,
          action: action ?? this.action,
          result: result ?? this.result,
          data: data ?? this.data,
          createdAt: createdAt ?? this.createdAt);

  static UserActivity initialState() => UserActivity(
      id: 0,
      userID: 0,
      targetUID: "",
      category: "",
      userIP: "",
      userAgent: "",
      topic: "",
      action: "",
      result: "",
      data: "",
      createdAt: "");

  factory UserActivity.fromJson(Map<String, dynamic> json) =>
      _$UserActivityFromJson(json);

  Map<String, dynamic> toJson() => _$UserActivityToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserActivity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userID == other.userID &&
          targetUID == other.targetUID &&
          category == other.category &&
          userIP == other.userIP &&
          userAgent == other.userAgent &&
          topic == other.topic &&
          action == other.action &&
          result == other.result &&
          data == other.data &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      userID.hashCode ^
      targetUID.hashCode ^
      category.hashCode ^
      userIP.hashCode ^
      userAgent.hashCode ^
      topic.hashCode ^
      action.hashCode ^
      result.hashCode ^
      data.hashCode ^
      createdAt.hashCode;
}
