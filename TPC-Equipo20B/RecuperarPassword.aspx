<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RecuperarPassword.aspx.cs" Inherits="TPC_Equipo20B.RecuperarPassword" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Restablecer Contraseña - AGIAPURR distribuidora</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com" rel="preconnect" />
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect" />
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&amp;display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />

    <style>
        body {
            font-family: 'Manrope', sans-serif;
            background-color: #f6f8f6;
            color: #111813;
        }

        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            user-select: none;
        }

        .validator {
            color: #dc3545;
            font-size: 0.875em;
            display: block;
            margin-top: 0.25rem;
        }

        .btn-primary {
            background-color: #11d452;
            border-color: #11d452;
            color: #102216;
            font-weight: 700;
        }

            .btn-primary:hover {
                background-color: #0fbc48;
                border-color: #0fbc48;
                color: #102216;
            }

        .form-control:focus, .btn-primary:focus {
            border-color: #11d452;
            box-shadow: 0 0 0 0.25rem rgba(17, 212, 82, 0.25);
        }

        .link-primary {
            color: #11d452 !important;
            text-decoration: none;
        }

            .link-primary:hover {
                text-decoration: underline !important;
            }

        .card-custom {
            background-color: #ffffff;
            border-color: #dbe6df;
        }

        .header-custom {
            background-color: #ffffff;
            border-bottom: 1px solid #dbe6df;
        }

        .form-control::placeholder {
            color: #61896f;
            opacity: 1;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

    <form id="form1" runat="server" class="d-flex flex-column flex-grow-1">

        <header class="w-100 header-custom shadow-sm">
            <div class="container py-3">
                <div class="d-flex align-items-center gap-3">
                    <div class="text-primary" style="width: 24px; height: 24px;">
                        <svg fill="none" viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">
                            <path clip-rule="evenodd" d="M24 4H42V17.3333V30.6667H24V44H6V30.6667V17.3333H24V4Z" fill="currentColor" fill-rule="evenodd"></path>
                        </svg>
                    </div>
                    <h2 class="h5 mb-0 fw-bold">AGIAPURR distribuidora</h2>
                </div>
            </div>
        </header>

        <main class="d-flex flex-grow-1 align-items-center justify-content-center p-4">

            <div class="col-12 col-md-10 col-lg-8 col-xl-6 col-xxl-5">
                <div class="card card-custom p-4 p-sm-5 rounded-4 shadow-sm">
                    <div class="card-body">

                        <h1 class="text-center h3 fw-bold">Restablecer Contraseña</h1>
                        <p class="mt-2 text-center text-muted">
                            Ingrese el correo electrónico con el que se registró. Generaremos una contraseña temporal.
                        </p>

                        <div class="mt-4">
                            <div class="mb-3">
                                <asp:Label ID="lblEmail" runat="server" AssociatedControlID="txtEmail" Text="Correo Electrónico" CssClass="form-label fw-medium" />
                                <div class="input-group input-group-lg">
                                    <span class="input-group-text bg-light" style="border-right: 0;">
                                        <span class="material-symbols-outlined text-muted">mail</span>
                                    </span>
                                    <asp:TextBox ID="txtEmail" runat="server"
                                        TextMode="Email"
                                        placeholder="correo@ejemplo.com"
                                        CssClass="form-control" Style="border-left: 0;" />
                                </div>
                                <asp:RequiredFieldValidator ID="valEmailRequerido" runat="server"
                                    ControlToValidate="txtEmail"
                                    ErrorMessage="El correo electrónico es requerido"
                                    Display="Dynamic"
                                    CssClass="validator"
                                    ValidationGroup="Recuperar" />
                                <asp:RegularExpressionValidator ID="valEmailFormato" runat="server"
                                    ControlToValidate="txtEmail"
                                    ErrorMessage="Ingrese un correo electrónico válido"
                                    ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"
                                    Display="Dynamic"
                                    CssClass="validator"
                                    ValidationGroup="Recuperar" />
                            </div>

                            <asp:Label ID="lblError" runat="server" CssClass="validator text-center mb-3" EnableViewState="false" />
                            <asp:Label ID="lblSuccess" runat="server" CssClass="text-success text-center mb-3 d-block fw-medium" EnableViewState="false" />

                            <asp:Button ID="btnRestablecer" runat="server"
                                Text="Generar nueva contraseña"
                                CssClass="btn btn-primary w-100 btn-lg"
                                OnClick="btnRestablecer_Click"
                                ValidationGroup="Recuperar" />

                            <div class="mt-3 text-center">
                                <a class="link-primary small" href="Default.aspx">Volver al inicio de sesión</a>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </main>

        <footer class="w-100 py-4 px-4">
            <div class="text-center text-muted small">
                <p class="mb-0">© 2025 AGIAPURR distribuidora. Todos los derechos reservados.</p>
            </div>
        </footer>

    </form>

</body>
</html>
