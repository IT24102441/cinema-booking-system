package com.example.secrud.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.validation.BindException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    private boolean wantsHtml(HttpServletRequest request) {
        String accept = request.getHeader("Accept");
        if (accept == null) return false;
        return accept.contains(MediaType.TEXT_HTML_VALUE);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Object> handleMethodArgNotValid(MethodArgumentNotValidException ex, HttpServletRequest request) {
        Map<String, String> errors = ex.getBindingResult().getFieldErrors().stream()
                .collect(Collectors.toMap(f -> f.getField(), f -> f.getDefaultMessage(), (a, b) -> a));

        if (wantsHtml(request)) {
            StringBuilder sb = new StringBuilder();
            sb.append("<html><head><title>Validation Error</title></head><body>");
            sb.append("<h1>Validation failed</h1><ul>");
            errors.forEach((k, v) -> sb.append("<li><strong>").append(k).append(":</strong> ").append(escapeHtml(v)).append("</li>"));
            sb.append("</ul><p><a href=\"/admin/movies\">Back</a></p></body></html>");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).contentType(MediaType.TEXT_HTML).body(sb.toString());
        }

        Map<String, Object> body = new HashMap<>();
        body.put("message", "Validation failed");
        body.put("errors", errors);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).contentType(MediaType.APPLICATION_JSON).body(body);
    }

    @ExceptionHandler(BindException.class)
    public ResponseEntity<Object> handleBindException(BindException ex, HttpServletRequest request) {
        Map<String, String> errors = ex.getBindingResult().getFieldErrors().stream()
                .collect(Collectors.toMap(f -> f.getField(), f -> f.getDefaultMessage(), (a, b) -> a));

        if (wantsHtml(request)) {
            StringBuilder sb = new StringBuilder();
            sb.append("<html><head><title>Binding Error</title></head><body>");
            sb.append("<h1>Form binding failed</h1><ul>");
            errors.forEach((k, v) -> sb.append("<li><strong>").append(k).append(":</strong> ").append(escapeHtml(v)).append("</li>"));
            sb.append("</ul><p><a href=\"/admin/movies\">Back</a></p></body></html>");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).contentType(MediaType.TEXT_HTML).body(sb.toString());
        }

        Map<String, Object> body = new HashMap<>();
        body.put("message", "Form binding failed");
        body.put("errors", errors);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).contentType(MediaType.APPLICATION_JSON).body(body);
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<Object> handleHttpMessageNotReadable(HttpMessageNotReadableException ex, HttpServletRequest request) {
        logger.warn("Malformed request body", ex);
        String msg = "Malformed request body: " + (ex.getMostSpecificCause() != null ? ex.getMostSpecificCause().getMessage() : ex.getMessage());

        if (wantsHtml(request)) {
            String html = "<html><head><title>Bad Request</title></head><body><h1>Bad Request</h1><p>" + escapeHtml(msg) + "</p>" +
                    "<p><a href=\"/admin/movies\">Back</a></p></body></html>";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).contentType(MediaType.TEXT_HTML).body(html);
        }

        Map<String, Object> body = new HashMap<>();
        body.put("message", "Malformed request body");
        body.put("detail", ex.getMostSpecificCause() != null ? ex.getMostSpecificCause().getMessage() : ex.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).contentType(MediaType.APPLICATION_JSON).body(body);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Object> handleAll(Exception ex, HttpServletRequest request) {
        logger.error("Unhandled exception", ex);

        if (wantsHtml(request)) {
            String html = "<html><head><title>Server Error</title></head><body>" +
                    "<h1>Server error</h1><p>An unexpected error occurred. Please try again later.</p>" +
                    "<p><a href=\"/admin/movies\">Back to movies</a></p></body></html>";
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).contentType(MediaType.TEXT_HTML).body(html);
        }

        Map<String, Object> body = new HashMap<>();
        body.put("message", "Internal server error");
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).contentType(MediaType.APPLICATION_JSON).body(body);
    }

    // simple HTML escaper
    private String escapeHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }
}
