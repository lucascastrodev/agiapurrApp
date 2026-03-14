<%@ Page Title="Detalle de Compra" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="CompraDetalle.aspx.cs" Inherits="TPC_Equipo20B.CompraDetalle" %>

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
        /* --- ESTILOS EXCLUSIVOS PARA IMPRESIÓN DINÁMICA ESTRICTA (50 ÍTEMS) --- */
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

            .navbar, .btn-cerrar, .btn-imprimir, footer, .no-print {
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

            /* CABECERA Y DATOS COMPACTOS PARA DEJAR ESPACIO A LOS 50 ÍTEMS */
            .card-header {
                padding: 4px 10px !important;
                border-bottom: 2px solid #000 !important;
                background-color: #f0f0f0 !important;
                color: #000 !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }

                .card-header h4 {
                    font-size: 16px !important;
                    margin: 0 !important;
                    font-weight: bold;
                }

            .info-section {
                flex-shrink: 0;
                padding: 4px 10px 2px 10px !important;
            }

            .info-label {
                font-size: 9px !important;
                color: #444 !important;
                margin-bottom: 0 !important;
                text-transform: uppercase;
            }

            .info-data {
                font-size: 12px !important;
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
                font-size: 11px !important;
                color: #000 !important;
                font-weight: bold !important;
                margin-bottom: 1px !important;
                padding-bottom: 1px !important;
                border-bottom: 1px solid #ccc !important;
            }

            /* TABLA ELÁSTICA */
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

            .table-success {
                background-color: #e5e5e5 !important;
                color: #000 !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }

            /* CELDAS SÚPER COMPACTAS PARA 50 ÍTEMS */
            #MainContent_gvLineas th {
                padding: 2px !important;
                font-size: 11px !important;
                border-bottom: 2px solid #000 !important;
            }

            #MainContent_gvLineas td {
                padding: 1px 2px !important;
                font-size: 11px !important;
                border-bottom: 1px solid #ccc !important;
                line-height: 1 !important;
                color: #000 !important;
                font-weight: bold !important;
            }

            /* PIE DE PÁGINA */
            .card-footer {
                padding: 4px 10px !important;
                border-top: none !important;
                background: transparent !important;
                display: flex !important;
                justify-content: flex-end !important;
                align-items: flex-end;
            }

            .total-container {
                border: none !important;
                width: auto !important;
                text-align: right !important;
                padding-top: 0 !important;
            }

            .card-footer h4 {
                font-size: 16px !important;
                margin: 0 !important;
            }

            .check-box {
                display: inline-block !important;
                width: 12px !important;
                height: 12px !important;
                border: 1.5px solid #000 !important;
                margin: 0 2px !important;
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
    </style>

    <div class="py-3">
        <div class="card shadow-sm border-0 card-remito print-wrapper">

            <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                <h4 class="mb-0 fs-6 fw-bold">
                    <i class="bi bi-box-seam me-2"></i>Comprobante de Ingreso
                </h4>

                <div class="d-flex gap-2 no-print">
                    <asp:Button ID="btnImprimir" runat="server" CssClass="btn btn-light btn-sm fw-bold btn-imprimir" Text="Imprimir / PDF" UseSubmitBehavior="false" OnClientClick="return imprimirComprobante('<%= NombreComprobante %>');" />
                    <asp:Button ID="btnCerrar" runat="server" Text="✖" CssClass="btn btn-light btn-sm fw-bold btn-cerrar" OnClick="btnCerrar_Click" />
                </div>
            </div>

            <div runat="server" id="panelCancelada" visible="false" class="alert alert-danger fw-bold m-0 border-bottom border-danger rounded-0 px-3 py-1" style="font-size: 0.9rem;">
                <i class="bi bi-x-circle me-1"></i>ESTA COMPRA ESTÁ CANCELADA.<br />
                <span class="fw-normal" style="font-size: 0.8rem;">Motivo:
                    <asp:Label ID="lblMotivo" runat="server" />
                    | Por:
                    <asp:Label ID="lblUsuarioCanc" runat="server" />
                    el
                    <asp:Label ID="lblFechaCanc" runat="server" /></span>
            </div>

            <div class="card-body info-section p-3">
                <div class="row mb-2 border-bottom pb-1">
                    <div class="col-4">
                        <div class="info-label">N° Ingreso (ID):</div>
                        <div class="info-data text-success fs-5">
                            <asp:Label ID="lblCompraId" runat="server" />
                        </div>
                    </div>
                    <div class="col-4 text-center">
                        <div class="info-label">Fecha:</div>
                        <div class="info-data">
                            <asp:Label ID="lblFecha" runat="server" />
                        </div>
                    </div>
                    <div class="col-4 text-end">
                        <div class="info-label">Registrado por:</div>
                        <div class="info-data">
                            <asp:Label ID="lblUsuario" runat="server" />
                        </div>
                    </div>
                </div>

                <div class="row mb-2 bg-light p-2 border mx-0" style="border-radius: 4px;">
                    <div class="col-6 mb-0 border-end border-secondary">
                        <h6 class="fw-bold text-muted text-uppercase mb-1">Datos del Proveedor</h6>
                        <div class="info-label mt-1">Nombre / Razón Social:</div>
                        <div class="info-data fs-6">
                            <asp:Label ID="lblProveedor" runat="server" />
                        </div>
                    </div>

                    <div class="col-6 mb-0 ps-2">
                        <h6 class="fw-bold text-muted text-uppercase mb-1">Información Adicional</h6>
                        <div class="info-label mt-1">Observaciones / N° Factura Asoc:</div>
                        <div class="info-data">
                            <asp:Label ID="lblObservaciones" runat="server" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="table-responsive border-0">
                <asp:GridView ID="gvLineas" runat="server" AutoGenerateColumns="False"
                    CssClass="table table-sm table-striped align-middle mb-0 border-0">
                    <HeaderStyle CssClass="table-success border-bottom border-dark" />
                    <Columns>
                        <asp:TemplateField HeaderText="Ctrl" ItemStyle-Width="55px" ItemStyle-CssClass="text-center no-print-bg">
                            <ItemTemplate>
                                <div style="display: flex; justify-content: center; gap: 4px;">
                                    <div class="check-box"></div>
                                    <div class="check-box"></div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="Cantidad" HeaderText="Cant" DataFormatString="{0:N2}" ItemStyle-Width="60px" ItemStyle-CssClass="text-center fw-bold text-dark" />

                        <asp:TemplateField HeaderText="Producto" ItemStyle-CssClass="text-start fw-bold">
                            <ItemTemplate>
                                <%# Eval("Producto.Descripcion") %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="PrecioUnitario" HeaderText="Costo Unit." DataFormatString="{0:C}" ItemStyle-Width="100px" ItemStyle-CssClass="text-end text-muted" />
                        <asp:BoundField DataField="Subtotal" HeaderText="Subtotal" DataFormatString="{0:C}" ItemStyle-Width="120px" ItemStyle-CssClass="text-end fw-bold text-dark pe-2" HeaderStyle-CssClass="pe-2" />
                    </Columns>
                </asp:GridView>
            </div>

            <div class="card-footer d-flex justify-content-end bg-white pt-2 pb-3 px-3 border-0">
                <div class="total-container pe-1">
                    <h4 class="fw-bold mb-0 text-success d-flex justify-content-between gap-3">
                        <span class="text-dark">Costo Total:</span>
                        <asp:Label ID="lblTotal" runat="server" />
                    </h4>
                </div>
            </div>

        </div>
    </div>
</asp:Content>
