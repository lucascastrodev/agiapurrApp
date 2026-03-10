<%@ Page Title="Agregar Proveedor" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="AgregarProveedor.aspx.cs" Inherits="TPC_Equipo20B.AgregarProveedor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />

    <script type="text/javascript">
        function validarNombreORazon(source, args) {
            var nombre = document.getElementById('<%= txtNombre.ClientID %>').value;
            var razon = document.getElementById('<%= txtRazonSocial.ClientID %>').value;
            args.IsValid = (nombre.trim() !== "" || razon.trim() !== "");
        }
    </script>

    <style>
        .validator {
            color: #dc3545;
            font-size: 0.85em;
            display: block;
            margin-top: 0.25rem;
            font-weight: 500;
        }

        .error-flotante {
            position: absolute;
            font-size: 0.85em;
            margin-top: 2px;
            color: #dc3545;
            font-weight: 500;
        }

        .col-md-6 {
            position: relative;
            margin-bottom: 1.5rem;
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
    </style>

    <div class="container-fluid py-4 max-w-1200" style="max-width: 1000px;">

        <div class="mb-4 border-bottom pb-2">
            <h2 id="lblTitulo" runat="server" class="fw-bold text-dark mb-1">Agregar Nuevo Proveedor</h2>
            <p class="text-muted mb-0">Complete los datos de la empresa proveedora</p>
        </div>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-4 p-md-5">
                <div class="row g-4">

                    <div class="col-md-6">
                        <label class="form-label">Nombre *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <span class="material-symbols-outlined text-muted">storefront</span>
                            </span>
                            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control border-start-0" placeholder="Nombre comercial" />
                        </div>
                        <asp:CustomValidator ID="cvNombreRazon" runat="server" ErrorMessage="Debe completar Nombre o Razón Social" ClientValidationFunction="validarNombreORazon" OnServerValidate="cvNombreRazon_ServerValidate" ValidationGroup="GuardarProveedor" CssClass="error-flotante" Display="Dynamic" />
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Razón Social *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <span class="material-symbols-outlined text-muted">domain</span>
                            </span>
                            <asp:TextBox ID="txtRazonSocial" runat="server" CssClass="form-control border-start-0" placeholder="Ej: Distribuidora Norte S.A." />
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Documento / CUIT *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <span class="material-symbols-outlined text-muted">credit_card</span>
                            </span>
                            <asp:TextBox ID="txtDocumento" runat="server" CssClass="form-control border-start-0" placeholder="Ej: 30-12345678-9" />
                        </div>
                        <asp:RegularExpressionValidator ID="revDocumento" runat="server" ControlToValidate="txtDocumento" ErrorMessage="Solo números y guiones" ValidationExpression="^[0-9-]+$" ValidationGroup="GuardarProveedor" CssClass="error-flotante" Display="Dynamic" />
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">¿Factura con IVA? *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <span class="material-symbols-outlined text-muted">receipt_long</span>
                            </span>
                            <asp:DropDownList ID="ddlFacturaIVA" runat="server" CssClass="form-select border-start-0">
                                <asp:ListItem Text="Seleccione una opción..." Value=""></asp:ListItem>
                                <asp:ListItem Text="SI" Value="true"></asp:ListItem>
                                <asp:ListItem Text="NO" Value="false"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <asp:RequiredFieldValidator ID="rfvFacturaIVA" runat="server" ControlToValidate="ddlFacturaIVA" InitialValue="" ErrorMessage="Indique condición IVA" ValidationGroup="GuardarProveedor" CssClass="error-flotante" Display="Dynamic" />
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Correo Electrónico *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <span class="material-symbols-outlined text-muted">mail</span>
                            </span>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control border-start-0" TextMode="Email" placeholder="correo@proveedor.com" />
                        </div>
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="El correo es obligatorio" ValidationGroup="GuardarProveedor" CssClass="error-flotante" Display="Dynamic" />
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Teléfono *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <span class="material-symbols-outlined text-muted">phone</span>
                            </span>
                            <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control border-start-0" placeholder="Ej: 011-4321-5678" />
                        </div>
                        <asp:RequiredFieldValidator ID="rfvTelefono" runat="server" ControlToValidate="txtTelefono" ErrorMessage="El teléfono es obligatorio" ValidationGroup="GuardarProveedor" CssClass="error-flotante" Display="Dynamic" />
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Dirección *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <span class="material-symbols-outlined text-muted">home</span>
                            </span>
                            <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control border-start-0" placeholder="Ej: Av. Belgrano 3456" />
                        </div>
                        <asp:RequiredFieldValidator ID="rfvDireccion" runat="server" ControlToValidate="txtDireccion" ErrorMessage="La dirección es obligatoria" ValidationGroup="GuardarProveedor" CssClass="error-flotante" Display="Dynamic" />
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Localidad *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <span class="material-symbols-outlined text-muted">location_city</span>
                            </span>
                            <asp:TextBox ID="txtLocalidad" runat="server" CssClass="form-control border-start-0" placeholder="Ej: CABA" />
                        </div>
                        <asp:RequiredFieldValidator ID="rfvLocalidad" runat="server" ControlToValidate="txtLocalidad" ErrorMessage="La localidad es obligatoria" ValidationGroup="GuardarProveedor" CssClass="error-flotante" Display="Dynamic" />
                    </div>

                </div>
            </div>

            <div class="card-footer bg-light p-4 border-top-0 rounded-bottom-4 d-flex justify-content-end gap-3">
                <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-toggle="modal" data-bs-target="#modalCancelar">
                    Cancelar
                </button>

                <button type="button" id="btnProcesarUI" runat="server" class="btn btn-success-custom px-4 d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalSeguridadGuardar">
                    <span class="material-symbols-outlined fs-5">save</span> Guardar Proveedor
                </button>
            </div>
        </div>

        <div class="mt-2 text-end">
            <asp:Label ID="lblError" runat="server" CssClass="text-danger fw-bold small" EnableViewState="false"></asp:Label>
        </div>
    </div>

    <div class="modal fade" id="modalCancelar" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-body text-center pt-5 pb-4 px-4">
                    <span class="material-symbols-outlined text-warning mb-3" style="font-size: 4rem;">warning</span>
                    <h4 class="fw-bold text-dark">¿Cancelar registro?</h4>
                    <p class="text-muted">Si cancelas ahora, se perderán todos los datos ingresados del proveedor.</p>
                </div>
                <div class="modal-footer bg-light justify-content-center border-top-0 rounded-bottom-4 py-3">
                    <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-dismiss="modal">Volver</button>
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
                    <h4 class="fw-bold text-dark">¿Guardar proveedor?</h4>
                    <p class="text-muted">Por favor, verificá que el CUIT y los datos de contacto sean correctos.</p>
                </div>
                <div class="modal-footer bg-light justify-content-center border-top-0 rounded-bottom-4 py-3 gap-2">
                    <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-dismiss="modal">Revisar</button>
                    <asp:Button ID="btnGuardarDefinitivo" runat="server" Text="Sí, guardar ahora" CssClass="btn btn-success-custom px-4 fw-bold" OnClick="btnGuardar_Click" ValidationGroup="GuardarProveedor" />
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
                        <asp:Label ID="lblMensajeExitoModal" runat="server"></asp:Label></p>
                </div>
                <div class="modal-footer bg-light justify-content-center border-top-0 rounded-bottom-4 py-3">
                    <a href="Proveedores.aspx" class="btn btn-success-custom px-5 fw-bold">Ir al Listado de Proveedores</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function mostrarModalExito() {
            var modalSeguridad = bootstrap.Modal.getInstance(document.getElementById('modalSeguridadGuardar'));
            if (modalSeguridad) modalSeguridad.hide();
            new bootstrap.Modal(document.getElementById('modalExito')).show();
        }
        function cerrarModalSeguridad() {
            var myModal = bootstrap.Modal.getInstance(document.getElementById('modalSeguridadGuardar'));
            if (myModal) myModal.hide();
        }
    </script>
</asp:Content>
