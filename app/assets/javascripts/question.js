$(document).on('turbolinks:load', function() {
    $('.question').on('click', '.edit-question-link', function(event) {
        event.preventDefault();

        $('.show-question').addClass('d-none');
        $('.edit-question').removeClass('d-none');
    })
});
