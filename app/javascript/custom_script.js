var sideCounter = 0;
var loginCounter = 0;
var signUpCounter = 0;

function toggleSidebar() {
    var mobileLeft = document.getElementById("mobile-left");
    var mobileRight = document.getElementById("mobile-right");

    var mainContent = document.getElementById("main-content");
    var mobileBottom = document.getElementById("mobile-bottom");

    if (sideCounter % 2 === 0) {
        mobileLeft.style.left = "0px";
        mobileRight.style.right = "0px";

        // mainContent sottoposto a mobileBottom
        mainContent.style.zIndex = "0";
        mobileBottom.style.zIndex = "1";
        mobileBottom.style.pointerEvents = "auto";

        sideCounter += 1;
    } else {
        mobileLeft.style.left = "-500px";
        mobileRight.style.right = "-500px";

        // mainContent sovrapposto a mobileBottom
        mainContent.style.zIndex = "2";
        mobileBottom.style.zIndex = "-1";
        mobileBottom.style.pointerEvents = "none";

        sideCounter += 1;
    }
}

function toggleLogin() {
    var login = document.getElementById("login");
    var mainContent = document.getElementById("main-content");
    if (loginCounter % 2 === 0) {
        login.style.opacity = "1";
        login.style.zIndex = "999999999";
        mainContent.style.zIndex = "-99999999";
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

function toggleSignUp() {
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
