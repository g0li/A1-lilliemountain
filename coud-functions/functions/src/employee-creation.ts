import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export async function employeeCreation(data: any, context: functions.https.CallableContext) {
    try {

        const userEmail: string = data.email;
        const userPassword: string = data.password;
        const userName: string = data.name;
        const joiningDate = new Date(data.joiningDate);
        const createdBy: string = data.createdBy;

        const EmployeeTokens = {
            role: 'EMP',
            isActive: true,
        };

        // create firebase account
        const newEmployee = await admin.auth().createUser({
            email: userEmail.trim(),
            password: userPassword.trim(),
            displayName: userName.trim(),
        });

        // add tokens to user
        await admin.auth().createCustomToken(newEmployee.uid, EmployeeTokens);

        // save user to firestore
        await admin.firestore().doc(`users/${newEmployee.uid}`).set({
            id: newEmployee.uid,
            role: 'Employee',
            name: userName.trim(),
            email: userEmail.trim(),
            joiningDate: joiningDate,
            whenCreated: admin.firestore.FieldValue.serverTimestamp(),
            createdBy: createdBy,
            isActive: true,
        });

        return {
            status: 1,
            message: 'Employee creation successful'
        };


    } catch (err) {
        console.log('Employee creation failed', err);
        return {
            status: 0,
            error: err
        };
    }
}


export async function changeEmployeePassword(data: any, context: any) {
    try {

        const userId: string = data.userId;
        const newPassword: string = data.password;

        if (!userId || !newPassword) {
            return {
                status: 0,
                error: 'User Id and password is required'
            }
        }

        await admin.auth().updateUser(userId, {
            password: newPassword.trim()
        });

        return {
            status: 1,
            message: 'Password updated successfully'
        }


    } catch (err) {
        console.log('Error changing employee password');
        return {
            status: 0,
            error: err,
        }
    }
}


export async function modifyUserStatus(data: any, context: any) {
    try {

        const status: boolean = data.isActive;
        const userId: string = data.userId;

        const EmployeeTokens = {
            role: 'EMP',
            isActive: status,
        };

        // update claims
        await admin.auth().setCustomUserClaims(userId, EmployeeTokens);

        await admin.firestore().doc(`users/${userId}`).update({
            isActive: status,
            whenModified: admin.firestore.FieldValue.serverTimestamp(),
        });

        return {
            status: 1,
            message: 'User status modified successfully',
        }


    } catch (err) {
        console.log('Error modifying user status', err);
        return {
            status: 0,
            error: err,
        }
    }
}