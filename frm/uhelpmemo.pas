unit uHelpMemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  DBGrids, DBCtrls, StdCtrls, Buttons, Menus, uConexao, ShellApi, uBackup,
  urestaurar;
type

  { TfrmHelpMemo }

  TfrmHelpMemo = class(TForm)
    btnLimpar: TBitBtn;
    btnAbrir: TBitBtn;
    btnLocal: TBitBtn;
    dbcCategoria: TDBComboBox;
    dbeAssunto: TDBEdit;
    dbeLocal: TDBEdit;
    dbeID: TDBEdit;
    DBGridEstudo: TDBGrid;
    dbmResumo: TDBMemo;
    DBNavigator1: TDBNavigator;
    edtPesq: TEdit;
    ImageList1: TImageList;
    Label1: TLabel;
    lblDisplay: TLabel;
    lblPesq: TLabel;
    lblLocal: TLabel;
    lblResumo: TLabel;
    lblAssusnto: TLabel;
    lblCategoria: TLabel;
    lblID: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    mAjCadstrar: TMenuItem;
    mAjEditar: TMenuItem;
    mAjPesquisar: TMenuItem;
    mAjRestaurar: TMenuItem;
    mAjSobre: TMenuItem;
    mCalculadora: TMenuItem;
    mCalendario: TMenuItem;
    mEdTexto: TMenuItem;
    MenuItem5: TMenuItem;
    mBackup: TMenuItem;
    mRestaurar: TMenuItem;
    MenuItem8: TMenuItem;
    mAjBackup: TMenuItem;
    PageControl1: TPageControl;
    pnlTopo: TPanel;
    pnlRodape: TPanel;
    pnlDir: TPanel;
    pnlEsq: TPanel;
    pnlPesqTopo: TPanel;
    pnlPesqRodape: TPanel;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    TabPesq: TTabSheet;
    TabDados: TTabSheet;
    procedure btnAbrirClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnLocalClick(Sender: TObject);
    procedure dbcCategoriaDropDown(Sender: TObject);
    procedure dbcCategoriaKeyPress(Sender: TObject; var Key: char);
    procedure dbeAssuntoKeyPress(Sender: TObject; var Key: char);
    procedure DBGridEstudoDblClick(Sender: TObject);
    procedure DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
    procedure edtPesqChange(Sender: TObject);
    procedure edtPesqKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mAjBackupClick(Sender: TObject);
    procedure mAjCadstrarClick(Sender: TObject);
    procedure mAjEditarClick(Sender: TObject);
    procedure mAjPesquisarClick(Sender: TObject);
    procedure mAjRestaurarClick(Sender: TObject);
    procedure mAjSobreClick(Sender: TObject);
    procedure mBackupClick(Sender: TObject);
    procedure mCalculadoraClick(Sender: TObject);
    procedure mCalendarioClick(Sender: TObject);
    procedure mEdTextoClick(Sender: TObject);
    procedure CarregaCombo;
    procedure DesabilitaEditar;
    procedure mRestaurarClick(Sender: TObject);
    procedure TabDadosEnter(Sender: TObject);
    procedure TabDadosExit(Sender: TObject);

  private

  public

  end;

var
  frmHelpMemo: TfrmHelpMemo;
  sPath : string;
implementation

{$R *.lfm}

{ TfrmHelpMemo }





procedure TfrmHelpMemo.FormCreate(Sender: TObject);
begin
  sPath := ExtractFilePath(Application.ExeName);
end;

procedure TfrmHelpMemo.edtPesqChange(Sender: TObject);
begin
    if (edtPesq.Text <> EmptyStr) then // verifico se o edit possui algum valor
   begin
     With dmConexao.qryEstudo do
     begin
      dmConexao.qryEstudo.Close;
      dmConexao.qryEstudo.SQL.Clear;
      dmConexao.qryEstudo.SQL.Add('Select * From Estudo');
      dmConexao.qryEstudo.SQL.Add('Where Assunto LIKE :BUSCA OR Resumo LIKE :BUSCA OR Categoria LIKE :BUSCA');
      dmConexao.qryEstudo.ParamByName('BUSCA').AsString := ('%' + edtPesq.Text) + '%';
      dmConexao.qryEstudo.Open;
      lblDisplay.Caption:= 'Foram encontrados '+IntToStr(dmConexao.qryEstudo.RecordCount)+' registro(s).';
     end;
    end;
end;

procedure TfrmHelpMemo.edtPesqKeyPress(Sender: TObject; var Key: char);
begin
   if Key = #13 then
   DBGridEstudo.SetFocus;

end;

