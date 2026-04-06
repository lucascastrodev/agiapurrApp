<%@ Page Title="Detalle de Orden" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PedidoProveedorDetalle.aspx.cs" Inherits="TPC_Equipo20B.PedidoProveedorDetalle" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />

    <style>
        /* Estilos generales de la pantalla */
        .hoja-a4 {
            background: white;
            max-width: 800px;
            margin: 0 auto;
            padding: 40px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            border-radius: 8px;
        }

        .text-proveedor {
            color: #6610f2 !important;
        }

        .bg-proveedor {
            background-color: #6610f2 !important;
            color: white !important;
        }

        .border-proveedor {
            border-color: #6610f2 !important;
        }

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
                margin: 0; /* Sin márgenes del navegador */
            }

            body {
                background: white;
                margin: 0 auto;
                padding: 0;
                width: 210mm;
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
            }

                body * {
                    visibility: hidden;
                }

            .hoja-a4, .hoja-a4 * {
                visibility: visible;
            }

            .hoja-a4 {
                position: relative;
                left: 0;
                top: 0;
                width: 100%;
                max-width: 100%;
                margin: 0;
                /* 1. Compresión extrema del padding general de la hoja (arriba/abajo 5mm) */
                padding: 5mm 15mm !important;
                box-shadow: none;
                border: none;
                border-radius: 0;
            }

            .container {
                padding: 0 !important;
                margin: 0 !important;
                max-width: 100% !important;
            }

            .no-print {
                display: none !important;
            }

            /* --- COMPRESIÓN VERTICAL PARA METER HASTA 25 ÍTEMS --- */

            /* 2. Textos generales un poco más chicos y sin márgenes extra */
            .hoja-a4 h2 {
                font-size: 1.4rem !important;
                margin-bottom: 0 !important;
            }

            .hoja-a4 h3 {
                font-size: 1.1rem !important;
                margin-bottom: 0 !important;
            }

            .hoja-a4 h4, .hoja-a4 h5 {
                font-size: 0.95rem !important;
                margin-bottom: 0 !important;
            }

            .hoja-a4 p {
                margin-bottom: 0 !important;
                line-height: 1.2 !important;
            }

            /* 3. Tabla súper finita */
            .table-comprobante th,
            .table-comprobante td {
                padding: 2px 4px !important; /* Mínimo espacio posible de alto */
                font-size: 0.70rem !important; /* Letra un punto más chica */
                line-height: 1.1 !important;
            }

            /* 4. Aplastar todos los espaciados gigantes de Bootstrap */
            .hoja-a4 .mb-5 {
                margin-bottom: 0.5rem !important;
            }

            .hoja-a4 .mb-4 {
                margin-bottom: 0.25rem !important;
            }

            .hoja-a4 .pb-4 {
                padding-bottom: 0.25rem !important;
            }

            .hoja-a4 .mt-4 {
                margin-top: 0.25rem !important;
            }

            .hoja-a4 .mt-5 {
                margin-top: 0.5rem !important;
            }

            .hoja-a4 .pt-4 {
                padding-top: 0.25rem !important;
            }

            /* 5. Comprimir cuadro de totales (Eliminamos el espacio entre subtotal, IVA, etc) */
            .hoja-a4 .p-4 {
                padding: 0.5rem !important;
            }

            .hoja-a4 .mb-2 {
                margin-bottom: 0 !important;
            }

            .hoja-a4 .pb-2 {
                padding-bottom: 2px !important;
            }

            .hoja-a4 .fs-2 {
                font-size: 1.1rem !important;
            }
            /* Total final no tan gigante */

            /* 6. Evitar cortes feos: Que las filas y el cuadro de totales no se partan al medio */
            tr {
                page-break-inside: avoid;
                break-inside: avoid;
            }

            .d-flex.justify-content-end {
                page-break-inside: avoid;
                break-inside: avoid;
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
                        <p class="small text-muted mt-2 mb-0">
                            CUIT: 30-12345678-9<br />
                            Villa Ballester, San Martín<br />
                            Buenos Aires, Argentina
                        </p>
                    </div>
                    <div class="col-sm-6 text-sm-end mt-4 mt-sm-0">
                        <h3 class="text-proveedor fw-bold text-uppercase mb-1">Orden de Pedido</h3>
                        <h4 class="text-dark fw-bold mb-3">N°
                            <asp:Label ID="lblNumeroPedido" runat="server"></asp:Label></h4>
                        <p class="mb-1 fw-medium text-secondary">
                            Fecha Emisión:
                            <asp:Label ID="lblFecha" runat="server" CssClass="text-dark"></asp:Label>
                        </p>
                        <p class="mb-0 fw-medium text-secondary">
                            Estado:
                            <asp:Label ID="lblEstado" runat="server" CssClass="badge bg-light text-dark border"></asp:Label>
                        </p>
                    </div>
                </div>

                <div class="row mb-5">
                    <div class="col-sm-6">
                        <h6 class="text-uppercase text-muted fw-bold mb-2 small">Emitido a:</h6>
                        <div class="bg-light p-3 rounded-3 border">
                            <h5 class="fw-bold text-dark mb-1">
                                <asp:Label ID="lblProveedorNombre" runat="server"></asp:Label></h5>
                        </div>
                    </div>
                    <div class="col-sm-6 mt-4 mt-sm-0">
                        <h6 class="text-uppercase text-muted fw-bold mb-2 small">Generado por:</h6>
                        <div class="p-3">
                            <p class="mb-1 fw-medium text-dark">
                                <asp:Label ID="lblUsuario" runat="server"></asp:Label>
                            </p>
                            <p class="mb-0 small text-muted">Departamento de Compras</p>
                        </div>
                    </div>
                </div>

                <div class="table-responsive mb-4">
                    <table class="table table-comprobante table-borderless align-middle">
                        <thead>
                            <tr>
                                <th style="width: 10%">Cod.</th>
                                <th style="width: 40%">Descripción del Producto</th>
                                <th class="text-center" style="width: 10%">Cant.</th>
                                <th class="text-center" style="width: 10%">Packs</th>
                                <th class="text-end text-nowrap" style="width: 15%">Costo Unit.</th>
                                <th class="text-end text-nowrap" style="width: 15%">Subtotal</th>
                            </tr>
                        </thead>
                        <tbody class="border-bottom">
                            <asp:Repeater ID="repDetalles" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td class="fw-bold text-muted small"><%# Eval("Producto.Codigo") %></td>
                                        <td class="fw-medium text-dark"><%# Eval("Producto.Descripcion") %></td>
                                        <td class="text-center fw-bold"><%# Eval("Cantidad") %></td>
                                        <td class="text-center fw-bold text-proveedor">
                                            <%# CalcularPacks(Eval("Cantidad"), Eval("Producto.UnidadesPorPack")) %>
                                        </td>
                                        <td class="text-end text-muted text-nowrap"><%# Eval("PrecioUnitario", "{0:C}") %></td>
                                        <td class="text-end fw-bold text-dark text-nowrap"><%# Eval("Subtotal", "{0:C}") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>

                <div class="d-flex justify-content-end mb-4">
                    <div class="p-4 bg-light rounded-3 border border-proveedor border-opacity-25" style="min-width: 320px;">

                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted fw-medium small text-uppercase">Subtotal Bruto</span>
                            <asp:Label ID="lblSubtotalBruto" runat="server" CssClass="fw-bold text-dark"></asp:Label>
                        </div>

                        <div id="divDescuento" runat="server" class="d-flex justify-content-between mb-2 text-danger">
                            <span class="fw-medium small text-uppercase">Descuento (<asp:Label ID="lblPorcDescuento" runat="server"></asp:Label>%)</span>
                            <asp:Label ID="lblDescuento" runat="server" CssClass="fw-bold"></asp:Label>
                        </div>

                        <div class="d-flex justify-content-between mb-2 pb-2 border-bottom border-secondary border-opacity-25">
                            <span class="text-muted fw-bold small text-uppercase">Neto Gravado</span>
                            <asp:Label ID="lblSubtotalNeto" runat="server" CssClass="fw-bold text-dark"></asp:Label>
                        </div>

                        <div id="divIva" runat="server" class="d-flex justify-content-between mb-2">
                            <span class="text-muted fw-medium small text-uppercase">IVA</span>
                            <asp:Label ID="lblIva" runat="server" CssClass="fw-bold text-secondary"></asp:Label>
                        </div>

                        <div id="divIibb" runat="server" class="d-flex justify-content-between mb-2">
                            <span class="text-muted fw-medium small text-uppercase">Ingresos Brutos</span>
                            <asp:Label ID="lblIibb" runat="server" CssClass="fw-bold text-secondary"></asp:Label>
                        </div>

                        <div id="divPercepcion" runat="server" class="d-flex justify-content-between mb-2 pb-2 border-bottom border-secondary border-opacity-25">
                            <span class="text-muted fw-medium small text-uppercase">Percepción</span>
                            <asp:Label ID="lblPercepcion" runat="server" CssClass="fw-bold text-secondary"></asp:Label>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mt-3">
                            <h6 class="text-uppercase text-muted fw-bold mb-0">Total Estimado</h6>
                            <h3 class="fw-bold text-proveedor mb-0">
                                <asp:Label ID="lblTotal" runat="server"></asp:Label></h3>
                        </div>

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
