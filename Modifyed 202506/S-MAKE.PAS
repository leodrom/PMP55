uses Objects;
const
  ShablonRepeat   = '%%';
  ShablonEqual    = '%=';
  ShablonNotEqual = '%<>';
  ShablonNotEmpty = '%''''';

type
  PRec = ^TRec;
  TRec = array [0 .. 50] of PString;
var
  Shablons : array [0 .. 50] of PString;
  ShablonCount : integer;
  A : array [0 .. 1000] of PRec;
  Count : integer;
  B : array [0 .. 1000] of PString;
  BCount : integer;

function NewStr (const s : string) : PString;
var
  P : PString;
begin
  p := Objects.NewStr (s);
  if p = nil then begin
    GetMem (p, 1);
    p^ [0] := #0;
  end;
  NewStr := P;
end;

function LoadOne (var s : string) : string;
var
  ss : string;
begin
  if Pos (',', s) = 0 then begin
    ss := s;
    s := '';
  end else begin
    ss := copy (s, 1, Pos (',', s) - 1);
    delete (s, 1, Pos (',', s));
  end;
  while (Pos ('{', ss) <> 0) and (Pos ('}', ss) > Pos ('{', ss)) do
    Delete (ss, Pos ('{', ss), Pos ('}', ss) - Pos ('{', ss) + 1);
  while Pos (' ', ss) = 1 do delete (ss, 1, 1);
  while (Length (ss) > 0) and (ss [Length (ss)] = ' ') do Delete (ss, Length (ss), 1);
  LoadOne := ss;
end;

function LoadShablons (var s : string) : boolean;
var
  ss : string;
begin
  ShablonCount := 0;
  repeat
    ss := LoadOne (s);
    if ss = '' then break;
    Shablons [ShablonCount] := NewStr (ss);
    Inc (ShablonCount);
  until False;
  LoadShablons := ShablonCount <> 0;
end;

function LoadRecord (i : integer; var s : string) : boolean;
var
  j : integer;
  ss : string;
begin
  LoadRecord := false;
  ss := LoadOne (s);
  if ss = '' then exit;
  GetMem (A [i], ShablonCount * SizeOf (A [i]^[0]));
  A [i]^[0] := NewStr (ss);
  for j := 1 to ShablonCount - 1 do
    A [i]^[j] := NewStr (LoadOne (s));
  LoadRecord := true;
end;

procedure LoadArray (const Name : string);
var
  F : Text;
  S : string;
begin
  Assign (F, Name);
  ReSet (F);
  ReadLn (F, S);
  LoadShablons (S);
  Count := 0;
  while not EOF (f) do begin
    ReadLn (F, S);
    if LoadRecord (Count, S) then Inc (Count);
  end;
  Close (F);
end;

procedure LoadShablon (const Name : string);
var
  F : Text;
  S : string;
begin
  Assign (F, Name);
  ReSet (F);
  BCount := 0;
  while not EOF (f) do begin
    ReadLn (F, S);
    B [BCount] := NewStr (S);
    Inc (BCount);
  end;
  Close (F);
end;

function DoShablon (var S : string; const Sh, Text : string) : boolean;
var
  P : integer;
begin
  DoShablon := false;
  P := Pos (Sh, S);
  if P = 0 then exit;
  Delete (S, P, Length (Sh));
  Insert (Text, S, P);
  DoShablon := true;
end;

function DoShablon2 (var S : string; const Sh : string; i : integer; B : Boolean) : boolean;
var
  P, L, j : integer;
  ss : string;
begin
  DoShablon2 := false;
  P := Pos (Sh, S);
  if P = 0 then exit;
  Delete (S, P, Length (Sh));
  ss := Copy (S, P, 256);
  if ss = '' then exit;
  if (Pos ('<<', ss) = 1) and (Pos ('>>', ss) > 1) then begin
    L := Pos ('>>', ss) - 3;
    Delete (S, P + Pos ('>>', ss) - 1, 2);
    Delete (S, P, 2);
    if not B then Delete (S, P, L);
  end else begin
    j := 0;
    while j < ShablonCount do begin
      if Pos (Shablons [j]^, ss) = 1 then begin
        Delete (S, P, Length (Shablons [j]^));
        if B then Insert (A [i]^[j]^, S, P);
        break;
      end;
      inc (j);
    end;
    if j = ShablonCount then
      if not B then Delete (S, P, 1);
  end;
  DoShablon2 := true;
end;

function DoShablon3 (var S : string; const Sh : string; i : integer) : boolean;
var
  P, L, j : integer;
  ss : string;
begin
  DoShablon3 := false;
  P := Pos (Sh, S);
  if P = 0 then exit;
  Delete (S, P, Length (Sh));
  ss := Copy (S, P, 256);
  if ss = '' then exit;
  j := 0;
  while j < ShablonCount do begin
    if Pos (Shablons [j]^, ss) = 1 then begin
      Delete (S, P, Length (Shablons [j]^));
      Delete (SS, 1, Length (Shablons [j]^));
      if (Pos ('<<', ss) = 1) and (Pos ('>>', ss) > 1) then begin
        L := Pos ('>>', ss) - 3;
        Delete (S, P + Pos ('>>', ss) - 1, 2);
        Delete (S, P, 2);
        if A [i]^[j]^ = '' then Delete (S, P, L)
      end else
        if A [i]^[j]^ <> '' then Insert (A [i]^[j]^, S, P);
      break;
    end;
    inc (j);
  end;
  DoShablon3 := true;
end;

procedure Go (const NameOut : string; i : integer);
var
  FOut : Text;
  S : string;
  n, j, k, Start : integer;
begin
  Assign (FOut, NameOut);
  ReWrite (FOut);
  n := 0;
  Start := -1;
  k := Count;
  while n < BCount do begin
    S := B [n]^;

    if Pos (ShablonRepeat, S) = 1 then begin
      if Start = -1 then begin
        Start := n;
        Inc (n);
        k := 0;
        Continue;
      end else begin
        if k < Count - 1 then begin
          N := Start;
          Inc (k);
        end else Start := -1;
        Inc (N);
        Continue;
      end;
    end else begin
      if Start = -1 then begin
        while DoShablon3 (S, ShablonNotEmpty, i) do;
        j := 0;
        while j < ShablonCount do begin
          while DoShablon (S, Shablons [j]^, A [i]^[j]^) do;
          inc (j);
        end;
      end else begin
        while DoShablon2 (S, ShablonEqual, k, k=i) do;
        while DoShablon2 (S, ShablonNotEqual, k, k<>i) do;
        while DoShablon3 (S, ShablonNotEmpty, k) do;
        j := 0;
        while j < ShablonCount do begin
          while DoShablon (S, Shablons [j]^, A [k]^[j]^) do;
          inc (j);
        end;
      end;
    end;
    WriteLn (FOut, S);

    inc (n);
  end;
  Close (FOut);
end;

var
  i : integer;
begin
  if ParamCount < 2 then begin
    WriteLn ('USAGE : s-make.exe <file list> <file shablon> [file prefix]');
    Halt (1);
  end;
  LoadArray (ParamStr (1));
  LoadShablon (ParamStr (2));
  for i := 0 to Count - 1 do
    Go (ParamStr (3) + A [i]^[0]^ + '.HTM', i);
end.
