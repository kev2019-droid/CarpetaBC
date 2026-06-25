query 50103 "Inventory By Item Query"
{
    QueryType = Normal;

    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            filter(LocationCode; "Location Code")
            {
            }
            filter(PostingDate; "Posting Date")
            {
            }
            column(ItemNo; "Item No.")
            {
            }
            column(InventoryQuantity; Quantity)
            {
                Method = Sum;
            }
        }
    }
}
