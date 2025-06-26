export class Scheduling {

    constructor(userId, startDateAndTime, serviceStatusCode) {
        this.userId = userId;
        this.startDateAndTime = startDateAndTime;
        this.serviceStatusCode = serviceStatusCode;
    }

    static fromDocumentFirestore(document) {
        return new Scheduling(
            document.userId, 
            document.startDateAndTime.toDate(), 
            document.serviceStatusCode,
        );
    }
}