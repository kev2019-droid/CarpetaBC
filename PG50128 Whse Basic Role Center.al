namespace SAPONAIBASE.SAPONAIBASE;

using Microsoft.Warehouse.RoleCenters;

pageextension 50128 "Whse. Basic Role Center" extends "Whse. Basic Role Center"
{
    layout
    {
        addafter(Control51)
        {
            part(KPIProductos; "Minimun Treshhold Items card")
            {
                ApplicationArea = All;
            }
            part(ListaUmbralM; "Minimun Treshhold Items List")
            {
                ApplicationArea = All;
            }
            part(Grafica; "Stock Pie")
            {
                ApplicationArea = All;
            }
            part(Top; "Warehouse Top Summary")
            {
                ApplicationArea = All;
            }
        }

    }
}