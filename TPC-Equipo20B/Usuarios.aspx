<%@ Page Title="Gestión de Usuarios" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Usuarios.aspx.cs" Inherits="TPC_Equipo20B.Usuarios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .fila-admin td {
            background-color: #e7f1ff !important;
        }
    </style>

    <div class="d-flex align-items-center justify-content-between mb-4">
        <h2 class="page-title m-0">Gestión de Usuarios</h2>
    </div>

    <asp:Panel ID="pnlBusquedaUsuarios" runat="server" DefaultButton="btnBuscarUsuario">

        <div class="toolbar d-flex gap-2 mb-4">
            <asp:TextBox ID="txtBuscarUsuario" runat="server" CssClass="form-control" placeholder="Buscar usuario o email…" />

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
</asp:Content>
