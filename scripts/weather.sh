#!/bin/sh

JSON=$(curl -s https://wttr.in/?m\&format='j1' | jq '.current_condition[0]' -c)

curl -s https://wttr.in/\?m\&format='j1'\
  |jq -r '.current_condition[0]|.weatherDesc[0].value,.FeelsLikeC,.temp_C,.humidity,.windspeedKmph,.winddirDegree,.precipMM,.uvIndex' \
  | sed -e '2 s/^/Feels: / ; 2,3 s/$/°C/ ; 4 s/^/Humidity: / ; 4 s/$/%/' \
    -e '5 s/^/Wind: / ; 5 s/$/kph/ ; 6 s/^/Wind Direction: / ; 6 s/$/°/' \
    -e '7 s/^/Precipitation: / ; 7 s/$/mm/ ; 8 s/^/UV: /'
