uses Crt,ModeXLib,gif,fade;
Var pic1_pal,                   {Paletten der beiden Bilder}
    pic2_pal:Array[0..767] of Byte;
    pic1,                       {beinhaltet 1.Bild}
    pic2:Pointer;               {2. Bild, ist gleich vscreen}

Begin
  Init_Mode13;                  {Mode 13h ein}
  Screen_off;                   {Bildschirm aus wÑhren Ladens}
  LoadGif('schach');            {erstes Bild laden}
  GetMem(pic1,64000);           {Speicher fÅr 1.Bild holen}
  Move(vscreen^,pic1^,64000);   {in pic1 sichern}
  Move(Palette,pic1_pal,768);   {und die Palette sichern}
  Show_Pic13;                   {dieses Bild auf Screen}

  LoadGif('kiste');             {nÑchstes in vscreen^ Laden}
  pic2:=vscreen;                {pic2 als Zeiger darauf verwendet}
  Move(Palette,pic2_pal,768);   {dessen Palette sichern}

  Move(pic1_pal,Palette,768);   {Palette von Bild 1 aktivieren}
  SetPal;                       {und setzen}
  Screen_on;                    {jetzt Bildschirm wieder einschalten}

  ReadLn;                       {warten}
  Ueberblenden(pic2,pic2_pal,0,0,200);
                                {und dann Bild 2 einblenden)}

  fade_ResetPic(0,200);         {erneutes Faden vorbereiten}
  ReadLn;
  Ueberblenden(pic1,pic1_pal,0,0,200);
                                {und Bild 1 einblenden}

  ReadLn;
  TextMode(3);
End.
