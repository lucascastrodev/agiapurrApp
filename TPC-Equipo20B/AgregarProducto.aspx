<%@ Page Title="Agregar Producto" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="AgregarProducto.aspx.cs" Inherits="TPC_Equipo20B.AgregarProducto"
    MaintainScrollPositionOnPostback="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />

    <style>
        .validator {
            color: #dc3545;
            font-size: 0.85em;
            display: block;
            margin-top: 0.25rem;
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

        .proveedores-container {
            max-height: 400px;
            overflow-y: auto;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            background-color: #fff;
        }

        .form-switch .form-check-input:checked {
            background-color: #11d452;
            border-color: #11d452;
        }
    </style>

    <div class="container-fluid py-4 max-w-1200" style="max-width: 1200px;">

        <asp:Panel ID="pnlMensaje" runat="server" Visible="false" role="alert">
            <asp:Label ID="lblMensaje" runat="server"></asp:Label>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </asp:Panel>

        <div class="mb-4 border-bottom pb-2">
            <h2 id="lblTitulo" runat="server" class="fw-bold text-dark mb-1">Agregar Nuevo Producto</h2>
            <p class="text-muted mb-0">Complete los campos para registrar o editar un producto en el catálogo</p>
        </div>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-4 p-md-5">

                <div class="row g-5">

                    <div class="col-lg-7">
                        <h5 class="fw-bold text-muted mb-4 border-bottom pb-2 fs-6 text-uppercase">Información Principal</h5>

                        <div class="mb-4">
                            <label for="txtDescripcion" class="form-label">Descripción del Producto *</label>
                            <div class="input-group input-group-lg">
                                <span class="input-group-text bg-light border-end-0">
                                    <span class="material-symbols-outlined text-muted">inventory_2</span>
                                </span>
                                <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control border-start-0" placeholder="Ej: Aceite de Oliva Extra Virgen x 2 Lts" />
                            </div>
                            <asp:RequiredFieldValidator ErrorMessage="Debe ingresar la descripción" CssClass="validator" ControlToValidate="txtDescripcion" runat="server" Display="Dynamic" />
                        </div>

                        <div class="mb-4">
                            <label for="txtSKU" class="form-label">Código SKU *</label>
                            <div class="input-group input-group-lg">
                                <span class="input-group-text bg-light border-end-0">
                                    <span class="material-symbols-outlined text-muted">qr_code_2</span>
                                </span>
                                <asp:TextBox ID="txtSKU" runat="server" CssClass="form-control border-start-0" placeholder="Ej: SKU00187" />
                            </div>
                            <asp:Label ID="lblErrorSku" runat="server" CssClass="validator" EnableViewState="false" />
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label for="ddlMarca" class="form-label">Marca *</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0">
                                        <span class="material-symbols-outlined text-muted">sell</span>
                                    </span>
                                    <asp:DropDownList ID="ddlMarca" runat="server" CssClass="form-select border-start-0"></asp:DropDownList>
                                </div>
                                <asp:RequiredFieldValidator ErrorMessage="Seleccione una Marca" CssClass="validator" ControlToValidate="ddlMarca" runat="server" InitialValue="0" Display="Dynamic" />
                            </div>

                            <div class="col-md-6">
                                <label for="ddlCategoria" class="form-label">Categoría *</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0">
                                        <span class="material-symbols-outlined text-muted">category</span>
                                    </span>
                                    <asp:DropDownList ID="ddlCategoria" runat="server" CssClass="form-select border-start-0"></asp:DropDownList>
                                </div>
                                <asp:RequiredFieldValidator ErrorMessage="Seleccione una Categoría" CssClass="validator" ControlToValidate="ddlCategoria" InitialValue="0" runat="server" Display="Dynamic" />
                            </div>
                        </div>

                        <h5 class="fw-bold text-muted mb-4 mt-5 border-bottom pb-2 fs-6 text-uppercase">Control de Inventario y Finanzas</h5>

                        <div class="row g-3 mb-4">
                            <div class="col-md-3">
                                <label for="txtStockMinimo" class="form-label">Stock Mín. *</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted" style="font-size: 18px;">warning</span></span>
                                    <asp:TextBox ID="txtStockMinimo" runat="server" CssClass="form-control border-start-0 px-1 text-center" placeholder="0" oninput="this.value = this.value.replace(/[^0-9,.]/g, '');" />
                                </div>
                                <asp:RequiredFieldValidator ErrorMessage="Requerido" ControlToValidate="txtStockMinimo" runat="server" CssClass="validator" Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revStockMin" runat="server" ControlToValidate="txtStockMinimo" ValidationExpression="^\d+([.,]\d{1,2})?$" ErrorMessage="Inválido" CssClass="validator" Display="Dynamic" />
                            </div>

                            <div class="col-md-3">
                                <label for="txtStockActual" class="form-label">Stock Act. *</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted" style="font-size: 18px;">shelves</span></span>
                                    <asp:TextBox ID="txtStockActual" runat="server" CssClass="form-control border-start-0 px-1 text-center" placeholder="0" oninput="this.value = this.value.replace(/[^0-9,.]/g, '');" />
                                </div>
                                <asp:RequiredFieldValidator ErrorMessage="Requerido" ControlToValidate="txtStockActual" runat="server" CssClass="validator" Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revStockActual" runat="server" ControlToValidate="txtStockActual" ValidationExpression="^\d+([.,]\d{1,2})?$" ErrorMessage="Inválido" CssClass="validator" Display="Dynamic" />
                            </div>

                            <div class="col-md-3">
                                <label for="txtPrecioNeto" class="form-label">Costo Neto *</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted" style="font-size: 18px;">attach_money</span></span>
                                    <asp:TextBox ID="txtPrecioNeto" runat="server" CssClass="form-control border-start-0 px-1 text-center" placeholder="0.00" oninput="this.value = this.value.replace(/[^0-9,.]/g, '');" />
                                </div>
                                <asp:RequiredFieldValidator ID="rfvPrecioNeto" runat="server" ControlToValidate="txtPrecioNeto" ErrorMessage="Requerido" CssClass="validator" Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revPrecioNeto" runat="server" ControlToValidate="txtPrecioNeto" ErrorMessage="Inválido" CssClass="validator" Display="Dynamic" ValidationExpression="^\d+([.,]\d{1,2})?$" />
                            </div>

                            <div class="col-md-3" id="divGanancia" clientidmode="Static" runat="server">
                                <label for="txtGanancia" class="form-label">% Ganancia *</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted" style="font-size: 18px;">percent</span></span>
                                    <asp:TextBox ID="txtGanancia" runat="server" CssClass="form-control border-start-0 px-1 text-center" placeholder="Ej: 30" oninput="this.value = this.value.replace(/[^0-9,.]/g, '');" />
                                </div>
                                <asp:RequiredFieldValidator ID="rfvGanancia" runat="server" ControlToValidate="txtGanancia" ErrorMessage="Requerido" CssClass="validator" Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revGanancia" runat="server" ControlToValidate="txtGanancia" ErrorMessage="Inválido" CssClass="validator" Display="Dynamic" ValidationExpression="^\d+([.,]\d{1,2})?$" />
                            </div>
                        </div>

                        <div class="form-check form-switch mb-3 p-3 bg-light rounded-3 border d-flex align-items-center gap-3">
                            <input id="chkHabilitado" runat="server" type="checkbox" class="form-check-input m-0 fs-4" checked="checked" />
                            <label class="form-check-label fw-bold text-dark m-0" for="chkHabilitado" style="cursor: pointer;">
                                Producto Activo en Catálogo
                            </label>
                        </div>

                    </div>
                    <div class="col-lg-5">
                        <div class="bg-light p-4 rounded-4 h-100 border">
                            <h5 class="fw-bold text-muted mb-3 fs-6 text-uppercase d-flex align-items-center gap-2">
                                <span class="material-symbols-outlined">local_shipping</span>
                                Proveedores Asignados
                            </h5>

                            <p class="small text-muted mb-3">Busque y seleccione los proveedores que abastecen este producto.</p>

                            <div class="input-group mb-3 shadow-sm">
                                <span class="input-group-text bg-white border-end-0">
                                    <span class="material-symbols-outlined text-muted fs-6">search</span>
                                </span>
                                <asp:TextBox ID="txtBuscarProveedor" runat="server" CssClass="form-control border-start-0 border-end-0" placeholder="Buscar empresa..." />
                                <asp:Button ID="btnBuscarProveedor" runat="server" Text="Buscar" CssClass="btn btn-outline-secondary" OnClick="btnBuscarProveedor_Click" CausesValidation="false" />
                            </div>

                            <div class="proveedores-container shadow-sm">
                                <asp:GridView ID="gvProveedores" runat="server"
                                    AutoGenerateColumns="False"
                                    CssClass="table table-hover align-middle mb-0"
                                    DataKeyNames="Id" GridLines="None">
                                    <HeaderStyle CssClass="table-light text-secondary small text-uppercase" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Sel." ItemStyle-Width="50px" ItemStyle-CssClass="text-center">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSel" runat="server" CssClass="form-check-input m-0"
                                                    AutoPostBack="true" OnCheckedChanged="chkSel_CheckedChanged" />

                                                <asp:HiddenField ID="hdnVendeConIVA" runat="server" Value='<%# Eval("VendeConIVA") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:BoundField DataField="Nombre" HeaderText="Empresa Proveedora" ItemStyle-CssClass="fw-medium text-dark" />
                                        <asp:BoundField DataField="Telefono" HeaderText="Teléfono" ItemStyle-CssClass="text-muted small" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card-footer bg-white p-4 border-top rounded-bottom-4 d-flex justify-content-end gap-3">
                <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-toggle="modal" data-bs-target="#modalCancelar">
                    Cancelar
                </button>

                <button type="button" id="btnProcesarUI" runat="server" class="btn btn-success-custom px-4 d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalSeguridadGuardar">
                    <span class="material-symbols-outlined fs-5">save</span> Guardar Producto
                </button>
            </div>
        </div>

    </div>

    <div class="modal fade" id="modalCancelar" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-body text-center pt-5 pb-4 px-4">
                    <span class="material-symbols-outlined text-warning mb-3" style="font-size: 4rem;">warning</span>
                    <h4 class="fw-bold text-dark">¿Cancelar registro?</h4>
                    <p class="text-muted">Si cancelas ahora, se perderán todos los datos que hayas ingresado sobre este producto.</p>
                </div>
                <div class="modal-footer bg-light justify-content-center border-top-0 rounded-bottom-4 py-3">
                    <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-dismiss="modal">Volver a la edición</button>
                    <asp:Button ID="btnConfirmarCancelar" runat="server" Text="Sí, cancelar y salir" CssClass="btn btn-danger px-4 fw-bold" OnClick="btnCancelar_Click" CausesValidation="false" />
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
                    <h4 class="fw-bold text-dark">¿Guardar producto?</h4>
                    <p class="text-muted">Por favor, verificá que el stock, los precios y los proveedores sean correctos antes de confirmar.</p>
                </div>
                <div class="modal-footer bg-light justify-content-center border-top-0 rounded-bottom-4 py-3 gap-2">
                    <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-dismiss="modal">Revisar de nuevo</button>

                    <asp:Button ID="btnGuardarDefinitivo" runat="server" Text="Sí, guardar ahora" CssClass="btn btn-success-custom px-4 fw-bold" OnClick="btnGuardar_Click" CausesValidation="false" />
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
                    <a href="Productos.aspx" class="btn btn-success-custom px-5 fw-bold">Ir al Listado de Productos</a>
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

        document.addEventListener('DOMContentLoaded', function () {
            const campos = [
                '<%= txtDescripcion.ClientID %>',
                '<%= txtSKU.ClientID %>',
                '<%= ddlMarca.ClientID %>',
                '<%= ddlCategoria.ClientID %>',
                '<%= txtStockMinimo.ClientID %>',
                '<%= txtStockActual.ClientID %>',
                '<%= txtPrecioNeto.ClientID %>',
                '<%= txtGanancia.ClientID %>'
            ];

            const btnProcesarUI = document.getElementById('<%= btnProcesarUI.ClientID %>');

            const primero = document.getElementById('<%= txtDescripcion.ClientID %>');
            if (primero) primero.focus();

            campos.forEach((id, index) => {
                const input = document.getElementById(id);
                if (!input) return;

                input.addEventListener('keydown', function (e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        const siguienteId = campos[index + 1];
                        const siguiente = siguienteId ? document.getElementById(siguienteId) : null;

                        if (siguiente) {
                            siguiente.focus();
                        } else {
                            if (btnProcesarUI) btnProcesarUI.click();
                        }
                    }
                });
            });
        });
    </script>

</asp:Content>
