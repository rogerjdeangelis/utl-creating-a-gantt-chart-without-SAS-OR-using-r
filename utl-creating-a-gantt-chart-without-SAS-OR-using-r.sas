%let pgm=utl-creating-a-gantt-chart-without-SAS-OR-using-r;

Creating a gantt chart without SAS OR using r

github
https://tinyurl.com/553xxw7h
https://github.com/rogerjdeangelis/utl-creating-a-gantt-chart-without-SAS-OR-using-r

for output

https://tinyurl.com/j859e4yw
https://github.com/rogerjdeangelis/utl-creating-a-gantt-chart-without-SAS-OR-using-r/blob/main/gantt.pdf
https://www.dropbox.com/s/2tvf78q7iyx0nps/gantt.pdf?dl=0


see
https://chrisalbon.com/r-stats/gantt-chart.html

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/
options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
informat name $17. START_DATE END_DATE $10. ;
input NAME & $ START_DATE END_DATE IS_CRITICAL;
cards4;
Review literature    24/08/2010 31/10/2010 1
Mung data            01/10/2010 14/12/2010 0
Stats analysis       01/11/2010 28/02/2011 0
Write Report         14/02/2011 30/04/2011 1
;;;;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* SD1.HAVE total obs=4 11MAR2024:13:01:47                                                                                */
/*                                                                                                                        */
/* NAME              START_DATE  END_DATE  IS_CRITICAL                                                                    */
/*                                                                                                                        */
/* Review literature 24/08/2010 31/10/2010      1                                                                         */
/* Mung data         01/10/2010 14/12/2010      0                                                                         */
/* Stats analysis    01/11/2010 28/02/2011      0                                                                         */
/* Write Report      14/02/2011 30/04/2011      1                                                                         */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

%utl_submit_r64x("
library(reshape);
library(ggplot2);
library(haven);
dfr=as.data.frame
  (read_sas('d:/sd1/have.sas7bdat'));
dfr$NAME <- as.factor(dfr$NAME);
dfr$START_DATE <- as.factor(dfr$START_DATE);
dfr$END_DATE <- as.factor(dfr$END_DATE);
dfr$IS_CRITICAL <- as.logical(dfr$IS_CRITICAL);
mdfr <- melt(dfr, measure.vars =
  c('START_DATE', 'END_DATE'));
pdf('d:/pdf/gantt.pdf');
ggplot(mdfr, aes(as.Date(value
 ,'%d/%m/%Y'), NAME, colour = IS_CRITICAL)) +
  geom_line(size = 6) +
  xlab('Date') + ylab('Activity') +
  theme_minimal();
");

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/
                         October          January         April
+----------------------------------------------------------------------------+
|                           |               |               |   Is Critical  |
|  Review literature        | REDREDREDREDREDREDRED         |                |
|                           |               |               |    Red   True  |
|  Mung data                |               |   REDREDREDREDRED  Blue  False |
|                           |               |               |                |
|  Stats analysis     BLUEBLUEBLUEBLUE      |               |                |
|                           |               |               |                |
|  Write Report             |               |         REDREDREDREDREDREDRED  |
|                           |               |               |                |
+---------------------------+---------------+---------------+----------------+
                         October          January         April

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
