<%@ Page Title="Gestión de Clientes" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Clientes.aspx.cs" Inherits="TPC_Equipo20B.Clientes" %>

<asp:Content ID="HeadContentCli" ContentPlaceHolderID="HeadContent" runat="server" />
<asp:Content ID="MainContentCli" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex align-items-center justify-content-between mb-4">
        <h2 class="page-title m-0">Gestión de Clientes</h2>

        <asp:HyperLink ID="lnkAgregar" runat="server" NavigateUrl="~/AgregarCliente.aspx" CssClass="btn btn-success btn-principal">
            <i class="bi bi-plus-lg"></i> Agregar Cliente
        </asp:HyperLink>
    </div>

    <asp:Panel runat="server" DefaultButton="btnBuscar" CssClass="toolbar d-flex gap-2 mb-4">
        <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Buscar cliente por nombre o documento…" />

        <asp:Button ID="btnBuscar" runat="server" CssClass="btn btn-primary btn-principal px-4" Text="Buscar" OnClick="btnBuscar_Click" UseSubmitBehavior="false" />
    </asp:Panel>

    <div class="grid card shadow-sm">
        <div class="card-body p-0">
            <asp:GridView ID="gvClientes" runat="server"
                CssClass="table table-hover align-middle text-center mb-0"
                AutoGenerateColumns="False"
                AllowPaging="true" PageSize="10"
                OnPageIndexChanging="gvClientes_PageIndexChanging"
                OnRowDataBound="gvClientes_RowDataBound"
                GridLines="None">
                <Columns>
                    <asp:BoundField DataField="Nombre" HeaderText="Cliente" ItemStyle-CssClass="fw-bold" />
                    <asp:BoundField DataField="Documento" HeaderText="Documento" />
                    <asp:BoundField DataField="Telefono" HeaderText="Teléfono" />
                    <asp:BoundField DataField="NombreVendedor" HeaderText="Vendedor Asignado" />

                    <asp:TemplateField ItemStyle-CssClass="col-acciones">
                        <HeaderTemplate>
                            <span class="text-dark fw-bold">Acciones</span>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:HyperLink ID="lnkEditar" runat="server" CssClass="btn btn-primary btn-grilla me-1 shadow-sm"
                                NavigateUrl='<%# Eval("Id", "~/AgregarCliente.aspx?id={0}") %>'>
                                <i class="bi bi-pencil-square"></i> Editar
                            </asp:HyperLink>

                            <asp:HyperLink ID="lnkEliminar" runat="server" CssClass="btn btn-danger btn-grilla shadow-sm"
                                NavigateUrl='<%# Eval("Id", "~/ConfirmarEliminar.aspx?tipo=Cliente&id={0}") %>'>
                                <i class="bi bi-trash"></i> Eliminar
                            </asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

                <PagerStyle CssClass="p-3 border-top paginador-grid" HorizontalAlign="Center" />
            </asp:GridView>
        </div>
    </div>
</asp:Content>
