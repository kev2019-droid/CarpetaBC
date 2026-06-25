namespace SAPONAIBASE.SAPONAIBASE;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Transfer;

tableextension 50102 Item extends Item
{
    fields
    {
        field(50100; "Storage Location"; Code[20])
        {
            Caption = 'Storage Location';
            DataClassification = CustomerContent;
            TableRelation = "Storage Location".Code;
        }
        field(50101; "Allow Direct Purchase"; Boolean)
        {
            Caption = 'Permitir Compra Directa';
            ToolTip = 'Indica si se permite realizar compras directas de este producto desde una sucursal sin necesidad de recepcionar el producto en la Bodega Central.';
            DataClassification = CustomerContent;
            InitValue = false;
        }
        field(50102; "Subcategory Code"; Code[20])
        {
            Caption = 'Subcategoría Producto';
            DataClassification = CustomerContent;
            TableRelation = "Item Subcategory".Code where("Item Category Code" = field("Item Category Code"));
        }
        field(50103; "Item Type Code"; Code[20])
        {
            Caption = 'Tipo Producto';
            DataClassification = CustomerContent;
            TableRelation = "Item Type".Code where("Item Category Code" = field("Item Category Code"), "Item Subcategory Code" = field("Subcategory Code"));
        }
        field(50104; "Location Category Count"; Integer)
        {
            Caption = 'Categorias de almacen';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Item Location Category Asgmt." where("Item No." = field("No.")));
        }
        field(50105; "Short Description"; Text[100])
        {
            Caption = 'Descripcion corta';
            ToolTip = 'Texto corto sugerido para la etiqueta electronica del producto.';
            DataClassification = CustomerContent;
        }
        field(50106; "Transfer Unit of Measure"; Code[10])
        {
            Caption = 'Unidad medida transferencia';
            ToolTip = 'Especifica la unidad de medida que se utilizará para las transferencia. Esta unidad debe estar registrada dentro de las unidades de medida del producto.';
            DataClassification = CustomerContent;
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("No."));
        }
        field(50107; "Block Transfer"; Boolean)
        {
            Caption = 'Bloquear transferencias';
            ToolTip = 'Evita que este producto se sugiera en la hoja de demanda cuando está activado';
            DataClassification = CustomerContent;
        }
        field(50108; "Qty. On Transfer"; Decimal)
        {
            AccessByPermission = TableData "Transfer Header" = R;
            FieldClass = FlowField;
            CalcFormula = sum("Transfer Line"."Quantity (Base)" where("Item No." = field("No."),
                                                                                 "Transfer-to Code" = field("Location Filter"),
                                                                                 "Derived From Line No." = const(0)));
            DecimalPlaces = 0 : 5;
            Editable = false;
            AutoFormatType = 0;
            Caption = 'Cantidad en Transferencia';
            ToolTip = 'Indica la cantidad de productos que se encuentra en transferencia';
        }
        field(50109; "Qty. On Transfer Received"; Decimal)
        {
            AccessByPermission = TableData "Transfer Header" = R;
            FieldClass = FlowField;
            CalcFormula = sum("Transfer Line"."Qty. Received (Base)" where("Item No." = field("No."), "Transfer-to Code" = field("Location Filter"), "Derived From Line No." = const(0)));
            DecimalPlaces = 0 : 5;
            Editable = false;
            AutoFormatType = 0;
            Caption = 'Cantidad en Transferencia Recibida';
            ToolTip = 'Indica la cantidad de productos en transferencia que fueron recibidos';
        }
    }
}
