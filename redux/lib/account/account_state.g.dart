// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountUserState _$AccountUserStateFromJson(Map<String, dynamic> json) {
  return AccountUserState(
    isAuthourized: json['isAuthourized'] as bool,
    selectedIndex: json['selectedIndex'] as int,
    userSession:
        UserSessionState.fromJson(json['userSession'] as Map<String, dynamic>),
    balances: (json['balances'] as List)
        .map((e) => UserBalanceItemState.fromJson(e as Map<String, dynamic>))
        .toList(),
    beneficiaries: (json['beneficiaries'] as List)
        .map((e) => Beneficiary.fromJson(e as Map<String, dynamic>))
        .toList(),
    tradeHistory: (json['tradeHistory'] as List)
        .map((e) => TradeItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    ordersHistory: (json['ordersHistory'] as List)
        .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    user: UserState.fromJson(json['user'] as Map<String, dynamic>),
    userApiKey: (json['userApiKey'] as List)
        .map((e) => ApiKey.fromJson(e as Map<String, dynamic>))
        .toList(),
    activities: (json['activities'] as List)
        .map((e) => UserActivity.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$AccountUserStateToJson(AccountUserState instance) =>
    <String, dynamic>{
      'isAuthourized': instance.isAuthourized,
      'userSession': instance.userSession,
      'selectedIndex': instance.selectedIndex,
      'balances': instance.balances,
      'beneficiaries': instance.beneficiaries,
      'tradeHistory': instance.tradeHistory,
      'ordersHistory': instance.ordersHistory,
      'userApiKey': instance.userApiKey,
      'user': instance.user,
      'activities': instance.activities,
    };

UserSessionState _$UserSessionStateFromJson(Map<String, dynamic> json) {
  return UserSessionState(
    barongSession: json['_barong_session'] as String,
    barongSessionExpires: json['_barong_session_expires'] as String,
  );
}

Map<String, dynamic> _$UserSessionStateToJson(UserSessionState instance) =>
    <String, dynamic>{
      '_barong_session': instance.barongSession,
      '_barong_session_expires': instance.barongSessionExpires,
    };

UserBalanceItemState _$UserBalanceItemStateFromJson(Map<String, dynamic> json) {
  return UserBalanceItemState(
    balance: (json['balance'] as num).toDouble(),
    currency:
        CurrencyItemState.fromJson(json['currency'] as Map<String, dynamic>),
    locked: (json['locked'] as num).toDouble(),
  );
}

Map<String, dynamic> _$UserBalanceItemStateToJson(
        UserBalanceItemState instance) =>
    <String, dynamic>{
      'currency': instance.currency,
      'balance': instance.balance,
      'locked': instance.locked,
    };

CurrencyItemState _$CurrencyItemStateFromJson(Map<String, dynamic> json) {
  return CurrencyItemState(
    name: json['name'] as String,
    id: json['id'] as String,
    symbol: json['symbol'] as String,
    type: json['type'] as String,
    withdrawFee: (json['withdraw_fee'] as num)?.toDouble(),
    min_withdraw_amount: (json['min_withdraw_amount'] as num)?.toDouble(),
    iconUrl: json['icon_url'] as String,
    precision: json['precision'] as int,
    explorerTransaction: json['explorer_transaction'] as String,
    depositEnabled: json['deposit_enabled'] as bool,
    withdrawalEnabled: json['withdrawal_enabled'] as bool,
    depositAddress: json['deposit_address'] as String,
  );
}

Map<String, dynamic> _$CurrencyItemStateToJson(CurrencyItemState instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'symbol': instance.symbol,
      'type': instance.type,
      'icon_url': instance.iconUrl,
      'precision': instance.precision,
      'withdraw_fee': instance.withdrawFee,
      'min_withdraw_amount': instance.min_withdraw_amount,
      'explorer_transaction': instance.explorerTransaction,
      'deposit_address': instance.depositAddress,
      'deposit_enabled': instance.depositEnabled,
      'withdrawal_enabled': instance.withdrawalEnabled,
    };

UserState _$UserStateFromJson(Map<String, dynamic> json) {
  return UserState(
    uid: json['uid'] as String,
    email: json['email'] as String,
    role: json['role'] as String,
    level: json['level'] as int,
    otp: json['otp'] as bool,
    state: json['state'] as String,
    referralUID: json['referral_uid'] as String,
    labels: (json['labels'] as List)
        .map((e) => UserLabel.fromJson(e as Map<String, dynamic>))
        .toList(),
    data: json['data'] as String,
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
    phones: (json['phones'] as List)
        .map((e) => UserPhone.fromJson(e as Map<String, dynamic>))
        .toList(),
    profile: json['profile'] == null
        ? null
        : UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserStateToJson(UserState instance) => <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'role': instance.role,
      'level': instance.level,
      'otp': instance.otp,
      'state': instance.state,
      'referral_uid': instance.referralUID,
      'labels': instance.labels,
      'data': instance.data,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'phones': instance.phones,
      'profile': instance.profile,
    };

UserLabel _$UserLabelFromJson(Map<String, dynamic> json) {
  return UserLabel(
    key: json['key'] as String,
    value: json['value'] as String,
    scope: json['scope'] as String,
  );
}

Map<String, dynamic> _$UserLabelToJson(UserLabel instance) => <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'scope': instance.scope,
    };

UserPhone _$UserPhoneFromJson(Map<String, dynamic> json) {
  return UserPhone(
    country: json['country'] as String,
    validatedAt: json['validated_at'] as String,
    number: json['number'] as String,
  );
}

Map<String, dynamic> _$UserPhoneToJson(UserPhone instance) => <String, dynamic>{
      'country': instance.country,
      'number': instance.number,
      'validated_at': instance.validatedAt,
    };

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return UserProfile(
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    dob: json['dob'] as String,
    address: json['address'] as String,
    postcode: json['postcode'] as String,
    city: json['city'] as String,
    country: json['country'] as String,
    state: json['state'] as String,
    metadata: json['metadata'] as String,
  );
}

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'dob': instance.dob,
      'address': instance.address,
      'postcode': instance.postcode,
      'city': instance.city,
      'country': instance.country,
      'state': instance.state,
      'metadata': instance.metadata,
    };

ApiKey _$ApiKeyFromJson(Map<String, dynamic> json) {
  return ApiKey(
    kid: json['kid'] as String,
    algorithm: json['algorithm'] as String,
    scope: json['scope'] as String,
    enabled: json['enabled'] as bool,
    secret: json['secret'] as String,
    createApiKey: json['createApiKey'] as bool,
  );
}

Map<String, dynamic> _$ApiKeyToJson(ApiKey instance) => <String, dynamic>{
      'kid': instance.kid,
      'algorithm': instance.algorithm,
      'scope': instance.scope,
      'enabled': instance.enabled,
      'secret': instance.secret,
      'createApiKey': instance.createApiKey,
    };

Beneficiary _$BeneficiaryFromJson(Map<String, dynamic> json) {
  return Beneficiary(
    id: json['id'] as int,
    currency: json['currency'] as String,
    name: json['name'] as String,
    address: json['address'] as String,
    description: json['description'] as String,
    state: json['state'] as String,
  );
}

Map<String, dynamic> _$BeneficiaryToJson(Beneficiary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'currency': instance.currency,
      'name': instance.name,
      'address': instance.address,
      'description': instance.description,
      'state': instance.state,
    };

UserActivity _$UserActivityFromJson(Map<String, dynamic> json) {
  return UserActivity(
    id: json['id'] as int,
    userID: json['user_id'] as int,
    targetUID: json['target_uid'] as String,
    category: json['category'] as String,
    userIP: json['user_ip'] as String,
    userAgent: json['user_agent'] as String,
    topic: json['topic'] as String,
    action: json['action'] as String,
    result: json['result'] as String,
    data: json['data'] as String,
    createdAt: json['created_at'] as String,
  );
}

Map<String, dynamic> _$UserActivityToJson(UserActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userID,
      'target_uid': instance.targetUID,
      'category': instance.category,
      'user_ip': instance.userIP,
      'user_agent': instance.userAgent,
      'topic': instance.topic,
      'action': instance.action,
      'result': instance.result,
      'data': instance.data,
      'created_at': instance.createdAt,
    };
