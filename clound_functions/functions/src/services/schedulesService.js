import { SchedulesPerDayRepository } from "../repositories/schedulePerDayRepository.js";
import { UserRepository } from "../repositories/userRepository.js";
import formatDate from "../utils/date_utils.js";

export class SchedulesService {
    constructor() {
        this.schedulesPerDayRepository = new SchedulesPerDayRepository();
        this.userRepository = new UserRepository();
    }

    async schedulingCreated(scheduling) {
        const dateFormatted = formatDate(scheduling.startDateAndTime);
        await this.schedulesPerDayRepository.addSchedulingInDay(dateFormatted);

        let user = await this.userRepository.get(scheduling.userId);
        user = this.#increaseStatusCount(user, scheduling.serviceStatusCode);
        await this.userRepository.update(user);
    }

    async schedulingDeleted(scheduling) {
        const dateFormatted = formatDate(scheduling.startDateAndTime);
        await this.schedulesPerDayRepository.removeSchedulingInDay(dateFormatted);

        let user = await this.userRepository.get(scheduling.userId);
        user = this.#decreaseStatusCount(user, scheduling.serviceStatusCode);
        await this.userRepository.update(user);
    }

    async schedulingUpdated(schedulingBefore, schedulingAfter) {
        const dateFormattedBefore = formatDate(schedulingBefore.startDateAndTime);
        const dateFormattedAfter = formatDate(schedulingAfter.startDateAndTime);
        await this.schedulesPerDayRepository.updateScheduling(dateFormattedBefore, dateFormattedAfter); 

        if (schedulingBefore.serviceStatusCode !== schedulingAfter.serviceStatusCode) {
            let user = await this.userRepository.get(schedulingBefore.userId);
            user = this.#decreaseStatusCount(user, schedulingBefore.serviceStatusCode);
            user = this.#increaseStatusCount(user, schedulingAfter.serviceStatusCode);
            await this.userRepository.update(user);
        }
    }

    #increaseStatusCount(user, status) {
        if (status == 1) {
            user.pendingProviderSchedules += 1;
        } else if (status == 2) {
            user.pendingClientSchedules += 1;
        } else if (status == 3) {
            user.confirmedSchedules += 1;
        } else if (status == 4) {
            user.inServiceSchedules += 1;
        } else if (status == 5) {
            user.performedSchedules += 1;
        } else if (status == 6) {
            user.deniedSchedules += 1;
        } else if (status == 7) {
            user.canceledByProviderSchedules += 1;
        } else if (status == 8) {
            user.canceledByClientSchedules += 1;
        } else if (status == 9) {
            user.expiredSchedules += 1;
        }
    }

    #decreaseStatusCount(user, status) {
        if (status == 1 && user.pendingProviderSchedules > 0) {
            user.pendingProviderSchedules -= 1;
        } else if (status == 2 && user.pendingClientSchedules > 0) {
            user.pendingClientSchedules -= 1;
        } else if (status == 3 && user.confirmedSchedules > 0) {
            user.confirmedSchedules -= 1;
        } else if (status == 4 && user.inServiceSchedules > 0) {
            user.inServiceSchedules -= 1;
        } else if (status == 5 && user.performedSchedules > 0) {
            user.performedSchedules -= 1;
        } else if (status == 6 && user.deniedSchedules > 0) {
            user.deniedSchedules -= 1;
        } else if (status == 7 && user.canceledByProviderSchedules > 0) {
            user.canceledByProviderSchedules -= 1;
        } else if (status == 8 && user.canceledByClientSchedules > 0) {
            user.canceledByClientSchedules -= 1;
        } else if (status == 9 && user.expiredSchedules > 0) {
            user.expiredSchedules -= 1;
        }
    }
}