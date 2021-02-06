import { admin } from 'firebase-admin/lib/auth';
import * as functions from 'firebase-functions';
// import * as admin from 'firebase-admin';

import {
    employeeCreation,
    changeEmployeePassword,
    modifyUserStatus,
} from './employee-creation';

import { onAdminRegistration } from './admin-creation';

// Add employee account
export const addEmployeeAccount = functions
    .region('asia-east2')
    .https.onCall((data, context) => {
        return employeeCreation(data, context);
    });

// Change employee password
export const changeEmpPassword = functions
    .region('asia-east2')
    .https.onCall((data, context) => {
        return changeEmployeePassword(data, context);
    });

// Modify user status
export const modifyUser = functions
    .region('asia-east2')
    .https.onCall((data, context) => {
        return modifyUserStatus(data, context);
    });


export const onCreateAdmin = functions.region('asia-east2').auth.user().onCreate((user: admin.auth.UserRecord, context: any) => {
    return onAdminRegistration(user, context);
});