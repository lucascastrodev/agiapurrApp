<%@ Page Title="Reportes" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Reportes.aspx.cs" Inherits="TPC_Equipo20B.Reportes" %>

<asp:Content ID="c1" ContentPlaceHolderID="MainContent" runat="server">

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

        .icon-kpi {
            font-size: 2rem;
            opacity: 0.8;
        }
    </style>

    <div class="d-flex align-items-center mb-4 border-bottom pb-2">
        <h2 class="fw-bold text-dark mb-0">Reportes y Estadísticas</h2>
    </div>

    <div class="row row-cols-1 row-cols-md-3 row-cols-xl-5 g-3 mb-5">

        <div class="col">
            <div class="card h-100 card-custom shadow-sm border-start border-success border-4">
                <div class="card-body">
                    <p class="text-muted mb-1 fw-bold text-uppercase" style="font-size: 0.8rem;">Ventas del Mes</p>
                    <asp:Label ID="lblRptVentasMes" runat="server" CssClass="h4 fw-bold d-block text-dark"></asp:Label>
                    <small class="text-success fw-medium">Ingresos brutos</small>
                </div>
            </div>
        </div>

        <div class="col">
            <div class="card h-100 card-custom shadow-sm border-start border-success border-4">
                <div class="card-body">
                    <p class="text-muted mb-1 fw-bold text-uppercase" style="font-size: 0.8rem;">Pedidos Completados</p>
                    <asp:Label ID="lblRptPedidos" runat="server" CssClass="h4 fw-bold d-block text-dark"></asp:Label>
                    <small class="text-success fw-medium">Órdenes procesadas</small>
                </div>
            </div>
        </div>

        <div class="col">
            <div class="card h-100 card-custom shadow-sm border-start border-success border-4">
                <div class="card-body">
                    <p class="text-muted mb-1 fw-bold text-uppercase" style="font-size: 0.8rem;">Clientes Nuevos</p>
                    <asp:Label ID="lblRptClientes" runat="server" CssClass="h4 fw-bold d-block text-dark"></asp:Label>
                    <small class="text-success fw-medium">Cuentas creadas este mes</small>
                </div>
            </div>
        </div>

        <div class="col">
            <div class="card h-100 card-custom shadow-sm border-start border-success border-4">
                <div class="card-body">
                    <p class="text-muted mb-1 fw-bold text-uppercase" style="font-size: 0.8rem;">Ticket Promedio</p>
                    <asp:Label ID="lblRptTicket" runat="server" CssClass="h4 fw-bold d-block text-dark"></asp:Label>
                    <small class="text-success fw-medium">Gasto promedio por orden</small>
                </div>
            </div>
        </div>

        <div class="col">
            <div class="card h-100 card-custom shadow-sm border-start border-danger border-4">
                <div class="card-body bg-light rounded-end">
                    <p class="text-muted mb-1 fw-bold text-uppercase" style="font-size: 0.8rem;">Inflación Catálogo</p>
                    <asp:Label ID="lblRptInflacion" runat="server" CssClass="h4 fw-bold d-block text-danger"></asp:Label>
                    <small class="text-danger fw-medium">Variación anual estimada</small>
                </div>
            </div>
        </div>

    </div>

    <div class="row g-4">

        <div class="col-lg-7">
            <div class="card card-custom shadow-sm h-100">
                <div class="card-header bg-white border-bottom-0 pt-4 pb-0">
                    <h5 class="fw-bold text-dark mb-0">Top Productos Más Vendidos</h5>
                </div>
                <div class="card-body p-0 mt-3">
                    <div class="table-responsive grid-container m-3 mt-0">
                        <asp:GridView ID="gvTopProductos" runat="server" AutoGenerateColumns="False" CssClass="table table-hover align-middle text-center mb-0" GridLines="None">
                            <Columns>
                                <asp:BoundField DataField="Producto" HeaderText="Producto" ItemStyle-CssClass="text-start ps-4 fw-medium" HeaderStyle-CssClass="text-start ps-4" />
                                <asp:BoundField DataField="Categoria" HeaderText="Categoría" ItemStyle-CssClass="text-muted" />
                                <asp:BoundField DataField="Unidades" HeaderText="U. Vendidas" ItemStyle-CssClass="fw-bold" />
                                <asp:BoundField DataField="Ingresos" HeaderText="Ingresos" DataFormatString="{0:C}" ItemStyle-CssClass="text-success fw-bold" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="card card-custom shadow-sm h-100 border-danger border border-1">
                <div class="card-header bg-white border-bottom-0 pt-4 pb-0">
                    <h5 class="fw-bold text-danger mb-0 d-flex align-items-center gap-2">
                        <i class="bi bi-graph-up-arrow"></i>Mayores Aumentos (Año)
                    </h5>
                </div>
                <div class="card-body p-0 mt-3">
                    <div class="table-responsive grid-container m-3 mt-0 border-danger border-opacity-25">
                        <asp:GridView ID="gvTopAumentos" runat="server" AutoGenerateColumns="False" CssClass="table table-hover align-middle text-center mb-0" GridLines="None">
                            <Columns>
                                <asp:BoundField DataField="Producto" HeaderText="Producto" ItemStyle-CssClass="text-start ps-4 fw-medium text-dark" HeaderStyle-CssClass="text-start ps-4" />
                                <asp:TemplateField HeaderText="Variación">
                                    <ItemTemplate>
                                        <span class="badge bg-danger px-2 py-2 w-100 rounded-pill">
                                            <%# String.Format("{0:N1}%", Eval("Porcentaje")) %>
                                        </span>
                                    </ItemTemplate>
                                    <ItemStyle Width="100px" CssClass="pe-4" />
                                    <HeaderStyle CssClass="pe-4" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>

    </div>

</asp:Content>
