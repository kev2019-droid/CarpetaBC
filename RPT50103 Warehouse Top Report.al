namespace SAPONAIBASE.SAPONAIBASE;
using System.Utilities;
using Microsoft.Foundation.Company;
using Microsoft.Inventory.Item;

report 50103 "Warehouse Top Report"
{
    ApplicationArea = All;
    Caption = 'Reporte In Stock por sucursal';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'RDLC/WarehouseTopReport.rdlc';
    dataset
    {
        dataitem(SummaryLoop; Integer)
        {
            DataItemTableView = sorting(Number);
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress2; CompanyInfo."Address 2") { }
            column(CompanyCity; CompanyInfo.City) { }
            column(CompanyLogo; CompanyInfo.Picture) { }
            column(CompanyPhone; CompanyInfo."Phone No.") { }
            column(CompanyPhoneNo; CompanyInfo."Phone No.") { }

            column(Location_Code; TempSummary."Location Code") { }
            column(Location_Name; TempSummary."Location Name") { }
            column(In_Stock_Count; TempSummary."In Stock Count") { }
            column(Out_Stock_Count; TempSummary."Out Stock Count") { }
            column(On_Purchase_Count; TempSummary."On Purchase Count") { }
            column(Total_Top_Items; TempSummary."Total Top Items") { }
            column("Percent_In_Stock"; TempSummary."% In Stock") { }
            column(verdetalle; verdetalle) { }

            dataitem(DetailLoop; Integer)
            {
                DataItemTableView = sorting(Number);

                column(Item_No; TempDetail."Item No.") { }
                column(Description; TempDetail.Description) { }
                column(Sales_Quantity; TempDetail."Sales Quantity") { }
                column(Amount; TempDetail.Amount) { }
                column(Inventory; TempDetail.Inventory) { }
                column(Qty_on_Purch_Order; TempDetail."Qty. on Purch. Order") { }
                column(Qty_On_Transfer_Real; TempDetail."Qty. On Transfer(Real)") { }
                column(Stock_Status; TempDetail."Stock Status") { }

                trigger OnPreDataItem()
                begin
                    TempDetail.Reset();
                    TempDetail.DeleteAll();

                    TopSellingItemMgt.BuildWarehouseDetail(
                        TempSummary."Location Code",
                        TempTopBuffer,
                        TempSalesBuffer,
                        TempDetail);

                    DetailLoop.SetRange(Number, 1, TempDetail.Count());

                    if TempDetail.FindSet() then;
                end;

                trigger OnAfterGetRecord()
                begin
                    if DetailLoop.Number > 1 then
                        TempDetail.Next();
                end;
            }

            trigger OnPreDataItem()
            begin
                SummaryLoop.SetRange(Number, 1, TempSummary.Count());

                if TempSummary.FindSet() then;
            end;

            trigger OnAfterGetRecord()
            begin
                if SummaryLoop.Number > 1 then
                    TempSummary.Next();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Detalle)
                {
                    field(verdetalle; verdetalle)
                    {
                        Caption = 'Mostrar detalle';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        TopSellingItemMgt.BuildBuffers(
            TempTopBuffer,
            TempSalesBuffer);

        TopSellingItemMgt.BuildWarehouseSummary(
            TempTopBuffer,
            TempSummary);
    end;

    var
        TopSellingItemMgt: Codeunit "Top Selling Item Mgt.";
        TempTopBuffer: Record "Top Sales Buffer" temporary;
        TempSalesBuffer: Record "Sales Buffer" temporary;
        TempSummary: Record "Warehouse Top Summary" temporary;
        TempDetail: Record "Warehouse Top Detail" temporary;
        CompanyInfo: Record "Company Information";
        verdetalle: Boolean;

}
