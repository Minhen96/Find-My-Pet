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
        origin: process.env.FRONTEND_URL || '*',
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

    // Subscribe to the JOIN_PET event
    @SubscribeMessage(WS_EVENTS.JOIN_PET)
    handleJoinPet(client: Socket, petId: string) {
        // Join a private room for each pet
        // Prevents from waking up for thousands of unrelated likes.
        client.join(`pet_${petId}`);
        this.logger.log(`Client ${client.id} joined room pet_${petId}`);
    }

    // Subscribe to the LEAVE_PET event
    @SubscribeMessage(WS_EVENTS.LEAVE_PET)
    handleLeavePet(client: Socket, petId: string) {
        // Leave the private room for the pet
        client.leave(`pet_${petId}`);
        this.logger.log(`Client ${client.id} left room pet_${petId}`);
    }

    // Broadcast to all clients in the pet's room
    broadcastToPet(petId: string, event: string, data: any) {
        this.server.to(`pet_${petId}`).emit(event, data);
    }
}
