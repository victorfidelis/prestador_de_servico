
export class SchedulesPerDayRepository {  
    async addSchedulingInDay(dateDocumentId) {
        const docRef = getFirestore().collection("schedulesPerDay").doc(dateDocumentId);
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
    
    async removeSchedulingInDay(dateDocumentId) {
        const docRef = getFirestore().collection("schedulesPerDay").doc(dateDocumentId);
        const doc = await docRef.get();

        if (doc.exists) {
            let schedulesPerDay = SchedulesPerDay.fromDocumentFirestore(doc.data());
            schedulesPerDay.removeScheduling();
            await docRef.update(schedulesPerDay.toDocumentFirestore());
        } 
    }
}
