namespace SAPONAIBASE.SAPONAIBASE;

using Microsoft.Inventory.Setup;
using Microsoft.Foundation.NoSeries;

tableextension 50109 "Inventory Setup" extends "Inventory Setup"
{
    fields
    {
        field(50100; "Inventory Loading Nos."; Code[20])
        {
            Caption = 'N° carga inventario';
            ToolTip = 'Especifica la serie de numeración utilizada para crear documentos de carga de inventario.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(50101; "Allow Item No. in Picking"; Boolean)
        {
            Caption = 'Permitir uso de Nº. producto en picking';
            ToolTip = 'Si está activado, permite ingresar manualmente el código interno del producto (No. Producto) durante el proceso de picking. Si está desactivado, solo se permitirá la búsqueda mediante código de barras.';
            DataClassification = CustomerContent;
        }
        field(50102; "Allow Item No. in Loading"; Boolean)
        {
            Caption = 'Permitir uso de Nº. producto en cargas';
            ToolTip = 'Si está activado, permite ingresar manualmente el código interno del producto (No. Producto) durante el proceso de carga del camión (Pedidos de trasferencia). Si está desactivado, solo se permitirá la búsqueda mediante código de barras.';
            DataClassification = CustomerContent;
        }
        field(50103; "Allow Modify Qty. To Ship"; Boolean)
        {
            Caption = 'Permitir Modificar Cant. a Cargar';
            ToolTip = 'Si está activado, permite modificar la cantidad a cargar durante el proceso de carga del camión (Pedidos de trasferencia). Si está desactivado, forzará el registro del envío según lo preparado en el proceso de Picking.';
            DataClassification = CustomerContent;
        }
        field(50104; "Init SKU Transfer Reorder %"; Decimal)
        {
            Caption = 'Porcentaje reorder transferencia SKU inicial';
            ToolTip = 'Define el porcentaje de la unidad de empaque que se utilizara como punto de reposicion al generar SKUs iniciales para sucursales.';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(50105; "Init SKU Transfer Max Mult."; Decimal)
        {
            Caption = 'Multiplicador maximo transferencia SKU inicial';
            ToolTip = 'Define cuantas unidades de empaque se tomaran como inventario maximo al generar SKUs iniciales de transferencia.';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(50106; "Init SKU Purchase Reorder %"; Decimal)
        {
            Caption = 'Porcentaje reorder compra SKU inicial';
            ToolTip = 'Define el porcentaje de la base de compra que se utilizara como punto de reposicion para la SKU inicial de compra.';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(50107; "Init SKU Purchase Max Mult."; Decimal)
        {
            Caption = 'Multiplicador maximo compra SKU inicial';
            ToolTip = 'Define cuantas veces se multiplicara la base de compra para calcular el inventario maximo de la SKU inicial de compra.';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(50108; "Initial SKU Opening Loc. Cat."; Code[20])
        {
            Caption = 'Categoría almacén aperturas';
            ToolTip = 'Especifica la categoría de almacén que se utilizará para generar masivamente las SKUs iniciales de los productos asociados a dicha categoría. Esta configuración está pensada para procesos de apertura o carga inicial; por eso, se recomienda asignar temporalmente esta categoría a las sucursales que se van a inicializar y luego reemplazarla por su categoría operativa definitiva.';
            DataClassification = CustomerContent;
            TableRelation = "Location Category".Code;
        }
        field(50109; "Percent"; Boolean)
        {
            Caption = 'Porcentaje';
            InitValue = false;
            ToolTip = 'Indica si el calculo del Inventario por sucursal se hará en base a porcentaje o en base a cantidad';
            DataClassification = CustomerContent;
        }
        field(50110; Dato; Decimal)
        {
            Caption = 'Dato';
            ToolTip = 'Indica la Cantidad a utilizar para el calculo de inventario ya sea en porcentaje o en número';
            DataClassification = CustomerContent;
        }
        field(50111; "Top Sales Start Date"; Date)
        {
            Caption = 'Fecha Inicial';
            ToolTip = 'Indica la fecha inicial para realizar el calculo';
            DataClassification = CustomerContent;
        }
        field(50112; "Top Sales End Date"; Date)
        {
            Caption = 'Fecha Final';
            ToolTip = 'Indica la fecha inicial para realizar el calculo';
            DataClassification = CustomerContent;
        }
        field(50113; "Top Sales By Quantity"; Boolean)
        {
            Caption = 'Top por Cantidad';
            ToolTip = 'Determina si el Top sera por Cantidad si esta en Verdadero o por Importe si esta en Falso';
            DataClassification = CustomerContent;
        }
        field(50114; "Daily Sales Average Days"; Integer)
        {
            Caption = 'Dias para promedio de ventas';
            ToolTip = 'Especifica la cantidad de dias, contados hacia atras desde la fecha de trabajo, que se analizaran para calcular el promedio diario de ventas.';
            DataClassification = CustomerContent;
            InitValue = 30;
            MinValue = 1;
        }
    }
}
