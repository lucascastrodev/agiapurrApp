<%@ Page Title="Agregar Cliente" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="AgregarCliente.aspx.cs" Inherits="TPC_Equipo20B.AgregarCliente" %>

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
    </style>

    <div class="container-fluid py-4 max-w-1200" style="max-width: 1000px;">

        <div class="mb-4">
            <h2 id="lblTitulo" runat="server" class="fw-bold text-dark mb-1">Agregar Nuevo Cliente</h2>
            <p class="text-muted">Complete los datos de la cuenta comercial</p>
        </div>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-4 p-md-5">
                <div class="row g-4">

                    <div class="col-md-6">
                        <label for="txtNombre" class="form-label">Nombre y Apellido *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <span class="material-symbols-outlined text-muted">badge</span>
                            </span>
                            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control border-start-0" placeholder="Nombre y Apellido del cliente" />
                        </div>
                        <asp:RequiredFieldValidator ErrorMessage="Ingrese nombre del cliente" ControlToValidate="txtNombre" runat="server" CssClass="validator" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revNombre" runat="server" ControlToValidate="txtNombre" ErrorMessage="Solo letras y espacios" CssClass="validator" Display="Dynamic" SetFocusOnError="true" ValidationExpression="^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$" />
                    </div>

                    <div class="col-md-6">
                        <label for="txtDocumento" class="form-label">Documento / CUIT *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <span class="material-symbols-outlined text-muted">credit_card</span>
                            </span>
                            <asp:TextBox ID="txtDocumento" runat="server" CssClass="form-control border-start-0" placeholder="Ej: 30123456789" />
                        </div>
                        <asp:RequiredFieldValidator ErrorMessage="Ingrese documento del cliente" ControlToValidate="txtDocumento" runat="server" CssClass="validator" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revSoloNumeros" runat="server" ControlToValidate="txtDocumento" ErrorMessage="Este campo solo acepta números." CssClass="validator" Display="Dynamic" ValidationExpression="^\d+$" />
                        <asp:Label ID="lblError" runat="server" CssClass="text-danger fw-bold d-block mt-1"></asp:Label>
                    </div>

                    <div class="col-md-6">
                        <label for="txtEmail" class="form-label">Correo Electrónico *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <span class="material-symbols-outlined text-muted">mail</span>
                            </span>
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control border-start-0" placeholder="correo@cliente.com" />
                        </div>
                        <asp:RequiredFieldValidator ID="rfvEmail" ErrorMessage="Ingresar un Mail" ControlToValidate="txtEmail" runat="server" CssClass="validator" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Formato de email no válido." CssClass="validator" Display="Dynamic" SetFocusOnError="true" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" />
                    </div>

                    <div class="col-md-6">
                        <label for="txtTelefono" class="form-label">Teléfono *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <span class="material-symbols-outlined text-muted">phone</span>
                            </span>
                            <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control border-start-0" placeholder="Ej: 011-4321-5678" />
                        </div>
                        <asp:RequiredFieldValidator ID="rfvTelefono" ErrorMessage="Ingresa Telefono del cliente" ControlToValidate="txtTelefono" runat="server" CssClass="validator" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revTelefono" runat="server" ControlToValidate="txtTelefono" ErrorMessage="Solo números y guiones." CssClass="validator" Display="Dynamic" SetFocusOnError="true" ValidationExpression="^[\d-]+$" />
                    </div>

                    <div class="col-md-6">
                        <label for="txtDireccion" class="form-label">Dirección *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <span class="material-symbols-outlined text-muted">home</span>
                            </span>
                            <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control border-start-0" placeholder="Ej: Av. Belgrano 1234" />
                        </div>
                        <asp:RequiredFieldValidator ErrorMessage="Ingresar dirección del cliente" ControlToValidate="txtDireccion" runat="server" CssClass="validator" Display="Dynamic" />
                    </div>

                    <div class="col-md-6">
                        <label for="txtLocalidad" class="form-label">Localidad *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <span class="material-symbols-outlined text-muted">location_city</span>
                            </span>
                            <asp:TextBox ID="txtLocalidad" runat="server" CssClass="form-control border-start-0" placeholder="Ej: CABA" />
                        </div>
                        <asp:RequiredFieldValidator ErrorMessage="Ingresar localidad del cliente" ControlToValidate="txtLocalidad" runat="server" CssClass="validator" Display="Dynamic" />
                    </div>

                    <div class="col-md-6">
                        <label for="ddlCondicionIVA" class="form-label">Condición IVA *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <span class="material-symbols-outlined text-muted">account_balance</span>
                            </span>
                            <asp:DropDownList ID="ddlCondicionIVA" runat="server" CssClass="form-select border-start-0">
                                <asp:ListItem Text="Seleccione..." />
                                <asp:ListItem Text="Responsable Inscripto" />
                                <asp:ListItem Text="Monotributista" />
                                <asp:ListItem Text="Consumidor Final" />
                                <asp:ListItem Text="Exento" />
                            </asp:DropDownList>
                        </div>
                        <asp:RequiredFieldValidator ErrorMessage="Seleccione condición IVA" CssClass="validator" ControlToValidate="ddlCondicionIVA" runat="server" InitialValue="Seleccione..." Display="Dynamic" />
                    </div>

                    <div class="col-12 mt-4 pt-2 border-top">
                        <label for="txtObservaciones" class="form-label">Entre Calles / Observaciones *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 align-items-start pt-2">
                                <span class="material-symbols-outlined text-muted">map</span>
                            </span>
                            <asp:TextBox ID="txtObservaciones" runat="server" CssClass="form-control border-start-0" TextMode="MultiLine" Rows="3" placeholder="Ej: Entre San Martín y Belgrano. Casa con portón negro." />
                        </div>
                        <asp:RequiredFieldValidator ErrorMessage="Es obligatorio ingresar indicaciones o entre calles para el envío" ControlToValidate="txtObservaciones" runat="server" CssClass="validator" Display="Dynamic" />
                    </div>

                </div>
            </div>

            <div class="card-footer bg-light p-4 border-top-0 rounded-bottom-4 d-flex justify-content-end gap-3">
                <button type="button" class="btn btn-outline-secondary px-4 fw-bold" data-bs-toggle="modal" data-bs-target="#modalCancelar">
                    Cancelar
                </button>

                <button type="button" id="btnProcesarUI" runat="server" class="btn btn-success-custom px-4 d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalSeguridadGuardar">
                    <span class="material-symbols-outlined fs-5">save</span> Guardar Cliente
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
                    <p class="text-muted">Si cancelas ahora, se perderán todos los datos que hayas ingresado sobre este cliente.</p>
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
                    <h4 class="fw-bold text-dark">¿Guardar cliente?</h4>
                    <p class="text-muted">Por favor, verificá que el documento y la dirección sean correctos antes de confirmar el registro.</p>
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
                    <a href="Clientes.aspx" class="btn btn-success-custom px-5 fw-bold">Ir al Listado de Clientes</a>
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
