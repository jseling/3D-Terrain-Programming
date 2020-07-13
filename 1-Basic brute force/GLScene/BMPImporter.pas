unit BMPImporter;

interface

uses
  CompactBiDimensionalArray,
  Vcl.Graphics,
  System.SysUtils;

type
  THeightField = TCompactBidimensionalArray<Byte>;

  TBMPImporter = class
  private
    class function ClampToByte(const aValue: Integer): Integer;
  public
    class function Import(_ABMPFilename: string): THeightField;
  end;

implementation

{ TBMPImporter }

class function TBMPImporter.ClampToByte(const aValue: Integer): Integer;
begin
  if aValue < 0 then
    result := 0
  else if aValue > 255 then
    result := 255
  else
    result := aValue;
end;

class function TBMPImporter.Import(_ABMPFilename: string): THeightField;
type
  TRGBTriple = packed record
    B, G, R: byte;
  end;
  TRGBTripleArray = ARRAY [Word] of TRGBTriple;
  pRGBTripleArray = ^TRGBTripleArray; // use a PByteArray for pf8bit color
var
  x, y: Integer;
  AScanLine: pRGBTripleArray;
  ABitmap: TBitmap;
  AValue: Byte;
begin
  ABitmap := TBitmap.Create;
  try
    ABitmap.LoadFromFile(_ABMPFilename);
    ABitmap.PixelFormat := pf24Bit;

    if ABitmap.Height <> ABitmap.Width then
      raise Exception.Create('Only square bitmaps allowed.');

    result := THeightField.Create(ABitmap.Height);
    for y := ABitmap.Height - 1 downto  0 do
    begin
      AScanLine := ABitmap.ScanLine[ABitmap.Height - 1 - y];
      for x := 0 to ABitmap.Width - 1 do
      begin
        AValue := ClampToByte((AScanLine[x].R + AScanLine[x].G + AScanLine[x].B) div 3);
        result.SetValue(x, y, AValue);
      end;
    end;
  finally
    ABitmap.Free;
  end;
end;

end.
