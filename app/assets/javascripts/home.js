
function add_to_cart(sku) {
	jQuery.ajax({
        type: "POST",
        async: true,
        data: { authenticity_token: $('[name="csrf-token"]')[0].content},
        url: '/cart/add/' + sku,
        dataType: "json",
        success: function (msg) 
                { alert('successfully added') },
        error: function (err)
        		{ alert(err.responseText)}
    });
}

function remove_item_from_cart(sku) {
    jQuery.ajax({
        type: "POST",
        async: true,
        data: { authenticity_token: $('[name="csrf-token"]')[0].content},
        url: '/cart/remove/' + sku,
        dataType: "json",
        success: function (msg) 
                { alert('successfully removed') 
                    location.reload(); },
        error: function (err)
                { alert(err.responseText)}
    });
}

function apply_coupon() {
    var code = document.getElementById('coupon-code').value
    jQuery.ajax({
        type: "POST",
        async: true,
        data: { authenticity_token: $('[name="csrf-token"]')[0].content},
        url: '/cart/apply_coupon/' + code,
        dataType: "json",
        success: function (msg) 
                { alert('successfully added');
                location.reload();
                 },
        error: function (err)
                { alert(err.responseText)
                location.reload();}
    });
}

function remove_coupon(code) {
    jQuery.ajax({
        type: "POST",
        async: true,
        data: { authenticity_token: $('[name="csrf-token"]')[0].content},
        url: '/cart/remove_coupon/' + code,
        dataType: "json",
        success: function (msg) 
                { alert('successfully removed!!') 
                location.reload();},
        error: function (err)
                { alert(err.responseText)}
    });
}
