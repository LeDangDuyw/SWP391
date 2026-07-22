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
        // Chức năng gửi email hóa đơn điện tử đã bị tắt theo yêu cầu.
        System.out.println("[EmailService] Electronic invoice email feature disabled.");
        return false;
    }
}
