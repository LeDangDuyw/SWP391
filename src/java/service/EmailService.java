package service;

import jakarta.activation.DataHandler;
import jakarta.activation.FileDataSource;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import java.io.File;
import java.util.Properties;

public class EmailService {

    public static boolean sendInvoiceEmail(String toEmail, String orderCode, File pdfFile) {
        final String from = "unilap.store@gmail.com"; 
        final String password = "unilapPassMock123"; 

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from, "UniLap Store"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Your UniLap Order Invoice");

            MimeBodyPart textPart = new MimeBodyPart();
            textPart.setText("Dear Customer,\n\n" +
                             "Thank you politely for your purchase at UniLap Store!\n" +
                             "Please find attached the PDF invoice for your order: #" + orderCode + ".\n\n" +
                             "Best regards,\n" +
                             "UniLap Team");

            MimeBodyPart attachmentPart = new MimeBodyPart();
            attachmentPart.setDataHandler(new DataHandler(new FileDataSource(pdfFile)));
            attachmentPart.setFileName(pdfFile.getName());

            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(textPart);
            multipart.addBodyPart(attachmentPart);

            message.setContent(multipart);
            
            try {
                Transport.send(message);
                return true;
            } catch (Exception e) {
                System.out.println("JavaMail send error: " + e.getMessage());
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
