import { getFirestore } from "firebase-admin/firestore";
import { User } from "../models/user.js";

export class UserRepository {
    async get(userId) {
        const docRef = getFirestore().collection("users").doc(userId);
        const userDoc = await docRef.get();
        return User.fromDocumentFirestore(userId, userDoc);
    }

    async update(user) {
        const docRef = getFirestore().collection("users").doc(user.userId);
        await docRef.update(user.toDocumentFirestore());
    } 
}

