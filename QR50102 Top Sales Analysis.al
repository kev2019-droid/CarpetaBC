query 50102 "Sales Analysis Query"
{
    QueryType = Normal;

    elements
    {
        dataitem(Item; Item)
        {
            DataItemTableFilter =
                Blocked = const(false),
                "Block Transfer" = const(false),
                "Allow Direct Purchase" = const(false);

            column(ItemNo; "No.")
            {
            }


            column(Description; Description)
            {
            }

            column(BaseUnit; "Base Unit of Measure")
            {
            }

            dataitem(ValueEntry; "Value Entry")
            {
                SqlJoinType = InnerJoin;

                DataItemLink = "Item No." = Item."No.";

                filter(PostingDate; "Posting Date")
                {
                }

                filter(EntryType; "Item Ledger Entry Type")
                {
                }

                filter(LocationCode; "Location Code")
                {
                }

                column(LocationCodeResult; "Location Code")
                {
                }

                column(SalesQuantity; "Invoiced Quantity")
                {
                    Method = Sum;
                }

                column(SalesAmount; "Sales Amount (Actual)")
                {
                    Method = Sum;
                }
            }
        }
    }
}