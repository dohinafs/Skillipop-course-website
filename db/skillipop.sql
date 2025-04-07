-- Database: skillipop

CREATE DATABASE IF NOT EXISTS skillipop;
USE skillipop;

-- Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('student', 'instructor', 'admin') DEFAULT 'student',
    profile_pic VARCHAR(255) DEFAULT 'https://randomuser.me/api/portraits/men/1.jpg',
    bio TEXT,
    interests TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verified BOOLEAN DEFAULT FALSE,
    verification_token VARCHAR(100)
);

-- Courses table
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT NOT NULL,
    instructor_id INT NOT NULL,
    thumbnail VARCHAR(255) DEFAULT 'https://source.unsplash.com/random/600x400/?course',
    category VARCHAR(50) NOT NULL,
    difficulty ENUM('beginner', 'intermediate', 'advanced') DEFAULT 'beginner',
    duration INT NOT NULL COMMENT 'Duration in hours',
    is_free BOOLEAN DEFAULT TRUE,
    price DECIMAL(10,2) DEFAULT 0.00,
    rating DECIMAL(3,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (instructor_id) REFERENCES users(user_id)
);

-- Course content table
CREATE TABLE course_content (
    content_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    content_type ENUM('video', 'text', 'quiz', 'assignment') NOT NULL,
    duration INT COMMENT 'Duration in minutes',
    resource_url VARCHAR(255),
    is_preview BOOLEAN DEFAULT FALSE,
    sequence INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Enrollments table
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    progress INT DEFAULT 0 COMMENT 'Percentage completed',
    completed BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP NULL,
    certificate_id VARCHAR(50) NULL,
    FOREIGN KEY (student_id) REFERENCES users(user_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    UNIQUE KEY unique_enrollment (student_id, course_id)
);

-- Progress tracking table
CREATE TABLE progress (
    progress_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    content_id INT NOT NULL,
    completed BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP NULL,
    score INT NULL,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id),
    FOREIGN KEY (content_id) REFERENCES course_content(content_id)
);

-- Reviews table
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Discussion forums
CREATE TABLE discussions (
    discussion_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    user_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Discussion replies
CREATE TABLE discussion_replies (
    reply_id INT AUTO_INCREMENT PRIMARY KEY,
    discussion_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (discussion_id) REFERENCES discussions(discussion_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Sample data
INSERT INTO users (username, email, password, full_name, role, bio, verified) VALUES
('admin', 'admin@skillipop.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin User', 'admin', 'System Administrator', TRUE),
('instructor1', 'instructor1@skillipop.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'John Doe', 'instructor', 'Professional Communication Trainer', TRUE),
('student1', 'student1@skillipop.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Alice Johnson', 'student', 'Computer Science Student', TRUE);

INSERT INTO courses (title, slug, description, instructor_id, category, difficulty, duration, is_free, price) VALUES
('Effective Communication Skills', 'effective-communication-skills', 'Master the art of communication in professional and personal settings.', 2, 'Communication', 'beginner', 10, TRUE, 0.00),
('Public Speaking Mastery', 'public-speaking-mastery', 'Overcome your fear of public speaking and deliver powerful presentations.', 2, 'Communication', 'intermediate', 15, FALSE, 49.99),
('Time Management for Professionals', 'time-management', 'Learn proven techniques to manage your time effectively and boost productivity.', 2, 'Productivity', 'beginner', 8, TRUE, 0.00),
('Leadership and Team Building', 'leadership-team-building', 'Develop essential leadership skills to inspire and guide your team to success.', 2, 'Leadership', 'advanced', 20, FALSE, 79.99);

INSERT INTO course_content (course_id, title, description, content_type, duration, resource_url, sequence) VALUES
(1, 'Introduction to Communication', 'Understanding the basics of effective communication', 'video', 15, 'https://www.youtube.com/embed/abc123', 1),
(1, 'Verbal vs Non-verbal Communication', 'Learn the difference and importance of both types', 'video', 20, 'https://www.youtube.com/embed/def456', 2),
(1, 'Active Listening', 'Techniques to improve your listening skills', 'text', NULL, NULL, 3),
(1, 'Communication Quiz', 'Test your understanding of communication basics', 'quiz', 10, NULL, 4),
(2, 'Overcoming Stage Fear', 'Techniques to conquer your fear of public speaking', 'video', 25, 'https://www.youtube.com/embed/ghi789', 1),
(2, 'Structuring Your Speech', 'How to organize your thoughts for maximum impact', 'video', 30, 'https://www.youtube.com/embed/jkl012', 2),
(3, 'Prioritization Techniques', 'Learn how to prioritize tasks effectively', 'video', 15, 'https://www.youtube.com/embed/mno345', 1);

INSERT INTO enrollments (student_id, course_id, progress, completed) VALUES
(3, 1, 75, FALSE),
(3, 3, 100, TRUE);

INSERT INTO reviews (course_id, user_id, rating, comment) VALUES
(1, 3, 5, 'Excellent course! Really helped me improve my communication skills.'),
(3, 3, 4, 'Great content, but could use more practical examples.');