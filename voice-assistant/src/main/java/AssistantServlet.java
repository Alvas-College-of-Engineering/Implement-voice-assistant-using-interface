import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.*;

public class AssistantServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("text/plain");

        String command = req.getParameter("command");

        System.out.println("[ARIA] Received: " + command);

        VoiceAssistant assistant =
                new VoiceAssistantImpl();

        assistant.listenCommand(command);

        assistant.executeTask();

        String response =
                assistant.provideResponse();

        res.getWriter().write(response);
    }
}