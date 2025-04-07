document.addEventListener('DOMContentLoaded', function() {
    const mobileMenuBtn = document.querySelector('.mobile-menu-btn');
    const mobileMenu = document.querySelector('.mobile-menu');
    const mobileMenuOverlay = document.createElement('div');
    mobileMenuOverlay.className = 'mobile-menu-overlay';
    document.body.appendChild(mobileMenuOverlay);

    mobileMenuBtn.addEventListener('click', function() {
        mobileMenu.classList.toggle('active');
        mobileMenuOverlay.classList.toggle('active');
    });

    mobileMenuOverlay.addEventListener('click', function() {
        mobileMenu.classList.remove('active');
        mobileMenuOverlay.classList.remove('active');
    });

    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.opacity = '0';
            setTimeout(() => {
                alert.style.display = 'none';
            }, 300);
        }, 5000);
    });

    const enrollButtons = document.querySelectorAll('.enroll-btn');
    enrollButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            if (!button.classList.contains('logged-in')) {
                e.preventDefault();
                window.location.href = 'login.html?redirect=' + encodeURIComponent(window.location.href);
            }
        });
    });

    const completeButtons = document.querySelectorAll('.complete-btn');
    completeButtons.forEach(button => {
        button.addEventListener('click', function() {
            const contentId = this.dataset.contentId;
            const enrollmentId = this.dataset.enrollmentId;

            console.log(`Marking content ${contentId} as completed for enrollment ${enrollmentId}`);
            
            const contentItem = this.closest('.course-content-item');
            contentItem.classList.add('completed');
            this.innerHTML = '<i class="fas fa-check"></i> Completed';
            this.classList.remove('btn-primary');
            this.classList.add('btn-outline');
            
            const progressFill = document.querySelector('.progress-fill');
            const progressPercent = document.querySelector('.progress-percent');
            if (progressFill && progressPercent) {
                const currentProgress = parseInt(progressFill.style.width) || 0;
                const newProgress = Math.min(currentProgress + 25, 100);
                progressFill.style.width = newProgress + '%';
                progressPercent.textContent = newProgress + '%';
            }
        });
    });

    const discussionForm = document.getElementById('discussion-form');
    if (discussionForm) {
        discussionForm.addEventListener('submit', function(e) {
            e.preventDefault();
            console.log('Discussion form submitted');
            alert('Discussion created successfully! Page will reload.');
            window.location.reload();
        });
    }

    const replyForms = document.querySelectorAll('.reply-form');
    replyForms.forEach(form => {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            const discussionId = this.dataset.discussionId;
            console.log(`Reply submitted for discussion ${discussionId}`);
            alert('Reply submitted successfully!');
            this.querySelector('textarea').value = '';
        });
    });

   
    const toggleReplyButtons = document.querySelectorAll('.toggle-replies');
    toggleReplyButtons.forEach(button => {
        button.addEventListener('click', function() {
            const discussionId = this.dataset.discussionId;
            const repliesContainer = document.querySelector(`.replies-container[data-discussion-id="${discussionId}"]`);
            const replyForm = document.querySelector(`.reply-form[data-discussion-id="${discussionId}"]`);
            
            repliesContainer.style.display = repliesContainer.style.display === 'none' ? 'block' : 'none';
            replyForm.style.display = replyForm.style.display === 'none' ? 'block' : 'none';
            
            this.innerHTML = repliesContainer.style.display === 'none' ? 
                '<i class="fas fa-chevron-down"></i> Show Replies' : 
                '<i class="fas fa-chevron-up"></i> Hide Replies';
        });
    });


  if (localStorage.getItem("isLoggedIn") === "true") {
    document.getElementById("login-link").style.display = "none";
    document.getElementById("register-link").style.display = "none";
    document.getElementById("profile-link").style.display = "inline-block";
    document.getElementById("logout-link").style.display = "inline-block";
  }

  function logout() {
    localStorage.removeItem("isLoggedIn");
    alert("Logged out successfully.");
    location.reload();
  }


});