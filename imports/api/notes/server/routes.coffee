bodyParser = Npm.require( 'body-parser' )

Picker.middleware( bodyParser.json() )
Picker.middleware( bodyParser.urlencoded( { extended: false } ) )

Picker.route '/note/inbox', ( params, request, response, next ) ->
  console.log request.body
  noteId = Meteor.call 'notes.inbox',
    userId: request.body.userId
    title: request.body.title
    body: request.body.body
  response.setHeader( 'Content-Type', 'application/json' );
  response.statusCode = 200;
  response.end( noteId );