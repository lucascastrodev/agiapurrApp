<%@ Page Title="Gestión de Ventas" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Ventas.aspx.cs" Inherits="TPC_Equipo20B.Ventas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        /* Estilos para badges de Estado tipo Dashboard */
        .badge.bg-success.bg-opacity-10 {
            background-color: rgba(25, 135, 84, 0.1) !important;
            color: #198754 !important;
            border-color: #198754 !important;
        }

        .badge.bg-warning.bg-opacity-10 {
            background-color: rgba(255, 193, 7, 0.1) !important;
            color: #997404 !important;
            border-color: #ffc107 !important;
        }

        .badge.bg-danger.bg-opacity-10 {
            background-color: rgba(220, 53, 69, 0.1) !important;
            color: #dc3545 !important;
            border-color: #dc3545 !important;
        }

        .badge.bg-info.bg-opacity-10 {
            background-color: rgba(13, 202, 240, 0.1) !important;
            color: #087990 !important;
            border-color: #0dcaf0 !important;
        }

        .text-nowrap {
            white-space: nowrap !important;
        }

        .col-flexible {
            white-space: normal !important;
        }

        .btn-grilla {
            border-radius: 6px;
            font-size: 0.85rem;
            padding: 0.3rem 0.6rem;
            font-weight: 600;
        }
    </style>

    <asp:HiddenField ID="hfVentaId" runat="server" />

    <div class="d-flex align-items-center justify-content-between mb-4">
        <h2 id="lblTituloPagina" runat="server" class="page-title m-0">Gestión de Ventas</h2>

        <asp:LinkButton ID="btnNuevaVenta" runat="server" CssClass="btn btn-success btn-principal" OnClick="btnNuevaVenta_Click">
        </asp:LinkButton>
    </div>

    <asp:Panel runat="server" DefaultButton="btnBuscarVenta" CssClass="toolbar d-flex gap-2 mb-4">
        <asp:TextBox ID="txtBuscarVenta" runat="server" CssClass="form-control" placeholder="Buscar por cliente, N° de remito..."></asp:TextBox>

        <asp:Button ID="btnBuscarVenta" runat="server" CssClass="btn btn-primary btn-principal px-4" Text="Buscar" OnClick="btnBuscarVenta_Click" UseSubmitBehavior="false" />
    </asp:Panel>

    <div class="grid card shadow-sm">
        <div class="card-body p-0">
            <asp:GridView ID="gvVentas" runat="server" AutoGenerateColumns="False"
                CssClass="table table-hover align-middle text-center mb-0"
                DataKeyNames="Id"
                OnRowCommand="gvVentas_RowCommand"
                OnRowDataBound="gvVentas_RowDataBound"
                AllowPaging="True" PageSize="10"
                OnPageIndexChanging="gvVentas_PageIndexChanging"
                GridLines="None">

                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="N° Venta" />
                    <asp:BoundField DataField="Fecha" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" />

                    <asp:TemplateField HeaderText="Cliente" ItemStyle-CssClass="text-start col-flexible" HeaderStyle-CssClass="text-start">
                        <ItemTemplate><%# Eval("Cliente.Nombre") %></ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="TipoVentaBadge" HeaderText="Tipo Venta" HtmlEncode="false" ItemStyle-CssClass="align-middle" />

                    <asp:BoundField DataField="NumeroFactura" HeaderText="N° Remito" />
                    <asp:BoundField DataField="MetodoPago" HeaderText="Método de Pago" />
                    
                    <asp:BoundField DataField="TotalBD" HeaderText="Total" DataFormatString="{0:C}" ItemStyle-CssClass="fw-bold text-nowrap" />

                    <asp:TemplateField HeaderText="Estado" ItemStyle-Width="130px">
                        <ItemTemplate>
                            <span class='badge border rounded-pill px-3 py-2 w-100 <%# ObtenerCssPorEstado(Eval("Estado")) %>'>
                                <%# FormatearEstadoTexto(Eval("Estado")) %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField ItemStyle-CssClass="col-acciones text-nowrap">
                        <HeaderTemplate>
                            <span class="text-dark fw-bold">Acciones</span>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:LinkButton ID="cmdDetalle" runat="server" CommandName="Detalle" CommandArgument='<%# Eval("Id") %>'
                                CssClass="btn btn-info text-white btn-grilla me-1 shadow-sm">
                                <i class="bi bi-eye-fill"></i> Detalle
                            </asp:LinkButton>

                            <asp:LinkButton ID="cmdEditar" runat="server" CommandName="Editar" CommandArgument='<%# Eval("Id") %>'
                                CssClass="btn btn-warning text-dark btn-grilla me-1 shadow-sm">
                                <i class="bi bi-pencil-square"></i> Editar
                            </asp:LinkButton>

                            <asp:LinkButton ID="cmdEntregar" runat="server"
                                CssClass="btn btn-success btn-grilla me-1 shadow-sm"
                                OnClientClick='<%# "abrirModalEntrega(" + Eval("Id") + "); return false;" %>'>
                                <i class="bi bi-truck"></i> Entregar
                            </asp:LinkButton>

                            <asp:LinkButton ID="cmdCancelar" runat="server" CommandName="Cancelar" CommandArgument='<%# Eval("Id") %>'
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

    <div class="modal fade" id="modalConfirmarEntrega" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-header border-bottom-0 pb-0">
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center pt-0 pb-4 px-4">
                    <div class="mb-3 text-success">
                        <i class="bi bi-check-circle" style="font-size: 5rem;"></i>
                    </div>
                    <h4 class="fw-bold text-dark mb-2">Confirmar Entrega</h4>
                    <p class="text-muted mb-0">¿Estás seguro de que deseas marcar este pedido como <b>Entregado</b>? Esta acción no se puede deshacer.</p>
                </div>
                <div class="modal-footer bg-light border-top-0 justify-content-center gap-2 rounded-bottom-4 py-3">
                    <button type="button" class="btn btn-outline-secondary fw-bold px-4" data-bs-dismiss="modal">Cancelar</button>
                    <asp:Button ID="btnConfirmarEntrega" runat="server" Text="Sí, entregar pedido" CssClass="btn btn-success px-4 fw-bold" OnClick="btnConfirmarEntrega_Click" />
                </div>
            </div>
        </div>
    </div>

    <script>
        function abrirModalEntrega(idVenta) {
            document.getElementById('<%= hfVentaId.ClientID %>').value = idVenta;
            var myModal = new bootstrap.Modal(document.getElementById('modalConfirmarEntrega'));
            myModal.show();
        }
    </script>
</asp:Content>
