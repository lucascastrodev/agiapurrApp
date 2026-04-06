<%@ Page Title="Detalle de Orden" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PedidoProveedorDetalle.aspx.cs" Inherits="TPC_Equipo20B.PedidoProveedorDetalle" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />

    <style>
        /* Estilos generales de la pantalla */
        .hoja-a4 {
            background: white;
            max-width: 800px; /* Ancho máximo para la pantalla */
            margin: 0 auto;
            padding: 40px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            border-radius: 8px;
        }
        
        .text-proveedor { color: #6610f2 !important; }
        .bg-proveedor { background-color: #6610f2 !important; color: white !important; }
        .border-proveedor { border-color: #6610f2 !important; }

        .table-comprobante th {
            background-color: #f8f9fa;
            color: #495057;
            text-transform: uppercase;
            font-size: 0.85rem;
            border-bottom: 2px solid #6610f2;
        }
        
        /* --- ESTILOS EXCLUSIVOS PARA CUANDO SE GENERA EL PDF / IMPRIME --- */
        @media print {
            @page {
                size: A4;
                margin: 0; /* No márgenes de página por defecto */
            }
            body { 
                background: white; 
                margin: 0 auto; /* Centrar el cuerpo */
                padding: 0; 
                width: 210mm; /* Forzar el ancho A4 real */
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
            }
            body * {
                visibility: hidden; /* Oculta todo por defecto */
            }
            
            /* SOLO la hoja y sus hijos son visibles */
            .hoja-a4, .hoja-a4 * {
                visibility: visible; 
            }
            
            .hoja-a4 {
                position: relative; /* Cambiado a relative para mejor flujo de impresión */
                left: 0;
                top: 0;
                width: 100%; /* Ocupar el 210mm del body */
                max-width: 100%;
                margin: 0; 
                padding: 20mm; /* Padding real para la hoja real del PDF */
                box-shadow: none;
                border: none;
                border-radius: 0;
            }
            
            /* Evita que los márgenes del contenedor de Bootstrap empujen la hoja */
            .container { padding: 0 !important; margin: 0 !important; max-width: 100% !important; }
            
            .no-print {
                display: none !important; /* Oculta botones en el PDF */
            }
        }
    </style>

    <div class="container py-4">
        
        <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger fw-bold shadow-sm mb-4 d-block" Visible="false"></asp:Label>

        <asp:Panel ID="pnlComprobante" runat="server">
        
            <div class="d-flex justify-content-between align-items-center mb-4 max-w-800 mx-auto no-print" style="max-width: 800px;">
                <a href="PedidosProveedores.aspx" class="btn btn-outline-secondary fw-bold">
                    <i class="bi bi-arrow-left me-2"></i>Volver al Listado
                </a>
                
                <button type="button" class="btn bg-proveedor px-4 fw-bold shadow-sm d-flex align-items-center gap-2" onclick="window.print();">
                    <span class="material-symbols-outlined fs-5">picture_as_pdf</span> Guardar PDF / Imprimir
                </button>
            </div>

            <div class="hoja-a4 border-top border-proveedor border-5">
                
                <div class="row mb-5 border-bottom pb-4">
                    <div class="col-sm-6">
                        <h2 class="fw-black mb-0 text-dark">AGIAPURR</h2>
                        <p class="text-muted mb-0 fw-medium">Distribuidora Mayorista</p>
                        <p class="small text-muted mt-2 mb-0">CUIT: 30-12345678-9<br /> Villa Ballester, San Martín<br /> Buenos Aires, Argentina</p>
                    </div>
                    <div class="col-sm-6 text-sm-end mt-4 mt-sm-0">
                        <h3 class="text-proveedor fw-bold text-uppercase mb-1">Orden de Pedido</h3>
                        <h4 class="text-dark fw-bold mb-3">N° <asp:Label ID="lblNumeroPedido" runat="server"></asp:Label></h4>
                        <p class="mb-1 fw-medium text-secondary">Fecha Emisión: <asp:Label ID="lblFecha" runat="server" CssClass="text-dark"></asp:Label></p>
                        <p class="mb-0 fw-medium text-secondary">Estado: <asp:Label ID="lblEstado" runat="server" CssClass="badge bg-light text-dark border"></asp:Label></p>
                    </div>
                </div>

                <div class="row mb-5">
                    <div class="col-sm-6">
                        <h6 class="text-uppercase text-muted fw-bold mb-2 small">Emitido a:</h6>
                        <div class="bg-light p-3 rounded-3 border">
                            <h5 class="fw-bold text-dark mb-1"><asp:Label ID="lblProveedorNombre" runat="server"></asp:Label></h5>
                        </div>
                    </div>
                    <div class="col-sm-6 mt-4 mt-sm-0">
                        <h6 class="text-uppercase text-muted fw-bold mb-2 small">Generado por:</h6>
                        <div class="p-3">
                            <p class="mb-1 fw-medium text-dark"><asp:Label ID="lblUsuario" runat="server"></asp:Label></p>
                            <p class="mb-0 small text-muted">Departamento de Compras</p>
                        </div>
                    </div>
                </div>

                <div class="table-responsive mb-4">
                    <table class="table table-comprobante table-borderless align-middle">
                        <thead>
                            <tr>
                                <th style="width: 15%">SKU</th>
                                <th style="width: 45%">Descripción del Producto</th>
                                <th class="text-center" style="width: 10%">Cant.</th>
                                <th class="text-end" style="width: 15%">Costo Unit.</th>
                                <th class="text-end" style="width: 15%">Subtotal</th>
                            </tr>
                        </thead>
                        <tbody class="border-bottom">
                            <asp:Repeater ID="repDetalles" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td class="fw-bold text-muted small"><%# Eval("Producto.Codigo") %></td>
                                        <td class="fw-medium text-dark"><%# Eval("Producto.Descripcion") %></td>
                                        <td class="text-center fw-bold"><%# Eval("Cantidad") %></td>
                                        <td class="text-end text-muted"><%# Eval("PrecioUnitario", "{0:C}") %></td>
                                        <td class="text-end fw-bold text-dark"><%# Eval("Subtotal", "{0:C}") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>

                <div class="d-flex justify-content-end mb-4">
                    <div class="p-3 bg-light rounded-3 border border-proveedor border-opacity-25 text-end" style="min-width: 280px;">
                        <h6 class="text-uppercase text-muted fw-bold mb-2 small">Total Estimado</h6>
                        <h3 class="fw-bold text-proveedor mb-0"><asp:Label ID="lblTotal" runat="server"></asp:Label></h3>
                    </div>
                </div>

                <div class="text-center mt-5 pt-4 border-top text-muted small">
                    <p class="mb-0">Este documento es una orden de pedido de carácter interno y estimativo.</p>
                    <p>Generado automáticamente por el Sistema de Gestión AGIAPURR.</p>
                </div>

            </div>
            
        </asp:Panel>

    </div>

</asp:Content>