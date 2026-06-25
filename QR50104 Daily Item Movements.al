query 50104 "Daily Item Movements Query"
{
    QueryType = Normal;

    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            filter(LocationCode; "Location Code")
            {
            }
            filter(PostingDateFilter; "Posting Date")
            {
            }
            column(ItemNo; "Item No.")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(EntryType; "Entry Type")
            {
            }
            column(MovementQuantity; Quantity)
            {
                Method = Sum;
            }
        }
    }
}
