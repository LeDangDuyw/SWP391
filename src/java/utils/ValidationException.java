package utils;

/**
 * ValidationException is thrown when a warranty business rule is violated.
 *
 * Used by WarrantyService to signal invalid operations to WarrantyController.
 *
 * Version 1.0
 * Author DuyLD
 */
public class ValidationException extends Exception {

    /**
     * Creates a new ValidationException with the given message.
     *
     * @param message description of the validation error
     */
    public ValidationException(String message) {
        super(message);
    }
}
