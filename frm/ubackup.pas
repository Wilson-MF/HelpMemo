unit uBackup;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil , Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ComCtrls, uConexao;


type

  { TfrmBackup }

  TfrmBackup = class(TForm)
    btnBackUp: TBitBtn;
    btnLocalBackup: TBitBtn;
    edtLocal: TEdit;
    Label1: TLabel;
    lblLocalBackup: TLabel;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    procedure btnBackUpClick(Sender: TObject);
    procedure btnLocalBackupClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);

  private

  public

  end;

var
  frmBackup: TfrmBackup;
   sPath : string;
implementation


{$R *.lfm}

{ TfrmBackup }

procedure TfrmBackup.btnLocalBackupClick(Sender: TObject);
begin
    if SelectDirectoryDialog1.Execute then
    edtLocal.Text:= SelectDirectoryDialog1.FileName;
end;

procedure TfrmBackup.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

  dmConexao.ZConexao.Connected:= True;

 end;

procedure TfrmBackup.FormCreate(Sender: TObject);
begin
   sPath := ExtractFilePath(Application.ExeName);

end;

procedure TfrmBackup.btnBackUpClick(Sender: TObject);
var
  Data, Pathdata, caminhoEscolhido, escolhidoData, Arq : string;
  Arq_Original, Arq_Destino : string;
 begin
   dmConexao.ZConexao.Connected:= False;
   caminhoEscolhido := edtLocal.Text+'\';
   Data  := FormatDateTime('DD-MM-YYYY', Now);
   PathData := sPath+Data+'-';
   escolhidoData := caminhoEscolhido+Data+'-';
   Arq := 'HelpMemo.db';
   Arq_Original := sPath+Arq;
   Arq_Destino  := PathData+Arq;

   if (edtLocal.text <> '') then

      begin
       Arq_Destino  := escolhidoData+Arq;

       if CopyFile(Arq_Original, Arq_Destino, True) then

         messagedlg('Backup realizado com sucesso!',mtinformation,[mbok],0)
       else
        messagedlg('Não foi possível fazer o backup!',mtwarning,[mbok],0);
      end

      else

      begin

       if CopyFile(Arq_Original, Arq_Destino, True) then

         messagedlg('Backup realizado com sucesso!',mtinformation,[mbok],0)
       else
         messagedlg('Não foi possível fazer o backup!',mtwarning,[mbok],0);
      end;
end;

end.

