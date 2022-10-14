# 	Mobidax Guide 

1. [Sign Up](#sign-up) 

2. Email verification

3. Forgott Password

4. Sing in

5. Sing in with 2FA

   **Account Page**  

6. Phone verification

7. Identity verification

8. Document verification

9. API keys

10. Disable API

11. Delete API 

    **Funds Page**

12. Deposit 

13. Withdrawal 

14. Beneficiary 

15. Create beneficiary coin/fiat 

16. Activate beneficiary

17. Delete beneficiary

    **Exchange Page** 

18. Order book

19. Chart 

20. Market/Limit orders

21. User orders

22. My trades /All trades

    **History Page**

23. Order History

24. Trade History

    **Logout**







# Sign Up

![img](https://lh6.googleusercontent.com/FNOJWYwYiKYY-OO2DVHa6Au7wPVFIfUabmLxYkPP6LzxfX0hFEt8Kq8Goz78u7ASYp-mZoazcpziV-2q-4qSMU0qaXeryT0nwJdnJinZ0bA8SAwUMiIhA4A5zA94a_jwoUdIQ4no)

User identification (referral code) is a set of numbers and letters which used to identify user and referral program,it's not necessary to input

![img](https://lh6.googleusercontent.com/0P7-kDN-W73JysmuLpcwXcowJfNH9QFLzRqdDRK8ArIAGdUX-_VGkZ631MD0DWOP3P5g1PZXgNcsTT1gFIcwN7qZ6oCWfHoe5WgNTLCNKOPhLp4t92uCmb3aq04bojiRx8d6aTuV)

This is what registration through [graphql(click)](https://trade.mobidax.io/graphql) looks like

```
mutation {
	createUser (email:"qa+1q252a@mobidax.io", password:"1q2w3e4td3fghjA") {
    email
    uid
    level
    created_at
  }
}
```



```
{
  "data": {
    "createUser": {
      "email": "qa+1q252a@mobidax.io",
      "uid": "IDC2D3460198",
      "level": 0,
      "created_at": "2021-07-13T16:01:10Z"
    }
  }
}
```



## Email verification

![img](https://lh5.googleusercontent.com/UZqwNPzSRG0B05NNgJIKAW_eiEboC3XUmlI94OzUGyHgnpNt9TZnk9yezGsOtnRDbNX2n2s9Sas8FIx2hAXlffKqh16f8-1Iwj2RJygW-2iL71m2Ic8FWEI2wtSvKcZR0w8nyKkG)

You need to confirm your email for end registration

```
mutation {
	emailConfirm (token:" " , lang:"eng") {
	data
  }
}
```



```
{
  "data": {
    "emailConfirm": {
      "data": "ok"
    }
  }
}
```





## Forgott Password 

![img](https://lh3.googleusercontent.com/NGxJ05I1JwXzXljs-o7ZDJvWaxGD_iqIL6f0CyASC2chaCK-JuNGeEOtRdNfpV3ZAyCmJ84kGAiqDILIXGUq7d_JD9BRB8WbWE3qeFf2YUI8nT1gEueQBaSpK_RHGbqyKuzJf9bG)

Enter your email to get mail with unique link to reset your password

```
mutation {
	askResetPassword (email:"qa+2q@mobidax.io , "lang:"eng") {
	data
  }
}
```

```
{
  "data": {
    "askResetPassword": {
      "data": "ok"
    }
  }
}
```

Enter new password

![img](https://lh4.googleusercontent.com/fkwfXy6BKIDmDZWVZy3yoazto_56n3SS9UpsDTpYn6icrfhsENlULyzYvRVBmpuj73zJTkYezmiqHudZCdhABCY_Q2L-XD60CvSBHpWAel969z_Mgl9RX8uT1-wcRBEVIW0Je5J8)



```
mutation {
	resetPassword (reset_password_token:" " , password:"1z2g4hedjdsAdJS" , 
	confirm_password:"1z2g4hedjdsAdJS" , lang:"eng" {
  	data
  }
}
```



```
{
  "data": {
    "resetPassword": {
      "data": "ok"
    }
  }
}
```



## Sing in

![img](https://lh6.googleusercontent.com/RMk2jZmWikIW2VK7GYcysgPcsKoobxaOYHLet8EOp-_9vkdejU9NqNSTByjyAi8VxntcpKY7khBe5anbCTl5qW06sGv_T4rXl4r4ENguD1BiRVBBrMp7OAItckXWvG06FLH3fxBK)



```
mutation { 
	login (email:"qa+2q@mobidax.io" , password:"1z2g4hedjdsAdJS") {
	uid
	email
	_barong_session
  }
}
```



```
{
  "data": {
    "login": {
      "uid": "ID78C6A1C05A",
      "email": "qa+2admmsamds@mbo.io",
      "_barong_session": "17f07795d79cd416fe3b552e6a3ecd0a"
    }
  }
}
```





## Sing in with 2FA



```
mutation {
	login (email:"qa+2q@mobidax.io" , password:"1z2g4hedjdsAdJS" , 
	otp_code: "313533" ) {
	uid
	email
	level_barong_session
	otp
  }
}
```



```
{
  "data": {
    "login": {
      "uid": "ID6240BA93D4",
      "email": "qa+2q@mobidax.io" ,
      "level": 3,
      "_barong_session": "6d1998f1e55575f3f8af1e671ee2537d",
      "otp": true
    }
  }
}
```





# Account Page 

![img](https://lh3.googleusercontent.com/yp9iUeosW2hmRg3RoXmviTlSnr5-HUkPAbDko22CMRuCX3zLcTmie9AOd4tL0f7x-OPeKw3Z_ZpVnBTJMeSAsMN41gi9CIg7_5peEa9yJkvJESPvAzEFiw5mS4rbj-NaTGvJOppO)

Two-factor authentication is extra layer of security system to your account — an additional login step — to prevent someone from logging. Click on slider 2FA status.



## 2FA enable

![img](https://lh4.googleusercontent.com/UTuSv4QST2TJ-s0qwATb7jBFEN28p2fWXBN-UM4W1k9_2sxwGCKRIu_m47VcWNPUwtabB6WGdcVpUS76W96xFAI_pjM0GXSl2gJxIi6a4_-Hx-byjpAw0rrsdOoTj_BCkRXzoGId)

Copy code in google authenticator and enter code to turn on 2FA

```
mutation {
	enableOTP (_barong_session:"7ae61cc5bdf63a4e919d24fbb5aeb8fa" , code:"731603") { 
	data
  }
}
```





## 2FA disable

![img](https://lh6.googleusercontent.com/z3BhRne5XZC8aVcLZFTCL8WDY3D3qpzc7Qs28DD0ps6gfZHTNwXnOH9H3O7Fk6SLTjYSWv39I8TtK9kWIi4dOgZQ6azwUvWpr9AvD0WhO6nImIsaQs6FEKlV_Qw0PODk0WO-J4sU)



```
mutation {
	disableOTP (_barong_session: "7ae61cc5bdf63a4e919d24fbb5aeb8fa", code:"209900") { 
	data
  }
}
```



```
{
  "data": {
    "disableOTP": {
      "data": "ok"
    }
  }
}
```



## Phone verification

![image-20210713153411487](C:\Users\user\AppData\Roaming\Typora\typora-user-images\image-20210713153411487.png)

![img](https://lh4.googleusercontent.com/WkYQe3HL-YWNq5c7x-ZqWjAMNo1FdXR7Lyg8yc-LVlq06yG-lGPIQxCFTN9SzNnlKStSN_6ViuQWWkRRsoHl9cYZg9bq8V_89SYbBcqWTgdUP4tupB7l1eK5ALXc2UPMzn-ausqx)



```
mutation {
	addPhone (_barong_session:"b8163651a35f7395255bd4639f050a60" , phone_number:"380962585669") {
	data
  }
}
```



```
{
  "data": {
    "addPhone": {
      "data": "ok"
    }
  }
}
```



```
mutation {
	askPhoneCode (_barong_session:"b8163651a35f7395255bd4639f050a60" ,
	phone_number:"380962585669") {
	data
  }
}
```



```
{
  "data": {
    "askPhoneCode": {
      "data": "ok"
    }
  }
}
```

![img](https://lh4.googleusercontent.com/2nsqGjf_6nQzjvp-Ug6--W8O1IJM7zTEiSBMz1K5A3YhXIrsVHbdx6fKORKDDGVsKux8_t0dIN2s4UG00f56A2ziCN6B7xRUPLnZaYoIoRMaMS8JY6ZxnrlUAxgDb12NXCboeXvn)





```
mutation {
	verifyPhone (_barong_session:"b8163651a35f7395255bd4639f050a60" ,
 	phone_number:"380962585669" , verification_code:"58236") {
	data
  }
}
```



```
{
  "data": {
    "verifyPhone": {
      "data": "ok"
    }
  }
}
```



## Identity verification

Identity verification is an authentication process that compares the identity a person claims to possess with data that proves it. There are many documents that can serve as providers of this objective truth: birth certificates, social security cards, driver's licenses, and others.

![img](https://lh4.googleusercontent.com/uZdoNSJ-kmE3HJ9Ylp1WxoTDTX9qyrtYHKC1FHgCN9ijuV-n_5ZqEQMuyHonv7sZohOheeCpJHGF5W7RGHCpANlZGBwLj1kx4LgGIgzzwII1ywqQHvi_UsxcN-0vqyckK3UZsmpp)

![img](https://lh6.googleusercontent.com/e038zpnUIU3owfz0KLD8Lc5jWseGxfmQnEhBTrPaKSGL-_tLCRWanl7dygrsfuHC4MhnwUX6Pmo72tsQk7ZDetj7PKGoZDurELC6Ti1jxGsl4M-Tkubhb-4ZTLVTPBizeYrrKq6h)



## Document verification

![img](https://lh5.googleusercontent.com/cWhldmsbCGWzs6L9MJ1RcQrkQ_e-1uL2GADcCVLGAfG_g1k8Uk0orgp8wS9sHJcbh4Bc-dONBxVcAuoW-hCEuYSyO9gpF0dEjX_kPZDCIf37d9CqMmIqZU6iDKUmkMxuyWP0SCuQ)





## API keys

In application programming interface key (API key) is a unique identifier used to authenticate a user, developer, or calling program to an API. An API Key can be considered as a username that is generating to allow access to data. In this example, the API is generated by the exchange and you then pass it on to another application. The application will then import your data based on the permissions you allow for.

### Enable API 

![img](https://lh4.googleusercontent.com/5kvSnasM7nzyAuz15Fv3oPepYWBXGO8uRT-ZEDD9noMCs8Sd6Cj38YGo_kOnpC1BrAecTDu4jXn9n5MAi5vKaGQRjUpaevB4fYZBnD4ASdjImTv_2HYQMoR7ItQG3w4UNVt8CF8u)

To create an API key you need to enable 2FA and enter 2FA code

```
mutation { 
	createApiKey
	(_barong_session:"30464564483d5fdb066b8fcefbf485ce" , otp:"086651") {
	kid
	algorithm
	enabled
	secret
  }
}

```



```
{
  "data": {
    "createApiKey": {
      "kid": "28410986effce4280"
      "algorithm": "HS256"
      "enabled": "true"
      "secret": "647sj58787fhs37dmksm5sqsnn5329bb9"
    }
  }
}
```



### Disable API



![img](https://lh3.googleusercontent.com/wZ3U8u1PZfllqDkVT-5OVbXBHWvgi7TVHXuEnhbn9i-3acZvfPMTOlpALuW30fTpYTQlOa-6y1kFV38yX7ah1epVv7Hk22FJWaeGNWNKm3rlGeFbh8IxzKsnyQDbDWfl0UYfLmY6)



```
mutation {
	updateApiKey (_barong_session:"30464564483d5fdb066b8fcefbf485ce" , otp:"276822" ,
  kid:"f934fedf9f92c6d5" , enabled:false) {
  data
  }
}
```



```
{
  "data": {
    "updateApiKey": {
      "data": "ok"
    }
  }
}
```



### Delete API 

```
mutation {
	deleteApiKey (_barong_session:"30464564483d5fdb066b8fcefbf485ce" ,
	otp:"158286" , kid:"f934fedf9f92c6d5") {
	data
  }
}
```



```
{
  "data": {
    "deleteApiKey": {
      "data": "ok"
    }
  }
}
```



# Funds Page

![img](https://lh6.googleusercontent.com/7f-yaa8cMztFG08GjNqpMFqzNz8x5B4OR_S55iTYpM5PZ5vUYhOFikaaeBXk2jNqQ_ZFVKrrgrr5PZxQ8YM1JvV03wPzRbVtXft5o1RCxPkG6x2DZj8PGntqyr1SrES6eX_abWiM)

On these page user can see coin/token/fiat balances, deposit or withdrawal funds. 



## Deposit 

In funds page select the type of cryptocurrency that you need to deposit you will see a deposit wallet address

![img](https://lh6.googleusercontent.com/qmgBTRguSXnJmIFJh7m727DdOgHZC342DpRfB0FrnpzEueg0uo7G7EFKejWGnLe9N009ul_oEZyvJkdnY-bknb7hWuRKvoGJBnhDN3dzCzxIzPXEXrYPfC5U_G7K07B0SC3kr8Xg)

Click “Copy” button or scan QR-code and send cryptocurrency to these address







## Withdrawal  	

First choose the cryptocurrency you’d like to withdraw,than choose beneficiary, enter withdrawal amount, next click withdraw and enter 2FA code.

![img](https://lh4.googleusercontent.com/gz_MbcyxTg3LuIDneqIbKKZJcsXWxScSKW9VGKihzKIhTesbdBtJ3phcdq6EFQyjofuVtttD9phJ3Dp-BIyS0NysQ2ZdfDb8vqGhTGxTe3d8IyBohqNP5n3oaX3fXe6PTDmUoFy-)



```
mutation {
	createWithdrawal (_barong_session:"" , otp:"" , beneficiary_id: 4 ,
	currency:"" , amount:5 , note:"") {
	currency
	id
	blockchain_txid
	created_at
	fee
	done_atid
  }
}
```





## Beneficiary

A beneficiary is the address that you legally designated to receive cryptocurrency, this is used to further protect your funds.

### Create beneficiary coin/fiat 

You need click “choose beneficiary” button and click “add beneficiary” , enter name beneficiary , blockchain address and click create . 

![img](https://lh5.googleusercontent.com/4zDr4QZjncZyO53t98dJxBTGu0tqfkTKeW6NATT257OwNB-lpRYXB3evZ8KQ6FAipCo0vdNUdbw5CYrZh8PnEOdZJxKQgM6Q1PZF7zqmqFW1cgY6KZhIZF5fGKC6v_MCWwcqb4tK)

```

mutation {
	addBeneficiaryCoin
	(_barong_session:"34f54446f6c9646071cb227c28c66f0c" , currency:"eth" ,
	address:"0xe0s15csc95d7e382d4a986377f30e616bbe93b90d1" , name:"test2" ,
	description:"1") {
	id
	currency
	name
  }
}
```



```
{
  "data": {
    "addBeneficiaryCoin": {
      "id": 134,
      "currency": "eth",
      "name": "test2"
    }
  }
}
```



### Activate beneficiary

![img](https://lh6.googleusercontent.com/zJe_IuSN7pNIlgbC97hsn2SFKGOxjjvf0gz1zJrvpI8oqJwFW1_6YazB9bz5T5aRz4koguBQb1hrj-7-0AkyigCErufXhyevXynpgynlTXyPVa6W2tSnGDl6zS4c5a7-szl0vBY5)

Enter beneficiary verification code from email

```
mutation {
	activateBeneficiary (_barong_session:"34542d10dcfdbd9436c2f9eb29c56de3" ,
	id:134 , pin:"438888") {
	id
	currency
	name
	address
  }
}

```



```
{
  "data": {
    "activateBeneficiary": {
      "id": 134,
      "currency": "eth",
      "name": "test2",
      "address": "0xe0s15csc915d7e382d4a986377f30e616bbe93b90d1"
    }
  }
}
```





### Delete beneficiary

![img](https://lh3.googleusercontent.com/xIxTxgffJumYwrSs7QeP_4ceewmhpYolhFnfR6x1kuIHRbXhoL-VfR_2V0hAlASZT5HIISao8t4L5NUhIVT0krr_J6NoXrl-NZEp87d7DExWswFeORXo1my3eJhQPvq8M9BQEiQM)

Сlick on cross to delete beneficiary

```
mutation {
	deleteBeneficiary (_barong_session:"34542d10dcfdbd9436c2f9eb29c56de3" ,
	id:134) {
	data
  }
}
```



```
{
  "data": {
    "deleteBeneficiary": {
      "data": "ok"
    }
  }
}
```





# Exchange Page 

![img](https://lh3.googleusercontent.com/AbZz90AVdxzXfrAji9Z1RCN079r-SJMnh81Tp--X8lvsUfNA6BOBHJ6rk8WLIWVw_a2J0xTOCfJUvvNiFIYhTsU2EqrOZvzHCL96PGn-82lirayv6vsd8pCyRlf4C6P82d8xA-tb)



## Order book

![img](https://lh5.googleusercontent.com/fasFlSMWticSy3sIXfQ0PfoJ9Sht3YgOVkSl61c6KRHHOs0-8iFYXUHYITfn5NO0WFYN-yskZoCggpjSudZ8xalQk8kyAnw6edifvO87KnJB8xBnWHH1YzGUCGZDsbf5_iIujSlj)

**Order book** is electronic list of buy and sell orders for a cryptocurrency organized by price level. An order book lists the number of crypto being bid on or offered at each price point, or market depth.These lists help traders and also improve market transparency because they provide valuable trading information.**Market depth** refers to a market's ability to absorb relatively large market orders without significantly impacting the price of the cryptocurrency . Market depth considers the overall level and breadth of open orders, bids, and offers, and usually refers to trading within an individual cryptocurrency. Typically, the more buy and sell orders that exist, the greater the depth of the market—provided that those orders are dispersed fairly evenly around the current market price of that cryptocurrency.



## Chart 

A **daily chart** is a graph consisting of a price сryptocurrency during a single day of trading. Commonly, these data points are depicted by bar, candlestick, or line charts.

![img](https://lh3.googleusercontent.com/26oYR0myrM9KlBbYla2lJtlXz9UIRQCJwv2SsrQZnw6zmPXGTMtubyZlQ0NkfL_zJWJzTN6DzSm_DohVgj4ZjgD3wyepCAfan135nSpeJcaPqW-_ZRONQC__-9geeHoY2QT_SA16)



Chart **time frame** is a period of seconds, minutes, days, hours, weeks, months, etc. in which period price have changes.One-minute charts show how the price moves during each one-minute period. A five-minute chart tracks price movement in five-minute increments and etc.

![img](https://lh3.googleusercontent.com/10zm6Z63f7EUwWGfcNToBlC-9cWo7mv7mx22HgbTgfaVRuhlBUShyPM4psMG2b6hBZQ4-INufoG3q-elbK-EhlsLhyPyNrpKGmvLETCBUkn1ajGVaM1S8WPLyU0A5VVg9eMhHM2M)



## Market/Limit orders

![img](https://lh5.googleusercontent.com/A177S4xLn0-UfBMq0HHRvhu76RafkvPQScZvYN_cCdwbw9dccNhfLEKqX9JqaKj4vx4RaLNUH6Odk1X9g7WvJG9cvvbxcBvAlgAjkfJZFcD0MHrcrgov9LJ2N4zyJbgcKuj2yW_g)![img](https://lh4.googleusercontent.com/uaHadGkJsPJw_gB8BIj_ycFac6hc3l_Tq7uuKteCKBv-KqBaj4UTbeqvfqPAKAnAuh1-tSB9uMPBNk2mYWSWTQWEpl5Ok-1Ym5_AfFjpPusheMfHjXEqxsm93q4zUsdbykRFM6-D)



**Market orders** are essentially orders that are expected to execute immediately.A market order will be filled at the highest possible existing market price at the time an order is placed. For instance, if you are looking to buy half a Ethereum at Mobidax for $2100 and don’t want to wait until the price drops lower, then a market order is your best option.
A **limit order** is a type of buy or sell order that dictates the specific price at which an asset must be purchased or sold. For instance, If the price of Ethereum is $2100, you can set a limit order of $2000. This means if Ethereum drops to $2000, your limit order will automatically purchase the asset for you.



Market order

```
mutation {
	createOrder (_barong_session:"3483429bb0f6e59feb8bc02b20d77308" , market:"ethusd" ,
	side:"buy" , volume:0.00678 , ord_type:"market") {
	id 
	side
	market
	origin_volume 
  }
}
```



```
{
  "data": {
    "createOrder": {
      "id": 10390647,
      "side": "buy",
      "market": "ethusd",
      "origin_volume": "0.00678"
    }
  }
}
```



Limit order

```
mutation  {
	createOrder	(_barong_session:"3483429bb0f6e59feb8bc02b20d77308" , market:"ethusd" , side:"sell",
	volume:0.0222 , ord_type:"limit" , price: 2012) {
	id 
	side
	market
	price
	origin_volume
  }
}
```



```
{
  "data": {
    "createOrder": {
      "id": 10390754,
      "side": "sell",
      "market": "ethusd",
      "price": "2012.0",
      "origin_volume": "0.0222"
    }
  }
}
```



## User orders

Here we can see orders that were not executed. These are all limit orders

![img](https://lh5.googleusercontent.com/oI5XMq_014m-E_YfgKaSoJFF_8H8Wj-t5XYYNBYTNabErL6om2-guEfSrEQyE6TrZltddOnIpBuSWlCFCgAmclJ5xc1_1pYXST_0BgTDURqmauLl62nWAqmew2IrdjKZhkxw7YbE)



```
query {
	userOrders (_barong_session:"3483429bb0f6e59feb8bc02b20d77308" , market:"ethusd" , state :"wait" ,
	limit: 5 , page: 1 , order_by:"desc" , order_type:"limit" ,type:"sell") {
	id 
	market 
	side 
	ord_type
    price 
  }
}
```



```
{
  "data": {
    "userOrders": [
      {
        "id": 10390754,
        "market": "ethusd",
        "side": "sell",
        "ord_type": "limit",
        "price": "2012.0"
      },
      {
        "id": 10389517,
        "market": "ethusd",
        "side": "sell",
        "ord_type": "limit",
        "price": "2000.0"
      },
      {
        "id": 10322707,
        "market": "ethusd",
        "side": "sell",
        "ord_type": "limit",
        "price": "2100.0"
      },
      {
        "id": 10280127,
        "market": "ethusd",
        "side": "sell",
        "ord_type": "limit",
        "price": "2119.0"
      },
      {
        "id": 10280126,
        "market": "ethusd",
        "side": "sell",
        "ord_type": "limit",
        "price": "2119.0"
      }
    ]
  }
}
```





## My trades /All trades



![img](https://lh6.googleusercontent.com/osVURf-cwIdHUnsuB7iC0T1F2_Iv5m-0q6VaiX8S_wDCwftM50z6_2JdRUBPENlF0KoUIq3PM2YImO533-7Y6OEFZ0B3Vlhu-Lfck2PaetYLPwMwr_AeLdxjxkXlm_DyHvVnIUrm)

In the window “my trades” user can see his trades,similarly “all trades” show all trades on Mobidax 

![img](https://lh6.googleusercontent.com/osVURf-cwIdHUnsuB7iC0T1F2_Iv5m-0q6VaiX8S_wDCwftM50z6_2JdRUBPENlF0KoUIq3PM2YImO533-7Y6OEFZ0B3Vlhu-Lfck2PaetYLPwMwr_AeLdxjxkXlm_DyHvVnIUrm)



# History Page

## Order History

Order history is a convenient way for a user to keep track of all current and past orders and their status. It allows the buyer to get up-to-date information on each order placed, including amount,time and price buy/sell

![img](https://lh4.googleusercontent.com/hy60HptfTGTFbODBBVXK3hh0fsXwR82QvQrcUO09HCU5uLl8eVGJDDV7y0D6SIwQuM5_u2fKMlCzjJCi70nXM5O3X2NSVW4cRs4gQ_tg8L4wZDyCelmGXSTstxiZ2fSsRb2wQO6z)



```
query {
	getOrderHistory (_barong_session:"3483429bb0f6e59feb8bc02b20d77308" , market:"ethusd" , state:"done"
	page:8 , limit:5 , order_by:ASC , type:"sell" , ord_type:"market") {
	orders {
	side
    price 
    created_at
    marketName
  }
 }
}
```



```
{
  "data": {
    "getOrderHistory": {
      "orders": [
        {
          "side": "sell",
          "price": "2493.35",
          "created_at": "1622456059",
          "marketName": "ETH/USD"
        },
        {
          "side": "sell",
          "price": "2060.25",
          "created_at": "1625216071",
          "marketName": "ETH/USD"
        }
      ]
    }
  }
```



## Trade History

The trade history is a way for traders to read the latest buy and sell trades that have been executed on an exchange. When a customer using an exchange makes a trade on a trading pair, the completed trade will be broadcast to the other traders on the exchange.

![img](https://lh5.googleusercontent.com/jDZl5etgnYMwZ0CyfhD02HCHJo1GQhd3xSYxY-f8SPPC8BAeifOZ-0cupjFhjMkfm18WDEBnaj-oQ5UizJA7M7XM05MtA3GFa2EWefFpM2m9of4Dju6o5h3Pz20mAwQS52FIBZ8P)



```
uery {
	getTradeHistory (_barong_session:"3483429bb0f6e59feb8bc02b20d77308" , market:"ethusd"
	page:1 , limit:3 , order_by: DESC ,time_to: 1626260007 , time_from: 1626259805) {
	trades {
	market
    side
    amount 
    total 
    id
  }
 }
}
```



```
{
  "data": {
    "getTradeHistory": {
      "trades": [
        {
          "market": "ethusd",
          "side": "sell",
          "amount": 0.0084,
          "total": 16.313388,
          "id": "7690481"
        },
        {
          "market": "ethusd",
          "side": "sell",
          "amount": 0.00011,
          "total": 0.2136277,
          "id": "7690480"
        },
        {
          "market": "ethusd",
          "side": "sell",
          "amount": 0.00022,
          "total": 0.4272972,
          "id": "7690472"
        }
      ]
    }
  }
}
```





# Logout



![img](https://lh3.googleusercontent.com/wAgSWeGxRmGfJkRS9pb4vNiRq8-OHoHI1iuWrBA1A8Oeec8N-5IeTo6FVurJfewj3EUS5YXUF2GQwJriGPTj3NofQEp5JuOv2quhXtJ2ZuM_upDd3fbEHBte-4vuUheYD4moKKSp)

![img](https://lh5.googleusercontent.com/Ahi8dzsBlbLQLv-4UxkErF4ucURbDctwS9JRDSTItCn8TZGV1WzF_J_vbtTLufeVL8rDODwyomj0v2TgnMqIS2eY6k1Nlyc5itRohN0P8hbJEL84LZQadoxlU8Zp94ECYygssU5w)



```
mutation {
	logout (_barong_session:"3483429bb0f6e59feb8bc02b20d77308") {
	data
  }
 }
```



```
{
  "data": {
    "logout": {
      "data": "ok"
    }
  }
}
```



