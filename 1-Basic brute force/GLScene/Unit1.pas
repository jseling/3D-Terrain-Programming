unit Unit1;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  GLSimpleNavigation,
  GLScene,
  GLObjects,
  GLCoordinates,
  GLCrossPlatform,
  GLBaseClasses,
  GLCadencer,
  Vcl.StdCtrls,
  GLVectorGeometry,
  GLVectorTypes,
  GLSceneViewer,
  GLRenderContextInfo,
  OpenGL,
  GLState,
  BMPImporter;

type
  TForm1 = class(TForm)
    GLSceneViewer1: TGLSceneViewer;
    GLScene1: TGLScene;
    GLCamera1: TGLCamera;
    GLDummyCube1: TGLDummyCube;
    GLLightSource1: TGLLightSource;
    GLSimpleNavigation1: TGLSimpleNavigation;
    GLCadencer1: TGLCadencer;
    GLDirectOpenGL1: TGLDirectOpenGL;
    procedure GLCadencer1Progress(Sender: TObject;
      const deltaTime, newTime: Double);
    procedure GLDirectOpenGL1Render(Sender: TObject;
      var rci: TGLRenderContextInfo);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    FHeightField: THeightField;
  end;

const
  SCALE = 0.08;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  AHalfSize: Integer;
begin
  FHeightField := TBMPImporter.Import('terrain.bmp');

  AHalfSize := (FHeightField.DimensionLength div 2) * -1;
  GLDirectOpenGL1.Position.SetPoint(AHalfSize, 0, AHalfSize);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FHeightField.Free;
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject;
  const deltaTime, newTime: Double);
begin
  GLSceneViewer1.Invalidate();
  GLSceneViewer1.ResetPerformanceMonitor();
end;

procedure TForm1.GLDirectOpenGL1Render(Sender: TObject;
  var rci: TGLRenderContextInfo);
var
  z, x: integer;
  h: byte;
  y: single;
begin
  rci.GLStates.Disable(stCullFace);
  rci.GLStates.Enable(stColorMaterial);
  rci.GLStates.Disable(stLighting);

  for z := 0 to FHeightField.DimensionLength - 2 do
  begin
    glBegin(GL_TRIANGLE_STRIP);
    for x := 0 to FHeightField.DimensionLength - 1 do
    begin
      h := FHeightField.GetValue(x, z);
      y := h * SCALE;
      glColor3ub(h, h, h);
      glVertex3f(x, y, z);

      h := FHeightField.GetValue(x, z + 1);
      y := h * SCALE;
      glColor3ub(h, h, h);
      glVertex3f(x, y, z + 1);
    end;
    glEnd;
  end;
end;

end.
