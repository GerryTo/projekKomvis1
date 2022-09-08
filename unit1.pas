unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ExtDlgs, Menus;

type

  { TForm1 }

  TForm1 = class(TForm)
    brightnessbtn: TButton;
    Button1: TButton;
    smoothingbtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    thresholdbtn: TButton;
    GrayScalebtn: TButton;
    Image1: TImage;
    loadbtn: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure brightnessbtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    //procedure Button1Click(Sender: TObject);
    procedure GrayScalebtnClick(Sender: TObject);
    procedure loadbtnClick(Sender: TObject);
    procedure smoothingbtnClick(Sender: TObject);
    procedure thresholdbtnClick(Sender: TObject);
    function MaxMinPixel():Byte;
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
uses
  windows;
var
  bitmapR, bitmapG, bitmapB : array [0..10000, 0..10000] of byte;
  bitmap: array[0..10000, 0..10000] of boolean;

procedure TForm1.loadbtnClick(Sender: TObject);
var
  x,y : Integer;
begin
  if OpenPictureDialog1.Execute then
  begin
    Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    for y:= 0 to Image1.Height - 1 do
    begin
      for x := 0 to Image1.Width - 1 do
      begin
        bitmapR[x,y] := GetRValue(Image1.Canvas.Pixels[x,y]);
        bitmapG[x,y] := GetGValue(Image1.Canvas.Pixels[x,y]);
        bitmapB[x,y] := GetBValue(Image1.Canvas.Pixels[x,y]);
      end;
    end;
  end;
end;

procedure TForm1.smoothingbtnClick(Sender: TObject);
var
  r,g,b,x,y,m,n : Integer;
  minMaxPixels: Byte;
begin
 for y:=0 to Image1.Height-1 do
    begin
      for x:=0 to Image1.Width-1 do
      begin
         r:=0;
         g:=0;
         b:=0;
         for m:=-1 to 1 do
         begin
           for n:=-1 to 1 do
           begin
             r:=r+bitmapR[x + n,y + m];
             g:=g+bitmapG[x + n,y + m];
             b:=b+bitmapB[x + n,y + m];
           end;
         end;
         r:=r div 9;
         g:=g div 9;
         b:=b div 9;
         if r > 255 then r := 255;
         if g > 255 then g := 255;
         if b > 255 then b := 255;
         if r < 0 then r := 0;
         if g < 0 then g := 0;
         if b < 0 then b := 0;
         Image1.Canvas.Pixels[x,y]:=RGB(r,g,b);
         bitmapR[x,y] := r;
         bitmapG[x,y] := g;
         bitmapB[x,y] := b;
      end;
    end;
   minMaxPixels := MaxMinPixel();
   Label3.Caption:= IntToStr(minMaxPixels);
end;

procedure TForm1.thresholdbtnClick(Sender: TObject);
var
  x,y : Integer;
  threshold, minMaxPixels, gray: Byte;
begin
  minMaxPixels := MaxMinPixel();
  threshold:= minMaxPixels div 2;
  Label1.Caption:= IntToStr(threshold);
  Label3.Caption:= IntToStr(minMaxPixels);
  for y := 0 to Image1.Height - 1 do
  begin
    for x := 0 to Image1.Width - 1 do
    begin
       gray := (bitmapR[x,y] + bitmapG[x,y] + bitmapB[x,y]) div 3;
       image1.Canvas.Pixels[x,y]:= RGB(gray, gray ,gray);
      if gray > 128 then
      begin
        image1.Canvas.Pixels[x,y]:= RGB(255, 255, 255);
        bitmap[x,y]:= true;
      end
      else
      begin
        image1.Canvas.Pixels[x,y]:= RGB(0, 0, 0);
        bitmap[x,y]:= false;
      end;
    end;
  end;
end;

procedure TForm1.GrayScalebtnClick(Sender: TObject);
var
  x,y : Integer;
  gray,minMaxPixels : byte;
begin
  for y:= 0 to Image1.Height - 1 do
  begin
    for x:= 0 to Image1.Width - 1 do
    begin
      gray := (bitmapR[x,y] + bitmapG[x,y] + bitmapB[x,y]) div 3;
      image1.Canvas.Pixels[x,y]:= RGB(gray, gray ,gray);
        bitmapR[x,y] := gray;
        bitmapG[x,y] := gray;
        bitmapB[x,y] := gray;
    end;
  end;
  minMaxPixels := MaxMinPixel();
  Label3.Caption:= IntToStr(minMaxPixels);
end;

procedure TForm1.brightnessbtnClick(Sender: TObject);
var
  x,y : Integer;
  brR,brG,brB, minMaxPixels: Integer;
begin
  for y:= 0 to Image1.Height - 1 do
  begin
    for x:= 0 to Image1.Width - 1 do
    begin
      brR:= bitmapR[x,y]+80;
      brG:= bitmapG[x,y]+80;
      brB:= bitmapB[x,y]+80;

      if brR > 255 then brR := 255;
      if brG > 255 then brG := 255;
      if brB > 255 then brB := 255;

      if brR < 0 then brR := 0;
      if brG < 0 then brG := 0;
      if brB < 0 then brB := 0;

      image1.Canvas.Pixels[x,y]:= RGB(brR,brG,brB);
      bitmapR[x,y] := brR;
      bitmapG[x,y] := brG;
      bitmapB[x,y] := brB;
    end;
  end;
  minMaxPixels := MaxMinPixel();
  Label3.Caption:= IntToStr(minMaxPixels);
end;

procedure TForm1.Button1Click(Sender: TObject);
var x,y,G,P : Integer;
  conR,conG,conB : Integer;
begin
  G := 2;
  P := 80;
   for y:= 0 to Image1.Height - 1 do
   begin
     for x:= 0 to Image1.Width - 1 do
     begin
      conR:= G*(bitmapR[x,y]-P)+P;
      conG:= G*(bitmapR[x,y]-P)+P;
      conB:= G*(bitmapR[x,y]-P)+P;

      if conR > 255 then conR := 255;
      if conG > 255 then conG := 255;
      if conB > 255 then conB := 255;

      if conR < 0 then conR := 0;
      if conG < 0 then conG := 0;
      if conB < 0 then conB := 0;

      image1.Canvas.Pixels[x,y]:= RGB(conR,conG,conB);
      bitmapR[x,y] := conR;
      bitmapG[x,y] := conG;
      bitmapB[x,y] := conB;
     end;
   end;
end;


function Tform1.MaxMinPixel():Byte;
var
  temp1, temp2: Byte;
    x,y : Integer;
begin
  temp1:= 0;
  temp2:= 0;
  for y:= 0 to Image1.Height - 1 do
  begin
    for x:= 0 to Image1.Width - 1 do
    begin
        if Image1.Canvas.Pixels[x,y] > temp1 then
        begin
          temp1:= Image1.Canvas.pixels[x,y];
        end;
        if Image1.Canvas.Pixels[x,y] < temp2 then
        begin
          temp2:= Image1.canvas.pixels[x,y];
        end;
    end;
  end;
  Label5.Caption:= IntToStr(temp1);
  Label7.Caption:= IntToStr(temp2);
  MaxMinPixel := temp1 + temp2 ;
end;

end.

