# 3D Terrain Programming
A serie of examples increasing the complexity example-by-example.

Based on [Focus on 3D Terrain Rendering by Trent Polack](https://books.google.com/books/about/Focus_on_3D_Terrain_Programming.html?id=yrpgT_vHhqoC&redir_esc=y).


## 1-Basic brute force
In: Delphi(GLScene)

![](./1-Basic%20brute%20force/1-basic-brute-force.png)

Load a bitmap and render a very plain 3D Terrain without any optimization.

```pascal
var
  z, x: integer;
  h: byte;
  y: single;
//***
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
```
