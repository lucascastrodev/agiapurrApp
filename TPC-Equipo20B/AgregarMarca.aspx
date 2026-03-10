<%@ Page Title="Agregar Marca" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="AgregarMarca.aspx.cs" Inherits="TPC_Equipo20B.AgregarMarca" %>

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

        .form-control:focus {
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

    <div class="container-fluid py-4" style="max-width: 700px;">

        <div class="mb-4 border-bottom pb-2">
            <h2 id="lblTitulo" runat="server" class="fw-bold text-dark mb-1">Agregar Nueva Marca</h2>
            <p class="text-muted mb-0">Ingrese el nombre comercial de la marca</p>
        </div>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-4 p-md-5">

                <div class="mb-2">
                    <label for="txtNombre" class="form-label">Nombre de la Marca *</label>
                    <div class="input-group input-group-lg">
                        <span class="input-group-text bg-light border-end-0">
                            <span class="material-symbols-outlined text-muted">sell</span>
                        </span>
                        <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control border-start-0" placeholder="Ej: Arcor, Coca-Cola, Marolio..." />
                    </div>
                    <asp:RequiredFieldValidator ErrorMessage="Debe ingresar el nombre de la marca" ControlToValidate="txtNombre" runat="server" CssClass="validator" Display="Dynamic" />
                    <asp:Label ID="lblError" runat="server" CssClass="text-danger fw-bold d-block mt-2"></asp:Label>
                </div>

            </div>

            <div class="card-footer bg-light p-4 border-top-0 rounded-bottom-4 d-flex justify-content-end gap-3">
                <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-toggle="modal" data-bs-target="#modalCancelar">
                    Cancelar
                </button>

                <button type="button" id="btnProcesarUI" runat="server" class="btn btn-success-custom px-4 d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalSeguridadGuardar">
                    <span class="material-symbols-outlined fs-5">save</span> Guardar Marca
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
                    <p class="text-muted">Si cancelas ahora, no se guardarán los cambios realizados en esta marca.</p>
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
                    <h4 class="fw-bold text-dark">¿Guardar marca?</h4>
                    <p class="text-muted">Por favor, verificá que el nombre ingresado sea correcto antes de confirmar.</p>
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
                    <a href="Marcas.aspx" class="btn btn-success-custom px-5 fw-bold">Ir al Listado de Marcas</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function mostrarModalExito() {
            var modalSeguridad = bootstrap.Modal.getInstance(document.getElementById('modalSeguridadGuardar'));
            if(modalSeguridad) modalSeguridad.hide();

            var myModal = new bootstrap.Modal(document.getElementById('modalExito'));
            myModal.show();
        }
        
        function cerrarModalSeguridad() {
             var myModal = bootstrap.Modal.getInstance(document.getElementById('modalSeguridadGuardar'));
             if(myModal) myModal.hide();
        }
    </script>

</asp:Content>
