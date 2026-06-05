package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.PageContent;
import model.CampaignBanner;

public class PageContentDAO extends DBContext {
    private Connection cnn;

    public PageContentDAO() {
        this.cnn = super.connection;
    }

    public ArrayList<PageContent> getAllActivePages() {
        ArrayList<PageContent> list = new ArrayList<>();
        String sql = "SELECT page_id, page_key, title, content, status, created_at, updated_at FROM PageContent WHERE status = 1";
        try (PreparedStatement ps = cnn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                PageContent p = new PageContent();
                p.setPageId(rs.getInt("page_id"));
                p.setPageKey(rs.getString("page_key"));
                p.setTitle(rs.getString("title"));
                p.setContent(rs.getString("content"));
                p.setStatus(rs.getBoolean("status"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                p.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public PageContent getPageByKey(String key) {
        String sql = "SELECT page_id, page_key, title, content, status, created_at, updated_at FROM PageContent WHERE page_key = ? AND status = 1";
        try (PreparedStatement ps = cnn.prepareStatement(sql)) {
            ps.setString(1, key);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PageContent p = new PageContent();
                    p.setPageId(rs.getInt("page_id"));
                    p.setPageKey(rs.getString("page_key"));
                    p.setTitle(rs.getString("title"));
                    p.setContent(rs.getString("content"));
                    p.setStatus(rs.getBoolean("status"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));
                    p.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return p;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    
}