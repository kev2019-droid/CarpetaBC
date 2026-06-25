namespace SAPONAIBASE.SAPONAIBASE;

using Microsoft.Inventory.Setup;

pageextension 50117 "Inventory Setup" extends "Inventory Setup"
{
    layout
    {
        addafter("Allow Inventory Adjustment")
        {
            group(TransferProcess)
            {
                Caption = 'Pedidos de Transferencia';
                field("Inventory Loading Nos."; Rec."Inventory Loading Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica la serie de numeración utilizada para crear documentos de carga de inventario.';
                }
                field("Allow Item No. in Picking"; Rec."Allow Item No. in Picking")
                {
                    ApplicationArea = All;
                }
                field("Allow Item No. in Loading"; Rec."Allow Item No. in Loading")
                {
                    ApplicationArea = All;
                }
                field("Allow Modify Qty. To Ship"; Rec."Allow Modify Qty. To Ship")
                {
                    ApplicationArea = All;
                }
                group(InitialSKUGeneration)
                {
                    Caption = 'Generacion inicial de SKU';

                    field("Init SKU Transfer Reorder %"; Rec."Init SKU Transfer Reorder %")
                    {
                        ApplicationArea = All;
                    }
                    field("Init SKU Transfer Max Mult."; Rec."Init SKU Transfer Max Mult.")
                    {
                        ApplicationArea = All;
                    }
                    field("Init SKU Purchase Reorder %"; Rec."Init SKU Purchase Reorder %")
                    {
                        ApplicationArea = All;
                    }
                    field("Init SKU Purchase Max Mult."; Rec."Init SKU Purchase Max Mult.")
                    {
                        ApplicationArea = All;
                    }
                    field("Initial SKU Opening Loc. Cat."; Rec."Initial SKU Opening Loc. Cat.")
                    {
                        ApplicationArea = All;
                        Caption = 'Categoría almacén aperturas';
                        ToolTip = 'Especifica la categoría de almacén que se utilizará para generar masivamente las SKUs iniciales de los productos asociados a dicha categoría. Esta configuración está pensada para procesos de apertura o carga inicial; por eso, se recomienda asignar temporalmente esta categoría a las sucursales que se van a inicializar y luego reemplazarla por su categoría operativa definitiva.';
                    }
                }
                group(InventarioCal)
                {
                    Caption = 'Configuración para Inventario';
                    field(Percent; Rec.Percent)
                    {
                        ApplicationArea = All;
                    }
                    field(Dato; Rec.Dato)
                    {
                        ApplicationArea = All;
                    }
                    field("Top Sales Start Date"; Rec."Top Sales Start Date")
                    {
                        ApplicationArea = All;
                    }
                    field("Top Sales End Date"; Rec."Top Sales End Date")
                    {
                        ApplicationArea = All;
                    }
                    field("Top Sales By Quantity"; Rec."Top Sales By Quantity")
                    {
                        ApplicationArea = All;
                    }
                    field("Daily Sales Average Days"; Rec."Daily Sales Average Days")
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
}
