Quick start
-----------
Up docker-compose: 
```
docker-compose -f docker-compose.yml -f dc.local.yml.sample up -d
```
Already done! Just use it like this:

New session: `http://localhost/new?user_id=1&ip=192.168.1.1`
```json
{
  "ip": "192.168.1.1",
  "info": null,
  "user_id": 1,
  "create": 1464909151,
  "activity": 1464909151,
  "token": "61494096-9af7-49ba-9fb4-e89c0811e6d3"
}
```
Get session: `http://localhost/get?token=61494096-9af7-49ba-9fb4-e89c0811e6d3`
```json
{
  "ip": "192.168.1.1",
  "info": null,
  "user_id": 1,
  "create": 1464909151,
  "activity": 1464909999,
  "token": "61494096-9af7-49ba-9fb4-e89c0811e6d3"
}
```

API documentation
-----------------
Each response can be one of 2 variants:
- success: `{ status: 'success', data: array|object }`
- error: `{ status: 'error', code: string, message: string }`
