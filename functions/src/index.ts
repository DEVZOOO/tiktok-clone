/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// import {onRequest} from "firebase-functions/v2/https";
// import * as logger from "firebase-functions/logger";

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";    // admin 사용

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


// admin 초기화
admin.initializeApp();

// 새 비디오 업로드되어 DB에 추가되었으면 수정
export const onVideoCreated = functions.firestore.document("videos/{videoId}").onCreate(async (snapshot, context) => {
    // snapshot : 방금 만들어진 영상

    const spawn = require('child-process-promise').spawn;
    const video = snapshot.data();
    await spawn("ffmpeg", [
        "-i",
        video.fileUrl,  // 비디오 가져오기
        "-ss",  // 비디오 위치
        "00:00:01.000", // 1초 시간대
        "-vframes", // 프레임
        "1",    // 첫번째
        "-vf",  // 사이즈 조절
        "scale=150:-1", // 사이즈, width 150, height 비율에 맞게 알아서 조절
        `/tmp/${snapshot.id}.jpg`, // 임시저장소 /tmp에 저장
    ]);  // 명령어, 파라미터

    // storage 접근
    const storage = admin.storage();
    const [file, _] = await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {  // # 이름 같아야 함!
        destination : `thumbnails/${snapshot.id}.jpg`,  // 목적지
    });

    await file.makePublic();

    // ref : document 접근
    await snapshot.ref.update({
        thumbnailUrl : file.publicUrl(),
    });

    const db = admin.firestore();
    // users/:userId/videos/:videoId
    await db.collection("users").doc(video.creatorUid).collection("videos").doc(snapshot.id).set({
       thumbnailUrl : file.publicUrl(),
       videoId: snapshot.id, 
    });

});

