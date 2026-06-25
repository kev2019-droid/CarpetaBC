table 50154 "Warehouse Top Detail"
{
    Caption = 'Detalle Top Almacen';
    TableType = Temporary;

    fields
    {
        field(1; "Location Code"; Code[20])
        {
            Caption = 'Almacen';
        }

        field(2; "Item No."; Code[20])
        {
            Caption = 'N°';
        }

        field(3; Description; Text[100])
        {
            Caption = 'Descripción';
        }

        field(4; "Sales Quantity"; Decimal)
        {
            Caption = 'Cantidad en Ventas';
        }

        field(5; Inventory; Decimal)
        {
            Caption = 'Inventario';
        }

        field(6; "Qty. on Purch. Order"; Decimal)
        {
            Caption = 'Cantidad en Compras';
        }

        field(7; "Stock Status"; Option)
        {
            OptionMembers = "On Purchase Order","In Stock","Out of Stock";
        }
        field(8; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
        }
        field(9; Amount; Decimal)
        {
            Caption = 'Importe';
        }
        field(10; "Qty. On Transfer"; Decimal)
        {
            Caption = 'Cantidad en Pedidos de Transferencia';
        }
        field(11; "Qty. Received"; Decimal)
        {
            Caption = 'Cantidad en Pedidos de Transferencia Recibidos';
        }
        field(12; "Qty. On Transfer(Real)"; Decimal)
        {
            Caption = 'Cantidad en Pedidos de Transferencia';
            ToolTip = 'Cantidad Calculada en pedidos de transferencia';
        }
        field(13; "Daily Sales Average"; Decimal)
        {
            Caption = 'Promedio ventas diarias';
            ToolTip = 'Promedio diario de ventas calculado sobre los dias con ventas o con inventario disponible. Los dias sin ventas y sin inventario no se incluyen.';
            DecimalPlaces = 0 : 0;
        }
    }

    keys
    {
        key(PK; "Location Code", "Item No.")
        {
            Clustered = true;
        }
        key(FK; "Sales Quantity")
        {

        }
    }
}
