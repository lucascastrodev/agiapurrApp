<%@ Page Title="Mi Perfil" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Perfil.aspx.cs" Inherits="TPC_Equipo20B.Perfil" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="page-title mb-0">Mi Perfil</h1>
    </div>

    <!-- Información del Usuario -->
    <div class="row">
        <div class="col-lg-8">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-white">
                    <h5 class="mb-0 fw-bold">Información Personal</h5>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <!-- Nombre -->
                        <div class="col-md-6">
                            <asp:Label ID="lblNombre" runat="server" Text="Nombre" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Ingrese su nombre" />
                            <asp:RequiredFieldValidator ID="valNombre" runat="server"
                                ControlToValidate="txtNombre"
                                ErrorMessage="El nombre es requerido"
                                Display="Static"
                                CssClass="text-danger small"
                                ValidationGroup="Perfil" />
                        </div>

                        <!-- Documento -->
                        <div class="col-md-6">
                            <asp:Label ID="lblDocumento" runat="server" Text="Documento" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtDocumento" runat="server" CssClass="form-control" placeholder="Ingrese su documento" />
                        </div>

                        <!-- Email -->
                        <div class="col-md-6">
                            <asp:Label ID="lblEmail" runat="server" Text="Correo Electrónico" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="correo@ejemplo.com" />
                            <asp:RequiredFieldValidator ID="valEmailRequerido" runat="server"
                                ControlToValidate="txtEmail"
                                ErrorMessage="El correo electrónico es requerido"
                                Display="Static"
                                CssClass="text-danger small"
                                ValidationGroup="Perfil" />
                            <asp:RegularExpressionValidator ID="valEmailFormato" runat="server"
                                ControlToValidate="txtEmail"
                                ErrorMessage="Ingrese un correo electrónico válido"
                                ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"
                                Display="Static"
                                CssClass="text-danger small"
                                ValidationGroup="Perfil" />
                        </div>

                        <!-- Teléfono -->
                        <div class="col-md-6">
                            <asp:Label ID="lblTelefono" runat="server" Text="Teléfono" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" placeholder="Ingrese su teléfono" />
                        </div>

                        <!-- Dirección -->
                        <div class="col-md-6">
                            <asp:Label ID="lblDireccion" runat="server" Text="Dirección" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" placeholder="Ingrese su dirección" />
                        </div>

                        <!-- Localidad -->
                        <div class="col-md-6">
                            <asp:Label ID="lblLocalidad" runat="server" Text="Localidad" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtLocalidad" runat="server" CssClass="form-control" placeholder="Ingrese su localidad" />
                        </div>

                        <!-- Username (solo lectura) -->
                        <div class="col-md-6">
                            <asp:Label ID="lblUsername" runat="server" Text="Nombre de Usuario" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" ReadOnly="true" Enabled="false" />
                            <small class="text-muted">El nombre de usuario no se puede modificar</small>
                        </div>

                        <!-- Rol (solo lectura) -->
                        <div class="col-md-6">
                            <asp:Label ID="lblRol" runat="server" Text="Rol" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtRol" runat="server" CssClass="form-control" ReadOnly="true" Enabled="false" />
                        </div>
                    </div>

                    <div class="mt-4">
                        <asp:Label ID="lblMensaje" runat="server" CssClass="d-block mb-3" EnableViewState="false" />
                        
                        <asp:Button ID="btnGuardar" runat="server"
                            Text="Guardar Cambios"
                            CssClass="btn btn-brand me-2"
                            OnClick="btnGuardar_Click"
                            ValidationGroup="Perfil" />
                        
                        <asp:Button ID="btnCancelar" runat="server"
                            Text="Cancelar"
                            CssClass="btn btn-secondary"
                            OnClick="btnCancelar_Click"
                            CausesValidation="false" />
                    </div>
                </div>
            </div>

            <!-- Cambiar Contraseña -->
            <div class="card shadow-sm">
                <div class="card-header bg-white">
                    <h5 class="mb-0 fw-bold">Cambiar Contraseña</h5>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <!-- Contraseña Actual -->
                        <div class="col-md-12">
                            <asp:Label ID="lblPasswordActual" runat="server" Text="Contraseña Actual" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtPasswordActual" runat="server" TextMode="Password" CssClass="form-control" placeholder="Ingrese su contraseña actual" />
                            <asp:RequiredFieldValidator ID="valPasswordActual" runat="server"
                                ControlToValidate="txtPasswordActual"
                                ErrorMessage="La contraseña actual es requerida"
                                Display="Static"
                                CssClass="text-danger small"
                                ValidationGroup="Password" />
                        </div>

                        <!-- Nueva Contraseña -->
                        <div class="col-md-6">
                            <asp:Label ID="lblPasswordNueva" runat="server" Text="Nueva Contraseña" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtPasswordNueva" runat="server" TextMode="Password" CssClass="form-control" placeholder="Mínimo 6 caracteres" />
                            <asp:RequiredFieldValidator ID="valPasswordNueva" runat="server"
                                ControlToValidate="txtPasswordNueva"
                                ErrorMessage="La nueva contraseña es requerida"
                                Display="Static"
                                CssClass="text-danger small"
                                ValidationGroup="Password" />
                            <asp:RegularExpressionValidator ID="valPasswordLongitud" runat="server"
                                ControlToValidate="txtPasswordNueva"
                                ErrorMessage="La contraseña debe tener al menos 6 caracteres"
                                ValidationExpression=".{6,}"
                                Display="Static"
                                CssClass="text-danger small"
                                ValidationGroup="Password" />
                        </div>

                        <!-- Confirmar Nueva Contraseña -->
                        <div class="col-md-6">
                            <asp:Label ID="lblPasswordConfirmar" runat="server" Text="Confirmar Nueva Contraseña" CssClass="form-label fw-medium" />
                            <asp:TextBox ID="txtPasswordConfirmar" runat="server" TextMode="Password" CssClass="form-control" placeholder="Repita la nueva contraseña" />
                            <asp:RequiredFieldValidator ID="valPasswordConfirmar" runat="server"
                                ControlToValidate="txtPasswordConfirmar"
                                ErrorMessage="Debe confirmar la nueva contraseña"
                                Display="Static"
                                CssClass="text-danger small"
                                ValidationGroup="Password" />
                            <asp:CompareValidator ID="valPasswordMatch" runat="server"
                                ControlToValidate="txtPasswordConfirmar"
                                ControlToCompare="txtPasswordNueva"
                                ErrorMessage="Las contraseñas no coinciden"
                                Display="Static"
                                CssClass="text-danger small"
                                ValidationGroup="Password" />
                        </div>
                    </div>

                    <div class="mt-4">
                        <asp:Label ID="lblMensajePassword" runat="server" CssClass="d-block mb-3" EnableViewState="false" />
                        
                        <asp:Button ID="btnCambiarPassword" runat="server"
                            Text="Cambiar Contraseña"
                            CssClass="btn btn-brand"
                            OnClick="btnCambiarPassword_Click"
                            ValidationGroup="Password" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Información de la Cuenta -->
        <div class="col-lg-4">
            <div class="card shadow-sm">
                <div class="card-header bg-white">
                    <h5 class="mb-0 fw-bold">Información de la Cuenta</h5>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <small class="text-muted d-block mb-1">ID de Usuario</small>
                        <strong><asp:Label ID="lblUsuarioId" runat="server" /></strong>
                    </div>
                    <div class="mb-3">
                        <small class="text-muted d-block mb-1">Estado</small>
                        <span class="badge bg-success">Activo</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>