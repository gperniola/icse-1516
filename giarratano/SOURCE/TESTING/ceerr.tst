(unwatch all)(clear)(dribble-on "ceerr.out")(load "ceerr.clp")(dribble-off)(clear)(open "ceerr.rsl" ceerr "w")(load "compline.clp")(printout ceerr "ceerr.clp differences are as follows:" crlf)(compare-files ceerr.exp ceerr.out ceerr)(close ceerr)