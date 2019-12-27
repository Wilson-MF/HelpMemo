unit uConexao;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, ZConnection, ZDataset, ZSqlUpdate;

type

  { TdmConexao }

  TdmConexao = class(TDataModule)
    dsEstudo: TDataSource;
    qryEstudoAssunto: TStringField;
    qryEstudoCategoria: TStringField;
    qryEstudoIdEstudo: TLargeintField;
    qryEstudoLocal: TStringField;
    qryEstudoResumo: TStringField;
    ZConexao: TZConnection;
    qryEstudo: TZQuery;
    upEstudo: TZUpdateSQL;
    qryCombo: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure qryEstudoAfterPost(DataSet: TDataSet);
  private

  public

  end;

var
  dmConexao: TdmConexao;

implementation

{$R *.lfm}

{ TdmConexao }

procedure TdmConexao.qryEstudoAfterPost(DataSet: TDataSet);
begin
  qryEstudo.ApplyUpdates;
  qryEstudo.Refresh;
end;

procedure TdmConexao.DataModuleCreate(Sender: TObject);
 var
  caminho   : string;     // Path da Pasta onde esta o executavel
  db        : string;    // Nome do Banco de Dados
  caminhoDB : string; // Concatena caminho+bd
begin
  caminho    := ParamStr(0);
  caminho    := ExtractFilePath(caminho);
  db         := 'HelpMemo.db';
  caminhoDB  := caminho+db;

   ZConexao.Port:= 0;
   ZConexao.Password:= '';
   ZConexao.LoginPrompt:= False;
   ZConexao.Protocol:= 'sqlite-3';
   ZConexao.Database:= caminhoDB;
   ZConexao.Connected:= True;
   qryEstudo.Active:= True;
   qryCombo.Active:= True;
end;

end.

