<%@ Page Title="Editar Usuario" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="EditarUsuario.aspx.cs" Inherits="TPC_Equipo20B.EditarUsuario" %>

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

        .form-control[readonly] {
            background-color: #f8f9fa;
            color: #6c757d;
        }
    </style>

    <div class="container-fluid py-4 max-w-1200" style="max-width: 1000px;">

        <div class="d-flex align-items-center justify-content-between mb-4 border-bottom pb-2">
            <div>
                <h2 id="lblTitulo" runat="server" class="fw-bold text-dark mb-1">Editar Usuario</h2>
                <p class="text-muted mb-0">Modifique los datos de la cuenta seleccionada</p>
            </div>
            <asp:HyperLink ID="lnkVolver" runat="server" NavigateUrl="Usuarios.aspx" CssClass="btn btn-outline-secondary d-flex align-items-center gap-1 fw-bold">
                <span class="material-symbols-outlined fs-6">arrow_back</span>
                Volver a la lista
            </asp:HyperLink>
        </div>

        <asp:Panel ID="pnlEditarUsuario" runat="server" CssClass="card shadow-sm border-0 rounded-4">
            <div class="card-body p-4 p-md-5">
                <div class="row g-4">

                    <div class="col-md-6">
                        <div class="mb-4">
                            <label for="txtNombre" class="form-label">Nombre y Apellido *</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">badge</span></span>
                                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control border-start-0" />
                            </div>
                            <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre" ErrorMessage="El nombre es requerido" CssClass="validator" Display="Dynamic" />
                        </div>

                        <div class="mb-4">
                            <label for="txtEmail" class="form-label">Correo Electrónico *</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">mail</span></span>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control border-start-0" TextMode="Email" />
                            </div>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="El email es requerido" CssClass="validator" Display="Dynamic" />
                        </div>

                        <div class="mb-4">
                            <label for="txtDocumento" class="form-label">Documento</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">credit_card</span></span>
                                <asp:TextBox ID="txtDocumento" runat="server" CssClass="form-control border-start-0" />
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="txtTelefono" class="form-label">Teléfono</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">phone</span></span>
                                <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control border-start-0" />
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-4">
                            <label for="txtDireccion" class="form-label">Dirección</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">home</span></span>
                                <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control border-start-0" />
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="txtLocalidad" class="form-label">Localidad</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">location_city</span></span>
                                <asp:TextBox ID="txtLocalidad" runat="server" CssClass="form-control border-start-0" />
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="txtUsername" class="form-label">Nombre de Usuario</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined text-muted">person</span></span>
                                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control border-start-0" ReadOnly="true" />
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Estado de la cuenta</label><br />
                            <asp:Label ID="lblEstado" runat="server" CssClass="badge px-3 py-2 fs-6 rounded-pill shadow-sm"></asp:Label>
                        </div>
                    </div>

                    <div class="col-12 border-top pt-4 mt-2">
                        <label for="txtObservaciones" class="form-label">Entre Calles / Observaciones (Domicilio)</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 align-items-start pt-2"><span class="material-symbols-outlined text-muted">map</span></span>
                            <asp:TextBox ID="txtObservaciones" runat="server" CssClass="form-control border-start-0" TextMode="MultiLine" Rows="2" placeholder="Ej: Entre San Martín y Belgrano." />
                        </div>
                    </div>
                </div>
                <asp:Label ID="lblError" runat="server" CssClass="mt-3 d-block text-center fw-bold text-danger"></asp:Label>
            </div>

            <div class="card-footer bg-light p-4 border-top-0 rounded-bottom-4 d-flex justify-content-end gap-3">
                <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-toggle="modal" data-bs-target="#modalCancelar">
                    Cancelar
                </button>

                <button type="button" class="btn btn-success-custom px-4 d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalSeguridadGuardar">
                    <span class="material-symbols-outlined fs-5">save</span> Guardar cambios
                </button>
            </div>
        </asp:Panel>
    </div>

    <div class="modal fade" id="modalCancelar" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-body text-center pt-5 pb-4 px-4">
                    <span class="material-symbols-outlined text-warning mb-3" style="font-size: 4rem;">warning</span>
                    <h4 class="fw-bold text-dark">¿Descartar cambios?</h4>
                    <p class="text-muted">Si cancelas ahora, se perderán las modificaciones realizadas en el usuario.</p>
                </div>
                <div class="modal-footer bg-light justify-content-center border-top-0 rounded-bottom-4 py-3">
                    <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-dismiss="modal">Volver</button>
                    <asp:Button ID="btnConfirmarCancelar" runat="server" Text="Sí, descartar y salir" CssClass="btn btn-danger px-4 fw-bold" OnClick="btnCancelar_Click" CausesValidation="false" />
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
                    <h4 class="fw-bold text-dark">¿Actualizar datos de usuario?</h4>
                    <p class="text-muted">Por favor, verificá que el email y los datos de contacto sean los correctos antes de guardar.</p>
                </div>
                <div class="modal-footer bg-light justify-content-center border-top-0 rounded-bottom-4 py-3 gap-2">
                    <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-dismiss="modal">Revisar</button>
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
                    <h4 class="fw-bold text-dark">¡Perfil Actualizado!</h4>
                    <p class="text-muted">Los datos del usuario han sido modificados correctamente en el sistema.</p>
                </div>
                <div class="modal-footer bg-light justify-content-center border-top-0 rounded-bottom-4 py-3">
                    <a href="Usuarios.aspx" class="btn btn-success-custom px-5 fw-bold">Ir al Listado de Usuarios</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function mostrarModalExito() {
            var modalSeguridad = bootstrap.Modal.getInstance(document.getElementById('modalSeguridadGuardar'));
            if(modalSeguridad) modalSeguridad.hide();
            new bootstrap.Modal(document.getElementById('modalExito')).show();
        }
        function cerrarModalSeguridad() {
             var myModal = bootstrap.Modal.getInstance(document.getElementById('modalSeguridadGuardar'));
             if(myModal) myModal.hide();
        }
    </script>

</asp:Content>
