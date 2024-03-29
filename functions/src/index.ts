import * as functions from 'firebase-functions'

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
export const helloWorld = functions.https.onRequest((request, response) => {
  response.send('Hello from Firebase!')
})

export const ListVersions = functions.https.onRequest((_, response) => {
  response.set('Access-Control-Allow-Origin', '*')
  response.set('Access-Control-Allow-Methods', '*')
  response.set('Access-Control-Allow-Headers', '*')

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
