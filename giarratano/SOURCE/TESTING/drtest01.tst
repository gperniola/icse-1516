(unwatch all)(clear)(set-strategy depth)(open "drtest01.rsl" drtest01 "w")(dribble-on "drtest01.out")(batch "drtest01.bat")(dribble-off)(load "compline.clp")(printout drtest01 "drtest01.bat differences are as follows:" crlf)(compare-files drtest01.exp drtest01.out drtest01); close result file(close drtest01)