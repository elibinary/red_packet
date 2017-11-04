# API 文档

> 所有接口都需要携带身份凭证（red_token），可以放在 Headers 中或者直接在请求参数中携带



```
Header: { 'RED-TOKEN' => 'eyJhbGciOiJIUzI1NiJ9.eyJvcGVuaWQiOiJmOGU2NmRmNWVjZWI0ZGMyOWVmNjlkMzU3Mjc2NTlmZCIsImV4cCI6MTUxMjQxMTgzNn0.Cv5khl0sU8w5KBASOwlwTRerPw1hveUd3AEfjDByxeg' }
```

```
params: { red_token: 'eyJhbGciOiJIUzI1NiJ9.eyJvcGVuaWQiOiJmOGU2NmRmNWVjZWI0ZGMyOWVmNjlkMzU3Mjc2NTlmZCIsImV4cCI6MTUxMjQxMTgzNn0.Cv5khl0sU8w5KBASOwlwTRerPw1hveUd3AEfjDByxeg' }
```



## 查看个人余额 [ GET /api/v1/wallets ]

### Request

无

### Response

```
{
    "balance": "0.0"
}
```



### Example (curl)

```
curl -X GET \
  http://localhost:3000/api/v1/wallets \
  -H 'cache-control: no-cache' \
  -H 'postman-token: 7f9e472a-6bc4-1de9-7c15-c684c58dafdc' \
  -H 'red-token: eyJhbGciOiJIUzI1NiJ9.eyJvcGVuaWQiOiJmOGU2NmRmNWVjZWI0ZGMyOWVmNjlkMzU3Mjc2NTlmZCIsImV4cCI6MTUxMjQxMTgzNn0.Cv5khl0sU8w5KBASOwlwTRerPw1hveUd3AEfjDByxeg'
```





## 发红包 [ POST /api/v1/red_bags ]

### Request

* money: 金额
* numbers: 人数

```
{
  "money": "6.6",
  "numbers": 5
}
```

### Response

* red_code: 红包 ID
* word: 红包口令

```
{
    "success": 1,
    "red_code": "4f"
    "word": "1234abcd"
}
```

### Example (curl)

```
curl -X POST \
  http://localhost:3000/api/v1/red_bags \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'postman-token: 411b7545-5929-d925-1d09-5a8c0eac9c45' \
  -H 'red-token: eyJhbGciOiJIUzI1NiJ9.eyJvcGVuaWQiOiJmOGU2NmRmNWVjZWI0ZGMyOWVmNjlkMzU3Mjc2NTlmZCIsImV4cCI6MTUxMjQxMTgzNn0.Cv5khl0sU8w5KBASOwlwTRerPw1hveUd3AEfjDByxeg' \
  -d '{
	"money": "6.6",
	"numbers": 5
}'
```



## 抢红包 [GET /api/v1/red_bags/grab]

### Request

```
{
  "red_code": "红包 ID，创建红包时有返回",
  "word": "红包口令"
}
```

### Response

* money: 抽到的金额

```
{
    "success": 1,
    "money": "2.03"
}
```

or

```
{
    "success": 0,
    "message": "口令错误/红包已被抢光/不可以重复拆红包"
}
```

### Example (curl)

```
curl -X GET \
  'http://localhost:3000/api/v1/red_bags/grab?red_code=1&word=5mwdxZF9' \
  -H 'cache-control: no-cache' \
  -H 'postman-token: 8f78d23d-5116-240b-5ab5-3c8b86c85adf' \
  -H 'red-token: eyJhbGciOiJIUzI1NiJ9.eyJvcGVuaWQiOiI2OTc3NDQyM2M4MGE0N2ZhOTA0ODk4NTQ4MDNkNjhkMCIsImV4cCI6MTUxMjQxMTgzNn0.tGrvMDNQElmXXXLoRuJL5nbDu5fMmN-rYC8IovB6D2k'
```



## 用户抢到的红包列表 [GET /api/v1/red_bags]

### Request

无

### Response

* total_money: 红包总金额
* money: 抽到的金额

```
{
    "red_bags": [
        {
            "red_code": "4f",
            "total_money": "6.6",
            "money": "2.03"
        }
    ]
}
```

### Example (curl)

```
curl -X GET \
  http://localhost:3000/api/v1/red_bags \
  -H 'cache-control: no-cache' \
  -H 'postman-token: 6fdf2a23-9979-57e8-87bf-a49152aeeb5a' \
  -H 'red-token: eyJhbGciOiJIUzI1NiJ9.eyJvcGVuaWQiOiI2OTc3NDQyM2M4MGE0N2ZhOTA0ODk4NTQ4MDNkNjhkMCIsImV4cCI6MTUxMjQxMTgzNn0.tGrvMDNQElmXXXLoRuJL5nbDu5fMmN-rYC8IovB6D2k'
```

## 单个红包拆包列表 [GET /api/v1/red_bags/:id]

### Request

```
请求地址中的 :id 请传 red_code 值
```

### Response

* 外层为发红包人信息
* items 中为抢红包人信息

```
{
    "user_name": "265d3c",
    "avatar_url": null,
    "total_money": "6.6",
    "total_numbers": 5,
    "items": [
        {
            "user_name": "a63712",
            "avatar_url": null,
            "money": "2.03"
        }
    ]
}
```

### Example (curl)

```
curl -X GET \
  http://localhost:3000/api/v1/red_bags/1 \
  -H 'cache-control: no-cache' \
  -H 'postman-token: 92120d04-89e1-99a7-7cea-c8db22e2755b' \
  -H 'red-token: eyJhbGciOiJIUzI1NiJ9.eyJvcGVuaWQiOiI2OTc3NDQyM2M4MGE0N2ZhOTA0ODk4NTQ4MDNkNjhkMCIsImV4cCI6MTUxMjQxMTgzNn0.tGrvMDNQElmXXXLoRuJL5nbDu5fMmN-rYC8IovB6D2k'
```

