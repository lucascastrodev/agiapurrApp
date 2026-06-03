<%@ Page Title="Gestión de Usuarios" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Usuarios.aspx.cs" Inherits="TPC_Equipo20B.Usuarios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .fila-admin td {
            background-color: #e7f1ff !important;
        }

        .error-flotante {
            font-size: 0.85em;
            color: #dc3545;
            font-weight: 500;
        }
    </style>

    <div class="d-flex align-items-center justify-content-between mb-4 border-bottom pb-3">
        <h2 class="page-title m-0">Gestión de Usuarios</h2>

        <button type="button" class="btn btn-success fw-bold px-4 d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalNuevoUsuario">
            <i class="bi bi-person-plus-fill"></i>Nuevo Usuario
        </button>
    </div>

    <asp:Panel ID="pnlBusquedaUsuarios" runat="server" DefaultButton="btnBuscarUsuario">

        <div class="toolbar d-flex gap-2 mb-4">
            <asp:TextBox ID="txtBuscarUsuario" runat="server" CssClass="form-control" placeholder="Buscar usuario o email…" MaxLength="50" />
            <asp:Button ID="btnBuscarUsuario" runat="server" Text="Buscar" CssClass="btn btn-primary btn-principal px-4" OnClick="btnBuscarUsuario_Click" />
        </div>

        <div class="grid card shadow-sm">
            <div class="card-body p-0">
                <asp:GridView ID="gvUsuarios" runat="server"
                    CssClass="table table-hover align-middle text-center mb-0"
                    AutoGenerateColumns="False"
                    DataKeyNames="Id"
                    OnRowDataBound="gvUsuarios_RowDataBound"
                    OnRowCommand="gvUsuarios_RowCommand"
                    GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="Username" HeaderText="Usuario" ItemStyle-CssClass="fw-bold" />
                        <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:BoundField DataField="RolDescripcion" HeaderText="Rol" />

                        <asp:TemplateField ItemStyle-CssClass="col-acciones">
                            <HeaderTemplate>
                                <span class="text-dark fw-bold">Acciones</span>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:LinkButton ID="btnCambiarRol" runat="server"
                                    CssClass="btn btn-warning text-dark btn-grilla me-1 shadow-sm"
                                    CommandName="CambiarRol"
                                    CommandArgument='<%# Eval("Id") %>'>
                                </asp:LinkButton>

                                <asp:LinkButton ID="btnEditar" runat="server"
                                    CssClass="btn btn-primary btn-grilla me-1 shadow-sm"
                                    CommandName="EditarUsuario"
                                    CommandArgument='<%# Eval("Id") %>'>
                                    <i class="bi bi-pencil-square"></i> Editar
                                </asp:LinkButton>

                                <asp:LinkButton ID="btnToggleActivo" runat="server"
                                    CssClass="btn btn-grilla shadow-sm"
                                    CommandName="ToggleActivo"
                                    CommandArgument='<%# Eval("Id") %>'>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>

                    <PagerStyle CssClass="p-3 border-top paginador-grid" HorizontalAlign="Center" />
                </asp:GridView>
            </div>
        </div>
    </asp:Panel>

    <div class="modal fade" id="modalNuevoUsuario" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-header border-bottom-0 pb-3 bg-light rounded-top-4">
                    <h5 class="fw-bold text-dark mb-0 d-flex align-items-center gap-2">
                        <i class="bi bi-person-plus text-success fs-4"></i>Crear Usuario
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body px-4 pt-4 pb-2">
                    <div class="alert alert-info py-2 small mb-4">
                        Solo los campos con (*) son obligatorios. Por defecto, la cuenta se creará con el rol <strong>Vendedor</strong>.
                    </div>

                    <div class="mb-3 position-relative" style="padding-bottom: 12px;">
                        <label class="form-label small fw-bold">Nombre Completo *</label>
                        <asp:TextBox ID="txtNuevoNombre" runat="server" CssClass="form-control" placeholder="Ej: Juan Pérez" MaxLength="100"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNuevoNombre" ErrorMessage="Obligatorio" ValidationGroup="NuevoUser" CssClass="error-flotante" Display="Dynamic" />
                    </div>

                    <div class="mb-3 position-relative" style="padding-bottom: 12px;">
                        <label class="form-label small fw-bold">Correo Electrónico *</label>
                        <asp:TextBox ID="txtNuevoEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="correo@ejemplo.com" MaxLength="100"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNuevoEmail" ErrorMessage="Obligatorio" ValidationGroup="NuevoUser" CssClass="error-flotante" Display="Dynamic" />
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtNuevoEmail" ErrorMessage="Formato inválido" ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" ValidationGroup="NuevoUser" CssClass="error-flotante ms-5 ps-4" Display="Dynamic" />
                    </div>

                    <div class="mb-3 position-relative" style="padding-bottom: 12px;">
                        <label class="form-label small fw-bold">Nombre de Usuario (Login) *</label>
                        <asp:TextBox ID="txtNuevoUsername" runat="server" CssClass="form-control" placeholder="Ej: jperez" MaxLength="50"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNuevoUsername" ErrorMessage="Obligatorio" ValidationGroup="NuevoUser" CssClass="error-flotante" Display="Dynamic" />
                    </div>

                    <div class="mb-4 position-relative" style="padding-bottom: 12px;">
                        <label class="form-label small fw-bold">Contraseña Inicial *</label>
                        <asp:TextBox ID="txtNuevoPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Mínimo 6 caracteres" MaxLength="50"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNuevoPassword" ErrorMessage="Obligatorio" ValidationGroup="NuevoUser" CssClass="error-flotante" Display="Dynamic" />
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtNuevoPassword" ErrorMessage="Mínimo 6 caracteres" ValidationExpression=".{6,}" ValidationGroup="NuevoUser" CssClass="error-flotante ms-5 ps-3" Display="Dynamic" />
                    </div>

                    <div class="text-end mb-2">
                        <asp:Label ID="lblErrorModal" runat="server" CssClass="text-danger small fw-bold" EnableViewState="false"></asp:Label>
                    </div>
                </div>

                <div class="modal-footer bg-light border-top-0 rounded-bottom-4 py-3">
                    <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                    <asp:Button ID="btnGuardarUsuarioModal" runat="server" Text="Dar de Alta" CssClass="btn btn-success fw-bold px-4" ValidationGroup="NuevoUser" OnClick="btnGuardarUsuarioModal_Click" />
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="modalExitoUsuario" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-body text-center pt-5 pb-4 px-4">
                    <i class="bi bi-check-circle text-success mb-3" style="font-size: 4rem;"></i>
                    <h4 class="fw-bold text-dark">¡Usuario Creado!</h4>
                    <p class="text-muted">El empleado ya puede acceder al sistema con sus credenciales.</p>
                </div>
                <div class="modal-footer bg-light justify-content-center border-top-0 rounded-bottom-4 py-3">
                    <button type="button" class="btn btn-success px-4 fw-bold" data-bs-dismiss="modal">Entendido</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
