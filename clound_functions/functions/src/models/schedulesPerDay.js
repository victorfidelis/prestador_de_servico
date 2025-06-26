
export class SchedulesPerDay {
    constructor(hasService, numberOfServices) {
        this.hasService = hasService;
        this.numberOfServices = numberOfServices;
    }

    static createEmpty() {
        return new SchedulesPerDay(false, 0);
    }

    static createFirstScheduling() {
        return new SchedulesPerDay(true, 1);
    }

    static fromDocumentFirestore(document) {
        return new SchedulesPerDay(document.hasService, document.numberOfServices);
    }

    toDocumentFirestore() {
        return {
            hasService: this.hasService,
            numberOfServices: this.numberOfServices
        };
    }

    addScheduling() {
        this.hasService = true;
        this.numberOfServices += 1;
    }

    removeScheduling() {
        if (this.numberOfServices > 0) {
            this.numberOfServices -= 1
        } else {
            this.numberOfServices = 0
        }

        this.hasService = (this.numberOfServices > 0);
    }
}