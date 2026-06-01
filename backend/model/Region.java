package model;

/**
 * Region
 *
 * Purpose: Defines the Region component of the system. Responsibilities: -
 * Encapsulates the behavior and data related to Region. - Supports the
 * application business logic according to Java coding conventions.
 *
 * Author: Project Team Version: 1.0
 */
public class Region {

    private int regionId;
    private String regionCode;   // e.g. "NA", "EU", "APAC"
    private String regionName;   // e.g. "North America"
    private boolean active;

    public Region() {
    }

    public Region(int regionId, String regionCode, String regionName, boolean active) {
        this.regionId = regionId;
        this.regionCode = regionCode;
        this.regionName = regionName;
        this.active = active;
    }

    public int getRegionId() {
        return regionId;
    }

    public void setRegionId(int id) {
        this.regionId = id;
    }

    public String getRegionCode() {
        return regionCode;
    }

    public void setRegionCode(String code) {
        this.regionCode = code;
    }

    public String getRegionName() {
        return regionName;
    }

    public void setRegionName(String name) {
        this.regionName = name;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
