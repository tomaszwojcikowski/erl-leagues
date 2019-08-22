# Derivico

Div = League Division
Date = Match Date (dd/mm/yy)
HomeTeam = Home Team
AwayTeam = Away Team
FTHG and HG = Full Time Home Team Goals
FTAG and AG = Full Time Away Team Goals
FTR and Res = Full Time Result (H=Home Win, D=Draw, A=Away Win)
HTHG = Half Time Home Team Goals
HTAG = Half Time Away Team Goals
HTR = Half Time Result (H=Home Win, D=Draw, A=Away Win

# API

## JSON

    ```
        curl -H "content-type: application/json" -d {"season":"201617", "div": "SP1"} http://localhost:8000
    ```

    ```
    ```

## Protobuf

    ```
        curl -H "content-type: application/x-protobuf" -d [binary] http://localhost:8001
    ```

    ```
    ```

