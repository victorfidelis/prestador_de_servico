import { getFirestore } from "firebase-admin/firestore";
import { SchedulesPerDay } from "../models/schedulesPerDay";

export class SchedulesPerDayService {
    async addScheduling(timeStampDate) {
        const date = timeStampDate.toDate()
        const formatDate = formatDate(date)
        await this.#addScheduleInFirestore(formatDate)
    }
    
    async #addScheduleInFirestore(documentId) {
        const docRef = getFirestore().collection("schedulesPerDay").doc(documentId);
        const doc = await docRef.get();

        if (doc.exists) {
            let schedulesPerDay = SchedulesPerDay.fromDocumentFirestore(doc.data());
            schedulesPerDay.addScheduling();
            await docRef.update(schedulesPerDay.toDocumentFirestore());
        } else {
            const schedulesPerDay = SchedulesPerDay.createFirstScheduling();
            await docRef.create(schedulesPerDay.toDocumentFirestore());
        }
    }

    async removeScheduling(timeStampDate) {
        const date = timeStampDate.toDate()
        const formatDate = formatDate(date)
        await this.#removeScheduleInFirestore(formatDate)
    }

    async #removeScheduleInFirestore(documentId) {
        const docRef = getFirestore().collection("schedulesPerDay").doc(documentId);
        const doc = await docRef.get();

        if (doc.exists) {
            let schedulesPerDay = SchedulesPerDay.fromDocumentFirestore(doc.data());
            schedulesPerDay.removeScheduling();
            await docRef.update(schedulesPerDay.toDocumentFirestore());
        } 
    }

    async updateScheduling(beforeTimeStampDate, afterTimeStampDate) {
        const beforeFormatDate = formatDate(beforeTimeStampDate.toDate())
        const afterFormatDate = formatDate(afterTimeStampDate.toDate())

        if (beforeFormatDate === afterFormatDate) {
            return;
        }

        await this.#removeScheduleInFirestore(beforeFormatDate)
        await this.#addScheduleInFirestore(afterFormatDate)
    }
}

