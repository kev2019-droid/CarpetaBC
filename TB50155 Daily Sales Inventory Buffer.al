table 50155 "Daily Sales Inventory Buffer"
{
    Caption = 'Daily Sales Inventory Buffer';
    TableType = Temporary;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(3; "Inventory Change"; Decimal)
        {
            Caption = 'Inventory Change';
        }
        field(4; "Sales Quantity"; Decimal)
        {
            Caption = 'Sales Quantity';
        }
    }

    keys
    {
        key(PK; "Item No.", "Posting Date")
        {
            Clustered = true;
        }
    }
}
