<%@ Page Title="Registrar Compra" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="AgregarCompra.aspx.cs" Inherits="TPC_Equipo20B.AgregarCompra" %>

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
            overflow: hidden;
            background-color: #fff;
        }

        .table th {
            background-color: #f8f9fa !important;
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
                <h2 class="fw-bold text-dark m-0">Registrar Compra</h2>
                <p class="text-muted m-0 mt-1">Complete los datos para ingresar nuevo stock a la distribuidora</p>
            </div>

            <div class="card shadow-sm border border-success border-opacity-25 bg-white rounded-3 px-3 py-2">
                <div class="d-flex align-items-center gap-2">
                    <span class="material-symbols-outlined text-success">calendar_month</span>
                    <label for="txtFecha" class="fw-bold m-0 text-secondary small text-uppercase">Fecha Ingreso:</label>
                    <asp:TextBox ID="txtFecha" runat="server" TextMode="Date" CssClass="form-control form-control-sm text-center fw-bold p-0 text-dark fs-6" Style="width: 125px; outline: none; box-shadow: none;" />
                </div>
            </div>
        </div>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-4 p-md-5 pb-3">

                <div class="row g-5">

                    <div class="col-lg-5">

                        <h5 class="fw-bold text-muted mb-4 border-bottom pb-2 fs-6 text-uppercase d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined">domain</span> Datos del Proveedor
                        </h5>

                        <asp:Label ID="lblError" runat="server" CssClass="text-danger fw-bold small d-block mb-2" Visible="false"></asp:Label>

                        <div class="mb-4 position-relative">
                            <label for="ddlProveedor" class="form-label">Empresa Proveedora *</label>
                            <div class="input-group input-group-lg">
                                <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">factory</span></span>
                                <asp:DropDownList ID="ddlProveedor" runat="server" CssClass="form-select border-start-0 fs-6" AutoPostBack="true" OnSelectedIndexChanged="ddlProveedor_SelectedIndexChanged"></asp:DropDownList>
                            </div>
                            <div style="height: 18px;">
                                <asp:RequiredFieldValidator ErrorMessage="Debe seleccionar un proveedor" ControlToValidate="ddlProveedor" InitialValue="0" runat="server" CssClass="error-flotante" ValidationGroup="AgregarLinea" Display="Dynamic" />
                            </div>
                        </div>

                        <div class="mb-5 position-relative">
                            <label for="txtObservaciones" class="form-label">Observaciones de la compra (Opcional)</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 align-items-start pt-2"><span class="material-symbols-outlined text-muted">edit_note</span></span>
                                <asp:TextBox ID="txtObservaciones" runat="server" CssClass="form-control border-start-0" TextMode="MultiLine" Rows="2" placeholder="Ej: Remito N° 4567, entrega parcial..." />
                            </div>
                        </div>

                        <h5 class="fw-bold text-muted mb-4 border-bottom pb-2 fs-6 text-uppercase d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined">inventory_2</span> Ingreso de Mercadería
                        </h5>

                        <div class="mb-4 position-relative">
                            <label for="ddlProducto" class="form-label">Seleccionar Producto</label>

                            <div class="input-group input-group-lg shadow-sm rounded-3">
                                <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">search</span></span>
                                <asp:DropDownList ID="ddlProducto" runat="server" CssClass="form-select border-start-0 fs-6"></asp:DropDownList>

                                <button type="button" class="btn btn-success-custom px-3 d-flex align-items-center justify-content-center" data-bs-toggle="modal" data-bs-target="#modalIframeProducto" title="Crear Nuevo Producto">
                                    <span class="material-symbols-outlined">add</span>
                                </button>
                                <asp:LinkButton ID="btnActualizarLista" runat="server" CssClass="btn btn-outline-secondary px-3 d-flex align-items-center justify-content-center" OnClick="btnActualizarLista_Click" CausesValidation="false" title="Actualizar Lista">
                                    <span class="material-symbols-outlined">refresh</span>
                                </asp:LinkButton>
                            </div>

                            <div style="height: 18px;">
                                <asp:RequiredFieldValidator ID="rfvProducto" runat="server" ControlToValidate="ddlProducto" ErrorMessage="Seleccione un producto" InitialValue="0" ValidationGroup="AgregarLinea" CssClass="error-flotante" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-6 position-relative">
                                <label for="txtCantidad" class="form-label">Cantidad a Ingresar</label>
                                <div class="input-group input-group-lg">
                                    <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">tag</span></span>
                                    <asp:TextBox ID="txtCantidad" runat="server" CssClass="form-control sin-flechas text-center border-start-0 fw-bold fs-6" TextMode="Number" min="1" step="1" placeholder="0" />
                                </div>
                                <div style="height: 18px;">
                                    <asp:RequiredFieldValidator ID="rfvCantidad" runat="server" ControlToValidate="txtCantidad" ErrorMessage="Requerido" ValidationGroup="AgregarLinea" CssClass="error-flotante" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>

                            <div class="col-6 position-relative">
                                <label for="txtPrecio" class="form-label">Costo/Neto</label>
                                <div class="input-group input-group-lg">
                                    <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">attach_money</span></span>
                                    <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control sin-flechas text-center border-start-0 fs-6" TextMode="Number" min="0" step="0.01" placeholder="0,00" />
                                </div>
                                <div style="height: 18px;">
                                    <asp:RequiredFieldValidator ID="rfvPrecio" runat="server" ControlToValidate="txtPrecio" ErrorMessage="Requerido" ValidationGroup="AgregarLinea" CssClass="error-flotante" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>

                        <div class="mb-2">
                            <asp:LinkButton ID="btnAgregarLinea" runat="server" CssClass="btn btn-dark btn-lg w-100 fw-bold shadow-sm d-flex align-items-center justify-content-center gap-2" ValidationGroup="AgregarLinea" OnClick="btnAgregarLinea_Click">
                                <span class="material-symbols-outlined fs-5">add_circle</span> Agregar al Detalle
                            </asp:LinkButton>
                        </div>

                    </div>

                    <div class="col-lg-7 d-flex flex-column">

                        <div class="bg-light p-4 rounded-4 border d-flex flex-column flex-grow-1 shadow-sm">

                            <h5 class="fw-bold text-muted mb-3 fs-6 text-uppercase d-flex align-items-center gap-2">
                                <span class="material-symbols-outlined">receipt</span> Detalle de la Compra
                            </h5>

                            <div class="grid-container table-responsive mb-auto border bg-white shadow-sm">
                                <asp:GridView ID="gvLineas" runat="server" AutoGenerateColumns="False"
                                    CssClass="table table-hover align-middle text-center mb-0" OnRowCommand="gvLineas_RowCommand" GridLines="None">
                                    <Columns>
                                        <asp:BoundField DataField="Producto.Descripcion" HeaderText="Producto" ItemStyle-CssClass="text-start ps-4 fw-medium text-dark" HeaderStyle-CssClass="text-start ps-4" />
                                        <asp:BoundField DataField="Cantidad" HeaderText="Cant." ItemStyle-CssClass="fw-bold text-secondary" />
                                        <asp:BoundField DataField="PrecioUnitario" HeaderText="Costo/Neto" DataFormatString="{0:C}" ItemStyle-CssClass="text-muted small text-nowrap" />
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
                                            <span class="material-symbols-outlined d-block mb-2" style="font-size: 3rem; opacity: 0.3;">inventory</span>
                                            El detalle está vacío.
                                            <br />
                                            Seleccione un producto a la izquierda para ingresarlo.
                                        </div>
                                    </EmptyDataTemplate>
                                </asp:GridView>
                            </div>

                            <div class="mt-4 p-3 bg-white rounded-3 border d-flex justify-content-between align-items-center shadow-sm border-start border-success border-5">
                                <h4 class="mb-0 text-muted fs-5 fw-bold text-uppercase ps-2">Total Inversión</h4>
                                <asp:Label ID="lblTotal" runat="server" CssClass="fw-bold text-success fs-2 m-0 text-nowrap" Text="$ 0,00"></asp:Label>
                            </div>

                        </div>
                    </div>

                </div>

            </div>

            <div class="card-footer bg-white border-top-0 pt-0 pb-4 px-4 p-md-5 rounded-bottom-4">
                <div class="d-flex justify-content-end gap-3 border-top pt-4">
                    <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-toggle="modal" data-bs-target="#modalCancelarCompra">
                        Cancelar
                    </button>

                    <button type="button" class="btn btn-success-custom px-5 d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalSeguridadGuardar">
                        <span class="material-symbols-outlined fs-5">check_circle</span> Procesar Ingreso
                    </button>
                </div>

                <div class="mt-2 text-end">
                    <asp:Label ID="lblMensajeFooter" runat="server" CssClass="text-danger fw-bold small" Visible="false"></asp:Label>
                </div>
            </div>

        </div>
    </div>

    <div class="modal fade" id="modalIframeProducto" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-header bg-success text-white border-bottom-0 pb-3">
                    <h5 class="fw-bold mb-0 d-flex align-items-center gap-2">
                        <span class="material-symbols-outlined">add_box</span> Carga de Nuevo Producto
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-0 bg-light" style="height: 65vh; overflow: hidden;">

                    <iframe id="iframeProducto" src="AgregarProducto.aspx?modo=iframe" width="100%" height="100%" style="border: none;"></iframe>

                </div>
                <div class="modal-footer bg-light justify-content-between border-top-0 py-3 rounded-bottom-4">
                    <span class="text-muted small"><i class="bi bi-info-circle text-primary"></i><b>Instrucciones:</b> Guardá el producto, cerrá esta ventana y presioná el botón verde de actualizar (↻).</span>
                    <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-dismiss="modal">Cerrar Ventana</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalCancelarCompra" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-body text-center pt-5 pb-4 px-4">
                    <span class="material-symbols-outlined text-warning mb-3" style="font-size: 4rem;">warning</span>
                    <h4 class="fw-bold text-dark">¿Cancelar registro?</h4>
                    <p class="text-muted">Si cancelas ahora, se perderán todos los ingresos de mercadería que hayas agregado al detalle.</p>
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
                    <h4 class="fw-bold text-dark">¿Finalizar el ingreso?</h4>
                    <p class="text-muted">Por favor, verificá que las cantidades y el costo de los productos sean los correctos antes de procesar la compra al stock.</p>
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
                    <h4 class="fw-bold text-dark">¡Ingreso Registrado!</h4>
                    <p class="text-muted">La compra se procesó correctamente y el stock de los productos ha sido actualizado.</p>
                </div>
                <div class="modal-footer bg-light justify-content-center border-top-0 rounded-bottom-4 py-3">
                    <a href="Compras.aspx" class="btn btn-success-custom px-5 fw-bold">Ir al Historial de Compras</a>
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

        // --- SCRIPT PARA LIMPIAR EL IFRAME AL CERRARLO ---
        document.addEventListener("DOMContentLoaded", function () {
            var modalIframe = document.getElementById('modalIframeProducto');
            modalIframe.addEventListener('hidden.bs.modal', function (event) {
                // Forzamos al Iframe a recargar para que aparezca vacío la próxima vez que se abra
                document.getElementById('iframeProducto').src = "AgregarProducto.aspx?modo=iframe";
            });
        });
    </script>

</asp:Content>
