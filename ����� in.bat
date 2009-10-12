@echo off
cd "%~dp0" && ^
rar.exe a -rr10 -t -df -k -m3 -o+ -os "arc.rar" "work" && ^
ntfs_stream_writer.exe "arc.rar" "films:hy" > nul && ^
del arc.rar || echo Error saving info && PAUSE
