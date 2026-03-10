<%@ Page Title="Gestión de Marcas" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Marcas.aspx.cs" Inherits="TPC_Equipo20B.Marcas" %>

<asp:Content ID="HeadContentMarcas" ContentPlaceHolderID="HeadContent" runat="server" />
<asp:Content ID="MainContentMarcas" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-10">

            <div class="d-flex align-items-center justify-content-between mb-4">
                <h2 class="page-title m-0">Gestión de Marcas</h2>
                
                <asp:HyperLink ID="lnkAgregar" runat="server" NavigateUrl="~/AgregarMarca.aspx" CssClass="btn btn-success btn-principal">
                    <i class="bi bi-plus-lg"></i> Agregar Marca
                </asp:HyperLink>
            </div>

            <asp:Panel runat="server" DefaultButton="btnBuscar" CssClass="toolbar d-flex gap-2 mb-4">
                <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Buscar marca..." />
                
                <asp:Button ID="btnBuscar" runat="server" CssClass="btn btn-primary btn-principal px-4" Text="Buscar" OnClick="btnBuscar_Click" UseSubmitBehavior="false" />
            </asp:Panel>

            <div class="grid card shadow-sm">
                <div class="card-body p-0">
                    <asp:GridView ID="gvMarcas" runat="server"
                        CssClass="table table-hover align-middle mb-0"
                        AutoGenerateColumns="False"
                        AllowPaging="true" PageSize="10"
                        DataKeyNames="Id"
                        OnPageIndexChanging="gvMarcas_PageIndexChanging"
                        GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="Nombre" HeaderText="Marca" ItemStyle-CssClass="text-start ps-3 fw-bold" HeaderStyle-CssClass="text-start ps-3" />
                            
                            <asp:TemplateField ItemStyle-CssClass="col-acciones">
                                <HeaderTemplate>
                                    <span class="text-dark fw-bold">Acciones</span>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:HyperLink runat="server" CssClass="btn btn-primary btn-grilla me-1 shadow-sm"
                                        NavigateUrl='<%# Eval("Id", "~/AgregarMarca.aspx?id={0}") %>'>
                                        <i class="bi bi-pencil-square"></i> Editar
                                    </asp:HyperLink>
                                    
                                    <asp:HyperLink runat="server" CssClass="btn btn-danger btn-grilla shadow-sm"
                                        NavigateUrl='<%# Eval("Id", "~/ConfirmarEliminar.aspx?tipo=Marca&id={0}") %>'>
                                        <i class="bi bi-trash"></i> Eliminar
                                    </asp:HyperLink>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        
                        <PagerStyle CssClass="p-3 border-top paginador-grid" HorizontalAlign="Center" />
                    </asp:GridView>
                </div>
            </div>

        </div>
    </div>

</asp:Content>