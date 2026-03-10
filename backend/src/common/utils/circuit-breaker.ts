import { Logger } from '@nestjs/common';

export enum CircuitState {
    CLOSED = 'CLOSED',
    OPEN = 'OPEN',
    HALF_OPEN = 'HALF_OPEN',
}

export class CircuitBreaker {
    private state: CircuitState = CircuitState.CLOSED;
    private failureCount = 0;
    private lastFailureTime: number | null = null;
    private readonly logger: Logger;

    constructor(
        private readonly serviceName: string,
        private readonly failureThreshold: number = 5,
        private readonly resetTimeout: number = 30000, // 30 seconds
    ) {
        this.logger = new Logger(`CircuitBreaker:${serviceName}`);
    }

    // If the action fails, return the fallback value
    // If the action succeeds, return the result
    // If the circuit is open, return the fallback value
    // If the circuit is half-open, return the fallback value
    async execute<T>(action: () => Promise<T>, fallback: T): Promise<T> {
        this.checkState();

        if (this.state === CircuitState.OPEN) {
            return fallback;
        }

        try {
            const result = await action();
            this.onSuccess();
            return result;
        } catch (error: any) {
            this.onFailure(error);
            return fallback;
        }
    }

    private checkState() {
        if (this.state === CircuitState.OPEN && this.lastFailureTime) {
            const now = Date.now();
            if (now - this.lastFailureTime > this.resetTimeout) {
                this.state = CircuitState.HALF_OPEN;
                this.logger.log(`Circuit state changed from OPEN to HALF_OPEN (Testing recovery)`);
            }
        }
    }

    private onSuccess() {
        if (this.state === CircuitState.HALF_OPEN || this.state === CircuitState.OPEN) {
            this.logger.log(`Circuit state changed to CLOSED (Service recovered)`);
        }
        this.state = CircuitState.CLOSED;
        this.failureCount = 0;
        this.lastFailureTime = null;
    }

    private onFailure(error: any) {
        this.failureCount++;
        this.lastFailureTime = Date.now();

        if (this.state === CircuitState.HALF_OPEN || this.failureCount >= this.failureThreshold) {
            if (this.state !== CircuitState.OPEN) {
                this.state = CircuitState.OPEN;
                this.logger.error(
                    `Circuit state flipped to OPEN (Service failing). Failure count: ${this.failureCount}. Reason: ${error.message}`,
                );
            }
        }
    }

    getState(): CircuitState {
        return this.state;
    }
}
