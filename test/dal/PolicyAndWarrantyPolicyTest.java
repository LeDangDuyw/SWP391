package dal;

import java.util.List;
import model.GeneralPolicy;
import model.WarrantyPolicy;

public class PolicyAndWarrantyPolicyTest {

    public static void main(String[] args) {
        System.out.println("=========================================");
        System.out.println("   Policy & WarrantyPolicy Test Runner   ");
        System.out.println("=========================================");

        try {
            // 1. Test GeneralPolicyDAO
            GeneralPolicyDAO generalDAO = new GeneralPolicyDAO();
            System.out.println("\n--- Testing GeneralPolicyDAO ---");
            
            String[] policyTypes = {"PRIVACY", "TERMS", "SHOPPING_GUIDE", "ABOUT"};
            for (String type : policyTypes) {
                GeneralPolicy policy = generalDAO.getPolicyByType(type);
                if (policy != null) {
                    System.out.println("[SUCCESS] Fetched policy for type: " + type);
                    System.out.println("  ID: " + policy.getPolicyId());
                    System.out.println("  Title: " + policy.getTitle());
                    System.out.println("  Length: " + policy.getContent().length() + " chars");
                } else {
                    System.out.println("[ERROR] Failed to fetch policy for type: " + type);
                }
            }

            // 2. Test WarrantyPolicyDAO
            WarrantyPolicyDAO warrantyDAO = new WarrantyPolicyDAO();
            System.out.println("\n--- Testing WarrantyPolicyDAO ---");
            
            List<WarrantyPolicy> activePolicies = warrantyDAO.getActivePolicies();
            System.out.println("[INFO] Active warranty policies size: " + activePolicies.size());
            for (WarrantyPolicy wp : activePolicies) {
                System.out.println("[SUCCESS] Warranty Policy: " + wp.getPolicyName());
                System.out.println("  ID: " + wp.getPolicyId());
                System.out.println("  Warranty Months: " + wp.getWarrantyMonths());
                System.out.println("  Regions: " + wp.getApplicableRegions());
                System.out.println("  Description: " + wp.getDescription());
            }

        } catch (Exception e) {
            System.out.println("[ERROR] Exception occurred during testing:");
            e.printStackTrace();
        }
        System.out.println("\n=========================================");
    }
}
