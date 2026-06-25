namespace SAPONAIBASE.SAPONAIBASE;

using Microsoft.Purchases.RoleCenters;

pageextension 50127 "Purchasing Agent Role Center" extends "Purchasing Agent Role Center"
{
    layout
    {
        // 🔝 ZONA PRINCIPAL (KPI)
        addfirst(rolecenter)
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

        // 📊 ZONA OPERATIVA (LISTA GRANDE)
        /*addafter(Control1900724808)
        {
            group(UmbralOperativo)
            {
                ShowCaption = false;

                part(ListaUmbral; "Minimun Treshhold Items List")
                {
                    ApplicationArea = All;
                }
            }
        }*/
    }
}
