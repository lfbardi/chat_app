const io = require('socket.io')(require('http').createServer(() => {}).listen(80));

const users = {};

const rooms = {};

io.on('connection', io => {
    console.log('\n\nConnection established with a client');

    io.on('validate', (data, callback) => {
        const user = users[data.username];
        if(user) {
            user.password === data.password 
                ? callback({ status: 'ok' }) 
                : callback({ status: 'fail' })
        } else {
            users[data.username] = data;
            io.broadcast.emit("newUser", users);
            callback({ status: 'created' })
        }
    });
    
    io.on('create', (data, callback) => {
        if(rooms[data.roomName]) {
            callback({ status: 'exists' })
        } else {
            data.users = {};
            rooms[data.roomName] = data;
            io.broadcast.emit('created', rooms);
            callback({ status: 'created', rooms })
        }
    });
    
    io.on('listRooms', (data, callback) => callback(rooms));
    
    io.on('listUsers', (data, callback) => callback(users));
    
    io.on('join', (data, callback) => {
        const room  = rooms[data.roomName];
        if(Object.keys(rooms.user).length >= rooms.maxPeople) {
            callback({ status: 'full' });
        } else {
            room.users[data.username] = users[data.username];
            io.broadcast.emit('joined', room);
            callback({ status: 'joined', room });
        }
    });
    
    io.on('post', (data, callback) => {
        io.broadcast.emit('posted', data);
        callback({ status: 'ok' });
    });
    
    io.on('invite', (data, callback) => {
        io.broadcast.emit('invited', data);
        callback({ status: 'ok' });
    });
    
    io.on('leave', (data, callback) => {
        const room = rooms[data.roomName];
        delete room.users[data.username];
        io.broadcast.emmit('left', room);
        callback({ status: 'ok' });
    });
    
    io.on('close', (data, callback) => {
        delete rooms[data.roomName];
        io.broadcast.emit('closed', { roomName: data.roomName, rooms });
        callback(rooms);
    });
    
    io.on('kick', (data, callback) => {
        const room = rooms[data.roomName];
        const users = room.users;
        delete users[data.username];
        io.broadcast.emit('kicked', room);
        callback({ status: 'ok' });
    });
});



