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
    dilationBtn: TButton;
    erosionBtn: TButton;
    smoothingbtn: TButton;
    thresholdbtn: TButton;
    Image1: TImage;
    loadbtn: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure brightnessbtnClick(Sender: TObject);
    procedure dilationBtnClick(Sender: TObject);
    procedure erosionBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure loadbtnClick(Sender: TObject);
    procedure smoothingbtnClick(Sender: TObject);
    procedure thresholdbtnClick(Sender: TObject);
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
  temp: array[0..10000, 0..10000] of byte;

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
end;

procedure TForm1.thresholdbtnClick(Sender: TObject);
var
  x,y : Integer;
  gray: Byte;
begin
  for y := 0 to Image1.Height - 1 do
  begin
    for x := 0 to Image1.Width - 1 do
    begin
       gray := (bitmapR[x,y] + bitmapG[x,y] + bitmapB[x,y]) div 3;
       image1.Canvas.Pixels[x,y]:= RGB(gray, gray ,gray);
      if gray > 128 then
      begin
        image1.Canvas.Pixels[x,y]:= RGB(255, 255, 255);
        bitmapR[x,y]:= 255;
        bitmapG[x,y]:= 255;
        bitmapB[x,y]:= 255;
      end
      else
      begin
        image1.Canvas.Pixels[x,y]:= RGB(0, 0, 0);
        bitmapR[x,y]:= 0;
        bitmapG[x,y]:= 0;
        bitmapB[x,y]:= 0;
      end;
    end;
  end;
end;

procedure TForm1.brightnessbtnClick(Sender: TObject);
var
  x,y : Integer;
  brR,brG,brB: Integer;
begin
  for y:= 0 to Image1.Height - 1 do
  begin
    for x:= 0 to Image1.Width - 1 do
    begin
      brR:= bitmapR[x,y]+20;
      brG:= bitmapG[x,y]+20;
      brB:= bitmapB[x,y]+20;

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
end;

procedure TForm1.dilationBtnClick(Sender: TObject);
var
  x,y,aDi: integer;
begin
  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
     aDi:=0;
       if bitmapR[x,y-1] and bitmapR[x-1, y] and bitmapR[x, y]
       and bitmapR[x+1,y] and bitmapR[x, y+1]= 255 then
       begin
         aDi:= 255;
       end
       else
       begin
         aDi:= 0;
       end;
       image1.Canvas.Pixels[x,y]:= RGB(aDi, aDi, aDi);
       temp[x,y]:= aDi;
      end;
    end;
    for y:=0 to Image1.Height-1 do
    begin
      for x:=0 to Image1.Width-1 do
      begin
        bitmapR[x,y]:= temp[x,y];
      end;
    end;
end;

procedure TForm1.erosionBtnClick(Sender: TObject);
var
  x,y,aRe: integer;
begin
  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
     aRe:=0;
       if bitmapR[x,y-1] or bitmapR[x-1, y] or bitmapR[x, y]
       and bitmapR[x+1,y] or bitmapR[x, y+1] = 0 then
       begin
         aRe:=0;
       end
       else
       begin
         aRe:=255;
       end;
       image1.Canvas.Pixels[x,y]:= RGB(aRe, aRe, aRe);
       temp[x,y]:=aRe;
    end;
  end;
  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      bitmapR[x,y]:= temp[x,y];
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

end.

