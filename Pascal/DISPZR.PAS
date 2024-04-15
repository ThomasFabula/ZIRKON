program display_fluodata;


{$I typedef.sys}          { System unabhängige Typendefinitionen     }
{$I graphix.sys}          { System abhängige Definitionen & Routinen }
{$I kernel.sys}           { System unabhängige Support Routinen      }


var  fil             : file of byte;
     i,j,k,m         : integer;
     stuff           : byte;
     bb              : array [1..100,1..9] of byte;
     screen1,screens : integer;
     yfluo           : array [1..100] of real;
     yflu            : array [1..2000] of real;
     test            : boolean;
     y_max,gy_max,xx : real;
     antwort,cha     : char;
     temp,anzahl     : real;       { Anzahl der Fluowerte }
     titel           : string[80];
     dxg,ddxg,yy     : real;
     dxu,ddxu        : real;
     dy,dyy,xy       : real;
     du,dyu,xu       : real;


{---------------------}
{-----  Anfang  ------}
{---------------------}

procedure intro;
begin
  clrscr;
  screens:=0;
  titel:='ZrI - Spektrum,  a 3 F 3 -> z 3 F 3,  614.320 nm';
  writeln('FLUO-Meßdatenkonvertierung:');
  writeln('===========================');
  writeln;
  {
  write('Test (J/N) ? : '); readln(antwort);
  antwort:=upcase(antwort);
  if (antwort='J')
    then test:=TRUE
    else test:=FALSE;
  }
  repeat
    gotoxy(1,6);
    write('Ab welchen Screen : ');
    readln(screen1);
    gotoxy(1,7);
    write('Wieviele Screens  : ');
    readln(screens);
  until (screens<>0);
  anzahl:=screens*100;
  
end;

{-----------------------------------------------}
{-----  Meßdatei einlesen & konvertieren  ------}
{-----------------------------------------------}

procedure init_array;
begin
  for i:=1 to 100 do
  begin
    for j:=1 to 9 do bb[i,j]:=0;
  end;
  for i:=1 to 2000 do yflu[i]:=0;
end;


procedure in_dat;
begin
  assign(fil,'MESS.TMP');
  reset(fil);

  write('Datei wird eingelesen ...');
  temp:=(screen1)*1024+10240;
  for i:=1 to trunc(temp) do read(fil,stuff);
  writeln('Fertig!');

  { n Screens einlesen }
  if test
    then writeln('Datei wird konvertiert...')
    else write('Datei wird konvertiert...');
  for k:=1 to screens do
  begin
    for i:=1 to 100 do
    begin
      for j:=1 to 9 do
      begin
        read(fil,bb[i,j]);
      end;
    read(fil,stuff);
    end;

    { Bis Ende Screen überlesen }
    for i:=1 to 24 do read(fil,stuff);

    { Screens konvertieren }
    for i:=1 to 100 do
    begin
      yfluo[i]:= 1e8*ord(bb[i,1]-48)+1e7*ord(bb[i,2]-48)+1e6*ord(bb[i,3]-48)
                +1e5*ord(bb[i,4]-48)+1e4*ord(bb[i,5]-48)+1e3*ord(bb[i,6]-48)
                +100*ord(bb[i,7]-48)+ord(bb[i,8]-48);
      yflu[m]:=yfluo[i];
      { Sortieren nach Max }
      if  yfluo[i] > y_max then y_max:=yfluo[i];
      m:=m+1;
      if test then write(yflu[i]:10:0);
    end;
    if test then writeln('  FLUO-max : ',y_max:10:0);
  end;
  close(fil);
  if test then
    begin
     writeln;
     writeln('FLUO-max : ',y_max:9:0);
     for i:=1 to trunc(anzahl) do  write(yflu[i]:10:0);
    end;
end;

{-------------------------------------------}
{-----   Zeichnet das FLUO-Spektrum   ------}
{-------------------------------------------}

procedure bild;
var  ii : integer;
begin
  gy_max:=1.25*y_max;
  { Akustisches Zeichen für Grafikaufbau }
  writeln(#7);
  InitGraphic;
  SelectScreen(1);
  ClearScreen;
  DefineWorld(1,0,0,anzahl,gy_max);
  SelectWorld(1);
  SelectWindow(1);
  SetBackground(0);
  DrawBorder;
  gotoxy(15,2); write(titel);
 { gotoxy(2,2); write('Counts');  }

{ Achsenskalierung }
  yy:=y_max/100;
  dxg:=anzahl/4;
  dxu:=dxg/2;
  for i:=0 to 4 do
  begin
    ddxg:=dxg + dxg*i;
    drawline(ddxg,0,ddxg,2*yy);
    ddxu:=dxu + dxg*i;
    drawline(ddxu,0,ddxu,2*yy);
  end;
  { ddxu:=dxu;    drawline(ddxu,0,ddxu,yy);
    ddxu:=3*dxu;  drawline(ddxu,0,ddxu,yy);
    ddxu:=5*dxu;  drawline(ddxu,0,ddxu,yy);
    ddxu:=7*dxu;  drawline(ddxu,0,ddxu,yy);
  }
  dy:=5000;
  xy:=anzahl/100;
  xu:=xy/2;
  du:=dy/2;
  for i:=0 to 5 do
  begin
    dyy:=dy + dy*i;
    drawline(0,dyy,xy,dyy);
    dyu:=du + dy*i;
    drawline(0,dyu,xu,dyu);
  end;

  xx:=0;
  ii:=0;
  repeat
    xx:=xx+1;
    ii:=ii+1;
    DrawPoint(xx,yflu[ii]);
  until (xx >= anzahl);
end;

procedure schluss;
begin
  {  gotoxy(70,24); write('Freq.[MHz]'); }
  readln(cha);
  LeaveGraphic;
  writeln('Max. Zählrate : ',y_max:10:0);
  writeln('Display beendet.');
end;


{===================    H a u p t p r o g r a m m    ==================}

begin
  test:=FALSE;
  m:=1;
  y_max:=0;
  intro;
  init_array;
  in_dat;
  bild;
  schluss;
end.

{====================   P r o g r a m m - E n d e    ==================}
