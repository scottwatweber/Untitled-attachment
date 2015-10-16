del c:\backup\repositories\webersystems.net < c:\Y.txt
del c:\backup\repositories\yabahaba.net < c:\y.txt
xcopy d:\repositories z:\backup\repositories /s /y
"C:\Program Files (x86)\VisualSVN Server\bin\svnadmin.exe" hotcopy d:\repositories\webersystems.net c:\backup\repositories\webersystems.net
"C:\Program Files (x86)\VisualSVN Server\bin\svnadmin.exe" hotcopy d:\repositories\yabahaba.net c:\backup\repositories\yabahaba.net
xcopy C:\backup\repositories z:\backup\repositories /s /y
pause
