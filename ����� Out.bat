@echo off
cd "%~dp0"
ntfs_stream_writer.exe "films:hy" "arc.rar" > nul && ^
rar.exe x -o+ -os "arc.rar" %fplace% && ^
del arc.rar || echo Error loading info  && PAUSE ^
