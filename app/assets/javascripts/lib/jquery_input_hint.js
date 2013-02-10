jQuery.fn.inputHints=function() {
    // hides the input display text stored in the title on focus
    // and sets it on blur if the user hasn't changed it.
    // show the display text
    $(this).each(function(i) {
        $(this).val($(this).attr('title'))
            .addClass('hint');
    });
    // hook up the blur & focus
    return $(this).focus(function() {
        if ($(this).val() == $(this).attr('title'))
            $(this).val('').removeClass('hint');
    }).blur(function() {
        if ($(this).val() == '')
            $(this).val($(this).attr('title')).addClass('hint');
        else if ($.browser.msie && $(this).val() != $(this).attr('title')) {
            $(this).removeClass('hint');
        }
    });
};
