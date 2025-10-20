package com.example.secrud.migrations;

import com.example.secrud.models.Category;
import com.example.secrud.services.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class CategoryMigrationRunner implements ApplicationRunner {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private CategoryService categoryService;

    @Override
    public void run(ApplicationArguments args) throws Exception {
        try {
            // Check if legacy 'category' column exists
            Integer legacyCount = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'movies' AND column_name = 'category'",
                    Integer.class);

            if (legacyCount == null || legacyCount == 0) {
                System.out.println("CategoryMigration: no legacy 'category' column found, skipping migration.");
                return;
            }

            // Ensure join table exists (movie_categories); create if missing
            Integer joinExists = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'movie_categories'",
                    Integer.class);

            if (joinExists == null || joinExists == 0) {
                System.out.println("CategoryMigration: join table 'movie_categories' not found. Creating it now.");
                // Create join table compatible with Hibernate mapping
                String createSql = "CREATE TABLE IF NOT EXISTS movie_categories (" +
                        "movie_id BIGINT NOT NULL, " +
                        "category_id BIGINT NOT NULL, " +
                        "PRIMARY KEY (movie_id, category_id), " +
                        "INDEX idx_movie_id (movie_id), " +
                        "INDEX idx_category_id (category_id), " +
                        "CONSTRAINT fk_movie FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE, " +
                        "CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE" +
                        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;";
                try {
                    jdbcTemplate.execute(createSql);
                    System.out.println("CategoryMigration: created join table 'movie_categories'.");
                } catch (Exception ex) {
                    System.err.println("CategoryMigration: failed to create join table: " + ex.getMessage());
                    // continue, later logic will check again
                }
                // re-check
                joinExists = jdbcTemplate.queryForObject(
                        "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'movie_categories'",
                        Integer.class);
                if (joinExists == null || joinExists == 0) {
                    System.out.println("CategoryMigration: join table still not present - aborting migration.");
                    return;
                }
            }

            // Query rows with non-empty legacy category values
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                    "SELECT id, category FROM movies WHERE category IS NOT NULL AND TRIM(category) <> ''");

            if (rows.isEmpty()) {
                System.out.println("CategoryMigration: no legacy category values to migrate.");
                return;
            }

            // Map distinct category names to Category IDs
            Map<String, Long> nameToId = new HashMap<>();
            for (Map<String, Object> r : rows) {
                Object raw = r.get("category");
                if (raw == null) continue;
                String name = raw.toString().trim();
                if (name.isEmpty()) continue;
                if (!nameToId.containsKey(name)) {
                    Category c = categoryService.findByName(name);
                    if (c == null) c = categoryService.addCategory(name);
                    if (c != null) nameToId.put(name, c.getId());
                }
            }

            // Insert into join table per movie -> category mapping, avoid duplicates
            int totalInserted = 0;
            for (Map<String, Object> r : rows) {
                Object raw = r.get("category");
                if (raw == null) continue;
                String name = raw.toString().trim();
                if (name.isEmpty()) continue;
                Long catId = nameToId.get(name);
                if (catId == null) continue;
                Long movieId = ((Number) r.get("id")).longValue();

                Integer exists = jdbcTemplate.queryForObject(
                        "SELECT COUNT(*) FROM movie_categories WHERE movie_id = ? AND category_id = ?",
                        Integer.class, movieId, catId);
                if (exists == null || exists == 0) {
                    jdbcTemplate.update("INSERT INTO movie_categories (movie_id, category_id) VALUES (?, ?)", movieId, catId);
                    totalInserted++;
                }
            }

            // Optionally clear the old column so migration doesn't run again
            jdbcTemplate.update("UPDATE movies SET category = NULL WHERE category IS NOT NULL");

            System.out.println("CategoryMigration: migration completed, total join rows inserted=" + totalInserted);
        } catch (Exception ex) {
            System.err.println("CategoryMigration: migration failed: " + ex.getMessage());
            // don't rethrow to avoid blocking startup
        }
    }
}
