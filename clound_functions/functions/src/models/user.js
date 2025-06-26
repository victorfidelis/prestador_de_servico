export class User {
    constructor(
        userId,
        rating,
        pendingProviderSchedules,
        pendingClientSchedules,
        confirmedSchedules,
        inServiceSchedules,
        performedSchedules,
        deniedSchedules,
        canceledByProviderSchedules,
        canceledByClientSchedules,
        expiredSchedules,
    ) {
        this.userId = userId;
        this.rating = rating;
        this.pendingProviderSchedules = pendingProviderSchedules;
        this.pendingClientSchedules = pendingClientSchedules;
        this.confirmedSchedules = confirmedSchedules;
        this.inServiceSchedules = inServiceSchedules;
        this.performedSchedules = performedSchedules;
        this.deniedSchedules = deniedSchedules;
        this.canceledByProviderSchedules = canceledByProviderSchedules;
        this.canceledByClientSchedules = canceledByClientSchedules;
        this.expiredSchedules = expiredSchedules;
    }

    static fromDocumentFirestore(documentId, document) {
        return new User(
            documentId,
            document.rating ?? 0,
            document.pendingProviderSchedules ?? 0,
            document.pendingClientSchedules ?? 0,
            document.confirmedSchedules ?? 0,
            document.inServiceSchedules ?? 0,
            document.performedSchedules ?? 0,
            document.deniedSchedules ?? 0,
            document.canceledByProviderSchedules ?? 0,
            document.canceledByClientSchedules ?? 0,
            document.expiredSchedules ?? 0,
        );
    }

    toDocumentFirestore() {
        return {
            rating: this.rating,
            pendingProviderSchedules: this.pendingProviderSchedules,
            pendingClientSchedules: this.pendingClientSchedules,
            confirmedSchedules: this.confirmedSchedules,
            inServiceSchedules: this.inServiceSchedules,
            performedSchedules: this.performedSchedules,
            deniedSchedules: this.deniedSchedules,
            canceledByProviderSchedules: this.canceledByProviderSchedules,
            canceledByClientSchedules: this.canceledByClientSchedules,
            expiredSchedules: this.expiredSchedules
        }
    }
}