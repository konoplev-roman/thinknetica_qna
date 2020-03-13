$(document).on('turbolinks:load', function() {
    $('.question').on('click', '.edit-question-link', function(e) {
        e.preventDefault();

        $('.question').addClass('d-none');
        $('.edit-question').removeClass('d-none');
    })
});
