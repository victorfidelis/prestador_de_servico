
import { onDocumentCreated, onDocumentDeleted, onDocumentUpdated } from "firebase-functions/v2/firestore";
import { SchedulesPerDayService } from "src/services/schedulesPerDayService";

export const onSchedulingCreated = onDocumentCreated('/schedules/{documentId}',
    async (event) => {
        const timeStampDate = event.data.data().startDateAndTime;
        const schedulesPerDayService = new SchedulesPerDayService();
        await schedulesPerDayService.addScheduling(timeStampDate);
    }
);

export const onSchedulingDeleted = onDocumentDeleted('/schedules/{documentId}',
    async (event) => {
        const timeStampDate = event.data.data().startDateAndTime;
        const schedulesPerDayService = new SchedulesPerDayService();
        await schedulesPerDayService.removeScheduling(timeStampDate);
    }
);

export const onSchedulingUpdated = onDocumentUpdated('/schedules/{documentId}',
    async (event) => {
        const beforeTimeStampDate = event.data.before.data().startDateAndTime;
        const afterTimeStampDate = event.data.after.data().startDateAndTime;
        const schedulesPerDayService = new SchedulesPerDayService();

        await schedulesPerDayService.updateScheduling(beforeTimeStampDate, afterTimeStampDate);
    }
);



