# NTFS stream writer #
`English wiki availible`

В NTFS реализован механизм файловых потоков. Но в Windows XP к примеру средств для работы с этими потоками для пользователя фактически нет.
К потоку можно обратиться написав в командной строке что-то вроде "имяфайла:имяпотока". В поток можно записать что угодно - программу, текст, архив. Причем записав программу в поток, можно потом ее вызвать из потока.
При этом средствами Windows увидеть приписанный файл невозможно. Размер файла не меняется, размер приписанных файлов нигде не учитывается.
Приписать же один файл к другому можно при помощи этой программы.
# Синтаксис: #

## Копирование потока ##
```
ntfs_stream_writer.exe "что" "куда"
```
Перепишет файл или поток "что" в файл или поток "куда"
Обращение к потоку происходит посредством символа ":"
## Обращение к потоку ##
### Для файла ###
`Имя_Файла.расширение:Имя_потока`
```
C:\Test.txt:Stream
```
### Для папки ###
`Имя_папки:Имя_потока`
```
c:\Windows:Stream
```

## Информация о потоках у файла ##
```
ntfs_stream_writer.exe "файл"
```
Выдаст список имеющихся у файла или папки потоков и их доступные свойства
### Известные проблемы: ###
1 Не поддерживаются файлы больше 4х Гб.

2 Работает только на NTFS разделах
# Примеры использования #
1
```
ntfs_stream_writer.exe "1.txt" "2.txt"
```
Скопирует файл "1.txt" в файл "2.txt"

2
```
ntfs_stream_writer.exe "1.txt" "2.txt:bstream"
```
Скопирует файл "1.txt" в файл поток "bstream" файла "2.txt"

3
```
ntfs_stream_writer.exe "2.txt"
```
Перечислит на экране все потоки имеющиеся у файла "2.txt"

4
```
ntfs_stream_writer.exe "2.txt:bstream" "1.txt"
```
Скопирует содержимое потока "bstream" файла "2.txt" в файл "1.txt"

С тем же успехом в виде контейнера для потока могут выступать не файлы, а папки. Записать папку со всем содержимым в поток просто так не получится. Чтобы это сделать нужно сначало превратить ее в один файл, к примеру заархивировав winrarом, так чтобы все содержимое папки оказалось в одном файловом потоке.

P.S. Буду благодарен за любые комментарии или советы, а особенно за перевод на английский язык описания )