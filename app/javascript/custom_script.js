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
