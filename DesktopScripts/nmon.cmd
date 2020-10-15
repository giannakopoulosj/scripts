ECHO OFF
IF NOT EXIST "C:\Users\%USERNAME%\Desktop\NMON\" md "C:\Users\%USERNAME%\Desktop\NMON\"
del "C:\Users\%USERNAME%\Desktop\NMON\charts" /f /s /q
java -jar C:\Users\%USERNAME%\Desktop\MyScripts\NMONVisualizer_2019-04-06.jar com.ibm.nmon.ReportGenerator C:\Users\%USERNAME%\Desktop\NMON