var sideCounter = 0;
var loginCounter = 0;
var signUpCounter = 0;

function toogleSidebar() {
    var sidebarLeft = document.getElementById("sidebar-left");
    var sidebarRight = document.getElementById("sidebar-right");
    var searchContainer = document.getElementById("search-container");
    sidebarLeft.style.transition = "0.5s ease";
    sidebarRight.style.transition = "0.5s ease";

    if (sideCounter % 2 === 0) {
        sidebarLeft.style.left = "0";
        sidebarRight.style.right = "0";
        sideCounter += 1;
    } else {
        sidebarLeft.style.left = "-500px";
        sidebarRight.style.right = "-500px";
        sideCounter += 1;
    }
}

function toogleLogin() {
    var login = document.getElementById("login");
    var mainContent = document.getElementById("main-content");

    if (loginCounter % 2 === 0) {
        login.style.opacity = "1";
        login.style.zIndex = "2";
        mainContent.style.zIndex = "-1";
        mainContent.style.opacity = "0.25";
        loginCounter += 1;
    } else {
        login.style.opacity = "0";
        login.style.zIndex = "-1";
        mainContent.style.zIndex = "1";
        mainContent.style.opacity = "1";
        loginCounter += 1;
    }
}

function toogleSignUp() {
    var loginSection = document.getElementById("login-section");
    var signUpSection = document.getElementById("signup-section");

    if (signUpCounter % 2 === 0) {
        loginSection.style.opacity = "0";
        loginSection.style.zIndex = "-2";
        signUpSection.style.zIndex = "2";
        signUpSection.style.opacity = "1";
        signUpCounter += 1;
    } else {
        loginSection.style.opacity = "1";
        loginSection.style.zIndex = "2";
        signUpSection.style.zIndex = "-2";
        signUpSection.style.opacity = "0";
        signUpCounter += 1;
    }
}
