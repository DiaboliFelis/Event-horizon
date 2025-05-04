const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const firestore = admin.firestore();

// Функция-триггер при создании события
exports.onEventCreated = functions.firestore
  .document('events/{eventId}')
  .onCreate(async (snapshot, context) => {
    const eventData = snapshot.data();
    const eventId = context.params.eventId;

    // Можно здесь ничего не делать или записать в отдельную коллекцию "notifications_to_send"
    // с временем отправки уведомления

    // Получаем userId и время события
    const userId = eventData.userId;
    const eventName = eventData.eventName;
    const eventDateTime = eventData.eventDateTime.toDate();

    // Получаем настройки пользователя
    const userSettingsDoc = await firestore.collection('user_settings').doc(userId).get();
    const userSettings = userSettingsDoc.data();
    const notificationTimePreference = userSettings?.notificationTime || 'день';

    let notificationTimeInMinutes;
    if (notificationTimePreference === 'день') {
      notificationTimeInMinutes = 24 * 60;
    } else {
      notificationTimeInMinutes = 60;
    }

    // Время отправки уведомления
    const notificationTriggerTime = new Date(eventDateTime.getTime() - notificationTimeInMinutes * 60000);

    if (notificationTriggerTime <= new Date()) {
      console.warn(`Notification time for event ${eventId} is in the past. Skipping scheduling.`);
      return null;
    }

    // Записываем задачу на отправку уведомления в отдельную коллекцию
    await firestore.collection('notifications_to_send').doc(eventId).set({
      userId,
      eventName,
      sendAt: admin.firestore.Timestamp.fromDate(notificationTriggerTime),
      eventId,
      sent: false,
    });

    console.log(`Notification scheduled for event ${eventId} at ${notificationTriggerTime.toISOString()}`);

    return null;
  });

// Периодическая функция для отправки уведомлений (например, запускается каждую минуту)
exports.sendScheduledNotifications = functions.pubsub.schedule('every 1 minutes').onRun(async (context) => {
  const now = admin.firestore.Timestamp.now();

  // Получаем все уведомления, которые нужно отправить и которые еще не были отправлены
  const notificationsQuerySnapshot = await firestore.collection('notifications_to_send')
    .where('sendAt', '<=', now)
    .where('sent', '==', false)
    .get();

  if (notificationsQuerySnapshot.empty) {
    console.log('No notifications to send at this time.');
    return null;
  }

  const batch = firestore.batch();

  for (const doc of notificationsQuerySnapshot.docs) {
    const data = doc.data();
    
    try {
      await sendNotification(data.userId, data.eventName, data.eventId);
      
      // Отмечаем уведомление как отправленное
      batch.update(doc.ref, { sent: true });
      
      console.log(`Notification sent for event ${data.eventId}`);
      
    } catch (error) {
      console.error(`Failed to send notification for event ${data.eventId}:`, error);
      // Можно добавить логику повторных попыток или пометить ошибку
    }
  }

  await batch.commit();

  return null;
});

// Функция отправки FCM уведомления
async function sendNotification(userId, eventName, eventId) {
  // Получаем FCM токен пользователя
  const userDoc = await firestore.collection('users').doc(userId).get();
  if (!userDoc.exists) {
    console.warn(`User ${userId} not found`);
    return;
  }
  
  const userData = userDoc.data();
  const fcmToken = userData?.fcmToken;

  if (!fcmToken) {
    console.warn(`No FCM token found for user ${userId}`);
    return;
  }

  const payload = {
    notification: {
      title: 'Напоминание о мероприятии',
      body: `Мероприятие "${eventName}" скоро начнется!`,
    },
    data: { // данные для приложения
      eventId,
      click_action: 'FLUTTER_NOTIFICATION_CLICK', // если используете Flutter например
    },
  };

  await admin.messaging().sendToDevice(fcmToken, payload);
}