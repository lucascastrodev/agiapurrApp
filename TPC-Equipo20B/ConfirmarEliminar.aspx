<%@ Page Title="Confirmar Eliminación" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="ConfirmarEliminar.aspx.cs" Inherits="TPC_Equipo20B.ConfirmarEliminar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-center mt-5">
        <div class="card shadow-lg" style="max-width: 600px; width: 100%;">
            <div class="card-header bg-danger text-white text-center">
                <h4 class="mb-0">⚠️ Confirmar eliminación</h4>
            </div>

            <div class="card-body text-center">
                <asp:Label ID="lblMensaje" runat="server" CssClass="fs-5 d-block mb-4 fw-semibold"></asp:Label>
                <p class="text-muted mb-4">
                    Esta acción no se puede deshacer. ¿Deseas continuar?
                </p>

                <div class="mb-3" id="panelMotivo" runat="server" visible="false">
                <label class="form-label fw-bold">Motivo de cancelación</label>
                <asp:TextBox ID="txtMotivo" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvMotivo" runat="server"
                    ControlToValidate="txtMotivo"
                    ErrorMessage="El motivo de cancelación es obligatorio."
                    CssClass="text-danger"
                    Display="Dynamic"
                    ValidationGroup="ConfirmarEliminar" /> 
                </div>


                <div class="d-flex justify-content-center gap-3">
                    <asp:Button ID="btnCancelar" runat="server" Text="Cancelar"
                        CssClass="btn btn-outline-secondary px-4"
                        CausesValidation="false"
                        OnClick="btnCancelar_Click" />

                    <asp:Button ID="btnConfirmar" runat="server" Text="Eliminar"
                        CssClass="btn btn-danger px-4"
                        OnClick="btnConfirmar_Click" 
                        ValidationGroup="ConfirmarEliminar" />
                </div>
            </div>

            <div class="card-footer text-center text-muted small">
                Sistema de Gestión Comercial · TPC Equipo 20B
            </div>
        </div>
    </div>
</asp:Content>


