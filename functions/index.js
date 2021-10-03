/* eslint-disable max-len */

import functions from "firebase-functions";

// The Firebase Admin SDK to access Firestore.
import admin from "firebase-admin";
admin.initializeApp();

const db = admin.firestore();

import countries from "./countries.js";
import regions from "./regions.js";
import appellations from "./appellations.js";
import varieties from "./varieties.js";

export const cleanNotEnabled = functions.https.onRequest(async (req, res) => {
  const collectionName = req.body.collection;

  await Promise.all((await db.collection(collectionName).where("enabled", "==", false).get()).docs.map((document) => db.collection(collectionName).doc(document.id).delete()));
  res.sendStatus(200);
});


/**
 * @param {onject} object
 * @return {array}
 */
function convertObjectToArray(object) {
  const list = [];

  for (const [key, value] of Object.entries(object)) {
    value.id = key;
    list.push(value);
  }

  return list;
}

export const toFirestoreCountries = functions.https.onRequest(async (req, res) => {
  const list = convertObjectToArray(countries);

  await Promise.all(list.map((document) => db.collection("countries").doc(document.id).set(document)));
  res.sendStatus(200);
});

export const toFirestoreRegions = functions.https.onRequest(async (req, res) => {
  const list = convertObjectToArray(regions);

  await Promise.all(list.map((document) => db.collection("regions").doc(document.id).set(document)));
  res.sendStatus(200);
});

export const toFirestoreAppellations = functions.https.onRequest(async (req, res) => {
  const list = convertObjectToArray(appellations);

  await Promise.all(list.map((document) => db.collection("appellations").doc(document.id).set(document)));
  res.sendStatus(200);
});

export const toFirestoreVarieties = functions.https.onRequest(async (req, res) => {
  const list = convertObjectToArray(varieties);

  await Promise.all(list.map((document) => db.collection("varieties").doc(document.id).set(document)));
  res.sendStatus(200);
});

export const addCacheColorToPositions = functions.https.onRequest(async (req, res) => {
  var cellars = await db.collectionGroup("cellars").get();
  var blocks = await db.collection("cellars/"+cellar.id+"blocks").get();

  await Promise.all(blocks.docs.map((block) => { 
      db.collection("wines").doc(position.data().wine).get().then((wine) => {
        if (wine.data()) {
          db.collection("appellations").doc(wine.data().appellation).get().then((appellation) => {
            if (appellation.data()) {
              db.collectionGroup("positions").doc(position.data().id).update({"color":appellation.color})
            }
          })
        }
      })
  }));

  await Promise.all(positions.docs.map((position) => 
    db.collection("wines").doc(position.data().wine).get().then((wine) => {
      if (wine.data()) {
        db.collection("appellations").doc(wine.data().appellation).get().then((appellation) => {
          if (appellation.data()) {
            db.collectionGroup("positions").doc(position.data().id).update({"color":appellation.color})
          }
        })
      }
    })
  ));
  res.sendStatus(200);
});


