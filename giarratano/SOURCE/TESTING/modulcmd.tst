(unwatch all)(clear)(dribble-on "modulcmd.out")(batch "modulcmd.bat")(dribble-off)(clear)(open "modulcmd.rsl" modulcmd "w")(load "compline.clp")(printout modulcmd "modulcmd.bat differences are as follows:" crlf)(compare-files modulcmd.exp modulcmd.out modulcmd)(close modulcmd)