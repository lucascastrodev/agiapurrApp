<%@ Page Title="Pedidos a Proveedores" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="PedidosProveedores.aspx.cs" Inherits="TPC_Equipo20B.PedidosProveedores" %>

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

        /* --- DISTINTIVO SUTIL PARA PROVEEDORES (ÍNDIGO/VIOLETA) --- */
        .text-proveedores {
            color: #6610f2 !important;
        }

        .btn-proveedores {
            background-color: #6610f2;
            color: white;
            border-color: #6610f2;
            font-weight: 600;
        }

            .btn-proveedores:hover {
                background-color: #520dc2;
                color: white;
                border-color: #520dc2;
            }

        .icon-title-bg {
            background-color: rgba(102, 16, 242, 0.1);
            padding: 8px 12px;
            border-radius: 8px;
            margin-right: 10px;
        }
    </style>

    <asp:HiddenField ID="hfPedidoId" runat="server" />

    <div class="d-flex align-items-center justify-content-between mb-4">
        <h2 id="lblTituloPagina" runat="server" class="page-title m-0 d-flex align-items-center">
            <span class="icon-title-bg text-proveedores"><i class="bi bi-truck"></i></span>
            Pedidos a Proveedores
        </h2>

        <asp:LinkButton ID="btnNuevoPedido" runat="server" CssClass="btn btn-proveedores px-4 shadow-sm" OnClick="btnNuevoPedido_Click">
            <i class="bi bi-plus-lg me-1"></i> Nuevo Pedido
        </asp:LinkButton>
    </div>

    <asp:Panel runat="server" DefaultButton="btnBuscarPedido" CssClass="toolbar d-flex gap-2 mb-4">
        <asp:TextBox ID="txtBuscarPedido" runat="server" CssClass="form-control" placeholder="Buscar por proveedor, N° de pedido..."></asp:TextBox>

        <asp:Button ID="btnBuscarPedido" runat="server" CssClass="btn btn-outline-secondary px-4 fw-bold" Text="Buscar" OnClick="btnBuscarPedido_Click" UseSubmitBehavior="false" />
    </asp:Panel>

    <div class="grid card shadow-sm border-0 rounded-4">
        <div class="card-body p-0">
            <asp:GridView ID="gvPedidos" runat="server" AutoGenerateColumns="False"
                CssClass="table table-hover align-middle text-center mb-0"
                DataKeyNames="Id"
                OnRowCommand="gvPedidos_RowCommand"
                OnRowDataBound="gvPedidos_RowDataBound"
                AllowPaging="True" PageSize="10"
                OnPageIndexChanging="gvPedidos_PageIndexChanging"
                GridLines="None">

                <HeaderStyle CssClass="bg-light text-secondary text-uppercase small" />

                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="N° Pedido" ItemStyle-CssClass="fw-bold" />
                    <asp:BoundField DataField="FechaEmision" HeaderText="Fecha Emisión" DataFormatString="{0:dd/MM/yyyy}" />

                    <asp:TemplateField HeaderText="Proveedor" ItemStyle-CssClass="text-start col-flexible fw-medium" HeaderStyle-CssClass="text-start">
                        <ItemTemplate><%# Eval("Proveedor.Nombre") %></ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="TotalEstimado" HeaderText="Costo Estimado" DataFormatString="{0:C}" ItemStyle-CssClass="fw-bold text-nowrap text-secondary" />

                    <asp:TemplateField HeaderText="Estado" ItemStyle-Width="130px">
                        <ItemTemplate>
                            <span class='badge border rounded-pill px-3 py-2 w-100 <%# ObtenerCssPorEstado(Eval("Estado")) %>'>
                                <%# FormatearEstadoTexto(Eval("Estado")) %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField ItemStyle-CssClass="col-acciones text-nowrap text-end pe-4" HeaderStyle-CssClass="text-end pe-4">
                        <HeaderTemplate>
                            <span class="text-dark fw-bold">Acciones</span>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:LinkButton ID="cmdDetalle" runat="server" CommandName="Detalle" CommandArgument='<%# Eval("Id") %>'
                                CssClass="btn btn-info text-white btn-grilla me-1 shadow-sm" ToolTip="Ver PDF / Enviar Mail">
                                <i class="bi bi-file-earmark-pdf-fill"></i> Detalle
                            </asp:LinkButton>

                            <asp:LinkButton ID="cmdEditar" runat="server" CommandName="Editar" CommandArgument='<%# Eval("Id") %>'
                                CssClass="btn btn-warning text-dark btn-grilla me-1 shadow-sm" ToolTip="Modificar Pedido">
                                <i class="bi bi-pencil-square"></i> Editar
                            </asp:LinkButton>

                            <asp:LinkButton ID="cmdRecibir" runat="server"
                                CssClass="btn btn-proveedores btn-grilla me-1 shadow-sm"
                                OnClientClick='<%# "abrirModalRecibir(" + Eval("Id") + "); return false;" %>' ToolTip="Ingresar al Stock (Compra)">
                                <i class="bi bi-box-arrow-in-down"></i> Recibir
                            </asp:LinkButton>

                            <asp:LinkButton ID="cmdCancelar" runat="server" CommandName="Cancelar" CommandArgument='<%# Eval("Id") %>'
                                CssClass="btn btn-danger btn-grilla shadow-sm" ToolTip="Cancelar Pedido"
                                OnClientClick="return confirm('¿Estás seguro de que deseas cancelar este pedido? Esta acción no se puede deshacer.');">
                                <i class="bi bi-x-circle-fill"></i> Cancelar
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

                <PagerStyle CssClass="p-3 border-top paginador-grid bg-white rounded-bottom-4" HorizontalAlign="Center" />

                <EmptyDataTemplate>
                    <div class="text-center py-5">
                        <i class="bi bi-truck text-muted opacity-25" style="font-size: 4rem;"></i>
                        <p class="text-muted mt-3 fw-medium">No se encontraron pedidos registrados.</p>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>

    <div class="modal fade" id="modalConfirmarRecepcion" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-header border-bottom-0 pb-0">
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center pt-0 pb-4 px-4">
                    <div class="mb-3 text-proveedores">
                        <i class="bi bi-box-seam" style="font-size: 5rem;"></i>
                    </div>
                    <h4 class="fw-bold text-dark mb-2">¿Marcar como Recibido?</h4>
                    <p class="text-muted mb-0">Al confirmar, este pedido cambiará su estado a <b>Recibido</b> y te llevaremos a la pantalla de compras para que ingreses la mercadería al stock oficial.</p>
                </div>
                <div class="modal-footer bg-light border-top-0 justify-content-center gap-2 rounded-bottom-4 py-3">
                    <button type="button" class="btn btn-outline-secondary fw-bold px-4" data-bs-dismiss="modal">Cancelar</button>
                    <asp:Button ID="btnConfirmarRecepcion" runat="server" Text="Sí, recibir e ingresar stock" CssClass="btn btn-proveedores px-4 fw-bold" OnClick="btnConfirmarRecepcion_Click" />
                </div>
            </div>
        </div>
    </div>

    <script>
        function abrirModalRecibir(idPedido) {
            document.getElementById('<%= hfPedidoId.ClientID %>').value = idPedido;
            var myModal = new bootstrap.Modal(document.getElementById('modalConfirmarRecepcion'));
            myModal.show();
        }
    </script>
</asp:Content>
