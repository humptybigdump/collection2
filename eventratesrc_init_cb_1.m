function eventratesrc_init_cb(blk,eventratesrc,eventrate,signaltype)
switch get_param(blk,'eventratesrc')
    case 'Dialog'
        if strcmp(get_param([blk '/eventrate'],'Blocktype'),'Inport')
            replace_IIIT([blk '/eventrate'],'built-in/Constant');
            set_param([blk '/eventrate'],'Value','eventrate');
        end
    case 'Signal port lambda'
        if strcmp(get_param([blk '/eventrate'],'Blocktype'),'Constant')
            replace_IIIT([blk '/eventrate'],'built-in/Inport');
        end
end
switch get_param(blk,'signaltype')
    case 'event-based'
        if strcmp(get_param([blk '/tau_t'],'Blocktype'),'Outport')
            replace_IIIT([blk '/tau_t'],'built-in/Terminator');
        end
        if strcmp(get_param([blk '/tau_e'],'Blocktype'),'Terminator')
            replace_IIIT([blk '/tau_e'],'built-in/Outport');
        end
    case 'time-based'
        if strcmp(get_param([blk '/tau_e'],'Blocktype'),'Outport')
            replace_IIIT([blk '/tau_e'],'built-in/Terminator');
        end
        if strcmp(get_param([blk '/tau_t'],'Blocktype'),'Terminator')
            replace_IIIT([blk '/tau_t'],'built-in/Outport');
        end
end
