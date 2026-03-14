<%@ Page Title="Mi Perfil" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Perfil.aspx.cs" Inherits="TPC_Equipo20B.Perfil" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />

    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            user-select: none;
            font-size: 20px;
        }
        
        .btn-brand-custom {
            background-color: #11d452; 
            border-color: #11d452;
            color: #102216;
            font-weight: 700;
        }

        .btn-brand-custom:hover {
            background-color: #0fbc48;
            border-color: #0fbc48;
            color: #102216;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="page-title mb-0 fw-bold">Mi Perfil</h1>
    </div>

    <div class="row">
        <div class="col-lg-8">
            <div class="card shadow-sm mb-4 border-0 rounded-4">
                <div class="card-header bg-white pt-4 pb-2 border-bottom-0">
                    <h5 class="mb-0 fw-bold d-flex align-items-center gap-2 text-muted text-uppercase fs-6">
                        <span class="material-symbols-outlined">person</span> Información Personal
                    </h5>
                </div>
                <div class="card-body px-4 pb-4">
                    <div class="row g-4">
                        <div class="col-md-6">
                            <asp:Label ID="lblNombre" runat="server" Text="Nombre" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control bg-light" placeholder="Ingrese su nombre" />
                            <asp:RequiredFieldValidator ID="valNombre" runat="server"
                                ControlToValidate="txtNombre"
                                ErrorMessage="El nombre es requerido"
                                Display="Dynamic"
                                CssClass="text-danger small fw-bold mt-1"
                                ValidationGroup="Perfil" />
                        </div>

                        <div class="col-md-6">
                            <asp:Label ID="lblDocumento" runat="server" Text="Documento" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtDocumento" runat="server" CssClass="form-control bg-light" placeholder="Ingrese su documento" />
                        </div>

                        <div class="col-md-6">
                            <asp:Label ID="lblEmail" runat="server" Text="Correo Electrónico" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control bg-light" placeholder="correo@ejemplo.com" />
                            <asp:RequiredFieldValidator ID="valEmailRequerido" runat="server"
                                ControlToValidate="txtEmail"
                                ErrorMessage="El correo electrónico es requerido"
                                Display="Dynamic"
                                CssClass="text-danger small fw-bold mt-1"
                                ValidationGroup="Perfil" />
                            <asp:RegularExpressionValidator ID="valEmailFormato" runat="server"
                                ControlToValidate="txtEmail"
                                ErrorMessage="Ingrese un correo electrónico válido"
                                ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"
                                Display="Dynamic"
                                CssClass="text-danger small fw-bold mt-1"
                                ValidationGroup="Perfil" />
                        </div>

                        <div class="col-md-6">
                            <asp:Label ID="lblTelefono" runat="server" Text="Teléfono" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control bg-light" placeholder="Ingrese su teléfono" />
                        </div>

                        <div class="col-md-6">
                            <asp:Label ID="lblDireccion" runat="server" Text="Dirección" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control bg-light" placeholder="Ingrese su dirección" />
                        </div>

                        <div class="col-md-6">
                            <asp:Label ID="lblLocalidad" runat="server" Text="Localidad" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtLocalidad" runat="server" CssClass="form-control bg-light" placeholder="Ingrese su localidad" />
                        </div>

                        <div class="col-md-6">
                            <asp:Label ID="lblUsername" runat="server" Text="Nombre de Usuario" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" ReadOnly="true" Enabled="false" />
                            <small class="text-muted">El nombre de usuario no se puede modificar</small>
                        </div>

                        <div class="col-md-6">
                            <asp:Label ID="lblRol" runat="server" Text="Rol" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtRol" runat="server" CssClass="form-control" ReadOnly="true" Enabled="false" />
                        </div>

                        <div class="col-12 mt-4 pt-3 border-top">
                            <label for="txtObservaciones" class="form-label fw-medium">Observaciones de la cuenta</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 align-items-start pt-2">
                                    <span class="material-symbols-outlined text-muted">edit_note</span>
                                </span>
                                <asp:TextBox ID="txtObservaciones" runat="server" CssClass="form-control border-start-0 bg-light" TextMode="MultiLine" Rows="3" placeholder="Añade información adicional, notas personales o detalles relevantes sobre tu cuenta..." />
                            </div>
                        </div>
                    </div>

                    <div class="mt-4 pt-3 d-flex gap-3 justify-content-end border-top">
                        <asp:Label ID="lblMensaje" runat="server" CssClass="d-none" EnableViewState="false" />
                        
                        <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-toggle="modal" data-bs-target="#modalCancelar">
                            Cancelar
                        </button>
                        
                        <button type="button" class="btn btn-brand-custom px-4 fw-bold d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalSeguridadGuardar">
                            <span class="material-symbols-outlined fs-5">save</span> Guardar Cambios
                        </button>
                    </div>
                </div>
            </div>

            <div class="card shadow-sm border-0 rounded-4">
                <div class="card-header bg-white pt-4 pb-2 border-bottom-0">
                    <h5 class="mb-0 fw-bold d-flex align-items-center gap-2 text-muted text-uppercase fs-6">
                        <span class="material-symbols-outlined">lock_reset</span> Cambiar Contraseña
                    </h5>
                </div>
                <div class="card-body px-4 pb-4">
                    <div class="row g-4">
                        <div class="col-md-12">
                            <asp:Label ID="lblPasswordActual" runat="server" Text="Contraseña Actual" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtPasswordActual" runat="server" TextMode="Password" CssClass="form-control bg-light" placeholder="Ingrese su contraseña actual" />
                            <asp:RequiredFieldValidator ID="valPasswordActual" runat="server"
                                ControlToValidate="txtPasswordActual"
                                ErrorMessage="La contraseña actual es requerida"
                                Display="Dynamic"
                                CssClass="text-danger small fw-bold mt-1"
                                ValidationGroup="Password" />
                        </div>

                        <div class="col-md-6">
                            <asp:Label ID="lblPasswordNueva" runat="server" Text="Nueva Contraseña" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtPasswordNueva" runat="server" TextMode="Password" CssClass="form-control bg-light" placeholder="Mínimo 6 caracteres" />
                            <asp:RequiredFieldValidator ID="valPasswordNueva" runat="server"
                                ControlToValidate="txtPasswordNueva"
                                ErrorMessage="La nueva contraseña es requerida"
                                Display="Dynamic"
                                CssClass="text-danger small fw-bold mt-1"
                                ValidationGroup="Password" />
                            <asp:RegularExpressionValidator ID="valPasswordLongitud" runat="server"
                                ControlToValidate="txtPasswordNueva"
                                ErrorMessage="La contraseña debe tener al menos 6 caracteres"
                                ValidationExpression=".{6,}"
                                Display="Dynamic"
                                CssClass="text-danger small fw-bold mt-1"
                                ValidationGroup="Password" />
                        </div>

                        <div class="col-md-6">
                            <asp:Label ID="lblPasswordConfirmar" runat="server" Text="Confirmar Nueva Contraseña" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtPasswordConfirmar" runat="server" TextMode="Password" CssClass="form-control bg-light" placeholder="Repita la nueva contraseña" />
                            <asp:RequiredFieldValidator ID="valPasswordConfirmar" runat="server"
                                ControlToValidate="txtPasswordConfirmar"
                                ErrorMessage="Debe confirmar la nueva contraseña"
                                Display="Dynamic"
                                CssClass="text-danger small fw-bold mt-1"
                                ValidationGroup="Password" />
                            <asp:CompareValidator ID="valPasswordMatch" runat="server"
                                ControlToValidate="txtPasswordConfirmar"
                                ControlToCompare="txtPasswordNueva"
                                ErrorMessage="Las contraseñas no coinciden"
                                Display="Dynamic"
                                CssClass="text-danger small fw-bold mt-1"
                                ValidationGroup="Password" />
                        </div>
                    </div>

                    <div class="mt-4 pt-3 d-flex justify-content-end border-top">
                        <asp:Label ID="lblMensajePassword" runat="server" CssClass="d-block mb-3 w-100 text-end" EnableViewState="false" />
                        
                        <button type="button" class="btn btn-dark fw-bold px-4 d-flex align-items-center gap-2" onclick="validarYMostrarModalPassword();">
                            <span class="material-symbols-outlined fs-5">key</span> Actualizar Contraseña
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card shadow-sm border-0 rounded-4">
                <div class="card-header bg-white pt-4 pb-2 border-bottom-0">
                    <h5 class="mb-0 fw-bold d-flex align-items-center gap-2 text-muted text-uppercase fs-6">
                        <span class="material-symbols-outlined">manage_accounts</span> Estado de la Cuenta
                    </h5>
                </div>
                <div class="card-body px-4 pb-4">
                    <div class="mb-3 p-3 bg-light rounded-3 border">
                        <small class="text-muted d-block mb-1 text-uppercase fw-bold" style="font-size: 0.75rem;">ID de Usuario</small>
                        <strong class="fs-5 text-dark">#<asp:Label ID="lblUsuarioId" runat="server" /></strong>
                    </div>
                    <div class="p-3 bg-light rounded-3 border">
                        <small class="text-muted d-block mb-2 text-uppercase fw-bold" style="font-size: 0.75rem;">Estado Operativo</small>
                        <span class="badge bg-success bg-opacity-10 text-success border border-success fw-bold px-3 py-2 rounded-pill d-inline-flex align-items-center gap-1">
                            <span class="material-symbols-outlined" style="font-size: 14px;">check_circle</span> Activo
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalCancelar" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-body text-center pt-5 pb-4 px-4">
                    <span class="material-symbols-outlined text-warning mb-3" style="font-size: 4rem;">warning</span>
                    <h4 class="fw-bold text-dark">¿Descartar cambios?</h4>
                    <p class="text-muted">Si cancelas ahora, no se guardarán los cambios que hiciste en tu perfil y volverás al inicio.</p>
                </div>
                <div class="modal-footer bg-light justify-content-center border-top-0 rounded-bottom-4 py-3">
                    <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-dismiss="modal">Continuar editando</button>
                    <asp:Button ID="btnConfirmarCancelar" runat="server" Text="Sí, salir" CssClass="btn btn-danger px-4 fw-bold" OnClick="btnCancelar_Click" CausesValidation="false" />
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
                    <h4 class="fw-bold text-dark">¿Actualizar perfil?</h4>
                    <p class="text-muted">Verificá que los datos de contacto y observaciones sean correctos antes de guardarlos.</p>
                </div>
                <div class="modal-footer bg-light justify-content-center border-top-0 rounded-bottom-4 py-3 gap-2">
                    <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-dismiss="modal">Revisar de nuevo</button>
                    <asp:Button ID="btnGuardarDefinitivo" runat="server" Text="Sí, guardar ahora" CssClass="btn btn-brand-custom px-4 fw-bold" OnClick="btnGuardar_Click" ValidationGroup="Perfil" />
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalConfirmarPassword" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-header border-bottom-0 pb-0 justify-content-end">
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center pt-0 pb-4 px-4">
                    <span class="material-symbols-outlined text-primary mb-3" style="font-size: 4rem;">shield_lock</span>
                    <h4 class="fw-bold text-dark">¿Actualizar contraseña?</h4>
                    <p class="text-muted">Estás a punto de modificar tu credencial de acceso. ¿Estás seguro de que deseas cambiarla?</p>
                </div>
                <div class="modal-footer bg-light justify-content-center border-top-0 rounded-bottom-4 py-3 gap-2">
                    <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-dismiss="modal">Cancelar</button>
                    <asp:Button ID="btnCambiarPasswordDefinitivo" runat="server" Text="Sí, actualizar" CssClass="btn btn-dark px-4 fw-bold" OnClick="btnCambiarPassword_Click" ValidationGroup="Password" />
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
                    <button type="button" class="btn btn-brand-custom px-5 fw-bold" data-bs-dismiss="modal">Aceptar</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        function validarYMostrarModalPassword() {
            // Solo abre el modal si los campos de la contraseña están correctamente llenos
            if (typeof (Page_ClientValidate) === 'function') {
                if (Page_ClientValidate('Password')) {
                    var modal = new bootstrap.Modal(document.getElementById('modalConfirmarPassword'));
                    modal.show();
                }
            } else {
                var modal = new bootstrap.Modal(document.getElementById('modalConfirmarPassword'));
                modal.show();
            }
        }

        function mostrarModalExito() {
            var modalSeguridad = bootstrap.Modal.getInstance(document.getElementById('modalSeguridadGuardar'));
            if (modalSeguridad) modalSeguridad.hide();

            var modalPass = bootstrap.Modal.getInstance(document.getElementById('modalConfirmarPassword'));
            if (modalPass) modalPass.hide();

            var myModal = new bootstrap.Modal(document.getElementById('modalExito'));
            myModal.show();
        }

        function cerrarModalSeguridad() {
            var myModal = bootstrap.Modal.getInstance(document.getElementById('modalSeguridadGuardar'));
            if (myModal) myModal.hide();
        }

        function cerrarModalPassword() {
            var myModal = bootstrap.Modal.getInstance(document.getElementById('modalConfirmarPassword'));
            if (myModal) myModal.hide();
        }
    </script>

</asp:Content>