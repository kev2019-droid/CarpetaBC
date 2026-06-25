table 50150 "Top Sales Buffer"
{
    Caption = 'Top Sales Buffer';
    TableType = Temporary;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }

        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }

        field(3; "Sales Quantity"; Decimal)
        {
            Caption = 'Sales Quantity';
        }

        field(4; Rank; Integer)
        {
            Caption = 'Rank';
        }
        field(5; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
        }
        field(6; Amount; decimal)
        {
            Caption = 'Importe';
        }
        field(7; score; decimal)
        {
            Caption = 'Puntaje';
        }
    }

    keys
    {
        key(PK; "Item No.")
        {
            Clustered = true;
        }

        key(ScoreKey; Score)
        {
        }
    }
}