procedure TfrmHelpMemo.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
 if MessageDlg('Confirmação',
  'Deseja sair do aplicativo?',
  mtConfirmation, mbYesNo,'') <> 6 then Abort;
  FreeAndNil(dmConexao);
  frmHelpMemo.Release;
  Application.Terminate;
end;

procedure TfrmHelpMemo.btnLimparClick(Sender: TObject);
begin
    edtPesq.Text := '*';
    dmConexao.qryEstudo.Close;
    dmConexao.qryEstudo.SQL.Clear;
    dmConexao.qryEstudo.SQL.Add('Select * From Estudo');
    dmConexao.qryEstudo.SQL.Add('Where Assunto LIKE :BUSCA OR Categoria LIKE :BUSCA');
    dmConexao.qryEstudo.ParamByName('BUSCA').AsString := ('%' + edtPesq.Text) + '%';
    dmConexao.qryEstudo.Open;
    edtPesq.Text := '';
    edtPesq.SetFocus;
    lblDisplay.Caption:= 'Duplo clique para ver detalhes do registro!';
end;

procedure TfrmHelpMemo.btnAbrirClick(Sender: TObject);
var
sArq : string;

begin
 sArq := dbeLocal.Text;
   if DirectoryExists(sArq) then
   ShellExecute(0, nil, PChar(sArq), PChar(sArq), nil,1)
   else
    messagedlg('Local não encontrado ou nulo!',mtinformation,[mbok],0);
end;

procedure TfrmHelpMemo.btnLocalClick(Sender: TObject);
begin
    if SelectDirectoryDialog1.Execute then
    dbeLocal.Text:= SelectDirectoryDialog1.FileName;
end;

procedure TfrmHelpMemo.dbcCategoriaDropDown(Sender: TObject);
begin
  CarregaCombo;
end;

procedure TfrmHelpMemo.dbcCategoriaKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
   dbeAssunto.SetFocus;
end;

procedure TfrmHelpMemo.dbeAssuntoKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
   dbmResumo.SetFocus;
end;

procedure TfrmHelpMemo.DBGridEstudoDblClick(Sender: TObject);
begin
  PageControl1.ActivePage := TabDados;
end;

procedure TfrmHelpMemo.DBNavigator1Click(Sender: TObject;
  Button: TDBNavButtonType);
begin
   If (Button = nbInsert) Or (Button = nbEdit) then
   begin
      dbeID.ReadOnly:= True;
      dbcCategoria.ReadOnly:= False;
      dbeAssunto.ReadOnly:= False;
      dbmResumo.ReadOnly:= False;
      dbeLocal.ReadOnly:= False;
      btnLocal.Enabled:= True;
      DBNavigator1.Controls[0].Enabled:= FALSE; //Prior
      DBNavigator1.Controls[1].Enabled:= FALSE; //Next
      DBNavigator1.Controls[2].Enabled:= FALSE; //Insert
      DBNavigator1.Controls[3].Enabled:= FALSE; //Delete
      dbcCategoria.SetFocus;
   end
   else
     If (Button = nbPost) Or (Button = nbCancel) then
        DesabilitaEditar;
end;

procedure TfrmHelpMemo.FormShow(Sender: TObject);
begin
    dmConexao.qryEstudo.Close;
    dmConexao.qryEstudo.SQL.Clear;
    dmConexao.qryEstudo.SQL.Add('Select * From Estudo Order By IdEstudo Desc Limit 1');
    dmConexao.qryEstudo.Open;
    edtPesq.Text := '';
    edtPesq.SetFocus;
    lblDisplay.Caption:= 'Duplo clique para ver detalhes do registro!';
end;

procedure TfrmHelpMemo.mAjBackupClick(Sender: TObject);
begin
    Application.MessageBox('O sistema de backup do HelpMemo acrescentará a data atual ao'+#13+
'Banco de Dados. Ficando assim muito fácil gerenciar seus'+#13+
'backups. Se não escolher um local o backup será feito no'+#13+
'mesmo diretório do aplicativo.','Backup',0);
end;

procedure TfrmHelpMemo.mAjCadstrarClick(Sender: TObject);
begin
      Application.MessageBox('O sistema de cadastro do HelpMemo é muito simples e intuitivo.'+#13+
'No entanto ressalto que os assuntos são organizados por'+#13+
'categoria e recomendo fortemente que se aplique em dedicar'+#13+
'alguns segundos para cadastrar os detalhes importantes de tudo'+#13+
'que estiver estudando. Em pouco tempo estará colhendo os'+#13+
'resultados dessa prática.','Cadastrar',0);
end;

