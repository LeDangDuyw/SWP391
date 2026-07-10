package utils;

import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

/*
 * Name: EmailUtils
 * @Author: LUCTVHE201874
 * Date: [21/06/2026]
 * Version: 1.0
 * Description: Utility class to send email notifications via Gmail SMTP. Logs fallback details in console for offline testing.
 */
public class EmailUtils {

    // Configurable SMTP details - update with valid credentials if real mail dispatch is required
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SENDER_EMAIL = "trinhvanluc412@gmail.com";
    private static final String SENDER_PASSWORD = "inodknqihcjqxlbb";

    /**
     * Sends an email using Jakarta Mail SMTP.
     * Always logs email details to the server stdout as a fallback for offline development.
     */
    public static boolean sendEmail(String toEmail, String subject, String body) {
        // Output fallback logs for developer debugging
        System.out.println("==================================================");
        System.out.println("[EMAIL OUTBOX LOG]");
        System.out.println("Recipient: " + toEmail);
        System.out.println("Subject:   " + subject);
        System.out.println("Content:\n" + body);
        System.out.println("==================================================");

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject, "UTF-8");
            message.setContent(body, "text/html; charset=UTF-8");

            // We attempt sending. If it throws (e.g. because credentials are dummy), 
            // we catch it and print error, but return false without breaking the server controller execution.
            try {
                Transport.send(message);
                System.out.println("[EMAIL] Dispatch succeeded to " + toEmail);
                return true;
            } catch (Exception ex) {
                System.err.println("[EMAIL] Real mail delivery failed: " + ex.getMessage());
                return false;
            }
        } catch (Exception e) {
            System.err.println("[EMAIL] Mail preparation failed: " + e.getMessage());
            return false;
        }
    }
}
