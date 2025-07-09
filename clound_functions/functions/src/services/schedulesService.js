import { SchedulesPerDayRepository } from "../repositories/schedulePerDayRepository.js";
import { SchedulingRepository } from "../repositories/schedulingRepository.js";
import { UserRepository } from "../repositories/userRepository.js";
import formatDate from "../utils/date_utils.js";

export class SchedulesService {
    constructor() {
        this.schedulesPerDayRepository = new SchedulesPerDayRepository();
        this.userRepository = new UserRepository();
        this.schedulingRepository = new SchedulingRepository();
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
        if (scheduling.review > 0) {
            user.averageRating = await this.schedulingRepository.getAverageRatingByUser(user.userId);
        }
        await this.userRepository.update(user);
    }

    async schedulingUpdated(schedulingBefore, schedulingAfter) {
        await this.#updateSchedulesPerDay(schedulingBefore, schedulingAfter);
        await this.#updateUser(schedulingBefore, schedulingAfter);
    }

    async #updateSchedulesPerDay(schedulingBefore, schedulingAfter) {
        const dateFormattedBefore = formatDate(schedulingBefore.startDateAndTime);
        const dateFormattedAfter = formatDate(schedulingAfter.startDateAndTime);
        if (dateFormattedBefore !== dateFormattedAfter) {
            await this.schedulesPerDayRepository.removeSchedulingInDay(dateFormattedBefore);
            await this.schedulesPerDayRepository.addSchedulingInDay(dateFormattedAfter);
        }
    }

    async #updateUser(schedulingBefore, schedulingAfter) {
        if (schedulingBefore.serviceStatusCode === schedulingAfter.serviceStatusCode &&
            schedulingBefore.review === schedulingAfter.review) {
            return;
        }

        let user = await this.userRepository.get(schedulingBefore.userId);

        if (schedulingBefore.serviceStatusCode !== schedulingAfter.serviceStatusCode) {
            user = this.#decreaseStatusCount(user, schedulingBefore.serviceStatusCode);
            user = this.#increaseStatusCount(user, schedulingAfter.serviceStatusCode);
        }

        if (schedulingBefore.review != schedulingAfter.review) {
            user.averageRating = await this.schedulingRepository.getAverageRatingByUser(user.userId);
        }

        await this.userRepository.update(user);
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
        return user;
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
        return user;
    }
}