import "./Styles/main.css";
import { Elm } from "./Main.elm";
var app = Elm.Main.init({node: document.getElementById("main")});
// constants and global variables
var DB_NAME = "BubblesDatabase";
var DB_VERSION = 1;
var STORE_WATER_DETAILS = "waterDetails";
var STORE_USER_DETAILS = "userDetails";
var USERNAME = "Happy Bubbles User";
var db;
// check if indexedDB is available
if (!("indexedDB" in window)) {
    sendDataToElm("ErrorMessage", "This browser doesn't support IndexedDB");
}
else {
    openDb();
}
// todo list
// remove login and signup pages
/*******************
handle data from elm
*******************/
app.ports.dataForOutside.subscribe(msg => {
    const action = msg.action;
    switch (action) {
        case "UpdateWaterBottleSize":
            getUser()
                .then(response => {
                const currentUser = response;
                const updatedUser = {
                    userName: currentUser.userName,
                    waterBottleSize: msg.data,
                    goal: currentUser.goal
                };
                addOrUpdateUser(updatedUser);
            })
                .catch(error => {
                sendDataToElm("ErrorMessage", error);
            });
            break;
        case "UpdateGoal":
            getUser()
                .then(response => {
                const currentUser = response;
                const updatedUser = {
                    userName: currentUser.userName,
                    waterBottleSize: currentUser.waterBottleSize,
                    goal: msg.data.goal
                };
                addOrUpdateUser(updatedUser);
                getWaterDetails().then(response => {
                    const currentWaterDetails = response;
                    const updatedWaterDetails = {
                        date: currentWaterDetails.date,
                        goalReached: msg.data.goalReached,
                        todayWater: currentWaterDetails.todayWater
                    };
                    addOrUpdateWaterDetails(updatedWaterDetails);
                });
            })
                .catch(error => {
                sendDataToElm("ErrorMessage", error);
            });
            break;
        case "UpdateWaterDetails":
            const updatedWaterDetails = {
                date: getDateString(),
                goalReached: msg.data.goalReached,
                todayWater: msg.data.todayWater
            };
            addOrUpdateWaterDetails(updatedWaterDetails);
            break;
        case "GetUserAndWaterDetails":
            Promise.all([getUser(), getWaterDetails()])
                .then(userAndWaterDetails => {
                sendDataToElm("GetUserAndWaterDetailsSuccess", combineUserAndWaterDetails(userAndWaterDetails));
            })
                .catch(error => {
                sendDataToElm("ErrorMessage", error);
            });
            break;
        default:
            sendDataToElm("ErrorMessage", "no matching actions");
            break;
    }
});
/******************
indexedDB functions
******************/
function openDb() {
    const request = window.indexedDB.open(DB_NAME, DB_VERSION);
    // error handling
    request.onerror = function (event) {
        sendDataToElm("ErrorMessage", this.error);
    };
    // successfully opened indexedDB
    request.onsuccess = function (event) {
        db = event.target.result;
        Promise.all([getUser(), getWaterDetails()])
            .then(userAndWaterDetails => {
            sendDataToElm("GetInitialUserAndWaterDetailsSuccess", combineUserAndWaterDetails(userAndWaterDetails));
        })
            .catch(error => {
            sendDataToElm("ErrorMessage", error);
        });
    };
    // upgrade the db for new users or updated versions
    request.onupgradeneeded = function (event) {
        var db = event.currentTarget.result;
        // User Details Store
        var user_details_store = db.createObjectStore(STORE_USER_DETAILS, {
            keyPath: "userName"
        });
        user_details_store.createIndex("goal", "goal", { unique: false });
        user_details_store.createIndex("waterBottleSize", "waterBottleSize", {
            unique: false
        });
        // Water Details Store
        var water_details_store = db.createObjectStore(STORE_WATER_DETAILS, {
            keyPath: "date"
        });
        water_details_store.createIndex("todayWater", "todayWater", {
            unique: false
        });
        water_details_store.createIndex("goalReached", "goalReached", {
            unique: false
        });
    };
}
function getObjectStore(store_name, mode) {
    var store = db.transaction(store_name, mode);
    return store.objectStore(store_name);
}
/**********************
crud database functions
**********************/
function getUser() {
    const transaction = db.transaction(STORE_USER_DETAILS);
    const objectStore = transaction.objectStore(STORE_USER_DETAILS);
    var request = objectStore.get(USERNAME);
    return new Promise((resolve, reject) => {
        // error
        request.onerror = function (event) {
            sendDataToElm("ErrorMessage", this.error);
        };
        // success
        request.onsuccess = function (event) {
            // if there are no user in the db (first time user or data wiped by browser),
            // we create one and add to indexedDB...
            if (this.result === undefined) {
                const userToAdd = {
                    userName: USERNAME,
                    waterBottleSize: 20,
                    goal: 120
                };
                addOrUpdateUser(userToAdd);
                // ...then send the new user to elm
                resolve(userToAdd);
            }
            else {
                // if there is a user we send the data to elm
                resolve(this.result);
            }
        };
    });
}
function addOrUpdateUser(userToAdd) {
    var store = getObjectStore(STORE_USER_DETAILS, "readwrite");
    // .put() adds a new entry if one doen't already exists, and updates if it does
    var request = store.put(userToAdd);
    // error
    request.onerror = function (event) {
        sendDataToElm("ErrorMessage", this.error);
    };
    // success
    request.onsuccess = function (event) { };
}
function getWaterDetails() {
    const transaction = db.transaction(STORE_WATER_DETAILS);
    const objectStore = transaction.objectStore(STORE_WATER_DETAILS);
    var request = objectStore.get(getDateString());
    return new Promise((resolve, reject) => {
        // error
        request.onerror = function (event) {
            sendDataToElm("ErrorMessage", this.error);
        };
        // success
        request.onsuccess = function (event) {
            // if there are no water details for the current day,
            // we create one and add to indexedDB...
            if (this.result === undefined) {
                const waterDetailsToAdd = {
                    date: getDateString(),
                    goalReached: "notreached",
                    todayWater: 0
                };
                addOrUpdateWaterDetails(waterDetailsToAdd);
                // ...then send the new water details to elm
                resolve(waterDetailsToAdd);
            }
            else {
                // if there are water details we send the data to elm
                resolve(this.result);
            }
        };
    });
}
function addOrUpdateWaterDetails(waterDetailsToAdd) {
    var store = getObjectStore(STORE_WATER_DETAILS, "readwrite");
    // .put() adds a new entry if one doen't already exists, and updates if it does
    var request = store.put(waterDetailsToAdd);
    // error
    request.onerror = function (event) {
        sendDataToElm("ErrorMessage", this.error);
    };
    // success
    request.onsuccess = function (event) { };
}
function clearObjectStore(store_name) {
    var store = getObjectStore(store_name, "readwrite");
    var request = store.clear();
    // error
    request.onerror = function (event) {
        sendDataToElm("ErrorMessage", this.error);
    };
    //success
    request.onsuccess = function (event) {
        sendDataToElm("StoreCleared", null);
    };
}
/********************
send data back to elm
********************/
function sendDataToElm(action, data) {
    app.ports.dataForElm.send({ action: action, data: data });
}
/***************
helper functions
***************/
function getDateString() {
    return `${new Date().getMonth() +
        1}/${new Date().getDate()}/${new Date().getFullYear()}`;
}
function combineUserAndWaterDetails(userAndWaterDetails) {
    // reducer to be used to combine objects
    const objReducer = (acc, curr) => Object.assign(acc, curr);
    const combinedDataForElm = userAndWaterDetails.reduce(objReducer);
    // get the keys needed in the elm type alias
    const myKeys = Object.keys(combinedDataForElm).filter(key => key !== "userName");
    // build an array of those indiviual objects
    const finalDataForElm = myKeys.map(key => {
        return { [key]: combinedDataForElm[key] };
    });
    // combine them to send to elm
    const combineFinalDataForElm = finalDataForElm.reduce(objReducer);
    return combineFinalDataForElm;
}
// registerServiceWorker();
//# sourceMappingURL=index.js.map