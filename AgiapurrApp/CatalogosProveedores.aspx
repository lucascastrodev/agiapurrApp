<%@ Page Title="Catálogos de Proveedores" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CatalogosProveedores.aspx.cs" Inherits="AgiapurrApp.CatalogosProveedores" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />
    <style>
        .proveedor-select {
            max-width: 400px;
            border-color: #6610f2;
            border-width: 2px;
        }

            .proveedor-select:focus {
                box-shadow: 0 0 0 0.25rem rgba(102, 16, 242, 0.25);
                border-color: #6610f2;
            }

        .btn-proveedor {
            background-color: #6610f2;
            color: white;
            border: none;
        }

            .btn-proveedor:hover {
                background-color: #520dc2;
                color: white;
            }

        .error-flotante {
            color: #dc3545;
            font-size: 0.85em;
            font-weight: 500;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
        <div>
            <h2 class="page-title text-dark m-0 d-flex align-items-center gap-2">
                <span class="material-symbols-outlined text-primary fs-2" style="color: #6610f2 !important;">inventory_2</span>
                Catálogos de Proveedores
            </h2>
            <p class="text-muted m-0 mt-1">Administre las listas de precios y presentaciones comerciales.</p>
        </div>
    </div>

    <div class="bg-light p-4 rounded-4 mb-4 border shadow-sm d-flex gap-3 align-items-end">
        <div class="flex-grow-1" style="max-width: 400px;">
            <label class="form-label fw-bold text-muted small text-uppercase">Seleccione un Proveedor</label>
            <asp:DropDownList ID="ddlProveedor" runat="server" CssClass="form-select form-select-lg proveedor-select" AutoPostBack="true" OnSelectedIndexChanged="ddlProveedor_SelectedIndexChanged">
            </asp:DropDownList>
        </div>
        <div>
            <asp:LinkButton ID="btnNuevo" runat="server" CssClass="btn btn-proveedor btn-lg px-4 fw-bold shadow-sm d-flex align-items-center gap-2" OnClick="btnNuevo_Click" Visible="false">
                <span class="material-symbols-outlined">add_circle</span> Nuevo Producto
            </asp:LinkButton>
        </div>
    </div>

    <asp:Label ID="lblMensajeVacio" runat="server" CssClass="d-block text-center text-muted p-5 bg-white border rounded-4 shadow-sm" Visible="false">
        <span class="material-symbols-outlined d-block mb-2" style="font-size: 3rem; opacity: 0.3;">search</span>
        Seleccione un proveedor para ver su catálogo.
    </asp:Label>

    <div class="grid" id="divGrilla" runat="server" visible="false">
        <div class="table-responsive bg-white rounded-4 border shadow-sm overflow-hidden">
            <asp:GridView ID="gvCatalogo" runat="server" AutoGenerateColumns="false" CssClass="table table-hover align-middle mb-0" GridLines="None" OnRowCommand="gvCatalogo_RowCommand">
                <Columns>
                    <asp:BoundField DataField="Codigo" HeaderText="Cód." ItemStyle-CssClass="fw-bold text-muted small" />
                    <asp:BoundField DataField="Descripcion" HeaderText="Descripción" ItemStyle-CssClass="fw-medium text-dark text-start" HeaderStyle-CssClass="text-start" />
                    <asp:BoundField DataField="UnidadesPorPack" HeaderText="Unid/Pack" ItemStyle-CssClass="text-center fw-bold" />
                    <asp:BoundField DataField="PrecioUnitario" HeaderText="Precio Unit." DataFormatString="{0:C}" ItemStyle-CssClass="text-end text-success fw-bold" HeaderStyle-CssClass="text-end" />
                    <asp:BoundField DataField="PorcentajeDescuento" HeaderText="Desc." DataFormatString="{0:0.##}%" ItemStyle-CssClass="text-center text-danger" />

                    <asp:TemplateField HeaderText="Acciones" ItemStyle-CssClass="col-acciones">
                        <ItemTemplate>
                            <div class="d-flex gap-2 justify-content-center">
                                <asp:LinkButton runat="server" CommandName="Editar" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-outline-primary btn-grilla px-3">
                                    Editar
                                </asp:LinkButton>
                                <asp:LinkButton runat="server" CommandName="Eliminar" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-outline-danger btn-grilla px-3" OnClientClick="return confirm('¿Seguro que desea eliminar este producto del catálogo?');">
                                    Eliminar
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <div class="modal fade" id="modalABM" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-header border-bottom-0 pb-3 bg-light rounded-top-4">
                    <h5 class="fw-bold text-dark mb-0 d-flex align-items-center gap-2">
                        <span class="material-symbols-outlined text-primary" style="color: #6610f2 !important;">inventory</span>
                        <asp:Label ID="lblModalTitulo" runat="server">Nuevo Producto</asp:Label>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body px-4 pt-4 pb-2">

                    <asp:HiddenField ID="hdfIdProducto" runat="server" Value="0" />

                    <div class="mb-3">
                        <label class="form-label small fw-bold">Código (SKU Proveedor)</label>
                        <asp:TextBox ID="txtCodigo" runat="server" CssClass="form-control" placeholder="Ej: 58-193 (Dejar '-' si no tiene)"></asp:TextBox>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-bold">Descripción *</label>
                        <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" placeholder="Ej: Yerba Mate Orgánica x 1 kg"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtDescripcion" ErrorMessage="Obligatorio" ValidationGroup="ABM" CssClass="error-flotante" Display="Dynamic" />
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-bold">Costo Unitario *</label>
                            <div class="input-group">
                                <span class="input-group-text">$</span>
                                <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control" placeholder="0,00"></asp:TextBox>
                            </div>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPrecio" ErrorMessage="Obligatorio" ValidationGroup="ABM" CssClass="error-flotante" Display="Dynamic" />
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-bold">Unidades x Pack *</label>
                            <asp:TextBox ID="txtPack" runat="server" CssClass="form-control" TextMode="Number" Text="1" min="1"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPack" ErrorMessage="Obligatorio" ValidationGroup="ABM" CssClass="error-flotante" Display="Dynamic" />
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label small fw-bold">Descuento (%)</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtDescuento" runat="server" CssClass="form-control" placeholder="0,00" Text="0,00"></asp:TextBox>
                            <span class="input-group-text">%</span>
                        </div>
                    </div>

                </div>
                <div class="modal-footer bg-light border-top-0 rounded-bottom-4 py-3">
                    <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar Producto" CssClass="btn btn-proveedor fw-bold px-4" ValidationGroup="ABM" OnClick="btnGuardar_Click" />
                </div>
            </div>
        </div>
    </div>

</asp:Content>
