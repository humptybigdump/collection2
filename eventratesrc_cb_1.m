% eventratesrc_cb Dialog Callback
function eventratesrc_cb(blk)
en = get_param(blk,'MaskEnables');
switch get_param(blk,'eventratesrc')
    case 'Dialog'
        en{3} = 'on';
    case 'Signal port lambda'
        en{3} = 'off';
end
set_param(blk,'MaskEnables',en)