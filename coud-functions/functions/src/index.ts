import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
const serviceAccount = require('../skimscope-firebase-adminsdk-ffwcv-b5bf61b309.json');
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://skimscope.firebaseio.com/"
});
// import * as admin from 'firebase-admin';

import {
    employeeCreation,
    changeEmployeePassword,
    modifyUserStatus,
} from './employee-creation';

import { onAdminRegistration } from './admin-creation';

// Add employee account
exports.addEmployeeAccount = functions
    .https.onCall((data, context) => {
        return employeeCreation(data, context);
    });

// Change employee password
exports.changeEmpPassword = functions
    .https.onCall((data, context) => {
        return changeEmployeePassword(data, context);
    });

// Modify user status
exports.modifyUser = functions
    .https.onCall((data, context) => {
        return modifyUserStatus(data, context);
    });


exports.onCreateAdmin = functions.region('asia-east2').auth.user().onCreate((user: admin.auth.UserRecord, context: any) => {
    return onAdminRegistration(user, context);
});