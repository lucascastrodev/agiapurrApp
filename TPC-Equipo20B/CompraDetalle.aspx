<%@ Page Title="Detalle de Compra" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="CompraDetalle.aspx.cs" Inherits="TPC_Equipo20B.CompraDetalle" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-center align-items-center" style="min-height:80vh;">
        <div class="card shadow-lg border-0" style="width: 700px; max-width: 95%;">
            <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                <h4 class="mb-0"><i class="bi bi-box-seam me-2"></i>Detalle de Compra</h4>
                <asp:Button ID="btnCerrar" runat="server" Text="✖"
                    CssClass="btn btn-light btn-sm fw-bold"
                    OnClick="btnCerrar_Click" />
            </div>

            <div runat="server" id="panelCancelada" visible="false"
                    class="alert alert-danger fw-bold">
                    <i class="bi bi-x-circle"></i>
                    Esta compra está cancelada.<br />
                Motivo: <asp:Label ID="lblMotivo" runat="server" /><br />
                Fecha: <asp:Label ID="lblFechaCanc" runat="server" /><br />
                    Usuario: <asp:Label ID="lblUsuarioCanc" runat="server" />
                        </div>


            <div class="card-body">
                <div class="mb-3">
                    <strong>Proveedor:</strong> <asp:Label ID="lblProveedor" runat="server" CssClass="ms-1" />
                </div>
                <div class="mb-3">
                    <strong>Fecha:</strong> <asp:Label ID="lblFecha" runat="server" CssClass="ms-1" />
                </div>
                <div class="mb-3">
                    <strong>Registrado por:</strong> <asp:Label ID="lblUsuario" runat="server" CssClass="ms-1" />
                </div>
                <div class="mb-3">
                    <strong>Observaciones:</strong> <asp:Label ID="lblObservaciones" runat="server" CssClass="ms-1" />
                </div>
            </div>

            <div class="table-responsive px-3">
                <asp:GridView ID="gvLineas" runat="server" AutoGenerateColumns="False"
                    CssClass="table table-sm table-striped align-middle mb-0">
                    <HeaderStyle CssClass="table-success" />
                    <Columns>
                        <asp:BoundField DataField="Producto.Descripcion" HeaderText="Producto" />
                        <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="PrecioUnitario" HeaderText="Precio Unitario" DataFormatString="{0:C}" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="Subtotal" HeaderText="Subtotal" DataFormatString="{0:C}" ItemStyle-HorizontalAlign="Right" />
                    </Columns>
                </asp:GridView>
            </div>

            <div class="card-footer d-flex justify-content-end bg-light">
                <h5 class="fw-bold text-end mb-0">Total: <asp:Label ID="lblTotal" runat="server" CssClass="text-success fw-bold" /></h5>
            </div>
        </div>
    </div>
</asp:Content>
