package model;

public class Category {
    private int categoryId;
    private String categoryName;

    /*
     * Name: Category
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Khởi tạo đối tượng Category rỗng (constructor mặc định).
     */
    public Category() {
    }

    /*
     * Name: Category
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Khởi tạo đối tượng Category với các thuộc tính categoryId và categoryName.
     */
    public Category(int categoryId, String categoryName) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
    }

    /*
     * Name: getCategoryId
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy mã danh mục (categoryId).
     */
    public int getCategoryId() {
        return categoryId;
    }

    /*
     * Name: setCategoryId
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Gán mã danh mục (categoryId).
     */
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    /*
     * Name: getCategoryName
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy tên danh mục (categoryName).
     */
    public String getCategoryName() {
        return categoryName;
    }

    /*
     * Name: setCategoryName
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Gán tên danh mục (categoryName).
     */
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
}
