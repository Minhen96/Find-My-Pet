export const REDIS_KEYS = {
    POST_LIKERS: (postId: string) => `post:${postId}:likers`,
    POST_LIKES_COUNT: (postId: string) => `post:${postId}:likes_count`,
    FEED_CACHE_PREFIX: 'feed:posts:',
};

export const QUEUE_NAMES = {
    INTERACTIONS: 'interactions',
};

export const WS_EVENTS = {
    JOIN_POST: 'joinPost',
    LEAVE_POST: 'leavePost',
    LIKE_UPDATE: 'likeUpdate',
    NEW_COMMENT: 'newComment',
};

export const JOB_NAMES = {
    LIKE: 'like',
    UNLIKE: 'unlike',
};
