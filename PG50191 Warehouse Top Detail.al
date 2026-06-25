namespace SAPONAIBASE.SAPONAIBASE;
using SAPONAIBASE.Transport;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Transfer;
using Microsoft.Purchases.Document;
using Microsoft.Inventory.Setup;
page 50191 "Warehouse Top Detail"
{
    PageType = List;
    SourceTable = "Warehouse Top Detail";
    SourceTableTemporary = true;
    Caption = 'Detalle In stock por sucursal';
    DeleteAllowed = false;
    Editable = false;

    //SourceTableView = sorting("Sales Quantity") order(descending);

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var

                        itemrec: Record item;
                    begin
                        if ItemRec.Get(Rec."Item No.") then
                            Page.Run(Page::"Item Card", ItemRec);
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Sales Quantity"; Rec."Sales Quantity")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = All;
                }
                field("Daily Sales Average"; Rec."Daily Sales Average")
                {
                    ApplicationArea = All;
                }
                field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        PurchaseLine: Record "Purchase Line";
                    begin
                        PurchaseLine.Reset();
                        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                        PurchaseLine.SetRange("No.", Rec."Item No.");
                        PurchaseLine.SetRange("Location Code", Rec."Location Code");
                        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                        PurchaseLine.SetFilter("Outstanding Quantity", '<>%1', 0);

                        Page.Run(Page::"Purchase Lines", PurchaseLine);
                    end;
                }
                field("Qty. On Transfer(Real)"; Rec."Qty. On Transfer(Real)")
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        TransferLine: Record "Transfer Line";
                        TransferHeader: Record "Transfer Header";
                        DocFilter: Text;
                    begin
                        TransferHeader.Reset();
                        TransferHeader.SetRange("Transfer-to Code", Rec."Location Code");

                        if TransferHeader.FindSet() then
                            repeat
                                if DocFilter = '' then
                                    DocFilter := TransferHeader."No."
                                else
                                    DocFilter += '|' + TransferHeader."No.";
                            until TransferHeader.Next() = 0;

                        if DocFilter = '' then begin
                            Message('No hay transferencias hacia el almacén %1.', Rec."Location Code");
                            exit;
                        end;

                        TransferLine.Reset();
                        TransferLine.SetFilter("Document No.", DocFilter);
                        TransferLine.SetRange("Item No.", Rec."Item No.");
                        TransferLine.SetFilter("Quantity (Base)", '<>%1', 0);
                        //TransferLine.SetFilter("Outstanding Qty. (Base)", '<>%1', 0);
                        //TransferLine.SetFilter("Qty. in Transit (Base)", '<>%1', 0);
                        TransferLine.SetFilter("Derived From Line No.", '%1', 0);
                        Page.RunModal(Page::"Transfer Lines", TransferLine);
                    end;
                }
                field("Stock Status"; Rec."Stock Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        TopSellingItemMgt: Codeunit "Top Selling Item Mgt.";
        LocationCode: Code[20];
        TempTopBuffer: Record "Top Sales Buffer" temporary;
        TempSalesBuffer: Record "Sales Buffer" temporary;
        WarehouseTopDetail: Record "Warehouse Top Detail";

    procedure SetData(
    NewLocationCode: Code[20];
    var NewTopBuffer: Record "Top Sales Buffer" temporary;
    var NewSalesBuffer: Record "Sales Buffer" temporary)
    begin
        LocationCode := NewLocationCode;

        TempTopBuffer.Copy(NewTopBuffer, true);
        TempSalesBuffer.Copy(NewSalesBuffer, true);
    end;

    trigger OnOpenPage()
    var
        log: Record "Inventory Setup";
    begin
        TopSellingItemMgt.BuildWarehouseDetail(LocationCode, TempTopBuffer, TempSalesBuffer, Rec);
        log.Get();
        if log."Top Sales By Quantity" then
            Rec.SetCurrentKey("Sales Quantity")
        else
            Rec.SetCurrentKey(Amount);

        Rec.Ascending(false);

        if Rec.FindFirst() then;

    end;


}
