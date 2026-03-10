export const REDIS_KEYS = {
    PET_LIKERS: (petId: string) => `pet:${petId}:likers`,
    PET_LIKES_COUNT: (petId: string) => `pet:${petId}:likes_count`,
    FEED_CACHE_PREFIX: 'feed:pets:',
};

export const QUEUE_NAMES = {
    INTERACTIONS: 'interactions',
};

export const WS_EVENTS = {
    JOIN_PET: 'joinPet',
    LEAVE_PET: 'leavePet',
    LIKE_UPDATE: 'likeUpdate',
    NEW_COMMENT: 'newComment',
};

export const JOB_NAMES = {
    LIKE: 'like',
    UNLIKE: 'unlike',
};
