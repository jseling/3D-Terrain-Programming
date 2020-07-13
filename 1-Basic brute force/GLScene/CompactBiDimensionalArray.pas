unit CompactBiDimensionalArray;

interface

type
  TCompactBidimensionalArray<T> = class
  private
    FDimensionLength: Integer;
    FBuffer: TArray<T>;
  public
    property DimensionLength: Integer read FDimensionLength;
    property Buffer: TArray<T> read FBuffer;

    constructor Create(pDimensionLength: Integer);
    procedure SetValue(x, y: Integer; value: T);
    procedure SetAllValues(value: T);
    function GetValue(x, y: Integer): T; inline;
  end;

implementation

{ TCompactBidimensionalArray }

constructor TCompactBidimensionalArray<T>.Create(pDimensionLength: Integer);
begin
  FDimensionLength := pDimensionLength;
  SetLength(FBuffer, FDimensionLength * FDimensionLength);
end;

function TCompactBidimensionalArray<T>.GetValue(x, y: Integer): T;
begin
  Result := FBuffer[x + y * FDimensionLength];
end;

procedure TCompactBidimensionalArray<T>.SetValue(x, y: Integer; value: T);
begin
  FBuffer[x + y * FDimensionLength] := value;
end;

procedure TCompactBidimensionalArray<T>.SetAllValues(value: T);
var
  i: Integer;
begin
  for i := Low(FBuffer) to High(FBuffer) do
    FBuffer[i] := value;
end;

end.
