// app/assets/javascripts/custom_script.js
document.addEventListener("DOMContentLoaded", () => {
    const champions = document.querySelectorAll(".table-row");
    const championInvisible = document.getElementById("champion-invisible");
    const championName = document.getElementById("champion-name");
    const championTitle = document.getElementById("champion-title");
    const championLore = document.getElementById("champion-lore");
    const championImage = document.getElementById("champion-image");
    const insightsContainer = document.getElementById("insights-container");

    champions.forEach((champion) => {
        champion.addEventListener("click", function () {
            const dataset = this.dataset;

            championName.textContent = dataset.name;
            championTitle.textContent = dataset.title;
            championLore.textContent = dataset.lore;
            championImage.src = `/assets/${dataset.imagePath}`;

            championInvisible.style.display = "flex";
            championInvisible.style.zIndex = "1";
            insightsContainer.style.display = "none";
        });
    });
});

function toggleChampions() {
    const championInvisible = document.getElementById("champion-invisible");
    const insightsContainer = document.getElementById("insights-container");

    championInvisible.style.display = "none";
    championInvisible.style.zIndex = "-1";
    insightsContainer.style.display = "flex";
}

document.addEventListener("DOMContentLoaded", function () {
    const items = document.querySelectorAll(".item-image");
    const itemInvisible = document.getElementById("item-invisible");
    const itemName = document.getElementById("item-name");
    const itemImage = document.getElementById("item-image");
    const itemDescription = document.getElementById("item-description");
    const itemCost = document.getElementById("item-cost");
    const itemContainer = document.getElementById("item-container");

    items.forEach((item) => {
        item.addEventListener("click", function () {
            itemName.textContent = this.dataset.name;
            itemDescription.innerHTML = this.dataset.description;
            itemCost.textContent = `Cost: ${this.dataset.cost}`;
            itemImage.src = `/assets/${this.dataset.imagePath}`;
            itemInvisible.style.display = "flex";
            itemInvisible.style.zIndex = "1";
            itemContainer.style.display = "none";
        });
    });
});

function toggleItem() {
    const itemInvisible = document.getElementById("item-invisible");
    const itemContainer = document.getElementById("item-container");

    itemInvisible.style.display = "none";
    itemInvisible.style.zIndex = "-2";
    itemContainer.style.display = "block";
}

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
