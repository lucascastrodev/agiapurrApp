<%@ Page Title="Detalle de Venta" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="VentaDetalle.aspx.cs" Inherits="TPC_Equipo20B.VentaDetalle" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        function imprimirComprobante(nombreArchivo) {
            if (nombreArchivo && nombreArchivo.trim() !== "") {
                document.title = nombreArchivo;
            }
            window.print();
            return false;
        }
    </script>

    <style type="text/css">
        /* --- ESTILOS EXCLUSIVOS PARA IMPRESIÓN (ULTRA COMPACTO PARA HASTA 40 ÍTEMS) --- */
        @media print {
            @page {
                size: A4 portrait;
                margin: 5mm;
            }

            .navbar, .btn-cerrar, .btn-imprimir, .btn-enviar-mail, footer, .no-print {
                display: none !important;
            }

            body {
                background: #ffffff !important;
                color: #000 !important;
                overflow: hidden !important;
            }

            .card-remito {
                box-shadow: none !important;
                border: 1px solid #000 !important;
                width: 100% !important;
                margin: 0 !important;
                page-break-inside: avoid;
            }

            .card-header {
                padding: 4px 10px !important;
                border-bottom: 1px solid #000 !important;
                background-color: #f0f0f0 !important;
                color: #000 !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }

                .card-header h4 {
                    font-size: 13px !important;
                    margin: 0 !important;
                    font-weight: bold;
                }

            .card-body {
                padding: 4px !important;
            }

            .info-label {
                font-size: 8px !important;
                color: #444 !important;
                margin-bottom: 0 !important;
                text-transform: uppercase;
            }

            .info-data {
                font-size: 10px !important;
                font-weight: bold !important;
                margin-bottom: 2px !important;
                line-height: 1 !important;
            }

            .row.bg-light {
                background-color: #fff !important;
                border: 1px solid #888 !important;
                padding: 4px !important;
                margin-bottom: 4px !important;
                border-radius: 0 !important;
            }

            h6.text-muted {
                font-size: 9px !important;
                color: #000 !important;
                margin-bottom: 1px !important;
                padding-bottom: 1px !important;
                border-bottom: 1px solid #ccc !important;
            }

            .table-responsive {
                border: 1px solid #000 !important;
                border-radius: 0 !important;
            }

            /* Ajuste milimétrico para que entren 40 filas en A4 */
            #MainContent_gvLineas th {
                padding: 2px !important;
                font-size: 10px !important;
                border-bottom: 1px solid #000 !important;
            }

            #MainContent_gvLineas td {
                padding: 1px 2px !important;
                font-size: 10px !important;
                border-bottom: 1px solid #ccc !important;
                line-height: 1.1 !important;
            }

            .table-primary {
                background-color: #e5e5e5 !important;
                color: #000 !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }

            .card-footer {
                padding: 4px 10px !important;
                border-top: none !important;
                background: transparent !important;
                display: flex !important;
                justify-content: flex-end !important;
            }

            .total-container {
                border: none !important;
                width: auto !important;
                text-align: right !important;
                padding-top: 0 !important;
            }

            .card-footer h4 {
                font-size: 14px !important;
                margin: 0 !important;
            }

            .fs-4, .fs-5 {
                font-size: 11px !important;
            }

            .fs-6 {
                font-size: 10px !important;
            }

            .check-box {
                width: 10px !important;
                height: 10px !important;
                border: 1px solid #000 !important;
                margin-top: 2px;
            }

            .editable-field[contenteditable="true"] {
                border: none !important;
                background-color: transparent !important;
                padding: 0 !important;
            }
        }

        /* --- ESTILOS EN PANTALLA --- */
        .card-remito {
            width: 850px !important;
            max-width: 100% !important;
            margin: auto;
        }

        .check-box {
            display: inline-block;
            width: 14px;
            height: 14px;
            border: 1.5px solid #000;
            margin-right: 2px;
            vertical-align: middle;
            background-color: white;
        }

        .info-label {
            font-size: 0.85rem;
            color: #555;
            margin-bottom: 1px;
        }

        .info-data {
            font-weight: 600;
            font-size: 1rem;
            margin-bottom: 6px;
            color: #222;
            line-height: 1.2;
        }

        #MainContent_gvLineas {
            width: 100% !important;
            margin-bottom: 0 !important;
        }

            #MainContent_gvLineas th, #MainContent_gvLineas td {
                text-align: center !important;
                vertical-align: middle !important;
            }

                #MainContent_gvLineas th:nth-child(3), #MainContent_gvLineas td:nth-child(3) {
                    text-align: left !important;
                    width: 45% !important;
                }

        .total-container {
            text-align: right;
            width: auto;
            border: none !important;
        }

        .editable-field[contenteditable="true"] {
            border-bottom: 1px dashed #11d452;
            cursor: text;
            outline: none;
            min-height: 1.5rem;
            transition: background-color 0.2s;
            padding: 2px 4px;
            margin-left: -4px;
            border-radius: 4px;
        }

            .editable-field[contenteditable="true"]:hover,
            .editable-field[contenteditable="true"]:focus {
                background-color: #f0fff4;
            }
    </style>

    <div class="py-3">
        <div class="card shadow-sm border-0 card-remito">

            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <h4 class="mb-0 fs-6 fw-bold">
                    <i class="bi bi-receipt me-2"></i>Remito de Pedido
                </h4>

                <div class="d-flex gap-2 no-print">
                    <asp:Button ID="btnEnviarMail" runat="server" CssClass="btn btn-warning btn-sm fw-bold btn-enviar-mail" Text="Reenviar mail" OnClick="btnEnviarMail_Click" />
                    <asp:Button ID="btnImprimir" runat="server" CssClass="btn btn-light btn-sm fw-bold btn-imprimir" Text="Imprimir / PDF" UseSubmitBehavior="false" OnClientClick="return imprimirComprobante('<%= NombreComprobante %>');" />
                    <asp:Button ID="btnCerrar" runat="server" Text="✖" CssClass="btn btn-light btn-sm fw-bold btn-cerrar" OnClick="btnCerrar_Click" />
                </div>
            </div>

            <div runat="server" id="panelCancelada" visible="false" class="alert alert-danger fw-bold m-0 border-bottom border-danger rounded-0 px-3 py-1" style="font-size: 0.9rem;">
                <i class="bi bi-x-circle me-1"></i>ESTA VENTA ESTÁ CANCELADA.<br />
                <span class="fw-normal" style="font-size: 0.8rem;">Motivo:
                    <asp:Label ID="lblMotivo" runat="server" />
                    | NC:
                    <asp:Label ID="lblNC" runat="server" />
                    | Por:
                    <asp:Label ID="lblUsuarioCanc" runat="server" />
                    el
                    <asp:Label ID="lblFechaCanc" runat="server" /></span>
            </div>

            <div class="card-body p-3">
                <div class="row mb-2 border-bottom pb-1">
                    <div class="col-4">
                        <div class="info-label">N° Remito:</div>
                        <div class="info-data text-primary fs-5">
                            <asp:Label ID="lblFactura" runat="server" />
                        </div>
                    </div>
                    <div class="col-4 text-center">
                        <div class="info-label">Fecha:</div>
                        <div class="info-data">
                            <asp:Label ID="lblFecha" runat="server" />
                        </div>
                    </div>
                    <div class="col-4 text-end">
                        <div class="info-label">Método de Pago:</div>
                        <div class="info-data">
                            <asp:Label ID="lblMetodoPago" runat="server" />
                        </div>
                    </div>
                </div>

                <div class="row mb-2 bg-light p-2 border mx-0" style="border-radius: 4px;">
                    <div class="col-6 mb-0 border-end border-secondary">
                        <h6 class="fw-bold text-muted text-uppercase mb-1">Datos del Cliente</h6>
                        <div class="info-label mt-1">Nombre / Razón Social:</div>
                        <div class="info-data fs-6">
                            <asp:Label ID="lblCliente" runat="server" /></div>
                        <div class="info-label">Teléfono:</div>
                        <div class="info-data">
                            <asp:Label ID="lblTelefono" runat="server" /></div>
                    </div>

                    <div class="col-6 mb-0 ps-2">
                        <h6 class="fw-bold text-muted text-uppercase mb-1">Información de Envío</h6>
                        <div class="info-label mt-1">Dirección y Localidad:</div>
                        <div class="info-data">
                            <asp:Label ID="lblDireccion" runat="server" /></div>

                        <div class="info-label d-flex align-items-center gap-1">
                            Entre Calles / Obs: 
                            <asp:Label ID="iconoEdicion" runat="server" CssClass="text-success no-print" Visible="false" ToolTip="Hacé clic en el texto de abajo para agregar notas antes de imprimir." Style="cursor: help;">
                                <i class="bi bi-pencil-square" style="font-size: 0.8rem;"></i>
                            </asp:Label>
                        </div>
                        <div class="info-data">
                            <asp:Label ID="lblObservacionesCliente" runat="server" CssClass="editable-field d-inline-block w-100" />
                        </div>
                    </div>
                </div>

                <div class="table-responsive border border-dark border-bottom-0">
                    <asp:GridView ID="gvLineas" runat="server" AutoGenerateColumns="False"
                        CssClass="table table-sm table-striped align-middle mb-0 border-0">
                        <HeaderStyle CssClass="table-primary border-bottom border-dark" />
                        <Columns>
                            <asp:TemplateField HeaderText="Ctrl" ItemStyle-Width="40px" ItemStyle-CssClass="text-center no-print-bg">
                                <ItemTemplate>
                                    <div class="check-box"></div>
                                    <div class="check-box"></div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="Cantidad" HeaderText="Cant" DataFormatString="{0:N2}" ItemStyle-Width="60px" ItemStyle-CssClass="text-center fw-bold text-dark" />

                            <asp:TemplateField HeaderText="Producto" ItemStyle-CssClass="text-start fw-bold">
                                <ItemTemplate>
                                    <%# Eval("Producto.Descripcion") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="PrecioUnitario" HeaderText="Precio" DataFormatString="{0:C}" ItemStyle-Width="100px" ItemStyle-CssClass="text-end text-muted" />
                            <asp:BoundField DataField="Subtotal" HeaderText="Subtotal" DataFormatString="{0:C}" ItemStyle-Width="120px" ItemStyle-CssClass="text-end fw-bold text-dark pe-2" HeaderStyle-CssClass="pe-2" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <div class="card-footer d-flex justify-content-end bg-white pt-2 pb-3 px-3 border-0">
                <div class="total-container pe-1">
                    <h4 class="fw-bold mb-0 text-success d-flex justify-content-between gap-3">
                        <span class="text-dark">Total:</span>
                        <asp:Label ID="lblTotal" runat="server" />
                    </h4>
                </div>
            </div>

        </div>
    </div>

</asp:Content>
