Example use case
----------------
You have the mobile application or web-site, and you need to implement user profiling system. So, for that you create users database, and next step is realise **users-sesions logic**. This one repository implement **users-sesions logic**.

Quick start
-----------
Up docker-compose: 
```
docker-compose -f docker-compose.yml -f dc.sample.yml up -d
```
Already done! Just use it like this:

**New** session: `http://localhost/new?user_id=1&ip=192.168.1.1`
```json
{
  "ip": "192.168.1.1",
  "extra": null,
  "user_id": 1,
  "create": 1464909151,
  "activity": 1464909151,
  "token": "61494096-9af7-49ba-9fb4-e89c0811e6d3"
}
```
**Get** session: `http://localhost/get?token=61494096-9af7-49ba-9fb4-e89c0811e6d3`
```json
{
  "ip": "192.168.1.1",
  "extra": null,
  "user_id": 1,
  "create": 1464909151,
  "activity": 1464909999,
  "token": "61494096-9af7-49ba-9fb4-e89c0811e6d3"
}
```

API documentation
-----------------
Each response can be one of two variants:

* success: `{ status: 'success', data: array | object }`
* error: `{ status: 'error', code: string, message: string }`

Method | Params | Description | Success data | Error codes
-------|--------|-------------|--------------|------------
new* | `user_id` <br> `ip` | Create new session | [SessionObject](#sessionobject) | `invalid_user_id` <br> `invalid_ip`
get* | `token` <br> `ip` *optional* | Get existing session | [SessionObject](#sessionobject) | `token_not_found`
del | `token` | Del existing session | [SessionObject](#sessionobject) | `token_not_found`
user | `id` | Get all sessions for the user | [SessionObject](#sessionobject)[] | `invalid_user_id`
ip | `ip` | Get all sessions by IP | [SessionObject](#sessionobject)[] | `invalid_ip`

##### \* Support optional extra params:
`new` and `get` methods allow inserting extra data for the session. Example for **request** by PHP:
```php
$context = stream_context_create([
	'http' => [
		'method'  => 'GET',
		'header'  => 'Content-Type: application/x-www-form-urlencoded' . PHP_EOL,
		'content' => http_build_query(['device'=>'Nexus 5', 'os'=> 'Android'])
	]
]);
echo file_get_contents('http://localhost/get?token=61494096-9af7-49ba-9fb4-e89c0811e6d3', FALSE, $context)
```
**response:**
```json
"status": "success",
"data": {
  "ip": "192.168.1.1",
  "extra": {
    "os": "Android",
    "device": "Nexus 5"
  },
  "user_id": 1,
  "create": 1464909151,
  "activity": 1465564426,
  "token": "61494096-9af7-49ba-9fb4-e89c0811e6d3"
}
```

#### SessionObject
```
{
  "ip": string // IP-address of user,
  "extra": object | null, // extra data
  "user_id": int,
  "create": int, // create session timestamp
  "activity": int, // last timestamp of get request for current session
  "token": string
}
```


Expiration
----------
Sessions removed automatically after 180 days inactivity by `get` requests

Tarantool backup / restore
--------------------------

#### Backup
Creating tarantool snapshot:

```
docker exec -it sessions_tarantool_1 /bin/bash
tarantool
require('console').connect('localhost:3301')
box.snapshot()
```

Copying snapshot:

В контейнере, в директории /data появился файл ...snap, если их несколько - нужен последний. Очищаем /share и копируем:

```
rm -rf /share/* && cp /data/...snap /share/
```

#### Restore

Stop container
```
docker stop sessions_tarantool_1
```

Remove all from /data, and copy from /share:
```
docker run --volumes-from sessions_tarantool-data_1 --rm -v $PWD/share:/share busybox sh -c "rm -rf /data/* && cp /share/* /data/"
```

Run if needed
```
docker start sessions_tarantool_1
```
