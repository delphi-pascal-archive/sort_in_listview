unit Unit1;

interface

uses
  Windows,math, Messages,dateutils, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
     croissant:boolean;
     ColumnToSort:integer;
  public
    { Déclarations publiques }

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function CustomSortProc(Item1,Item2: TListItem; ParamSort: integer): integer; stdcall;
var
 date1,date2: tdatetime;
 ix: integer;
begin
 ix:=abs(Paramsort)-1;
 if not TryStrToDate(item1.SubItems[ix],date1)
 then date1:=strtodate('01/01/1799');

 if not TryStrToDate(item2.SubItems[ix],date2)
 then date2:=strtodate('01/01/1799');

 result:=CompareDate(date1,date2);
 if paramsort<0
 then result:=-result;
end;

function CustomSortProcTime(Item1,Item2: TListItem; ParamSort: integer): integer; stdcall;
var
 date1,date2: tdatetime;
 ix: integer;
begin
 ix:=abs(Paramsort)-1;
 if not TryStrToDatetime(item1.SubItems[ix],date1)
 then date1:=strtodatetime('01/01/1799 00:00:00');

 if not TryStrToDatetime(item2.SubItems[ix],date2)
 then date2:=strtodatetime('01/01/1799 00:00:00');

 result:=CompareDatetime(date1,date2);
 if paramsort<0
 then result:=-result;
end;

function CustomSortProcChif(Item1,Item2: TListItem; ParamSort: integer): integer; stdcall;
var
 ix,i1,i2: integer;
begin
 ix:=abs(Paramsort)-1;
 if not TryStrToint(item1.SubItems[ix],i1)
 then i1:=0;

 if not TryStrToint(item2.SubItems[ix],i2)
 then i2:=0;

 result:=comparevalue(i1,i2);
 if paramsort<0
 then result:=-result;
end;

procedure TForm1.ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
  Data: integer; var Compare: integer);
var
 ix: integer;
begin
 if croissant
 then
  if ColumnToSort=0
  then Compare:=CompareText(Item1.Caption,Item2.Caption)
  else
   begin
    ix:=ColumnToSort-1;
    Compare:=CompareText(Item1.SubItems[ix],Item2.SubItems[ix]);
   end
 else
  if ColumnToSort=0
  then Compare:=CompareText(Item2.Caption,Item1.Caption)
  else
   begin
    ix:=ColumnToSort-1;
    Compare:=CompareText(Item2.SubItems[ix],Item1.SubItems[ix]);
   end;
end;

procedure TForm1.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
begin
 croissant:=not croissant; //inversion du précédent ordre de tri
 ColumnToSort:=Column.Index; //Quel colonne est à trier ?
 // Ensuite on détermine quel est le type de colonne à trier:
 // on peut aussi les déterminer en spécifiant un tag particulier dans chaque colonne
 if pos('DateTime',Column.Caption)>0
 then
  begin
   if croissant
   then (Sender as TCustomListView).CustomSort(@CustomSortProctime,column.index)
   else (Sender as TCustomListView).CustomSort(@CustomSortProctime,-column.index)
  end
 else
  if pos('Date',Column.Caption)>0
  then
   begin
    if croissant
    then (Sender as TCustomListView).CustomSort(@CustomSortProc,column.index)
    else (Sender as TCustomListView).CustomSort(@CustomSortProc,-column.index)
   end
  else
   if pos('Chiffre',Column.Caption)>0
   then
    begin
     if croissant
     then (Sender as TCustomListView).CustomSort(@CustomSortProcChif,column.index)
     else (Sender as TCustomListView).CustomSort(@CustomSortProcChif,-column.index)
    end
  else (Sender as TCustomListView).AlphaSort;
  // Méthode  de comparaison de text par défaut.
end;

procedure TForm1.FormShow(Sender: TObject);
var
 i: integer;
 Li: TListItem;
 Col: TListColumn;
begin
 Col:=ListView1.Columns.Add;
 Col.Caption := '';
 Col.AutoSize := True;
 col.Width := 1;
 Col := ListView1.Columns.Add;
 Col.Caption := 'Number';
 Col.AutoSize := True;
 col.Width := 80;
 Col := ListView1.Columns.Add;
 Col.Caption := 'Date 1';
 Col.AutoSize := True;
 col.Width := 80;
 Col := ListView1.Columns.Add;
 Col.Caption := 'DateTime';
 Col.AutoSize := True;
 col.Width := 160;
 Col := ListView1.Columns.Add;
 Col.Caption := 'Date 2';
 Col.AutoSize := True;
 col.Width := 100;

 Col := ListView1.Columns.Add;
 Col.Caption := 'Text';
 Col.AutoSize := True;
 Col.Width := 100;

 ListView1.Items.Clear;
 ListView1.Canvas.Font.Color:=clRed;
 for i:=0 to 10 do
  begin
   LI:=ListView1.Items.Add;

   LI.Caption:='';
   LI.subitems.add(inttostr(random(i+1)*random(i+1)));

   LI.SubItems.Add(datetostr(incday(now,random(20))));
   LI.SubItems.Add(datetimetostr(inchour(now,random(20))));
   LI.SubItems.Add(datetostr(incyear(now,random(20))));
   LI.SubItems.Add(chr(71+random(2*i))+chr(71+random(2*i))+chr(71+random(2*i)));
  end;
end;

initialization
 randomize;

end.
