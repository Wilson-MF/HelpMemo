unit urestaurar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  uConexao;

type

  { TfrmRestaurar }

  TfrmRestaurar = class(TForm)
    btnRestaurar: TBitBtn;
    btnLocalizar: TBitBtn;
    edtLocalizar: TEdit;
    Label1: TLabel;
    lblRetLocal: TLabel;
    OpenDialog1: TOpenDialog;
    procedure btnLocalizarClick(Sender: TObject);
    procedure btnRestaurarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private

  public

  end;

var
  frmRestaurar: TfrmRestaurar;
  sPath : string;
implementation

{$R *.lfm}

{ TfrmRestaurar }

procedure TfrmRestaurar.btnRestaurarClick(Sender: TObject);
var
  caminhoEdt, Arq : string;
  Arq_Original, Arq_Destino : string;
 begin
   dmConexao.ZConexao.Connected:= False;
   caminhoEdt := edtLocalizar.Text;
   Arq := 'HelpMemo.db';
   Arq_Original := caminhoEdt;
   Arq_Destino  := sPath+Arq;

     if CopyFile(Arq_Original, Arq_Destino, True) then

         messagedlg('Banco de Dados restaurado com sucesso!',mtinformation,[mbok],0)
       else
        messagedlg('Não foi possível Restaurar o Banco de Dados!',mtwarning,[mbok],0);
end;

procedure TfrmRestaurar.btnLocalizarClick(Sender: TObject);
begin
   if OpenDialog1.Execute then
    edtLocalizar.Text:= OpenDialog1.FileName;
end;

procedure TfrmRestaurar.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  dmConexao.ZConexao.Connected:= True;
end;

end.

