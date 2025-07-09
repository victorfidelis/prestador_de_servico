import { AggregateField, getFirestore } from "firebase-admin/firestore";

export class SchedulingRepository {
    async getAverageRatingByUser(userId) {
        const query = getFirestore().collection("schedules").where('userId', '==', userId).where('review', '>', 0);
        const averageRatingQuery = query.aggregate({
            averageRating: AggregateField.average('review'),
        });
        const averageRatingSnapshot = await averageRatingQuery.get();
        return averageRatingSnapshot.data().averageRating;
    }
}