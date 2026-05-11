import java.time.LocalDate;
import java.time.LocalTime;

public class VoiceAssistantImpl implements VoiceAssistant {

    private String command;
    private String response;

    @Override
    public void listenCommand(String command) {

        this.command = command.toLowerCase().trim();

        System.out.println("[ARIA] Command: " + this.command);
    }

    @Override
    public void executeTask() {

        if(command.contains("hello")) {

            response = "Hello! I am ARIA.";

        } else if(command.contains("time")) {

            response = "Current time is " +
                    LocalTime.now().withNano(0);

        } else if(command.contains("date")) {

            response = "Today's date is " +
                    LocalDate.now();

        } else if(command.contains("your name")) {

            response = "My name is ARIA.";

        } else {

            response = "Sorry, I did not understand.";
        }
    }

    @Override
    public String provideResponse() {

        return response;
    }
}