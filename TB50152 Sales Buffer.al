table 50152 "Sales Buffer"
{
    Caption = 'Sales Analysis Buffer';
    TableType = Temporary;

    fields
    {
        field(1; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }

        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }

        field(3; "Sales Quantity"; Decimal)
        {
            Caption = 'Sales Quantity';
        }

        field(4; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
        }

        field(6; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
        }
    }

    keys
    {
        key(PK; "Location Code", "Item No.")
        {
            Clustered = true;
        }

        key(Item; "Item No.")
        {
        }

        key(Location; "Location Code")
        {
        }

    }
}