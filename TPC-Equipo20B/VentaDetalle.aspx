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
        /* --- ESTILOS EXCLUSIVOS PARA IMPRESIÓN DINÁMICA ESTRICTA --- */
        @media print {
            @page {
                size: A4 portrait;
                margin: 0; /* ELIMINA URL Y FECHA DEL NAVEGADOR */
            }

            /* MATA LA HOJA EN BLANCO Y EMPUJA EL CONTENIDO AL RAS DEL TECHO */
            html, body {
                background: #ffffff !important;
                color: #000 !important;
                margin: 0 !important;
                padding: 2mm 5mm 0 5mm !important; /* 2mm DEL BORDE SUPERIOR */
                width: 100% !important;
                height: 100vh !important; /* ALTURA ESTRICTA DE 1 SOLA CARILLA */
                max-height: 297mm !important;
                box-sizing: border-box !important;
                overflow: hidden !important; /* CORTA CUALQUIER INTENTO DE PÁGINA 2 */
            }

            /* Resetea contenedores maestros del sitio */
            form, main, .container, .container-fluid, .py-3 {
                margin: 0 !important;
                padding: 0 !important;
                height: 100% !important;
                width: 100% !important;
                box-sizing: border-box !important;
            }

            .navbar, .btn-cerrar, .btn-imprimir, .btn-enviar-mail, footer, .no-print {
                display: none !important;
            }

            /* BORDE CUADRADO TIPO FACTURA REAL (REEMPLAZA LA TARJETA GRIS) */
            .print-wrapper {
                border: 2px solid #000 !important;
                border-radius: 0 !important;
                box-shadow: none !important;
                margin: 0 !important;
                padding: 0 !important;
                width: 100% !important;
                height: 99% !important; /* ESTIRA EL RECUADRO HASTA ABAJO DE LA HOJA */
                display: flex;
                flex-direction: column;
                box-sizing: border-box !important;
            }

            .info-section {
                flex-shrink: 0; /* Impide que la cabecera se achique */
            }

            .table-responsive {
                border-top: 2px solid #000 !important;
                border-bottom: 2px solid #000 !important;
                border-radius: 0 !important;
                flex-grow: 1; /* HACE QUE LA TABLA RELLENE TODO EL ESPACIO SOBRANTE */
                margin-bottom: 0 !important;
            }

            .table {
                margin-bottom: 0 !important;
                width: 100% !important;
            }

            .table-primary {
                background-color: #e5e5e5 !important;
                color: #000 !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }

            .total-container {
                border: none !important;
                width: auto !important;
                text-align: right !important;
                padding-top: 0 !important;
            }

            .editable-field[contenteditable="true"] {
                border: none !important;
                background-color: transparent !important;
                padding: 0 !important;
            }

            /* ==================================================== */
            /* MODO 1: CONSUMIDOR FINAL (LETRA GIGANTE - 25 ÍTEMS)  */
            /* ==================================================== */
            .print-mode-cf .card-header {
                padding: 6px 10px !important;
                border-bottom: 2px solid #000 !important;
            }

                .print-mode-cf .card-header h4 {
                    font-size: 24px !important;
                    margin: 0 !important;
                    font-weight: bold;
                }

            .print-mode-cf .info-section {
                padding: 8px 12px 2px 12px !important;
            }

            .print-mode-cf .info-label {
                font-size: 12px !important;
                color: #444 !important;
                margin-bottom: 0 !important;
                text-transform: uppercase;
            }

            .print-mode-cf .info-data {
                font-size: 16px !important;
                font-weight: bold !important;
                margin-bottom: 4px !important;
                line-height: 1 !important;
            }

            .print-mode-cf .row.bg-light {
                background-color: #fff !important;
                border: 1px solid #888 !important;
                padding: 6px !important;
                margin-bottom: 6px !important;
                border-radius: 0 !important;
            }

            .print-mode-cf h6.text-muted {
                font-size: 14px !important;
                color: #000 !important;
                font-weight: bold !important;
                margin-bottom: 4px !important;
                padding-bottom: 2px !important;
                border-bottom: 1px solid #ccc !important;
            }

            .print-mode-cf #MainContent_gvLineas th {
                padding: 6px 4px !important;
                font-size: 16px !important;
                border-bottom: 2px solid #000 !important;
            }

            .print-mode-cf #MainContent_gvLineas td {
                padding: 6px 4px !important;
                font-size: 16px !important;
                border-bottom: 1px solid #ccc !important;
                line-height: 1.1 !important;
                color: #000 !important;
                font-weight: bold !important;
            }

            .print-mode-cf .card-footer {
                padding: 8px 12px !important;
                border-top: none !important;
                background: transparent !important;
                display: flex !important;
                justify-content: flex-end !important;
            }

                .print-mode-cf .card-footer h4 {
                    font-size: 24px !important;
                    margin: 0 !important;
                }

            .print-mode-cf .check-box {
                display: inline-block !important;
                width: 18px !important;
                height: 18px !important;
                border: 2px solid #000 !important;
                margin: 0 4px !important;
            }

            .print-mode-cf .texto-descuento {
                font-size: 16px !important;
            }

            /* ==================================================== */
            /* MODO 2: MAYORISTA (LETRA GRANDE, COMPACTA - 40 ÍTEMS)*/
            /* ==================================================== */
            .print-mode-mayorista .card-header {
                padding: 4px 10px !important;
                border-bottom: 2px solid #000 !important;
            }

                .print-mode-mayorista .card-header h4 {
                    font-size: 18px !important;
                    margin: 0 !important;
                    font-weight: bold;
                }

            .print-mode-mayorista .info-section {
                padding: 4px 10px 2px 10px !important;
            }

            .print-mode-mayorista .info-label {
                font-size: 10px !important;
                color: #444 !important;
                margin-bottom: 0 !important;
                text-transform: uppercase;
            }

            .print-mode-mayorista .info-data {
                font-size: 14px !important;
                font-weight: bold !important;
                margin-bottom: 2px !important;
                line-height: 1 !important;
            }

            .print-mode-mayorista .row.bg-light {
                background-color: #fff !important;
                border: 1px solid #888 !important;
                padding: 4px !important;
                margin-bottom: 4px !important;
                border-radius: 0 !important;
            }

            .print-mode-mayorista h6.text-muted {
                font-size: 12px !important;
                color: #000 !important;
                font-weight: bold !important;
                margin-bottom: 2px !important;
                padding-bottom: 1px !important;
                border-bottom: 1px solid #ccc !important;
            }

            /* ESTA LÍNEA ES LA MAGIA MAYORISTA: ELIMINA RELLENOS PERO AGRANDA LETRA A 14px */
            .print-mode-mayorista #MainContent_gvLineas th {
                padding: 2px !important;
                font-size: 14px !important;
                border-bottom: 2px solid #000 !important;
            }

            .print-mode-mayorista #MainContent_gvLineas td {
                padding: 1px 2px !important;
                font-size: 14px !important;
                border-bottom: 1px solid #ccc !important;
                line-height: 1 !important;
                color: #000 !important;
                font-weight: bold !important;
            }

            .print-mode-mayorista .card-footer {
                padding: 4px 10px !important;
                border-top: none !important;
                background: transparent !important;
                display: flex !important;
                justify-content: flex-end !important;
            }

                .print-mode-mayorista .card-footer h4 {
                    font-size: 18px !important;
                    margin: 0 !important;
                }

            .print-mode-mayorista .check-box {
                display: inline-block !important;
                width: 14px !important;
                height: 14px !important;
                border: 2px solid #000 !important;
                margin: 0 2px !important;
            }

            .print-mode-mayorista .texto-descuento {
                font-size: 14px !important;
            }
        }

        /* --- ESTILOS EN PANTALLA WEB --- */
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

            .editable-field[contenteditable="true"]:hover, .editable-field[contenteditable="true"]:focus {
                background-color: #f0fff4;
            }

        .texto-descuento {
            font-size: 14px;
        }
    </style>

    <div id="printContainer" runat="server" class="print-mode-cf">

        <div class="card shadow-sm card-remito print-wrapper">

            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <h4 class="mb-0 fs-6 fw-bold">
                    <i class="bi bi-receipt me-2"></i>Orden de Pedido
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
                    <asp:Label ID="lblFechaCanc" runat="server" />
                </span>
            </div>

            <div class="card-body info-section p-3">
                <div class="row mb-2 border-bottom pb-1">
                    <div class="col-4">
                        <div class="info-label">Orden de Pedido:</div>
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
                            <asp:Label ID="lblCliente" runat="server" />
                        </div>
                        <div class="info-label">Teléfono:</div>
                        <div class="info-data">
                            <asp:Label ID="lblTelefono" runat="server" />
                        </div>
                    </div>

                    <div class="col-6 mb-0 ps-2">
                        <h6 class="fw-bold text-muted text-uppercase mb-1">Información de Envío</h6>
                        <div class="info-label mt-1">Dirección y Localidad:</div>
                        <div class="info-data">
                            <asp:Label ID="lblDireccion" runat="server" />
                        </div>

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
            </div>

            <div class="table-responsive border-0">
                <asp:GridView ID="gvLineas" runat="server" AutoGenerateColumns="False"
                    CssClass="table table-sm table-striped align-middle mb-0 border-0">
                    <headerstyle cssclass="table-primary border-bottom border-dark" />
                    <columns>
                        <asp:TemplateField HeaderText="Ctrl" ItemStyle-Width="60px" ItemStyle-CssClass="text-center no-print-bg">
                            <itemtemplate>
                                <div style="display: flex; justify-content: center; gap: 4px;">
                                    <div class="check-box"></div>
                                    <div class="check-box"></div>
                                </div>
                            </itemtemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="Cantidad" HeaderText="Cant" DataFormatString="{0:N0}" ItemStyle-Width="60px" ItemStyle-CssClass="text-center fw-bold text-dark" />

                        <asp:TemplateField HeaderText="Producto" ItemStyle-CssClass="text-start fw-bold">
                            <itemtemplate>
                                <%# Eval("Producto.Descripcion") %>
                            </itemtemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="PrecioUnitario" HeaderText="Precio" DataFormatString="{0:C}" ItemStyle-Width="100px" ItemStyle-CssClass="text-end text-muted" />
                        <asp:BoundField DataField="Subtotal" HeaderText="Subtotal" DataFormatString="{0:C}" ItemStyle-Width="120px" ItemStyle-CssClass="text-end fw-bold text-dark pe-2" HeaderStyle-CssClass="pe-2" />
                    </columns>
                </asp:GridView>
            </div>

            <div class="card-footer d-flex justify-content-end bg-white pt-2 pb-3 px-3 border-0">
                <div class="total-container pe-1" style="min-width: 250px;">

                    <div class="d-flex justify-content-between mb-1 texto-descuento" id="divSubtotal" runat="server">
                        <span class="text-muted fw-bold" style="margin-right: 25px;">Subtotal:</span>
                        <asp:Label ID="lblSubtotal" runat="server" CssClass="fw-bold text-dark" />
                    </div>

                    <div class="d-flex justify-content-between mb-2 text-danger texto-descuento" id="divDescuento" runat="server">
                        <span class="fw-bold" style="margin-right: 25px;" id="lblTextoDescuento" runat="server">Descuento:</span>
                        <asp:Label ID="lblDescuento" runat="server" CssClass="fw-bold" />
                    </div>

                    <h4 class="fw-bold mb-0 text-success d-flex justify-content-between border-top pt-2 mt-1">
                        <span class="text-dark">Total:</span>
                        <asp:Label ID="lblTotal" runat="server" />
                    </h4>

                </div>
            </div>

        </div>
    </div>

</asp:Content>
