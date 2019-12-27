program HelpMemo;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uHelpMemo, uconexao, zcomponent, uBackup, urestaurar;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmHelpMemo, frmHelpMemo);
  Application.CreateForm(TdmConexao, dmConexao);
  Application.Run;
end.

