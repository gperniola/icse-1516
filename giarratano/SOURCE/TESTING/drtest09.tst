(unwatch all)(clear)(set-strategy depth)(open "drtest09.rsl" drtest09 "w")(dribble-on "drtest09.out")(batch "drtest09.bat")(dribble-off)(load "compline.clp")(printout drtest09 "drtest09.bat differences are as follows:" crlf)(compare-files drtest09.exp drtest09.out drtest09); close result file(close drtest09)