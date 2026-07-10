package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "LocationServlet", urlPatterns = {"/LocationServlet"})
public class LocationServlet extends HttpServlet {

    private String fetchGetUrl(String urlString) throws IOException {
        URL url = new URL(urlString);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Accept", "application/json");

        int responseCode = conn.getResponseCode();
        if (responseCode == 200) {
            try (BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
                StringBuilder response = new StringBuilder();
                String inputLine;
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                return response.toString();
            }
        } else {
            throw new IOException("HTTP Error: " + responseCode);
        }
    }

    private String fetchPostUrl(String urlString, String jsonBody) throws IOException {
        URL url = new URL(urlString);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setRequestProperty("Accept", "application/json");
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonBody.getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        int responseCode = conn.getResponseCode();
        BufferedReader in;
        if (responseCode >= 200 && responseCode < 300) {
            in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        } else {
            in = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
        }

        StringBuilder response = new StringBuilder();
        String inputLine;
        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();
        return response.toString();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String action = request.getParameter("action");

        try {
            if ("provinces".equals(action)) {
                String data = fetchGetUrl("https://partner.viettelpost.vn/v2/categories/listProvince");
                out.print(data);
            } else if ("districts".equals(action)) {
                String provinceId = request.getParameter("provinceId");
                if (provinceId == null || provinceId.trim().isEmpty()) {
                    out.print("{\"status\":400,\"error\":true,\"message\":\"Missing provinceId\",\"data\":[]}");
                    return;
                }
                String data = fetchGetUrl("https://partner.viettelpost.vn/v2/categories/listDistrict?provinceId=" + provinceId.trim());
                out.print(data);
            } else if ("wards".equals(action)) {
                String districtId = request.getParameter("districtId");
                if (districtId == null || districtId.trim().isEmpty()) {
                    out.print("{\"status\":400,\"error\":true,\"message\":\"Missing districtId\",\"data\":[]}");
                    return;
                }
                String data = fetchGetUrl("https://partner.viettelpost.vn/v2/categories/listWards?districtId=" + districtId.trim());
                out.print(data);
            } else if ("calculateFee".equals(action)) {
                String receiverProvince = request.getParameter("provinceId");
                String receiverDistrict = request.getParameter("districtId");
                String totalStr = request.getParameter("total");

                if (receiverProvince == null || receiverDistrict == null || receiverProvince.trim().isEmpty() || receiverDistrict.trim().isEmpty()) {
                    out.print("{\"status\":400,\"error\":true,\"message\":\"Missing address ids\",\"fee\":30000}");
                    return;
                }

                long totalAmount = 0;
                try {
                    if (totalStr != null) {
                        totalAmount = new BigDecimal(totalStr.replaceAll("[^0-9]", "")).longValue();
                    }
                } catch (Exception e) {
                    totalAmount = 20000000;
                }

                // Call Viettel Post getPriceAll API
                String jsonInputString = "{" +
                        "\"PRODUCT_WEIGHT\": 2000," +
                        "\"PRODUCT_PRICE\": " + totalAmount + "," +
                        "\"MONEY_COLLECTION\": 0," +
                        "\"SENDER_PROVINCE\": 1," +
                        "\"SENDER_DISTRICT\": 25," +
                        "\"RECEIVER_PROVINCE\": " + receiverProvince.trim() + "," +
                        "\"RECEIVER_DISTRICT\": " + receiverDistrict.trim() + "," +
                        "\"PRODUCT_TYPE\": \"HH\"," +
                        "\"TYPE_LOOP\": 1" +
                        "}";

                try {
                    String resp = fetchPostUrl("https://partner.viettelpost.vn/v2/order/getPriceAll", jsonInputString);
                    // Parse GIA_CUOC from response json using regex
                    java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("\"GIA_CUOC\"\\s*:\\s*(\\d+)");
                    java.util.regex.Matcher matcher = pattern.matcher(resp);
                    long fee = 30000; // default fallback fee
                    if (matcher.find()) {
                        fee = Long.parseLong(matcher.group(1));
                    }
                    out.print("{\"status\":200,\"error\":false,\"fee\":" + fee + "}");
                } catch (Exception ex) {
                    out.print("{\"status\":500,\"error\":true,\"message\":\"" + ex.getMessage() + "\",\"fee\":30000}");
                }
            } else {
                out.print("{\"status\":400,\"error\":true,\"message\":\"Invalid action\"}");
            }
        } catch (Exception e) {
            out.print("{\"status\":500,\"error\":true,\"message\":\"" + e.getMessage() + "\",\"fee\":30000}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
