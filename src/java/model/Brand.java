package model;

public class Brand {
    private int brandId;
    private String brandName;

    /*
     * Name: Brand
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Khởi tạo đối tượng Brand rỗng (constructor mặc định).
     */
    public Brand() {
    }

    /*
     * Name: Brand
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Khởi tạo đối tượng Brand với các thuộc tính brandId và brandName.
     */
    public Brand(int brandId, String brandName) {
        this.brandId = brandId;
        this.brandName = brandName;
    }

    /*
     * Name: getBrandId
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy mã thương hiệu (brandId).
     */
    public int getBrandId() {
        return brandId;
    }

    /*
     * Name: setBrandId
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Gán mã thương hiệu (brandId).
     */
    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }

    /*
     * Name: getBrandName
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy tên thương hiệu (brandName).
     */
    public String getBrandName() {
        return brandName;
    }

    /*
     * Name: setBrandName
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Gán tên thương hiệu (brandName).
     */
    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }
}
