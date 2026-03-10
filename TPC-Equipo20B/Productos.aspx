<%@ Page Title="Productos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Productos.aspx.cs" Inherits="TPC_Equipo20B.Productos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .fila-deshabilitada td {
            background-color: #f0f0f0 !important;
            color: #6c757d !important;
        }

        .fila-precio-nuevo td {
            background-color: #d1e7dd !important;
            color: #0f5132 !important;
            font-weight: 500;
        }

        .precio-venta {
            font-weight: bold;
        }

        .nowrap-cell {
            white-space: nowrap !important;
            vertical-align: middle !important;
        }

        .sort-icon {
            font-size: 0.65rem;
            color: #adb5bd;
            letter-spacing: 1px;
            display: inline-block;
        }

        /* Estilo para el checkbox de selección */
        .chk-seleccion input {
            transform: scale(1.3);
            cursor: pointer;
        }
    </style>

    <div class="d-flex align-items-center justify-content-between mb-4">
        <h2 class="page-title m-0">Gestión de Productos</h2>

        <% if ((bool)(Session["EsAdmin"] ?? false))
            { %>
        <div class="d-flex gap-2">
            <button type="button" class="btn btn-info fw-bold text-dark btn-principal" data-bs-toggle="modal" data-bs-target="#modalAumentoIndividual">
                <i class="bi bi-check2-square"></i>Aumentar Seleccionados
            </button>

            <button type="button" class="btn btn-warning fw-bold text-dark btn-principal" data-bs-toggle="modal" data-bs-target="#modalAumentoMasivo">
                <i class="bi bi-building-up"></i>Aumento por Proveedor
            </button>

            <button type="button" class="btn btn-secondary fw-bold text-white btn-principal" data-bs-toggle="modal" data-bs-target="#modalAumentoMarca">
                <i class="bi bi-tags-fill"></i>Aumento por Marca
            </button>

            <asp:LinkButton ID="btnAgregarProducto" runat="server" CssClass="btn btn-success btn-principal" OnClick="btnAgregarProducto_Click">
                <i class="bi bi-plus-lg"></i> Agregar Producto
            </asp:LinkButton>
        </div>
        <% } %>
    </div>

    <asp:Panel ID="pnlNotificacion" runat="server" Visible="false" role="alert">
        <asp:Label ID="lblNotificacion" runat="server"></asp:Label>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </asp:Panel>

    <div class="modal fade" id="modalAumentoMasivo" tabindex="-1" aria-labelledby="modalAumentoLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-warning text-dark">
                    <h5 class="modal-title fw-bold" id="modalAumentoLabel">🏢 Aumento por Proveedor</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="text-muted small mb-3">Aumenta el costo base de <strong>todos</strong> los productos de un proveedor.</p>
                    <div class="mb-3">
                        <label class="form-label fw-bold">1. Seleccione el Proveedor</label>
                        <asp:DropDownList ID="ddlProveedorModal" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">2. Porcentaje de Aumento (%)</label>
                        <asp:TextBox ID="txtPorcentajeModal" runat="server" CssClass="form-control" placeholder="Ej: 15"></asp:TextBox>
                        <small class="text-danger" id="errorPorcentaje" style="display: none;">Ingrese un número válido mayor a 0.</small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <asp:Button ID="btnAplicarAumento" runat="server" Text="🚀 Aplicar Aumento" CssClass="btn btn-warning fw-bold" OnClick="btnAplicarAumento_Click" OnClientClick="return validarAumento('MainContent_txtPorcentajeModal', 'errorPorcentaje');" />
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalAumentoMarca" tabindex="-1" aria-labelledby="modalMarcaLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-secondary text-white">
                    <h5 class="modal-title fw-bold" id="modalMarcaLabel">🏷️ Aumento por Marca</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="text-muted small mb-3">Aumenta el costo base de <strong>todos</strong> los productos de una marca.</p>
                    <div class="mb-3">
                        <label class="form-label fw-bold">1. Seleccione la Marca</label>
                        <asp:DropDownList ID="ddlMarcaModal" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">2. Porcentaje de Aumento (%)</label>
                        <asp:TextBox ID="txtPorcentajeMarca" runat="server" CssClass="form-control" placeholder="Ej: 12"></asp:TextBox>
                        <small class="text-danger" id="errorPorcentajeMarca" style="display: none;">Ingrese un número válido mayor a 0.</small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <asp:Button ID="btnAplicarAumentoMarca" runat="server" Text="🚀 Aplicar Aumento" CssClass="btn btn-secondary fw-bold text-white" OnClick="btnAplicarAumentoMarca_Click" OnClientClick="return validarAumento('MainContent_txtPorcentajeMarca', 'errorPorcentajeMarca');" />
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalAumentoIndividual" tabindex="-1" aria-labelledby="modalIndividualLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-info text-dark">
                    <h5 class="modal-title fw-bold" id="modalIndividualLabel">✅ Aumentar Seleccionados</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-info border-0 shadow-sm mb-4">
                        <i class="bi bi-info-circle-fill me-2"></i>
                        Se aplicará el aumento a los productos que haya tildado en la grilla.
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Porcentaje de Aumento (%)</label>
                        <asp:TextBox ID="txtPorcentajeIndividual" runat="server" CssClass="form-control form-control-lg text-center fw-bold" placeholder="Ej: 10"></asp:TextBox>
                        <small class="text-danger" id="errorPorcentajeInd" style="display: none;">Ingrese un número válido mayor a 0.</small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <asp:Button ID="btnAplicarAumentoIndividual" runat="server" Text="🚀 Aplicar a la Selección" CssClass="btn btn-info fw-bold" OnClick="btnAplicarAumentoIndividual_Click" OnClientClick="return validarAumento('MainContent_txtPorcentajeIndividual', 'errorPorcentajeInd');" />
                </div>
            </div>
        </div>
    </div>

    <script>
        function validarAumento(inputId, errorId) {
            var input = document.getElementById(inputId).value;
            var numero = parseFloat(input.replace(',', '.'));

            if (isNaN(numero) || numero <= 0) {
                document.getElementById(errorId).style.display = 'block';
                return false;
            }
            document.getElementById(errorId).style.display = 'none';
            return true;
        }
    </script>

    <div class="form-check form-switch mb-3">
        <input id="chkSoloHabilitados" runat="server" type="checkbox" class="form-check-input" onchange="this.form.submit();" onserverchange="chkSoloHabilitados_CheckedChanged" />
        <label class="form-check-label fw-bold" for="<%= chkSoloHabilitados.ClientID %>">
            Mostrar solo habilitados
        </label>
    </div>

    <asp:Panel ID="pnlBusquedaProductos" runat="server" DefaultButton="btnBuscarProducto">
        <div class="toolbar d-flex gap-2 mb-4">
            <asp:TextBox ID="txtBuscarProducto" runat="server" CssClass="form-control" placeholder="Buscar producto, marca, código…" />

            <asp:DropDownList ID="ddlProveedor" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlProveedor_SelectedIndexChanged"></asp:DropDownList>

            <asp:Button ID="btnBuscarProducto" runat="server" CssClass="btn btn-primary btn-principal px-4" Text="Buscar" OnClick="btnBuscarProducto_Click" UseSubmitBehavior="false" />
        </div>

        <div class="grid card shadow-sm table-responsive">
            <div class="card-body p-0">
                <asp:GridView ID="gvProductos" runat="server"
                    CssClass="table table-hover align-middle text-center mb-0"
                    AutoGenerateColumns="False"
                    AllowSorting="true"
                    OnSorting="gvProductos_Sorting"
                    DataKeyNames="Id"
                    OnRowCommand="gvProductos_RowCommand"
                    OnRowDataBound="gvProductos_RowDataBound"
                    AllowPaging="True"
                    PageSize="30"
                    OnPageIndexChanging="gvProductos_PageIndexChanging"
                    EnableViewState="true"
                    GridLines="None">

                    <Columns>
                        <asp:TemplateField ItemStyle-Width="40px">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSeleccion" runat="server" CssClass="chk-seleccion" />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField ItemStyle-CssClass="align-middle text-start">
                            <HeaderTemplate>
                                <asp:LinkButton runat="server" CommandName="Sort" CommandArgument="Descripcion" CssClass="sort-link text-dark">
                                    Producto <span class="sort-icon">▲▼</span>
                                </asp:LinkButton>
                            </HeaderTemplate>
                            <ItemTemplate><%# Eval("Descripcion") %></ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField ItemStyle-CssClass="align-middle nowrap-cell">
                            <HeaderTemplate>
                                <asp:LinkButton runat="server" CommandName="Sort" CommandArgument="CodigoSKU" CssClass="sort-link text-dark">
                                    SKU <span class="sort-icon">▲▼</span>
                                </asp:LinkButton>
                            </HeaderTemplate>
                            <ItemTemplate><%# Eval("CodigoSKU") %></ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField ItemStyle-CssClass="align-middle text-start nowrap-cell">
                            <HeaderTemplate>
                                <asp:LinkButton runat="server" CommandName="Sort" CommandArgument="Marca.Nombre" CssClass="sort-link text-dark">
                                    Marca <span class="sort-icon">▲▼</span>
                                </asp:LinkButton>
                            </HeaderTemplate>
                            <ItemTemplate><%# Eval("Marca.Nombre") ?? "-" %></ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField ItemStyle-CssClass="align-middle text-start nowrap-cell">
                            <HeaderTemplate>
                                <asp:LinkButton runat="server" CommandName="Sort" CommandArgument="Proveedor.Nombre" CssClass="sort-link text-dark">
                                    Proveedor <span class="sort-icon">▲▼</span>
                                </asp:LinkButton>
                            </HeaderTemplate>
                            <ItemTemplate><%# Eval("Proveedor.Nombre") ?? "-" %></ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField ItemStyle-CssClass="align-middle nowrap-cell">
                            <HeaderTemplate>
                                <span class="text-dark fw-bold">P. Mayorista</span>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <span class="fw-bold text-primary">
                                    <%# String.Format("$ {0:N2}", Eval("PrecioMayorista")) %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField ItemStyle-CssClass="align-middle nowrap-cell">
                            <HeaderTemplate>
                                <asp:LinkButton runat="server" CommandName="Sort" CommandArgument="PrecioVenta" CssClass="sort-link text-dark">
                                    Precio Final (CF) <span class="sort-icon">▲▼</span>
                                </asp:LinkButton>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <span class="precio-venta text-success">
                                    <%# String.Format("$ {0:N2}", Eval("PrecioVenta")) %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField ItemStyle-CssClass="align-middle nowrap-cell">
                            <HeaderTemplate>
                                <asp:LinkButton runat="server" CommandName="Sort" CommandArgument="StockActual" CssClass="sort-link text-dark">
                                    Stock <span class="sort-icon">▲▼</span>
                                </asp:LinkButton>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lblStock" runat="server" Text='<%# Eval("StockActual") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField ItemStyle-CssClass="align-middle nowrap-cell">
                            <HeaderTemplate>
                                <asp:LinkButton runat="server" CommandName="Sort" CommandArgument="Habilitado" CssClass="sort-link text-dark">
                                    Habilitado <span class="sort-icon">▲▼</span>
                                </asp:LinkButton>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <%# (bool)Eval("Habilitado") ? "<span class='badge bg-success'>Sí</span>" : "<span class='badge bg-danger'>No</span>" %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField ItemStyle-CssClass="col-acciones text-center">
                            <HeaderTemplate>
                                <span class="text-dark fw-bold">Acciones</span>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:LinkButton ID="cmdEditar" runat="server" CssClass="btn btn-primary btn-grilla me-1 shadow-sm" CommandName="Editar" CommandArgument='<%# Eval("Id") %>'>
                                    <i class="bi bi-pencil-square"></i> Editar
                                </asp:LinkButton>

                                <asp:LinkButton ID="cmdEliminar" runat="server" CssClass="btn btn-danger btn-grilla shadow-sm" CommandName="Eliminar" CommandArgument='<%# Eval("Id") %>'>
                                    <i class="bi bi-trash"></i> Eliminar
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
