package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.PageContent;

/**
 * Class: PageContentDAO
 * Description: Data Access Object (DAO) làm việc với các trang nội dung tĩnh (PageContent).
 * 
 * Created: 2026-06-01
 * Updated: 2026-07-23
 * Version: v1.3
 *
 * @author DuyLD
 */
public class PageContentDAO extends DBContext {


    /**
     * Lấy toàn bộ danh sách các trang nội dung tĩnh đang hoạt động (status = 1).
     *
     * @return Danh sách các đối tượng PageContent
     */
    public ArrayList<PageContent> getAllActivePages() {
        ArrayList<PageContent> list = new ArrayList<>();
        String sql = "SELECT page_id, page_key, title, content, status, created_at, updated_at FROM PageContent WHERE status = 1";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
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

    /**
     * Lấy thông tin trang nội dung tĩnh theo khóa định danh (page_key).
     *
     * @param key Khóa định danh trang (VD: ABOUT, PRIVACY...)
     * @return Đối tượng PageContent hoặc null nếu không tồn tại
     */
    public PageContent getPageByKey(String key) {
        String sql = "SELECT page_id, page_key, title, content, status, created_at, updated_at FROM PageContent WHERE page_key = ? AND status = 1";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
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