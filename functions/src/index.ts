import * as functions from 'firebase-functions'

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
export const helloWorld = functions.https.onRequest((request, response) => {
  response.send('Hello from Firebase!')
})

export const getVersions = functions.https.onRequest((_, response) => {
  const versions = [
    {
      id: 'id1',
      name: 'hoge'
    },
    {
      id: 'id2',
      name: 'fuga'
    }
  ]

  response.send(versions)
})
