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
    cors: {
        origin: process.env.FRONTEND_URL || '*',
    },
})
export class EventsGateway implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect {
    @WebSocketServer() server: Server;
    private logger: Logger = new Logger('EventsGateway');

    afterInit(server: Server) {
        this.logger.log('WebSocket Gateway Initialized');
    }

    handleConnection(client: Socket, ...args: any[]) {
        this.logger.log(`Client connected: ${client.id}`);
    }

    handleDisconnect(client: Socket) {
        this.logger.log(`Client disconnected: ${client.id}`);
    }

    @SubscribeMessage(WS_EVENTS.JOIN_PET)
    handleJoinPet(client: Socket, petId: string) {
        client.join(`pet_${petId}`);
        this.logger.log(`Client ${client.id} joined room pet_${petId}`);
    }

    @SubscribeMessage(WS_EVENTS.LEAVE_PET)
    handleLeavePet(client: Socket, petId: string) {
        client.leave(`pet_${petId}`);
        this.logger.log(`Client ${client.id} left room pet_${petId}`);
    }

    broadcastToPet(petId: string, event: string, data: any) {
        this.server.to(`pet_${petId}`).emit(event, data);
    }
}
