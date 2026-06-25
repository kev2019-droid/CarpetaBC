namespace SAPONAIBASE.SAPONAIBASE;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using SAPONAIBASE.Transport;

page 50192 "Warehouse Top Summary"
{
    ApplicationArea = All;
    Caption = 'In Stock por sucursal';
    PageType = ListPart;
    SourceTable = "Warehouse Top Summary";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Especifica el valor del campo Almacen.', Comment = '%';
                    trigger OnDrillDown()
                    var
                        WarehouseTopDetail: Page "Warehouse Top Detail";
                    begin
                        WarehouseTopDetail.SetData(
                            Rec."Location Code",
                            TempTopBuffer,
                            TempSalesBuffer);

                        WarehouseTopDetail.RunModal();
                    end;
                }
                field("Location Name"; Rec."Location Name")
                {
                    ToolTip = 'Especifica el valor del campo Nombre de Almacen.', Comment = '%';
                }
                field("Total Top Items"; Rec."Total Top Items")
                {
                    ToolTip = 'Especifica el valor del campo Total.', Comment = '%';
                }
                field("In Stock Count"; Rec."In Stock Count")
                {
                    ToolTip = 'Especifica el valor del campo In Stock.', Comment = '%';
                }
                field("Out Stock Count"; Rec."Out Stock Count")
                {
                    ToolTip = 'Especifica el valor del campo Out Stock.', Comment = '%';
                }
                field("On Purchase Count"; Rec."On Purchase Count")
                {
                    ToolTip = 'Especifica el valor del campo On Purchase Stock.', Comment = '%';
                }
                field("% In Stock"; Rec."% In Stock")
                {
                    ToolTip = 'Especifica el valor del campo On Purchase Stock.', Comment = '%';
                }

            }
        }
    }
    trigger OnOpenPage()
    begin
        TopSellingItemMgt.BuildBuffers(
            TempTopBuffer,
            TempSalesBuffer);

        TopSellingItemMgt.BuildWarehouseSummary(
            TempTopBuffer,
            Rec);
    end;
    /*trigger OnOpenPage()
    var
        code: Codeunit "Top Selling Item Mgt.";
        ItemLedgerEntry: Record "Item Ledger Entry";
        Item: Record Item;
        ItemsFound: Dictionary of [Code[20], Boolean];
        ItemNo: Code[20];
        conf: Record "Logistics Setup";
    //startdate: Date;
    // enddate: Date;
    begin
        // startdate:=d'01/05/2026'
        code.BuildWarehouseSummary(Rec);
        conf.Get('CONFIG');
        ItemLedgerEntry.SetRange(
        "Posting Date",
        conf."Top Sales Start Date",
        conf."Top Sales End Date");
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Sale);
        if ItemLedgerEntry.FindSet() then
            repeat
                ItemNo := ItemLedgerEntry."Item No.";

                if Item.Get(ItemNo) then begin

                    // Validaciones de negocio
                    if Item.Blocked then
                        continue;

                    if Item."Block Transfer" then
                        continue;

                    if Item."Allow Direct Purchase" then
                        continue;

                    if not ItemsFound.ContainsKey(ItemNo) then
                        ItemsFound.Add(ItemNo, true);
                end;

            until ItemLedgerEntry.Next() = 0;

        Message(
            'Productos válidos con movimientos en los últimos 30 días: %1',
            ItemsFound.Count());

    end;*/

    var
        TopSellingItemMgt: Codeunit "Top Selling Item Mgt.";
        TempTopBuffer: Record "Top Sales Buffer" temporary;
        TempSalesBuffer: Record "Sales Buffer" temporary;





}
