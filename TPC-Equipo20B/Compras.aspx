<%@ Page Title="Compras" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Compras.aspx.cs" Inherits="TPC_Equipo20B.Compras" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex align-items-center justify-content-between mb-4">
        <h2 class="page-title m-0">Gestión de Compras</h2>

        <asp:LinkButton ID="btnNuevaCompra" runat="server" CssClass="btn btn-success btn-principal" OnClick="btnNuevaCompra_Click">
            <i class="bi bi-plus-lg"></i> Nueva Compra
        </asp:LinkButton>
    </div>

    <asp:Panel runat="server" DefaultButton="btnBuscarCompra" CssClass="toolbar d-flex gap-2 mb-4">
        <asp:TextBox ID="txtBuscarCompra" runat="server" CssClass="form-control" placeholder="Buscar por proveedor, usuario u observaciones…"></asp:TextBox>

        <asp:Button ID="btnBuscarCompra" runat="server" CssClass="btn btn-primary btn-principal px-4" Text="Buscar" OnClick="btnBuscarCompra_Click" UseSubmitBehavior="false" />
    </asp:Panel>

    <div class="grid card shadow-sm">
        <div class="card-body p-0">
            <asp:GridView ID="gvCompras" runat="server" AutoGenerateColumns="False"
                CssClass="table table-hover align-middle text-center mb-0" DataKeyNames="Id"
                OnRowCommand="gvCompras_RowCommand"
                OnRowDataBound="gvCompras_RowDataBound"
                AllowPaging="True" PageSize="10"
                OnPageIndexChanging="gvCompras_PageIndexChanging"
                GridLines="None">
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="N° Compra" />
                    <asp:BoundField DataField="Fecha" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" />

                    <asp:TemplateField HeaderText="Proveedor">
                        <ItemTemplate><%# Eval("Proveedor.Nombre") %></ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="Observaciones" HeaderText="Observaciones" />

                    <asp:TemplateField HeaderText="Estado">
                        <ItemTemplate>
                            <%# (bool)Eval("Cancelada") 
                             ? "<span class='badge bg-danger'>Cancelada</span>" 
                             : "<span class='badge bg-success'>Activa</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Usuario">
                        <ItemTemplate><%# Eval("Usuario.Nombre") %></ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField ItemStyle-CssClass="col-acciones">
                        <HeaderTemplate>
                            <span class="text-dark fw-bold">Acciones</span>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:LinkButton ID="cmdDetalle" runat="server" CommandName="Detalle" CommandArgument='<%# Eval("Id") %>'
                                CssClass="btn btn-info text-white btn-grilla me-1 shadow-sm">
                                <i class="bi bi-eye-fill"></i> Detalle
                            </asp:LinkButton>

                            <asp:LinkButton ID="cmdEliminar" runat="server" CommandName="Eliminar" CommandArgument='<%# Eval("Id") %>'
                                CssClass="btn btn-danger btn-grilla shadow-sm">
                                <i class="bi bi-x-circle-fill"></i> Cancelar
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

                <PagerStyle CssClass="p-3 border-top paginador-grid" HorizontalAlign="Center" />
            </asp:GridView>
        </div>
    </div>
</asp:Content>
