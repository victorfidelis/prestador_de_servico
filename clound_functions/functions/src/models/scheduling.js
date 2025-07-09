export class Scheduling {

    constructor(userId, startDateAndTime, serviceStatusCode, review) {
        this.userId = userId;
        this.startDateAndTime = startDateAndTime;
        this.serviceStatusCode = serviceStatusCode;
        this.review = review;
    }

    static fromDocumentFirestore(document) {
        return new Scheduling(
            document.userId, 
            document.startDateAndTime.toDate(), 
            document.serviceStatusCode,
            document.review,
        );
    }
}