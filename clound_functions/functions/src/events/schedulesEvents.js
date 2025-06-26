
import { onDocumentCreated, onDocumentDeleted, onDocumentUpdated } from "firebase-functions/v2/firestore";
import { Scheduling } from "../models/scheduling.js";
import { SchedulesService } from "../services/schedulesService.js";


export const onSchedulingCreated = onDocumentCreated('/schedules/{documentId}',
    (event) => {
        const schedulesService = new SchedulesService();
        schedulesService.schedulingCreated(Scheduling.fromDocumentFirestore(event.data.data()));
    }
);

export const onSchedulingDeleted = onDocumentDeleted('/schedules/{documentId}',
    (event) => {
        const schedulesService = new SchedulesService();
        schedulesService.schedulingDeleted(Scheduling.fromDocumentFirestore(event.data.data()));
    }
);

export const onSchedulingUpdated = onDocumentUpdated('/schedules/{documentId}',
    (event) => {
        const schedulesService = new SchedulesService();
        schedulesService.schedulingUpdated(
            Scheduling.fromDocumentFirestore(event.data.before.data()),
            Scheduling.fromDocumentFirestore(event.data.after.data()),
        );
    }
);



