# Technical Challenge App

## CSV Headers

```
Div = League Division
Date = Match Date (dd/mm/yy)
HomeTeam = Home Team
AwayTeam = Away Team
FTHG and HG = Full Time Home Team Goals
FTAG and AG = Full Time Away Team Goals
FTR and Res = Full Time Result (H=Home Win, D=Draw, A=Away Win)
HTHG = Half Time Home Team Goals
HTAG = Half Time Away Team Goals
HTR = Half Time Result (H=Home Win, D=Draw, A=Away Win)
```

## JSON API

### Request  

``` 
curl -H "content-type: application/json" -d {"season":"201617", "div": "SP1"} http://localhost:8000
```

### Results   

``` 
[
    {
        "id": "257",
        "AwayTeam": "La Coruna",
        "Date": "05/03/2017",
        "Div": "SP1",
        "FTAG": "1",
        "FTHG": "0",
        "FTR": "A",
        "HTAG": "1",
        "HTHG": "0",
        "HTR": "A",
        "HomeTeam": "Sp Gijon",
        "Season": "201617"
    }
]
```

    

    

## Protobuf API

    

### Request

``` 
curl -H "content-type: application/x-protobuf" -d [proto/messages.proto/Request] http://localhost:8001
```

### Results    

``` 
[proto/messages.proto/Data]
```

# Requirements

* Erlang 21
* Elixir 1.9
* Docker 18
* mix
* rebar3

    

## Building

### Environment variables

* `DATA_FILE` - path to CSV file with data
* `JSON_PORT` - port to handle json API
* `PROTO_PORT` - port to handle protobuff API

### Create release

``` 
make rel
```

### Create docker image

``` 
make docker
```

### Deploy 2 instances with HaProxy as Load Balancer

``` 
make deploy
```

## Testing

``` 
make test
```

## Logs

```
log/
```

## Metrics

* json.part
* json.all
* json.post
* proto.part
* proto.all
* proto.post
