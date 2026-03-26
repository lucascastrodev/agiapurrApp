<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="TPC_Equipo20B.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .card-custom {
            border-radius: 12px;
            border: none;
        }

        .grid-container {
            border: 1px solid #e9ecef;
            border-radius: 12px;
            overflow: hidden;
            background-color: #fff;
        }

        .table th {
            background-color: #f8f9fa !important;
            font-weight: 600;
            color: #495057;
            text-transform: uppercase;
            font-size: 0.85rem;
            padding-top: 12px;
            padding-bottom: 12px;
        }

        .table td {
            vertical-align: middle;
            color: #212529;
        }
    </style>

    <div class="mb-4 border-bottom pb-2">
        <h2 class="fw-bold text-dark mb-0">Dashboard</h2>
        <p class="text-muted small mb-0 mt-1">Resumen general del negocio</p>
    </div>

    <div class="row g-3 mb-5">
        <div class="col-md-4">
            <div id="card1" runat="server" class="card h-100 card-custom shadow-sm border-start border-success border-4">
                <div class="card-body">
                    <p id="lblTituloCard1" runat="server" class="mb-1 text-muted fw-bold text-uppercase" style="font-size: 0.8rem;">Ventas del Mes</p>
                    <asp:Label ID="lblMetrica1" runat="server" CssClass="h3 fw-bold d-block text-dark"></asp:Label>
                    <p id="lblDescCard1" runat="server" class="small text-success fw-medium mb-0">Ventas confirmadas del mes actual</p>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div id="card2" runat="server" class="card h-100 card-custom shadow-sm border-start border-success border-4">
                <div class="card-body">
                    <p id="lblTituloCard2" runat="server" class="mb-1 text-muted fw-bold text-uppercase" style="font-size: 0.8rem;">Pedidos Completados</p>
                    <asp:Label ID="lblMetrica2" runat="server" CssClass="h3 fw-bold d-block text-dark"></asp:Label>
                    <p id="lblDescCard2" runat="server" class="small text-success fw-medium mb-0">Órdenes procesadas en el mes</p>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div id="card3" runat="server" class="card h-100 card-custom shadow-sm border-start border-success border-4">
                <div class="card-body">
                    <p id="lblTituloCard3" runat="server" class="mb-1 text-muted fw-bold text-uppercase" style="font-size: 0.8rem;">Clientes Nuevos</p>
                    <asp:Label ID="lblMetrica3" runat="server" CssClass="h3 fw-bold d-block text-dark"></asp:Label>
                    <p id="lblDescCard3" runat="server" class="small text-success fw-medium mb-0">Cuentas creadas este mes</p>
                </div>
            </div>
        </div>
    </div>

    <div class="d-flex align-items-center mb-3">
        <h5 class="fw-bold text-danger m-0 d-flex align-items-center gap-2">
            <i class="bi bi-exclamation-triangle-fill"></i>Atención: Stock Bajo
        </h5>
    </div>
    <div class="card card-custom shadow-sm mb-5 border border-danger border-opacity-50">
        <div class="card-body p-0">
            <div class="table-responsive grid-container border-0 m-0">
                <asp:GridView ID="gvStockBajo" runat="server" AutoGenerateColumns="False"
                    CssClass="table table-hover align-middle text-center mb-0" GridLines="None">
                    <HeaderStyle CssClass="bg-danger bg-opacity-10 text-danger" />
                    <Columns>
                        <asp:BoundField DataField="Codigo" HeaderText="SKU" ItemStyle-CssClass="text-muted" />
                        <asp:BoundField DataField="Producto" HeaderText="Producto" ItemStyle-CssClass="fw-bold text-danger text-start" HeaderStyle-CssClass="text-start" />
                        <asp:BoundField DataField="StockVisual" HeaderText="Stock Actual" ItemStyle-CssClass="fw-bold fs-6 text-danger" />
                        <asp:BoundField DataField="StockMinimo" HeaderText="Mínimo Requerido" ItemStyle-CssClass="text-muted" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <div class="d-flex align-items-center mb-3 border-bottom pb-2">
        <h5 id="lblTituloVentas" runat="server" class="fw-bold text-dark m-0">Últimas Ventas Generadas</h5>
    </div>
    <div class="card card-custom shadow-sm mb-4">
        <div class="card-body p-0">
            <div class="table-responsive grid-container border-0 m-0">
                <asp:GridView ID="gvUltimasVentas" runat="server" AutoGenerateColumns="False"
                    CssClass="table table-hover align-middle text-center mb-0" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="IdVenta" HeaderText="N° Venta" ItemStyle-CssClass="fw-bold text-primary" />
                        <asp:BoundField DataField="Cliente" HeaderText="Cliente" ItemStyle-CssClass="text-start fw-medium" HeaderStyle-CssClass="text-start" />
                        <asp:BoundField DataField="Fecha" HeaderText="Fecha" ItemStyle-CssClass="text-muted" />
                        <asp:BoundField DataField="Total" HeaderText="Total" DataFormatString="{0:C}" ItemStyle-CssClass="fw-bold text-dark" />

                        <asp:BoundField DataField="TipoVentaBadge" HeaderText="Tipo Venta" HtmlEncode="false" ItemStyle-CssClass="align-middle" />

                        <asp:TemplateField HeaderText="Estado" ItemStyle-Width="140px">
                            <ItemTemplate>
                                <span class='badge border rounded-pill px-3 py-2 w-100 <%# Eval("CssEstado") %>'>
                                    <%# Eval("EstadoText") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

</asp:Content>
