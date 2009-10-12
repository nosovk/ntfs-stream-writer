program ntfs_stream_writer;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  windows;

  function BackupSeekA(hFile: THandle; dwLowBytesToSeek, dwHighBytesToSeek: DWORD;
    lpdwLowByteSeeked, lpdwHighByteSeeked: PDWORD;var lpContext: Pointer): BOOL; stdcall; external kernel32 name 'BackupSeek';

function CopyFileI(source, dest:pchar):boolean;
var h,h2:integer;
mas:array[1..2048] of byte;
i:cardinal;
done:cardinal;
begin
result:=false;
h:=CreateFile(source,GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,0,0);
if h=-1 then exit;
h2:=CreateFile(dest,GENERIC_WRITE,FILE_SHARE_WRITE,nil,OPEN_ALWAYS,0,0);
while ReadFile(h,mas,sizeof(mas),done,nil) and(done<>0) do
WriteFile(h2,mas,done,i,nil);
CloseHandle(h);
CloseHandle(h2);
result:=true;
end;

var
s:string;
wszStreamName:array[0..MAX_PATH-1] of WCHAR;
sid:WIN32_STREAM_ID absolute wszStreamName;
hh:thandle;
p:pointer;
temp,dw1, dw2:cardinal;
begin
ExitCode:=0;
if ParamCount=1 then
begin
p:=nil;
hh:=CreateFileW(pwidechar(ParamStr(1)),GENERIC_READ, 0, nil, OPEN_EXISTING,
FILE_FLAG_BACKUP_SEMANTICS or FILE_FLAG_POSIX_SEMANTICS, 0);
while true do begin
writeln('-------------------'); // разграничиваем записи ;)
BackupRead(hh, @wszStreamName, sizeof(sid), temp, FALSE, TRUE, p);
if temp = 0 then break;
if sid.dwStreamNameSize > 0 then begin // если у потока есть им€, то узнаем его
BackupRead(hh, pointer(integer(@wszStreamName) + sizeof(sid)), sid.dwStreamNameSize, temp, FALSE, TRUE, p);
if temp <> sid.dwStreamNameSize then break;
{ дл€ простоты всЄ выводитьс€ в TMemo }
writeln(PwideChar(@sid.cStreamName));
end
else writeln('Stream without name');
writeln('Stream size: '+IntToStr(sid.Size));
s:='Type of data: ';
case sid.dwStreamId of // определ€ем тип потока
BACKUP_DATA: s := s+' data';
BACKUP_EA_DATA: s := s+' extended attributes';
BACKUP_SECURITY_DATA:	s := s+' security';
BACKUP_ALTERNATE_DATA: s := s+' other streams';
BACKUP_LINK: s := s+' link';
else s := s+' unknown';
end;
writeln(s);
if sid.Size>0 then
{ € не думаю, что у кого-то есть потоки больше 4√Ѕ, поэтому второй параметр поиска = 0 }
BackupSeekA(hh, sid.Size, 0, @dw1, @dw2, p);
end;
BackupRead(hh, @sid, 0, temp, TRUE, FALSE, p);
CloseHandle(hh);
end
else
if ParamCount=2 then
begin
if CopyFileI(pwidechar(paramstr(1)),pwidechar(paramstr(2))) then
  Writeln('New file "'+ParamStr(2)+'" created')
else
  begin
    ExitCode:=2;
    Writeln('Unable to extract stream to file "' + ParamStr(2)+'"');
  end;
end
else
BEGIN
Writeln('To read data');
Writeln('First param - sourse ntfs stream in format:');
Writeln('"Full File Path + Name + Extension + : + StreamName"');
Writeln('Second param - destination file name, filename where to save stream');
Writeln('To write data - just change places :)');
ExitCode:=1;
Exit;
END



end.
