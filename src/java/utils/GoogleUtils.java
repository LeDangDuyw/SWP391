package utils;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class GoogleUtils {

    public static final String GOOGLE_CLIENT_ID = "560009557221-md9sba4a9jhc2o6uqmenduo1pbeansmo.apps.googleusercontent.com";
    public static final String GOOGLE_CLIENT_SECRET = "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";
    public static final String GOOGLE_REDIRECT_URI = "http://localhost:8080/UniLap/login-google";
    
    public static final String GOOGLE_LINK_GET_TOKEN = "https://accounts.google.com/o/oauth2/token";
    public static final String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";

    /*
     * Name: getToken
     * @Author: LUCTVHE201874
     * Date: [04/06/2026]
     * Version: 1.0
     * Description: Hàm này gửi yêu cầu POST đến endpoint của Google để trao đổi 
     * Authorization Code lấy chuỗi mã Access Token phục vụ truy cập dữ liệu người dùng.
     */
    public static String getToken(final String code) throws Exception {
        URL url = new URL(GOOGLE_LINK_GET_TOKEN);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setDoOutput(true);

        String postParams = "client_id=" + URLEncoder.encode(GOOGLE_CLIENT_ID, "UTF-8")
                + "&client_secret=" + URLEncoder.encode(GOOGLE_CLIENT_SECRET, "UTF-8")
                + "&redirect_uri=" + URLEncoder.encode(GOOGLE_REDIRECT_URI, "UTF-8")
                + "&code=" + URLEncoder.encode(code, "UTF-8")
                + "&grant_type=authorization_code";

        try (OutputStream os = conn.getOutputStream()) {
            os.write(postParams.getBytes());
            os.flush();
        }

        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            String inputLine;
            StringBuilder response = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();
            return response.toString();
        } else {
            throw new RuntimeException("Failed to exchange code for token: HTTP error code : " + responseCode);
        }
    }

    /*
     * Name: getUserInfo
     * @Author: LUCTVHE201874
     * Date: [04/06/2026]
     * Version: 1.0
     * Description: Hàm này gửi yêu cầu GET kèm theo Access Token đến Google UserInfo API 
     * để lấy thông tin cá nhân của người dùng dưới dạng chuỗi JSON.
     */
    public static String getUserInfo(final String accessToken) throws Exception {
        URL url = new URL(GOOGLE_LINK_GET_USER_INFO + accessToken);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            String inputLine;
            StringBuilder response = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();
            return response.toString();
        } else {
            throw new RuntimeException("Failed to get user info: HTTP error code : " + responseCode);
        }
    }

    /*
     * Name: getJsonField
     * @Author: LUCTVHE201874
     * Date: [04/06/2026]
     * Version: 1.0
     * Description: Hàm này sử dụng biểu thức chính quy (Regex) để trích xuất nhanh 
     * giá trị của một trường cụ thể từ chuỗi JSON trả về từ API.
     */
    public static String getJsonField(String json, String fieldName) {
        Pattern pattern = Pattern.compile("\"" + fieldName + "\"\\s*:\\s*\"([^\"]+)\"");
        Matcher matcher = pattern.matcher(json);
        if (matcher.find()) {
            return matcher.group(1);
        }
        return "";
    }
}
