import * as admin from 'firebase-admin';

export async function onAdminRegistration(user: admin.auth.UserRecord, context: any) {
    try {

        const userId = user.uid;
        const adminToken = {
            role: 'ADMIN',
            isActive: true,
        };

        await admin.auth().setCustomUserClaims(userId, adminToken);
        return Promise.resolve('Added admin claims successfully');

    } catch (err) {
        console.log('Error in admin registration', err);
        return Promise.reject('Error in adding admin claims');
    }
}