procedure TfrmHelpMemo.mAjEditarClick(Sender: TObject);
begin
  Application.MessageBox('Pode-se editar qualquer registro, para isso na aba Cadastro é só'+#13+
'clicar no botão como lápis e editar o que for necessário.'+#13+
'Incluindo a categoria do assunto.','Editar',0);
end;

procedure TfrmHelpMemo.mAjPesquisarClick(Sender: TObject);
begin
   Application.MessageBox('Pesquisar no HelpMemo é muito simples, é só digitar no'+#13+
'campo pesquisar. A busca será feita nas colunas Assunto,'+#13+
'Resumo e Categoria.'+#13+
'Digitando o texto como está na categoria, será selecionado'+#13+
'todos os registros daquela categoria.','Pesquisar',0);
end;

procedure TfrmHelpMemo.mAjRestaurarClick(Sender: TObject);
begin
  Application.MessageBox('Para restaurar o Banco de Dados, encontre o último backup feito'+#13+
'pela data e clique em Restauar.','Restaurar',0);
end;


procedure TfrmHelpMemo.mAjSobreClick(Sender: TObject);
begin
    Application.MessageBox('O HelpMemo é um sitema de cadastro de estudos ou qualquer tipo de informação.' +#13+
'Se você estuda assuntos diversos, de física quântica a estudos'+#13+
'bíblicos, de receitas culinárias a Javascript, o HelpMemo'+#13+
'pode auxiliá-lo a encontrar com muita facilidade suas anotações.'+#13+#13+
'Desenvolvido por Wilson Machado Filho'+#13+
'eu.wilson@gmail.com'+#13+#13+
'HelpMemo Versão 1.5','Sobre',0);
end;

procedure TfrmHelpMemo.mBackupClick(Sender: TObject);
begin
   try
    Application.CreateForm(TfrmBackup,frmBackup);
    frmBackup.ShowModal;
   finally
     FreeAndNil(frmBackup);
   end;

end;

procedure TfrmHelpMemo.mCalculadoraClick(Sender: TObject);
var
   EX        : string;  // Nome do Executável
  caminhoEX : String ; // Concatena caminho+EX
begin
  EX := 'Calculadora.exe';
  caminhoEX := SPath+EX;
  if ShellExecute( 0, nil, PChar(caminhoEX),
   PChar(caminhoEX+'\somepath\some_doc.ext'),nil,1) = 0 then ;
end;

procedure TfrmHelpMemo.mCalendarioClick(Sender: TObject);
var
   EX        : string;  // Nome do Executável
  caminhoEX : String ; // Concatena caminho+EX
begin
  EX := 'Calendario.exe';
  caminhoEX := SPath+EX;
  if ShellExecute( 0, nil, PChar(caminhoEX),
   PChar(caminhoEX+'\somepath\some_doc.ext'),nil,1) = 0 then ;
end;


procedure TfrmHelpMemo.mEdTextoClick(Sender: TObject);
var
   EX        : string;  // Nome do Executável
  caminhoEX : String ; // Concatena caminho+EX
begin
  EX := 'Texto Editor.exe';
  caminhoEX := SPath+EX;
  if ShellExecute( 0, nil, PChar(caminhoEX),
   PChar(caminhoEX+'\somepath\some_doc.ext'),nil,1) = 0 then ;
end;

procedure TfrmHelpMemo.CarregaCombo;
begin
    dbcCategoria.Items.Clear;
    dmConexao.qryCombo.Refresh;
    dmConexao.qryCombo.First;
    while not dmConexao.qryCombo.Eof do
      begin
        dbcCategoria.Items.Add(dmConexao.qryCombo.FieldByName('Categoria').AsString);
        dmConexao.qryCombo.Next;
      end;
end;

procedure TfrmHelpMemo.DesabilitaEditar;
begin
    dbeID.ReadOnly:= True;
    dbcCategoria.ReadOnly:= True;
    dbeAssunto.ReadOnly:= True;
    dbmResumo.ReadOnly:= True;
    dbeLocal.ReadOnly:= True;
    btnLocal.Enabled:= False;
end;

procedure TfrmHelpMemo.mRestaurarClick(Sender: TObject);
begin
     try
    Application.CreateForm(TfrmRestaurar,frmRestaurar);
    frmRestaurar.ShowModal;
   finally
     FreeAndNil(frmRestaurar);
   end;
end;


procedure TfrmHelpMemo.TabDadosEnter(Sender: TObject);
begin
  if (dbeID.Text <> EmptyStr) then
  DesabilitaEditar
  else
   DBNavigator1.BtnClick(nbInsert);
end;

procedure TfrmHelpMemo.TabDadosExit(Sender: TObject);
begin
  DBNavigator1.BtnClick(nbCancel);
end;

end.

