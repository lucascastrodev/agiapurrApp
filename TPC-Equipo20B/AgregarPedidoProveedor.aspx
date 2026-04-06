<%@ Page Title="Generar Pedido a Proveedor" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AgregarPedidoProveedor.aspx.cs" Inherits="TPC_Equipo20B.AgregarPedidoProveedor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />

    <style>
        .validator {
            color: #dc3545;
            font-size: 0.85em;
            display: block;
            margin-top: 0.3rem;
            font-weight: 500;
        }

        .error-flotante {
            position: absolute;
            font-size: 0.80em;
            margin-top: 2px;
            color: #dc3545;
            font-weight: 500;
        }

        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            user-select: none;
            font-size: 20px;
        }

        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.3rem;
        }

        /* --- TEMA PROVEEDORES (ÍNDIGO/VIOLETA) --- */
        .form-control:focus, .form-select:focus {
            border-color: #6610f2;
            box-shadow: 0 0 0 0.25rem rgba(102, 16, 242, 0.25);
        }

        .btn-proveedor-custom {
            background-color: #6610f2;
            border-color: #6610f2;
            color: #ffffff;
            font-weight: 700;
        }

            .btn-proveedor-custom:hover {
                background-color: #520dc2;
                border-color: #520dc2;
                color: #ffffff;
            }

        .text-proveedor {
            color: #6610f2 !important;
        }

        .border-proveedor {
            border-color: #6610f2 !important;
        }

        .sin-flechas::-webkit-outer-spin-button, .sin-flechas::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        .grid-container {
            border: 1px solid #e9ecef;
            border-radius: 12px;
            background-color: #fff;
            max-height: 380px;
            overflow-y: auto;
        }

        .table thead th {
            position: sticky;
            top: 0;
            background-color: #f8f9fa !important;
            z-index: 10;
            box-shadow: 0 1px 0 #dee2e6;
            font-weight: 600;
            color: #495057;
            text-transform: uppercase;
            font-size: 0.85rem;
            padding-top: 12px;
            padding-bottom: 12px;
        }

        .table td {
            vertical-align: middle;
            color: #212529;
        }

        input[type="date"]::-webkit-calendar-picker-indicator {
            cursor: pointer;
            opacity: 0.6;
            transition: 0.2s;
        }

            input[type="date"]::-webkit-calendar-picker-indicator:hover {
                opacity: 1;
            }
    </style>

    <div class="container-fluid py-4 max-w-1200" style="max-width: 1400px;">

        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 border-bottom pb-3 gap-3">
            <div>
                <h2 id="lblTituloPagina" runat="server" class="fw-bold text-dark m-0 d-flex align-items-center gap-2">
                    <span class="material-symbols-outlined text-proveedor fs-2">local_shipping</span> Armar Pedido a Proveedor
                </h2>
                <p id="lblSubtituloPagina" runat="server" class="text-muted m-0 mt-1">Seleccione la empresa y solicite los productos con su código específico</p>
            </div>

            <div class="card shadow-sm border border-proveedor border-opacity-25 bg-white rounded-3 px-3 py-2">
                <div class="d-flex align-items-center gap-2">
                    <span class="material-symbols-outlined text-proveedor">calendar_month</span>
                    <label for="txtFecha" class="fw-bold m-0 text-secondary small text-uppercase">Fecha Emisión:</label>
                    <asp:TextBox ID="txtFecha" runat="server" TextMode="Date" CssClass="form-control form-control-sm text-center fw-bold p-0 text-dark fs-6" Style="width: 125px; outline: none; box-shadow: none;" />
                </div>
            </div>
        </div>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-4 p-md-5 pb-3">

                <div class="row g-5">

                    <div class="col-lg-5">

                        <h5 class="fw-bold text-muted mb-4 border-bottom pb-2 fs-6 text-uppercase d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined">domain</span> Datos de la Empresa
                        </h5>

                        <div id="divProveedorBox" runat="server" class="mb-4 position-relative">
                            <label for="ddlProveedor" class="form-label">Proveedor *</label>
                            <div class="input-group input-group-lg">
                                <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">factory</span></span>
                                <asp:DropDownList ID="ddlProveedor" runat="server" CssClass="form-select border-start-0 fs-6" AutoPostBack="true" OnSelectedIndexChanged="ddlProveedor_SelectedIndexChanged"></asp:DropDownList>
                            </div>
                            <div style="height: 18px;">
                                <asp:RequiredFieldValidator ID="rfvProveedor" runat="server" ControlToValidate="ddlProveedor" ErrorMessage="Seleccione una empresa" InitialValue="0" ValidationGroup="AgregarLinea" CssClass="error-flotante" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <h5 class="fw-bold text-muted mb-4 border-bottom pb-2 fs-6 text-uppercase d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined">add_shopping_cart</span> Añadir al Pedido
                        </h5>

                        <div class="mb-4 position-relative">
                            <label for="ddlProducto" class="form-label">Producto del Proveedor *</label>
                            <div class="input-group input-group-lg">
                                <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">inventory_2</span></span>
                                <asp:DropDownList ID="ddlProducto" runat="server" CssClass="form-select border-start-0 fs-6" AutoPostBack="true" OnSelectedIndexChanged="ddlProducto_SelectedIndexChanged">
                                    <asp:ListItem Text="-- Seleccione un proveedor primero --" Value="0" />
                                </asp:DropDownList>
                            </div>
                            <div style="height: 18px;">
                                <asp:RequiredFieldValidator ID="rfvProducto" runat="server" ControlToValidate="ddlProducto" ErrorMessage="Seleccione un producto" InitialValue="0" ValidationGroup="AgregarLinea" CssClass="error-flotante" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-6 position-relative">
                                <asp:Label ID="lblLabelCantidad" runat="server" AssociatedControlID="txtCantidad" CssClass="form-label">Cantidad</asp:Label>
                                <div class="input-group input-group-lg">
                                    <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">tag</span></span>
                                    <asp:TextBox ID="txtCantidad" runat="server" CssClass="form-control sin-flechas text-center border-start-0 fw-bold fs-6" TextMode="Number" min="1" step="1" placeholder="0" />
                                </div>
                                <div style="height: 18px;">
                                    <asp:RequiredFieldValidator ID="rfvCantidad" runat="server" ControlToValidate="txtCantidad" ErrorMessage="Requerido" ValidationGroup="AgregarLinea" CssClass="error-flotante" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <asp:CompareValidator ID="cvCantidad" runat="server" ControlToValidate="txtCantidad" ErrorMessage="Mínimo 1" ValueToCompare="0" Operator="GreaterThan" Type="Integer" ValidationGroup="AgregarLinea" CssClass="error-flotante" Display="Dynamic"></asp:CompareValidator>
                                </div>
                            </div>

                            <div class="col-6 position-relative">
                                <label for="txtPrecio" class="form-label">Costo Unitario</label>
                                <div class="input-group input-group-lg">
                                    <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">attach_money</span></span>
                                    <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control bg-light text-center border-start-0 text-muted fs-6" ReadOnly="true" placeholder="0,00" />
                                </div>
                                <div style="height: 18px;"></div>
                            </div>
                        </div>

                        <div class="mb-2">
                            <asp:LinkButton ID="btnAgregarLinea" runat="server" CssClass="btn btn-dark btn-lg w-100 fw-bold shadow-sm d-flex align-items-center justify-content-center gap-2" ValidationGroup="AgregarLinea" OnClick="btnAgregarLinea_Click" CausesValidation="true">
                                <span class="material-symbols-outlined fs-5">playlist_add</span> Agregar al Listado
                            </asp:LinkButton>
                        </div>

                    </div>

                    <div class="col-lg-7 d-flex flex-column">
                        <div class="bg-light p-4 rounded-4 border d-flex flex-column flex-grow-1 shadow-sm">

                            <h5 class="fw-bold text-muted mb-3 fs-6 text-uppercase d-flex align-items-center gap-2">
                                <span class="material-symbols-outlined">receipt_long</span> Resumen de la Orden
                            </h5>

                            <div class="grid-container table-responsive mb-auto border bg-white shadow-sm">
                                <asp:GridView ID="gvLineas" runat="server" AutoGenerateColumns="False"
                                    CssClass="table table-hover align-middle text-center mb-0" OnRowCommand="gvLineas_RowCommand" GridLines="None">
                                    <Columns>
                                        <asp:BoundField DataField="Producto.Codigo" HeaderText="SKU" ItemStyle-CssClass="text-start ps-3 fw-bold text-muted small" HeaderStyle-CssClass="text-start ps-3" />
                                        <asp:BoundField DataField="Producto.Descripcion" HeaderText="Descripción Prov." ItemStyle-CssClass="text-start fw-medium text-dark" HeaderStyle-CssClass="text-start" />
                                        <asp:BoundField DataField="Cantidad" HeaderText="Unidades" ItemStyle-CssClass="fw-bold text-secondary" />

                                        <asp:BoundField DataField="PrecioUnitario" HeaderText="Costo Unit." DataFormatString="{0:C}" ItemStyle-CssClass="text-muted small text-nowrap" />
                                        <asp:BoundField DataField="Subtotal" HeaderText="Subtotal" DataFormatString="{0:C}" ItemStyle-CssClass="fw-bold text-dark text-nowrap" />

                                        <asp:TemplateField>
                                            <ItemStyle Width="60px" CssClass="pe-2" />
                                            <ItemTemplate>
                                                <asp:LinkButton ID="cmdEliminar" runat="server" CommandName="Eliminar" CommandArgument='<%# Container.DataItemIndex %>' CssClass="btn btn-outline-danger btn-sm rounded-3 shadow-sm d-flex align-items-center justify-content-center" CausesValidation="false">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">delete</span>
                                                </asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>

                                    <EmptyDataTemplate>
                                        <div class="p-5 text-muted text-center">
                                            <span class="material-symbols-outlined d-block mb-2 text-proveedor" style="font-size: 3rem; opacity: 0.3;">conveyor_belt</span>
                                            La orden está vacía.
                                            <br />
                                            Seleccione los productos del catálogo del proveedor para comenzar.
                                        </div>
                                    </EmptyDataTemplate>
                                </asp:GridView>
                            </div>

                            <div class="mt-4 p-3 bg-white rounded-3 border shadow-sm border-start border-proveedor border-5">
                                <div class="row text-end gx-3 gy-2" style="max-width: 400px; margin-left: auto;">

                                    <div class="col-12 d-flex justify-content-between align-items-center">
                                        <span class="text-muted fw-medium">Subtotal Bruto:</span>
                                        <asp:Label ID="lblSubtotalBruto" runat="server" CssClass="fw-bold text-dark fs-6">$ 0,00</asp:Label>
                                    </div>

                                    <div class="col-12 d-flex justify-content-between align-items-center text-danger" id="divDescuento" runat="server">
                                        <span class="fw-medium">Descuento (<asp:Label ID="lblPorcDescuento" runat="server">0</asp:Label>%):</span>
                                        <asp:Label ID="lblDescuento" runat="server" CssClass="fw-bold fs-6">- $ 0,00</asp:Label>
                                    </div>

                                    <div class="col-12 d-flex justify-content-between align-items-center border-top pt-2">
                                        <span class="text-muted fw-bold">Neto Gravado:</span>
                                        <asp:Label ID="lblSubtotalNeto" runat="server" CssClass="fw-bold text-dark fs-6">$ 0,00</asp:Label>
                                    </div>

                                    <div class="col-12 d-flex justify-content-between align-items-center" id="divIva" runat="server">
                                        <span class="text-muted fw-medium">IVA (<asp:Label ID="lblPorcIva" runat="server">0</asp:Label>%):</span>
                                        <asp:Label ID="lblIva" runat="server" CssClass="fw-bold text-secondary fs-6">$ 0,00</asp:Label>
                                    </div>

                                    <div class="col-12 d-flex justify-content-between align-items-center" id="divIibb" runat="server">
                                        <span class="text-muted fw-medium">Ingresos Brutos (<asp:Label ID="lblPorcIibb" runat="server">0</asp:Label>%):</span>
                                        <asp:Label ID="lblIibb" runat="server" CssClass="fw-bold text-secondary fs-6">$ 0,00</asp:Label>
                                    </div>

                                    <div class="col-12 d-flex justify-content-between align-items-center" id="divPercepcion" runat="server">
                                        <span class="text-muted fw-medium">Percepción (<asp:Label ID="lblPorcPercepcion" runat="server">0</asp:Label>%):</span>
                                        <asp:Label ID="lblPercepcion" runat="server" CssClass="fw-bold text-secondary fs-6">$ 0,00</asp:Label>
                                    </div>

                                    <div class="col-12 d-flex justify-content-between align-items-center border-top pt-3 mt-2">
                                        <h4 class="mb-0 text-muted fs-5 fw-bold text-uppercase">Total:</h4>
                                        <asp:Label ID="lblTotal" runat="server" CssClass="fw-bold text-proveedor fs-2 m-0 text-nowrap">$ 0,00</asp:Label>
                                    </div>

                                </div>
                            </div>

                        </div>
                    </div>

                </div>

            </div>

            <div class="card-footer bg-white border-top-0 pt-0 pb-4 px-4 p-md-5">
                <div class="d-flex justify-content-end gap-3 border-top pt-4">
                    <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-toggle="modal" data-bs-target="#modalCancelar">
                        Cancelar
                    </button>

                    <button type="button" class="btn btn-proveedor-custom px-5 d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalSeguridadGuardar">
                        <span class="material-symbols-outlined fs-5">send</span> Generar Orden
                    </button>
                </div>

                <div class="mt-2 text-end">
                    <asp:Label ID="lblMensajeFooter" runat="server" CssClass="text-danger fw-bold small" Visible="false"></asp:Label>
                </div>
            </div>

        </div>
    </div>

    <div class="modal fade" id="modalCancelar" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-body text-center pt-5 pb-4 px-4">
                    <span class="material-symbols-outlined text-warning mb-3" style="font-size: 4rem;">warning</span>
                    <h4 class="fw-bold text-dark">¿Descartar pedido?</h4>
                    <p class="text-muted">Si cancelas ahora, se perderán todos los productos que hayas cargado en esta orden.</p>
                </div>
                <div class="modal-footer bg-light justify-content-center border-top-0 rounded-bottom-4 py-3">
                    <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-dismiss="modal">Volver a la edición</button>
                    <asp:Button ID="btnConfirmarCancelar" runat="server" Text="Sí, cancelar y salir" CssClass="btn btn-danger px-4 fw-bold" OnClick="btnConfirmarCancelar_Click" CausesValidation="false" />
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalSeguridadGuardar" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-header border-bottom-0 pb-0 justify-content-end">
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center pt-0 pb-4 px-4">
                    <span class="material-symbols-outlined text-proveedor mb-3" style="font-size: 4rem;">help</span>
                    <h4 class="fw-bold text-dark">¿Confirmar y Generar?</h4>
                    <p class="text-muted">Se generará la Orden de Pedido para enviarle al proveedor. Verificá que las cantidades sean correctas.</p>
                </div>
                <div class="modal-footer bg-light justify-content-center border-top-0 rounded-bottom-4 py-3 gap-2">
                    <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-dismiss="modal">Revisar de nuevo</button>
                    <asp:Button ID="btnGuardarDefinitivo" runat="server" Text="Sí, generar pedido" CssClass="btn btn-proveedor-custom px-4 fw-bold" OnClick="btnGuardar_Click" CausesValidation="false" />
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalExito" tabindex="-1" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-body text-center pt-5 pb-4 px-4">
                    <span class="material-symbols-outlined text-success mb-3" style="font-size: 4rem;">check_circle</span>
                    <h4 class="fw-bold text-dark">¡Orden Generada!</h4>
                    <p class="text-muted">El pedido al proveedor ha sido registrado correctamente en el sistema.</p>
                </div>
                <div class="modal-footer bg-light justify-content-center border-top-0 rounded-bottom-4 py-3">
                    <a href="PedidosProveedores.aspx" class="btn btn-proveedor-custom px-5 fw-bold">Ir al Listado de Pedidos</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function mostrarModalExito() {
            var modalSeguridad = bootstrap.Modal.getInstance(document.getElementById('modalSeguridadGuardar'));
            if (modalSeguridad) modalSeguridad.hide();

            var myModal = new bootstrap.Modal(document.getElementById('modalExito'));
            myModal.show();
        }
    </script>

</asp:Content>
