namespace SAPONAIBASE.SAPONAIBASE;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Setup;
using Microsoft.Inventory.Ledger;
using SAPONAIBASE.Transport;
using Microsoft.Inventory.Location;

codeunit 50128 "Top Selling Item Mgt."
{
    procedure BuildBuffers(
    var TempTopBuffer: Record "Top Sales Buffer" temporary;
    var TempSalesBuffer: Record "Sales Buffer" temporary)
    var
        TempSourceBuffer: Record "Top Sales Buffer" temporary;
    begin
        LoadSetup();

        TempTopBuffer.Reset();
        TempTopBuffer.DeleteAll();

        TempSalesBuffer.Reset();
        TempSalesBuffer.DeleteAll();

        TempSourceBuffer.Reset();
        TempSourceBuffer.DeleteAll();

        LoadSalesData(TempSalesBuffer);

        BuildTopBuffer(
            TempSalesBuffer,
            TempSourceBuffer);

        //Message('SourceBuffer antes TOP: %1', TempSourceBuffer.Count());

        ApplyTopFilter(
            TempSourceBuffer,
            TempTopBuffer);

        //Message('TopBuffer después TOP: %1', TempTopBuffer.Count());
    end;

    procedure BuildWarehouseSummary(
    var TempTopBuffer: Record "Top Sales Buffer" temporary;
    var TempSummary: Record "Warehouse Top Summary" temporary)
    var
        Location: Record Location;
    begin
        TempSummary.Reset();
        TempSummary.DeleteAll();

        Location.Reset();
        Location.SetRange("Use As Store", true);

        if Location.FindSet() then
            repeat
                TempSummary.Init();

                TempSummary."Location Code" := Location.Code;
                TempSummary."Location Name" := Location.Name;

                CalculateLocationSummary(
                    Location.Code,
                    TempTopBuffer,
                    TempSummary."In Stock Count",
                    TempSummary."Out Stock Count",
                    TempSummary."On Purchase Count");

                TempSummary."Total Top Items" :=
                    TempSummary."In Stock Count" +
                    TempSummary."Out Stock Count";
                if TempSummary."In Stock Count" > 0 then
                    TempSummary."% In Stock" := (TempSummary."In Stock Count" / TempSummary."Total Top Items") * 100
                else
                    TempSummary."% In Stock" := 0;
                TempSummary.Insert();

            until Location.Next() = 0;
    end;

    local procedure CalculateLocationSummary(
    LocationCode: Code[20];
    var TempTopBuffer: Record "Top Sales Buffer" temporary;
    var InStockCount: Integer;
    var OutStockCount: Integer;
    var OnPurchaseCount: Integer)
    var
        Item: Record Item;
    begin
        InStockCount := 0;
        OutStockCount := 0;
        OnPurchaseCount := 0;

        TempTopBuffer.Reset();

        if TempTopBuffer.FindSet() then
            repeat
                if not Item.Get(TempTopBuffer."Item No.") then
                    continue;

                Item.SetRange("Location Filter", LocationCode);

                Item.CalcFields(
                    Inventory,
                    "Qty. on Purch. Order");

                if Item.Inventory > 0 then
                    InStockCount += 1
                else
                    OutStockCount += 1;

                if Item."Qty. on Purch. Order" > 0 then
                    OnPurchaseCount += 1;

            until TempTopBuffer.Next() = 0;
    end;

    procedure BuildWarehouseDetail(
    LocationCode: Code[20];
    var TempTopBuffer: Record "Top Sales Buffer" temporary;
    var TempSalesBuffer: Record "Sales Buffer" temporary;
    var TempDetail: Record "Warehouse Top Detail" temporary)
    var
        Item: Record Item;
        TempDailyBuffer: Record "Daily Sales Inventory Buffer" temporary;
        AverageStartDate: Date;
        AverageEndDate: Date;
    begin
        LoadSetup();

        TempDetail.Reset();
        TempDetail.DeleteAll();

        AverageEndDate := WorkDate();
        AverageStartDate :=
            AverageEndDate - (LogisticsSetup."Daily Sales Average Days" - 1);

        LoadDailySalesInventoryBuffer(
            LocationCode,
            AverageStartDate,
            AverageEndDate,
            TempTopBuffer,
            TempDailyBuffer);

        TempTopBuffer.Reset();

        if TempTopBuffer.FindSet() then
            repeat
                TempDetail.Init();

                TempDetail."Location Code" := LocationCode;
                TempDetail."Item No." := TempTopBuffer."Item No.";
                TempDetail.Description := TempTopBuffer.Description;
                TempDetail."Base Unit of Measure" := TempTopBuffer."Base Unit of Measure";

                if TempSalesBuffer.Get(LocationCode, TempTopBuffer."Item No.") then begin
                    TempDetail."Sales Quantity" := TempSalesBuffer."Sales Quantity";
                    TempDetail.Amount := TempSalesBuffer.Amount;
                end else begin
                    TempDetail."Sales Quantity" := 0;
                    TempDetail.Amount := 0;
                end;

                if Item.Get(TempTopBuffer."Item No.") then begin
                    Item.SetRange("Location Filter", LocationCode);
                    Item.CalcFields(
                        Inventory,
                        "Qty. on Purch. Order", "Qty. On Transfer", "Qty. On Transfer Received");
                    TempDetail."Qty. On Transfer" := Item."Qty. On Transfer";
                    TempDetail."Qty. Received" := Item."Qty. On Transfer Received";
                    TempDetail."Qty. On Transfer(Real)" := Item."Qty. On Transfer" - Item."Qty. On Transfer Received";

                    TempDetail.Inventory := Item.Inventory;
                    TempDetail."Qty. on Purch. Order" := Item."Qty. on Purch. Order";

                    if TempDetail.Inventory > 0 then
                        TempDetail."Stock Status" := TempDetail."Stock Status"::"In Stock"
                    else begin
                        if TempDetail."Qty. on Purch. Order" > 0 then
                            TempDetail."Stock Status" := TempDetail."Stock Status"::"On Purchase Order"
                        else
                            TempDetail."Stock Status" := TempDetail."Stock Status"::"Out of Stock";
                    end;
                end;

                TempDetail."Daily Sales Average" :=
                    CalculateDailySalesAverage(
                        TempTopBuffer."Item No.",
                        AverageStartDate,
                        AverageEndDate,
                        TempDailyBuffer);

                TempDetail.Insert();

            until TempTopBuffer.Next() = 0;
    end;

    local procedure LoadDailySalesInventoryBuffer(
        LocationCode: Code[20];
        StartDate: Date;
        EndDate: Date;
        var TempTopBuffer: Record "Top Sales Buffer" temporary;
        var TempDailyBuffer: Record "Daily Sales Inventory Buffer" temporary)
    var
        InventoryByItemQuery: Query "Inventory By Item Query";
        DailyItemMovementsQuery: Query "Daily Item Movements Query";
        ItemLedgerEntry: Record "Item Ledger Entry";
        OpeningInventoryDate: Date;
    begin
        TempDailyBuffer.Reset();
        TempDailyBuffer.DeleteAll();

        OpeningInventoryDate := StartDate - 1;

        InventoryByItemQuery.SetRange(LocationCode, LocationCode);
        InventoryByItemQuery.SetRange(PostingDate, 0D, OpeningInventoryDate);
        InventoryByItemQuery.Open();

        while InventoryByItemQuery.Read() do
            if TempTopBuffer.Get(InventoryByItemQuery.ItemNo) then begin
                TempDailyBuffer.Init();
                TempDailyBuffer."Item No." := InventoryByItemQuery.ItemNo;
                TempDailyBuffer."Posting Date" := 0D;
                TempDailyBuffer."Inventory Change" :=
                    InventoryByItemQuery.InventoryQuantity;
                TempDailyBuffer.Insert();
            end;

        InventoryByItemQuery.Close();

        DailyItemMovementsQuery.SetRange(LocationCode, LocationCode);
        DailyItemMovementsQuery.SetRange(
            PostingDateFilter,
            StartDate,
            EndDate);
        DailyItemMovementsQuery.Open();

        while DailyItemMovementsQuery.Read() do
            if TempTopBuffer.Get(DailyItemMovementsQuery.ItemNo) then begin
                if not TempDailyBuffer.Get(
                    DailyItemMovementsQuery.ItemNo,
                    DailyItemMovementsQuery.PostingDate)
                then begin
                    TempDailyBuffer.Init();
                    TempDailyBuffer."Item No." :=
                        DailyItemMovementsQuery.ItemNo;
                    TempDailyBuffer."Posting Date" :=
                        DailyItemMovementsQuery.PostingDate;
                    TempDailyBuffer.Insert();
                end;

                TempDailyBuffer."Inventory Change" +=
                    DailyItemMovementsQuery.MovementQuantity;

                if DailyItemMovementsQuery.EntryType =
                   ItemLedgerEntry."Entry Type"::Sale
                then
                    TempDailyBuffer."Sales Quantity" +=
                        DailyItemMovementsQuery.MovementQuantity;

                TempDailyBuffer.Modify();
            end;

        DailyItemMovementsQuery.Close();
    end;

    local procedure CalculateDailySalesAverage(
        ItemNo: Code[20];
        StartDate: Date;
        EndDate: Date;
        var TempDailyBuffer: Record "Daily Sales Inventory Buffer" temporary): Decimal
    var
        AnalysisDate: Date;
        ClosingInventory: Decimal;
        TotalSalesQuantity: Decimal;
        DailySalesQuantity: Decimal;
        ValidDays: Integer;
    begin
        if TempDailyBuffer.Get(ItemNo, 0D) then
            ClosingInventory := TempDailyBuffer."Inventory Change";

        AnalysisDate := StartDate;
        while AnalysisDate <= EndDate do begin
            DailySalesQuantity := 0;

            if TempDailyBuffer.Get(ItemNo, AnalysisDate) then begin
                ClosingInventory += TempDailyBuffer."Inventory Change";
                DailySalesQuantity :=
                    Abs(TempDailyBuffer."Sales Quantity");
            end;

            if DailySalesQuantity > 0 then begin
                TotalSalesQuantity += DailySalesQuantity;
                ValidDays += 1;
            end else
                if ClosingInventory > 0 then
                    ValidDays += 1;

            AnalysisDate := CalcDate('<1D>', AnalysisDate);
        end;

        if ValidDays = 0 then
            exit(0);

        exit(Round(TotalSalesQuantity / ValidDays, 1, '>'));
    end;

    local procedure LoadSetup()
    begin
        LogisticsSetup.Get();

        LogisticsSetup.TestField("Top Sales Start Date");
        LogisticsSetup.TestField("Top Sales End Date");
        LogisticsSetup.TestField("Daily Sales Average Days");
        // LogisticsSetup.TestField("Top Sales By Quantity");
    end;

    local procedure LoadSalesData(
    var TempSalesBuffer: Record "Sales Buffer" temporary)
    var
        SalesAnalysisQuery: Query "Sales Analysis Query";
        ValueEntry: Record "Value Entry";
    begin
        TempSalesBuffer.Reset();
        TempSalesBuffer.DeleteAll();

        SalesAnalysisQuery.SetRange(
            PostingDate,
            LogisticsSetup."Top Sales Start Date",
            LogisticsSetup."Top Sales End Date");

        SalesAnalysisQuery.SetRange(
            EntryType,
            ValueEntry."Item Ledger Entry Type"::Sale);

        SalesAnalysisQuery.Open();

        while SalesAnalysisQuery.Read() do begin
            TempSalesBuffer.Init();

            TempSalesBuffer."Location Code" :=
                SalesAnalysisQuery.LocationCodeResult;

            TempSalesBuffer."Item No." :=
                SalesAnalysisQuery.ItemNo;

            TempSalesBuffer.Description :=
                SalesAnalysisQuery.Description;

            TempSalesBuffer."Base Unit of Measure" :=
                SalesAnalysisQuery.BaseUnit;

            TempSalesBuffer."Sales Quantity" :=
                Abs(SalesAnalysisQuery.SalesQuantity);

            TempSalesBuffer.Amount :=
                Abs(SalesAnalysisQuery.SalesAmount);

            TempSalesBuffer.Insert();
        end;

        SalesAnalysisQuery.Close();
    end;

    local procedure ApplyTopFilter(
    var TempSourceBuffer: Record "Top Sales Buffer" temporary;
    var TempTopBuffer: Record "Top Sales Buffer" temporary)
    var
        TotalItems: Integer;
        ItemsToTake: Integer;
    begin
        TempTopBuffer.Reset();
        TempTopBuffer.DeleteAll();

        TotalItems := TempSourceBuffer.Count();

        if TotalItems = 0 then
            exit;

        if LogisticsSetup.Percent then begin
            ItemsToTake :=
                Round(
                    TotalItems * LogisticsSetup.Dato / 100,
                    1,
                    '>');
        end else begin
            ItemsToTake :=
                Round(LogisticsSetup.Dato, 1, '>');
        end;

        if ItemsToTake <= 0 then
            Error('La cantidad calculada para el TOP debe ser mayor que cero.');

        if ItemsToTake > TotalItems then
            ItemsToTake := TotalItems;

        TempSourceBuffer.Reset();
        TempSourceBuffer.SetCurrentKey(Score);
        TempSourceBuffer.Ascending(false);

        if TempSourceBuffer.FindSet() then
            repeat
                TempTopBuffer.Init();
                TempTopBuffer.TransferFields(TempSourceBuffer);
                TempTopBuffer.Insert();

                ItemsToTake -= 1;

            until (TempSourceBuffer.Next() = 0) or (ItemsToTake = 0);
    end;

    local procedure CalculateLocationSummary()
    begin

    end;

    local procedure IsEligibleItem(Item: Record Item): Boolean
    begin
        exit(
            ValidateGeneralRules(Item)
        ////ValidateCategory(Item) and
        ////ValidateProductGroup(Item)
        );
    end;

    local procedure ValidateGeneralRules(Item: Record Item): Boolean
    begin
        if Item.Blocked then
            exit(false);

        if Item."Block Transfer" then
            exit(false);

        if Item."Allow Direct Purchase" then
            exit(false);

        exit(true);
    end;

    local procedure BuildTopBuffer(
     var TempSalesBuffer: Record "Sales Buffer" temporary;
     var TempTopBuffer: Record "Top Sales Buffer" temporary)
    var
        CurrentItemNo: Code[20];
        CurrentDescription: Text[100];
        CurrentBaseUnit: Code[10];
        TotalQty: Decimal;
        TotalAmount: Decimal;
    begin
        TempTopBuffer.Reset();
        TempTopBuffer.DeleteAll();

        TempSalesBuffer.Reset();
        TempSalesBuffer.SetCurrentKey("Item No.");

        if not TempSalesBuffer.FindSet() then
            exit;

        Clear(CurrentItemNo);
        Clear(CurrentDescription);
        Clear(CurrentBaseUnit);

        TotalQty := 0;
        TotalAmount := 0;

        repeat

            // Si cambió el artículo, guardar el anterior
            if (CurrentItemNo <> '') and
               (CurrentItemNo <> TempSalesBuffer."Item No.") then begin

                TempTopBuffer.Init();
                TempTopBuffer."Item No." := CurrentItemNo;
                TempTopBuffer.Description := CurrentDescription;
                TempTopBuffer."Base Unit of Measure" := CurrentBaseUnit;
                TempTopBuffer."Sales Quantity" := TotalQty;
                TempTopBuffer.Amount := TotalAmount;

                if LogisticsSetup."Top Sales By Quantity" then
                    TempTopBuffer.Score := TotalQty
                else
                    TempTopBuffer.Score := TotalAmount;

                TempTopBuffer.Insert();

                TotalQty := 0;
                TotalAmount := 0;
            end;

            // Actualizar datos del artículo actual
            CurrentItemNo := TempSalesBuffer."Item No.";
            CurrentDescription := TempSalesBuffer.Description;
            CurrentBaseUnit := TempSalesBuffer."Base Unit of Measure";

            TotalQty += TempSalesBuffer."Sales Quantity";
            TotalAmount += TempSalesBuffer.Amount;

        until TempSalesBuffer.Next() = 0;

        // Insertar el último artículo
        if CurrentItemNo <> '' then begin

            TempTopBuffer.Init();
            TempTopBuffer."Item No." := CurrentItemNo;
            TempTopBuffer.Description := CurrentDescription;
            TempTopBuffer."Base Unit of Measure" := CurrentBaseUnit;
            TempTopBuffer."Sales Quantity" := TotalQty;
            TempTopBuffer.Amount := TotalAmount;

            if LogisticsSetup."Top Sales By Quantity" then
                TempTopBuffer.Score := TotalQty
            else
                TempTopBuffer.Score := TotalAmount;

            TempTopBuffer.Insert();
        end;
    end;

    var
        LogisticsSetup: Record "Inventory Setup";



        TempSalesBuffer: Record "Sales Buffer" temporary;

        TempTopBuffer: Record "Top Sales Buffer" temporary;
}
