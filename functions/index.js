const { onDocumentCreated } = require('firebase-functions/v2/firestore');
const { initializeApp } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');
const { getMessaging } = require('firebase-admin/messaging');

initializeApp();

exports.onNewMessage = onDocumentCreated(
  'pairs/{pairId}/messages/{messageId}',
  async (event) => {
    const snap = event.data;
    if (!snap) return;

    const data = snap.data();
    const senderId = data.senderId;
    const text = data.text;
    const pairId = event.params.pairId;
    const messageId = event.params.messageId;

    if (!senderId || !text) return;

    const db = getFirestore();
    const pairDoc = await db.collection('pairs').doc(pairId).get();
    const memberIds = pairDoc.data()?.memberIds ?? [];
    const recipientId = memberIds.find((id) => id !== senderId);
    if (!recipientId) return;

    const [recipientDoc, senderDoc] = await Promise.all([
      db.collection('users').doc(recipientId).get(),
      db.collection('users').doc(senderId).get(),
    ]);

    const token = recipientDoc.data()?.fcmToken;
    if (!token) return;

    const senderName = senderDoc.data()?.displayName ?? 'Your spouse';
    const preview = text.length > 100 ? `${text.substring(0, 100)}...` : text;

    await getMessaging().send({
      token,
      notification: {
        title: senderName,
        body: preview,
      },
      data: {
        type: 'new_message',
        pairId,
        messageId,
        title: senderName,
        body: preview,
      },
      android: {
        priority: 'high',
        ttl: 86400,
        collapseKey: 'pair_messages',
        notification: {
          channelId: 'pair_notifications',
          priority: 'high',
          defaultSound: true,
          defaultVibrateTimings: true,
        },
      },
      apns: {
        headers: {
          'apns-priority': '10',
        },
      },
    });
  },
);

exports.onGroceryItemCreated = onDocumentCreated(
  'pairs/{pairId}/groceryItems/{itemId}',
  async (event) => {
    const snap = event.data;
    if (!snap) return;

    const data = snap.data();
    const addedBy = data.addedBy;
    const text = data.text;
    const pairId = event.params.pairId;
    const itemId = event.params.itemId;

    if (!addedBy || !text) return;

    const db = getFirestore();
    const pairDoc = await db.collection('pairs').doc(pairId).get();
    const memberIds = pairDoc.data()?.memberIds ?? [];
    const recipientId = memberIds.find((id) => id !== addedBy);
    if (!recipientId) return;

    const [recipientDoc, senderDoc] = await Promise.all([
      db.collection('users').doc(recipientId).get(),
      db.collection('users').doc(addedBy).get(),
    ]);

    const token = recipientDoc.data()?.fcmToken;
    if (!token) return;

    const senderName = senderDoc.data()?.displayName ?? 'Your spouse';

    const body = `Added "${text}" to the grocery list`;

    await getMessaging().send({
      token,
      notification: {
        title: senderName,
        body,
      },
      data: {
        type: 'new_grocery_item',
        pairId,
        itemId,
        title: senderName,
        body,
      },
      android: {
        priority: 'high',
        ttl: 86400,
        collapseKey: 'pair_grocery',
        notification: {
          channelId: 'pair_notifications',
          priority: 'high',
          defaultSound: true,
          defaultVibrateTimings: true,
        },
      },
      apns: {
        headers: {
          'apns-priority': '10',
        },
      },
    });
  },
);
