// import * as functions from "firebase-functions";
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
import * as functions from "firebase-functions";
import vision from "@google-cloud/vision";

export const textRecognition = functions.https.onRequest(
    async (req: functions.https.Request, res: functions.Response<unknown>) => {
        const client = new vision.ImageAnnotatorClient();
        try {
            // const projectId = "mywine-9221a";
            // const bucketName = `${projectId}.appspot.com/uploads`;
            // const fileName = `${req.body.photoId}`;
            const request = {
                image: {
                    content: Buffer.from(req.body.base64, "base64"),
                },
            };
            const [result] = await client.textDetection(request);
            // const [result] = await client.textDetection(
            //     `gs://${bucketName}/${fileName}`
            // );
            console.log(result.fullTextAnnotation);
            // result.textAnnotations?.map((e) => console.log(e.description));
            res.send({"data": result});
        } catch (error) {
            console.error(error);
            res.send(error);
        }
    }
);
