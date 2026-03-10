<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TPC_Equipo20B.Default" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Inicio de Sesión - AGIAPURR distribuidora</title>


    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" xintegrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
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
                    <img src="~/img/logo.png" runat="server"
                        alt="AGIAPURR"
                        style="height: 40px; width: auto;" />

                    <h2 class="h5 mb-0 fw-bold">AGIAPURR distribuidora</h2>
                </div>
            </div>
        </header>

        <main class="d-flex flex-grow-1 align-items-center justify-content-center p-4">

            <div class="col-12 col-md-10 col-lg-8 col-xl-6 col-xxl-5">
                <div class="card card-custom p-4 p-sm-5 rounded-4 shadow-sm">
                    <div class="card-body">

                        <h1 class="text-center h3 fw-bold">Inicio de Sesión</h1>
                        <p class="mt-2 text-center text-muted">
                            Bienvenido de nuevo. Por favor, ingrese sus credenciales.
                        </p>

                        <div class="mt-4">
                            <div class="mb-3">
                                <asp:Label ID="lblUsername" runat="server" AssociatedControlID="txtUsername" Text="Nombre de Usuario" CssClass="form-label fw-medium" />
                                <div class="input-group input-group-lg">
                                    <span class="input-group-text bg-light" style="border-right: 0;">
                                        <span class="material-symbols-outlined text-muted">person</span>
                                    </span>
                                    <asp:TextBox ID="txtUsername" runat="server"
                                        placeholder="Ingrese su nombre de usuario"
                                        CssClass="form-control" Style="border-left: 0;" />
                                </div>
                                <asp:RequiredFieldValidator ID="valUsername" runat="server"
                                    ControlToValidate="txtUsername"
                                    ErrorMessage="El nombre de usuario es requerido"
                                    Display="Dynamic"
                                    CssClass="validator"
                                    ValidationGroup="Login" />
                            </div>

                            <div class="mb-3">
                                <asp:Label ID="lblPassword" runat="server" AssociatedControlID="txtPassword" Text="Contraseña" CssClass="form-label fw-medium" />
                                <div class="input-group input-group-lg">
                                    <span class="input-group-text bg-light" style="border-right: 0;">
                                        <span class="material-symbols-outlined text-muted">lock</span>
                                    </span>
                                    <asp:TextBox ID="txtPassword" runat="server"
                                        TextMode="Password"
                                        placeholder="Ingrese su contraseña"
                                        CssClass="form-control" Style="border-left: 0; border-right: 0;" />
                                    <button type="button" id="togglePassword" class="input-group-text bg-light" style="border-left: 0; cursor: pointer;">
                                        <span class="material-symbols-outlined text-muted">visibility</span>
                                    </button>
                                </div>
                                <asp:RequiredFieldValidator ID="valPassword" runat="server"
                                    ControlToValidate="txtPassword"
                                    ErrorMessage="La contraseña es requerida"
                                    Display="Dynamic"
                                    CssClass="validator"
                                    ValidationGroup="Login" />
                            </div>

                            <div class="mb-3 d-flex justify-content-between align-items-center">
                                <a class="link-primary small" href="RegistroUsuario.aspx">Registrarse</a>
                                <a class="link-primary small" href="RecuperarPassword.aspx">Olvidé mi contraseña</a>
                            </div>



                            <asp:Label ID="lblError" runat="server" CssClass="validator text-center mb-3" EnableViewState="false" />

                            <asp:Button ID="btnLogin" runat="server"
                                Text="Iniciar Sesión"
                                CssClass="btn btn-primary w-100 btn-lg"
                                OnClick="btnLogin_Click"
                                ValidationGroup="Login" />

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

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" xintegrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

    <!-- Script para el botón de 'ver contraseña' -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const toggleButton = document.getElementById('togglePassword');
            const usernameInput = document.getElementById('<%= txtUsername.ClientID %>');
            const passwordInput = document.getElementById('<%= txtPassword.ClientID %>');
            const btnLogin = document.getElementById('<%= btnLogin.ClientID %>');
            const icon = toggleButton ? toggleButton.querySelector('.material-symbols-outlined') : null;

            // --- FOCO INICIAL ---
            if (usernameInput) {
                usernameInput.focus();
            }

            // Enter en usuario -> pasa a contraseña (no envía el form)
            if (usernameInput && passwordInput) {
                usernameInput.addEventListener('keydown', function (e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        passwordInput.focus();
                    }
                });
            }

            // Enter en contraseña -> hace click en Iniciar Sesión
            if (passwordInput && btnLogin) {
                passwordInput.addEventListener('keydown', function (e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        btnLogin.click();
                    }
                });
            }

            // --- Botón mostrar/ocultar contraseña ---
            if (toggleButton && passwordInput && icon) {
                toggleButton.addEventListener('click', function () {
                    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                    passwordInput.setAttribute('type', type);

                    icon.textContent = type === 'password' ? 'visibility' : 'visibility_off';
                });
            }
        });
    </script>

</body>
</html>
