
import { initializeApp } from "firebase-admin/app";
import * as schedulesEvents from "./events/schedulesEvents"   

initializeApp();

export const onSchedulingCreated = schedulesEvents.onSchedulingCreated();
export const onSchedulingDeleted = schedulesEvents.onSchedulingDeleted();
export const onSchedulingUpdated = schedulesEvents.onSchedulingUpdated();
