<%@ Page Title="Agregar Venta" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AgregarVenta.aspx.cs" Inherits="TPC_Equipo20B.AgregarVenta" %>

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

        .form-control:focus, .form-select:focus {
            border-color: #11d452;
            box-shadow: 0 0 0 0.25rem rgba(17, 212, 82, 0.25);
        }

        .btn-success-custom {
            background-color: #11d452;
            border-color: #11d452;
            color: #102216;
            font-weight: 700;
        }

            .btn-success-custom:hover {
                background-color: #0fbc48;
                border-color: #0fbc48;
                color: #102216;
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

        .btn-group-modern {
            display: inline-flex;
            padding: 0;
            margin: 0;
            list-style: none;
            background-color: #f8f9fa;
            border-radius: 10px;
            border: 1px solid #dee2e6;
            overflow: hidden;
            width: 100%;
        }

            .btn-group-modern li {
                flex: 1;
                text-align: center;
            }

            .btn-group-modern input[type="radio"] {
                display: none;
            }

            .btn-group-modern label {
                display: block;
                padding: 10px 15px;
                margin: 0;
                cursor: pointer;
                font-weight: 600;
                color: #6c757d;
                transition: all 0.2s ease;
                border-left: 1px solid #dee2e6;
            }

            .btn-group-modern li:first-child label {
                border-left: none;
            }

            .btn-group-modern input[type="radio"]:checked + label {
                background-color: #11d452;
                color: #102216;
            }

            .btn-group-modern label:hover {
                background-color: #e9ecef;
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
                <h2 id="lblTituloPagina" runat="server" class="fw-bold text-dark m-0">Registrar Venta</h2>
                <p id="lblSubtituloPagina" runat="server" class="text-muted m-0 mt-1">Complete los datos para generar un nuevo remito</p>
            </div>

            <div class="card shadow-sm border border-success border-opacity-25 bg-white rounded-3 px-3 py-2">
                <div class="d-flex align-items-center gap-2">
                    <span class="material-symbols-outlined text-success">calendar_month</span>
                    <label for="txtFecha" class="fw-bold m-0 text-secondary small text-uppercase">Fecha Emisión:</label>
                    <asp:TextBox ID="txtFecha" runat="server" TextMode="Date" CssClass="form-control form-control-sm text-center fw-bold p-0 text-dark fs-6" Style="width: 125px; outline: none; box-shadow: none;" />
                </div>
            </div>
        </div>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-4 p-md-5 pb-3">

                <div class="row g-5">

                    <div class="col-lg-5">

                        <h5 id="tituloFacturacion" runat="server" class="fw-bold text-muted mb-4 border-bottom pb-2 fs-6 text-uppercase d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined">receipt_long</span> Datos de Facturación
                        </h5>

                        <div id="divClienteBox" runat="server" class="mb-4 position-relative">
                            <label for="ddlCliente" class="form-label">Cliente Asociado *</label>
                            <div class="input-group input-group-lg">
                                <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">person</span></span>
                                <asp:DropDownList ID="ddlCliente" runat="server" CssClass="form-select border-start-0 fs-6"></asp:DropDownList>
                            </div>
                            <div style="height: 18px;">
                                <asp:RequiredFieldValidator ID="rfvCliente" runat="server" ControlToValidate="ddlCliente" ErrorMessage="Debe seleccionar un cliente" InitialValue="0" ValidationGroup="AgregarLinea" CssClass="error-flotante" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="row g-3 mb-5" id="divFilaMetodos" runat="server">
                            <div id="divTipoVenta" runat="server" class="col-md-6 position-relative">
                                <label class="form-label">Lista de Precios</label>
                                <div>
                                    <asp:RadioButtonList ID="rblTipoVenta" runat="server" CssClass="btn-group-modern" RepeatLayout="UnorderedList" AutoPostBack="true" OnSelectedIndexChanged="rblTipoVenta_SelectedIndexChanged">
                                        <asp:ListItem Text="Mayorista" Value="Mayorista" />
                                        <asp:ListItem Text="C. Final" Value="Final" Selected="True" />
                                    </asp:RadioButtonList>
                                </div>
                            </div>

                            <div id="divMetodoPago" runat="server" class="col-md-6 position-relative">
                                <label for="ddlMetodoPago" class="form-label">Método de Pago *</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">payments</span></span>
                                    <asp:DropDownList ID="ddlMetodoPago" runat="server" CssClass="form-select border-start-0">
                                        <asp:ListItem Text="-- Seleccione --" Value="0" />
                                        <asp:ListItem Text="Efectivo" Value="Efectivo" />
                                        <asp:ListItem Text="Transferencia" Value="Transferencia" />
                                    </asp:DropDownList>
                                </div>
                                <div style="height: 18px;">
                                    <asp:RequiredFieldValidator ID="rfvMetodoPago" runat="server" ControlToValidate="ddlMetodoPago" ErrorMessage="Seleccione pago" InitialValue="0" ValidationGroup="AgregarLinea" CssClass="error-flotante" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>

                        <h5 class="fw-bold text-muted mb-4 border-bottom pb-2 fs-6 text-uppercase d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined">add_shopping_cart</span> Añadir al Remito
                        </h5>

                        <div class="mb-4 position-relative">
                            <label for="ddlProducto" class="form-label">Seleccionar Producto</label>
                            <div class="input-group input-group-lg">
                                <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">inventory_2</span></span>
                                <asp:DropDownList ID="ddlProducto" runat="server" CssClass="form-select border-start-0 fs-6" AutoPostBack="true" OnSelectedIndexChanged="ddlProducto_SelectedIndexChanged"></asp:DropDownList>
                            </div>
                            <div style="height: 18px;">
                                <asp:RequiredFieldValidator ID="rfvProducto" runat="server" ControlToValidate="ddlProducto" ErrorMessage="Seleccione un producto" InitialValue="0" ValidationGroup="AgregarLinea" CssClass="error-flotante" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-6 position-relative">
                                <label for="txtCantidad" class="form-label">Cantidad</label>
                                <div class="input-group input-group-lg">
                                    <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">tag</span></span>
                                    <asp:TextBox ID="txtCantidad" runat="server" CssClass="form-control sin-flechas text-center border-start-0 fw-bold fs-6" TextMode="Number" min="1" step="1" placeholder="0" />
                                </div>
                                <div style="height: 18px;">
                                    <asp:RequiredFieldValidator ID="rfvCantidad" runat="server" ControlToValidate="txtCantidad" ErrorMessage="Requerido" ValidationGroup="AgregarLinea" CssClass="error-flotante" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <asp:CompareValidator ID="cvCantidad" runat="server" ControlToValidate="txtCantidad" ErrorMessage="Mínimo 1" ValueToCompare="0" Operator="GreaterThan" Type="Integer" ValidationGroup="AgregarLinea" CssClass="error-flotante" Display="Dynamic"></asp:CompareValidator>
                                    <asp:CustomValidator ID="CustomValidatorCantidad" runat="server" ControlToValidate="txtCantidad" ErrorMessage="Stock insuficiente" CssClass="error-flotante" Display="Dynamic" OnServerValidate="ValidarCantidad_ServerValidate" ValidationGroup="AgregarLinea" EnableClientScript="false"></asp:CustomValidator>
                                </div>
                            </div>

                            <div class="col-6 position-relative">
                                <label id="lblTxtPrecio" runat="server" for="txtPrecio" class="form-label">Precio Unitario</label>
                                <div class="input-group input-group-lg">
                                    <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">attach_money</span></span>
                                    <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control bg-light text-center border-start-0 text-muted fs-6" ReadOnly="true" placeholder="0,00" />
                                </div>
                                <div style="height: 18px;"></div>
                            </div>
                        </div>

                        <div class="mb-2">
                            <asp:LinkButton ID="btnAgregarLinea" runat="server" CssClass="btn btn-dark btn-lg w-100 fw-bold shadow-sm d-flex align-items-center justify-content-center gap-2" ValidationGroup="AgregarLinea" OnClick="btnAgregarLinea_Click" CausesValidation="true">
                                <span class="material-symbols-outlined fs-5">add_circle</span> Agregar al Remito
                            </asp:LinkButton>
                            <asp:Label ID="lblErrorStock" runat="server" CssClass="text-danger fw-bold small d-block text-center mt-2" />
                        </div>

                    </div>

                    <div class="col-lg-7 d-flex flex-column">
                        <div class="bg-light p-4 rounded-4 border d-flex flex-column flex-grow-1 shadow-sm">

                            <h5 class="fw-bold text-muted mb-3 fs-6 text-uppercase d-flex align-items-center gap-2">
                                <span class="material-symbols-outlined">shopping_bag</span> Resumen del Pedido
                            </h5>

                            <div class="grid-container table-responsive mb-auto border bg-white shadow-sm">
                                <asp:GridView ID="gvLineas" runat="server" AutoGenerateColumns="False"
                                    CssClass="table table-hover align-middle text-center mb-0" OnRowCommand="gvLineas_RowCommand" GridLines="None">
                                    <Columns>
                                        <asp:BoundField DataField="Producto.Descripcion" HeaderText="Producto" ItemStyle-CssClass="text-start ps-4 fw-medium text-dark" HeaderStyle-CssClass="text-start ps-4" />
                                        <asp:BoundField DataField="Cantidad" HeaderText="Cant." ItemStyle-CssClass="fw-bold text-secondary" />

                                        <asp:BoundField DataField="PrecioUnitario" HeaderText="Precio" DataFormatString="{0:C}" ItemStyle-CssClass="text-muted small text-nowrap" />
                                        <asp:BoundField DataField="Subtotal" HeaderText="Subtotal" DataFormatString="{0:C}" ItemStyle-CssClass="fw-bold text-dark text-nowrap" />

                                        <asp:TemplateField>
                                            <ItemStyle Width="80px" CssClass="pe-3" />
                                            <ItemTemplate>
                                                <asp:LinkButton ID="cmdEliminar" runat="server" CommandName="Eliminar" CommandArgument='<%# Container.DataItemIndex %>' CssClass="btn btn-outline-danger btn-sm rounded-3 shadow-sm d-flex align-items-center justify-content-center" CausesValidation="false">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">delete</span>
                                                </asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>

                                    <EmptyDataTemplate>
                                        <div class="p-5 text-muted text-center">
                                            <span class="material-symbols-outlined d-block mb-2" style="font-size: 3rem; opacity: 0.3;">production_quantity_limits</span>
                                            El carrito está vacío.
                                            <br />
                                            Utilice el panel izquierdo para añadir productos.
                                        </div>
                                    </EmptyDataTemplate>
                                </asp:GridView>
                            </div>

                            <div id="divDescuentoAdmin" runat="server" class="mt-4 mb-2 p-3 bg-white rounded-3 border d-flex justify-content-between align-items-center shadow-sm border-start border-warning border-5">
                                <h5 class="mb-0 text-muted fs-6 fw-bold text-uppercase ps-2 d-flex align-items-center gap-2">
                                    <span class="material-symbols-outlined text-warning">local_offer</span> Descuento Extra (%)
                                </h5>
                                <asp:TextBox ID="txtDescuento" runat="server" CssClass="form-control text-end fw-bold text-danger fs-5" Style="width: 100px;" placeholder="0" AutoPostBack="true" OnTextChanged="txtDescuento_TextChanged" oninput="this.value = this.value.replace(/[^0-9]/g, '');" />
                            </div>

                            <div class="p-3 bg-white rounded-3 border d-flex justify-content-between align-items-center shadow-sm border-start border-success border-5">
                                <h4 id="lblTxtTotalRemito" runat="server" class="mb-0 text-muted fs-5 fw-bold text-uppercase ps-2">Total Remito</h4>
                                <asp:Label ID="lblTotal" runat="server" CssClass="fw-bold text-success fs-2 m-0 text-nowrap" Text="$ 0,00"></asp:Label>
                            </div>

                        </div>
                    </div>

                </div>

            </div>

            <div class="card-footer bg-white border-top-0 pt-0 pb-4 px-4 p-md-5">
                <div class="d-flex justify-content-end gap-3 border-top pt-4">
                    <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-toggle="modal" data-bs-target="#modalCancelarVenta">
                        Cancelar
                    </button>

                    <button type="button" id="btnProcesarUI" runat="server" class="btn btn-success-custom px-5 d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalSeguridadGuardar">
                    </button>
                </div>

                <div class="mt-2 text-end">
                    <asp:Label ID="lblMensajeFooter" runat="server" CssClass="text-danger fw-bold small" Visible="false"></asp:Label>
                </div>
            </div>

        </div>
    </div>

    <div class="modal fade" id="modalCancelarVenta" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-body text-center pt-5 pb-4 px-4">
                    <span class="material-symbols-outlined text-warning mb-3" style="font-size: 4rem;">warning</span>
                    <h4 class="fw-bold text-dark">¿Cancelar registro?</h4>
                    <p class="text-muted">Si cancelas ahora, se perderán todos los productos que hayas agregado al remito.</p>
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
                    <span class="material-symbols-outlined text-success mb-3" style="font-size: 4rem;">help</span>
                    <h4 class="fw-bold text-dark">¿Finalizar el pedido?</h4>
                    <p class="text-muted">Por favor, verificá que los productos y el cliente sean los correctos antes de procesar la venta.</p>
                </div>
                <div class="modal-footer bg-light justify-content-center border-top-0 rounded-bottom-4 py-3 gap-2">
                    <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-dismiss="modal">Revisar de nuevo</button>
                    <asp:Button ID="btnGuardarDefinitivo" runat="server" Text="Sí, procesar ahora" CssClass="btn btn-success-custom px-4 fw-bold" OnClick="btnGuardar_Click" CausesValidation="false" />
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalExito" tabindex="-1" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-body text-center pt-5 pb-4 px-4">
                    <span class="material-symbols-outlined text-success mb-3" style="font-size: 4rem;">check_circle</span>
                    <h4 class="fw-bold text-dark">¡Operación Exitosa!</h4>
                    <p class="text-muted">
                        <asp:Label ID="lblMensajeExitoModal" runat="server"></asp:Label>
                    </p>
                </div>
                <div class="modal-footer bg-light justify-content-center border-top-0 rounded-bottom-4 py-3">
                    <a href="Ventas.aspx" class="btn btn-success-custom px-5 fw-bold">Ir al Listado de Pedidos</a>
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

        function cerrarModalSeguridad() {
            var myModal = bootstrap.Modal.getInstance(document.getElementById('modalSeguridadGuardar'));
            if (myModal) myModal.hide();
        }
    </script>

</asp:Content>
