table 50153
 "Warehouse Top Summary"
{
    Caption = 'Resumen Top por Almacen';
    TableType = Temporary;

    fields
    {
        field(1; "Location Code"; Code[20])
        {
            Caption = 'Almacen';
        }

        field(2; "Location Name"; Text[100])
        {
            Caption = 'Nombre';
        }

        field(3; "In Stock Count"; Integer)
        {
            Caption = 'Productos con Inventario';
        }

        field(4; "Out Stock Count"; Integer)
        {
            Caption = 'Productos sin inventario';
        }

        field(5; "On Purchase Count"; Integer)
        {
            Caption = 'Productos en Compras';
        }

        field(6; "Total Top Items"; Integer)
        {
            Caption = 'Productos Considerados';
        }
        field(7; "% In Stock"; Decimal)
        {
            Caption = '% In Stock';
            DecimalPlaces = 0 : 2;
        }
    }

    keys
    {
        key(PK; "Location Code")
        {
            Clustered = true;
        }
    }
}