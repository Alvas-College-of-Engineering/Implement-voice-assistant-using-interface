 
/**
 * VoiceAssistant Interface
 *
 * WHY AN INTERFACE?
 * -----------------
 * An interface is a CONTRACT. It says "whoever implements me MUST have these methods."
 * This is the core of the project requirement.
 *
 * In real systems (Alexa, Siri), each method would be a separate microservice.
 * Here we define all 3 in one interface and implement them in one class.
 *
 * Spring equivalent: Think of this like a @Service interface that you
 * @Autowire — same concept, just without the Spring container.
 */
public interface VoiceAssistant {

    void listenCommand(String command);
    void executeTask();
    String provideResponse();

}