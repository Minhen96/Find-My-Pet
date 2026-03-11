import {
    WebSocketGateway,
    WebSocketServer,
    SubscribeMessage,
    OnGatewayInit,
    OnGatewayConnection,
    OnGatewayDisconnect,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { Logger } from '@nestjs/common';
import { WS_EVENTS } from '../../common/constants/app.constants';

@WebSocketGateway({
    // Allow frontend to connect
    cors: {
        origin: true,
    },
})
export class EventsGateway implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect {
    // WebSocket server instance
    @WebSocketServer() server: Server;
    // Logger instance
    private logger: Logger = new Logger('EventsGateway');

    // Handle gateway initialization
    afterInit(server: Server) {
        this.logger.log('WebSocket Gateway Initialized');
    }

    // Handle client connection
    handleConnection(client: Socket, ...args: any[]) {
        this.logger.log(`Client connected: ${client.id}`);
    }

    // Handle client disconnection
    handleDisconnect(client: Socket) {
        this.logger.log(`Client disconnected: ${client.id}`);
    }

    // Subscribe to the JOIN_POST event
    @SubscribeMessage(WS_EVENTS.JOIN_POST)
    handleJoinPost(client: Socket, postId: string) {
        // Join a private room for each post
        client.join(`post_${postId}`);
        this.logger.log(`Client ${client.id} joined room post_${postId}`);
    }

    // Subscribe to the LEAVE_POST event
    @SubscribeMessage(WS_EVENTS.LEAVE_POST)
    handleLeavePost(client: Socket, postId: string) {
        // Leave the private room for the post
        client.leave(`post_${postId}`);
        this.logger.log(`Client ${client.id} left room post_${postId}`);
    }

    // Broadcast to all clients in the post's room
    broadcastToPost(postId: string, event: string, data: any) {
        this.server.to(`post_${postId}`).emit(event, data);
    }
}
