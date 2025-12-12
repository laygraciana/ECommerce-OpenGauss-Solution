// Custom JavaScript for ShopSphere

// Initialize tooltips
document.addEventListener('DOMContentLoaded', function() {
    // Enable Bootstrap tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Add loading animation to buttons
    document.querySelectorAll('.btn').forEach(button => {
        button.addEventListener('click', function(e) {
            if (this.getAttribute('data-loading') !== 'true') {
                const originalText = this.innerHTML;
                this.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...';
                this.setAttribute('data-original-text', originalText);
                this.setAttribute('data-loading', 'true');
                this.disabled = true;
                
                // Reset after 2 seconds (for demo)
                setTimeout(() => {
                    this.innerHTML = originalText;
                    this.setAttribute('data-loading', 'false');
                    this.disabled = false;
                }, 2000);
            }
        });
    });
    
    // Add cart counter animation
    const cartBadge = document.querySelector('.navbar .badge');
    if (cartBadge) {
        cartBadge.addEventListener('animationend', function() {
            this.classList.remove('animate__bounce');
        });
    }
    
    // Search functionality
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keyup', function() {
            const searchTerm = this.value.toLowerCase();
            const productCards = document.querySelectorAll('.product-card');
            
            productCards.forEach(card => {
                const title = card.querySelector('.card-title').textContent.toLowerCase();
                const description = card.querySelector('.card-text').textContent.toLowerCase();
                
                if (title.includes(searchTerm) || description.includes(searchTerm)) {
                    card.parentElement.style.display = 'block';
                    card.classList.add('animate__animated', 'animate__fadeIn');
                } else {
                    card.parentElement.style.display = 'none';
                }
            });
        });
    }
    
    // Add to cart functionality
    window.addToCart = function(productId) {
        const cartBadge = document.querySelector('.navbar .badge');
        if (cartBadge) {
            let count = parseInt(cartBadge.textContent) || 0;
            count++;
            cartBadge.textContent = count;
            cartBadge.classList.add('animate__animated', 'animate__bounce');
            
            // Show success message
            showNotification('Product added to cart!', 'success');
        }
        
        // In a real app, make API call here
        console.log('Added product ' + productId + ' to cart');
    };
    
    // View details functionality
    window.viewDetails = function(productId) {
        console.log('Viewing details for product ' + productId);
        showNotification('Loading product details...', 'info');
        
        // In a real app, navigate to product details page
        // window.location.href = '/Products/Details/' + productId;
    };
    
    // Notification system
    function showNotification(message, type = 'info') {
        const container = document.createElement('div');
        container.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
        container.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
        container.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        
        document.body.appendChild(container);
        
        // Auto remove after 3 seconds
        setTimeout(() => {
            if (container.parentNode) {
                container.remove();
            }
        }, 3000);
    }
    
    // Filter functionality
    const categoryFilter = document.getElementById('categoryFilter');
    if (categoryFilter) {
        categoryFilter.addEventListener('change', function() {
            console.log('Filtering by category:', this.value);
            showNotification(`Filtering by: ${this.value}`, 'info');
        });
    }
    
    const sortFilter = document.getElementById('sortFilter');
    if (sortFilter) {
        sortFilter.addEventListener('change', function() {
            console.log('Sorting by:', this.value);
            showNotification(`Sorted by: ${this.value}`, 'info');
        });
    }
});

// Price formatter
function formatPrice(price) {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD'
    }).format(price);
}

// Stock status checker
function getStockStatus(quantity) {
    if (quantity > 10) return { text: 'In Stock', class: 'in-stock' };
    if (quantity > 0) return { text: 'Low Stock', class: 'low-stock' };
    return { text: 'Out of Stock', class: 'out-of-stock' };
}

// Smooth scroll to top
function scrollToTop() {
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

// Add scroll to top button
window.addEventListener('scroll', function() {
    const scrollTopBtn = document.getElementById('scrollTopBtn');
    if (!scrollTopBtn && window.scrollY > 300) {
        const btn = document.createElement('button');
        btn.id = 'scrollTopBtn';
        btn.className = 'btn btn-primary position-fixed';
        btn.style.cssText = 'bottom: 20px; right: 20px; z-index: 1000; border-radius: 50%; width: 50px; height: 50px;';
        btn.innerHTML = '<i class="bi bi-chevron-up"></i>';
        btn.onclick = scrollToTop;
        document.body.appendChild(btn);
    } else if (scrollTopBtn && window.scrollY <= 300) {
        scrollTopBtn.remove();
    }
});
