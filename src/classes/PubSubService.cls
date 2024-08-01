/**
 * @description A simple Pub/Sub pattern implementation
 */
public with sharing class PubSubService {

    private Map<String, Set<IHandleMessages>> subscriptionsByChannel;

    private PubSubService() { 
        subscriptionsByChannel = new Map<String, Set<IHandleMessages>>();
    }

    /**
     * @description A singleton for service interaction.
     */
    public static PubSubService Instance {
        get {
            if (Instance == null) {
                Instance = new PubSubService();
            }

            return Instance;
        }

        private set;
    }

    /**
     * @description Subscribes a given IHandleMessages implementation to the channels it returns.
     * @param implementation An instance of IHandleMessages.
     * @throws ArgumentNullException if implementation is null.
     */
    public void subscribe(IHandleMessages implementation) {
        if (implementation == null) {
            throw new ArgumentNullException();
        }

        for(String channel : implementation.getSubscribedChannels()) {
            if (!subscriptionsByChannel.containsKey(channel)) {
                subscriptionsByChannel.put(channel, new Set<IHandleMessages>{implementation});
            }

            subscriptionsByChannel.get(channel).add(implementation);
        }
    }

    /**
     * @description Un-subscribes a given IHandleMessages implementation to the channels it returns.
     * @param implementation An instance of IHandleMessages.
     * @throws ArgumentNullException if implementation is null.
     */
    public void unsubscribe(IHandleMessages implementation) {
        if (implementation == null) {
            throw new ArgumentNullException();
        }

        for(String channel : implementation.getSubscribedChannels()) {
            if (subscriptionsByChannel.containsKey(channel)) {
                subscriptionsByChannel.get(channel).remove(implementation);
            }
        }
    }

    //TO DO - Test to check channel is null 
    //      - Test to check if the channel has no subscribers

    /**
     * @description Emits a message to a given channel containing the specified data.
     * @param channel The channel to emit a message on.
     * @param data The data to emit.
     * @throws ArgumentNullException if channel is null.
     */
    public void emit(String channel, Object data) {
        ArgumentNullException.throwIfNull(channel, Constants.CHANNEL_PARAM);

        if (subscriptionsByChannel.containsKey(channel)) {
            for (IHandleMessages handleMessages : subscriptionsByChannel.get(channel)) {
                handleMessages.handleMessage(channel, data);
            }
        }

        //It could be a exception or a log due you are emitting a message to a channel that has no subscribers
    }
}


// /**
//  * @description A simple Pub/Sub pattern implementation
//  */
// public with sharing class PubSubService {

//     private Set<IHandleMessages> subscriptions;

//     private PubSubService() { 
//         subscriptions = new Set<IHandleMessages>();
//     }

//     /**
//      * @description A singleton for service interaction.
//      */
//     public static PubSubService Instance {
//         get {
//             if (Instance == null) {
//                 Instance = new PubSubService();
//             }

//             return Instance;
//         }

//         private set;
//     }

//     /**
//      * @description Subscribes a given IHandleMessages implementation to the channels it returns.
//      * @param implementation An instance of IHandleMessages.
//      * @throws ArgumentNullException if implementation is null.
//      */
//     public void subscribe(IHandleMessages implementation) {
//         if (implementation == null) {
//             throw new ArgumentNullException();
//         }

//         subscriptions.add(implementation);
//     }

//     /**
//      * @description Un-subscribes a given IHandleMessages implementation to the channels it returns.
//      * @param implementation An instance of IHandleMessages.
//      * @throws ArgumentNullException if implementation is null.
//      */
//     public void unsubscribe(IHandleMessages implementation) {
//         if (implementation == null) {
//             throw new ArgumentNullException();
//         }

//         subscriptions.remove(implementation);
//     }

//     /**
//      * @description Emits a message to a given channel containing the specified data.
//      * @param channel The channel to emit a message on.
//      * @param data The data to emit.
//      * @throws ArgumentNullException if channel is null.
//      */
//     public void emit(String channel, Object data) {
//         ArgumentNullException.throwIfNull(channel, Constants.CHANNEL_PARAM);
        
//         for (IHandleMessages handleMessages : subscriptions) {
//             if (handleMessages.getSubscribedChannels().contains(channel)) {
//                 handleMessages.handleMessage(channel, data);
//             }
//         }
//     }
// }