local ifp = engineLoadIFP("custom/gta_online.ifp", "gta_online")
local customIfpBlockName = "gta_online"

globalPedAnimationBlock = {
    -- Complete list of all animations in ped block, it is the default block
    -- in gta sa 
    animations = {
        "abseil","arrestgun","atm","bike_elbowl","bike_elbowr","bike_fallr","bike_fall_off","bike_pickupl","bike_pickupr",
        "bike_pullupl","bike_pullupr","bomber","car_alignhi_lhs","car_alignhi_rhs","car_align_lhs","car_align_rhs","car_closedoorl_lhs",
        "car_closedoorl_rhs","car_closedoor_lhs","car_closedoor_rhs","car_close_lhs","car_close_rhs","car_crawloutrhs","car_dead_lhs","car_dead_rhs",
        "car_doorlocked_lhs","car_doorlocked_rhs","car_fallout_lhs","car_fallout_rhs","car_getinl_lhs","car_getinl_rhs","car_getin_lhs","car_getin_rhs",
        "car_getoutl_lhs","car_getoutl_rhs","car_getout_lhs","car_getout_rhs","car_hookertalk","car_jackedlhs","car_jackedrhs","car_jumpin_lhs",
        "car_lb","car_lb_pro","car_lb_weak","car_ljackedlhs","car_ljackedrhs","car_lshuffle_rhs","car_lsit","car_open_lhs","car_open_rhs",
        "car_pulloutl_lhs","car_pulloutl_rhs","car_pullout_lhs","car_pullout_rhs","car_qjacked","car_rolldoor","car_rolldoorlo","car_rollout_lhs",
        "car_rollout_rhs","car_shuffle_rhs","car_sit","car_sitp","car_sitplo","car_sit_pro","car_sit_weak","car_tune_radio","climb_idle","climb_jump",
        "climb_jump2fall","climb_jump_b","climb_pull","climb_stand","climb_stand_finish","cower","crouch_roll_l","crouch_roll_r","dam_arml_frmbk",
        "dam_arml_frmft","dam_arml_frmlt","dam_armr_frmbk","dam_armr_frmft","dam_armr_frmrt","dam_legl_frmbk","dam_legl_frmft","dam_legl_frmlt","dam_legr_frmbk",
        "dam_legr_frmft","dam_legr_frmrt","dam_stomach_frmbk","dam_stomach_frmft","dam_stomach_frmlt","dam_stomach_frmrt","door_lhinge_o","door_rhinge_o",
        "drivebyl_l","drivebyl_r","driveby_l","driveby_r","drive_boat","drive_boat_back","drive_boat_l","drive_boat_r","drive_l","drive_lo_l","drive_lo_r",
        "drive_l_pro","drive_l_pro_slow","drive_l_slow","drive_l_weak","drive_l_weak_slow","drive_r","drive_r_pro","drive_r_pro_slow","drive_r_slow","drive_r_weak",
        "drive_r_weak_slow","drive_truck","drive_truck_back","drive_truck_l","drive_truck_r","drown","duck_cower","endchat_01","endchat_02","endchat_03",
        "ev_dive","ev_step","facanger","facgum","facsurp","facsurpm","factalk","facurios","fall_back","fall_collapse","fall_fall","fall_front","fall_glide",
        "fall_land","fall_skydive","fight2idle","fighta_1","fighta_2","fighta_3","fighta_block","fighta_g","fighta_m","fightidle","fightshb","fightshf",
        "fightsh_bwd","fightsh_fwd","fightsh_left","fightsh_right","flee_lkaround_01","floor_hit","floor_hit_f","fucku","gang_gunstand","gas_cwr","getup",
        "getup_front","gum_eat","guncrouchbwd","guncrouchfwd","gunmove_bwd","gunmove_fwd","gunmove_l","gunmove_r","gun_2_idle","gun_butt","gun_butt_crouch",
        "gun_stand","handscower","handsup","hita_1","hita_2","hita_3","hit_back","hit_behind","hit_front","hit_gun_butt","hit_l","hit_r","hit_walk","hit_wall",
        "idlestance_fat","idlestance_old","idle_armed","idle_chat","idle_csaw","idle_gang1","idle_hbhb","idle_rocket","idle_stance","idle_taxi","idle_tired",
        "jetpack_idle","jog_femalea","jog_malea","jump_glide","jump_land","jump_launch","jump_launch_r","kart_drive","kart_l","kart_lb","kart_r","kd_left",
        "kd_right","ko_shot_face","ko_shot_front","ko_shot_stom","ko_skid_back","ko_skid_front","ko_spin_l","ko_spin_r","pass_smoke_in_car","phone_in","phone_out",
        "phone_talk","player_sneak","player_sneak_walkstart","roadcross","roadcross_female","roadcross_gang","roadcross_old","run_1armed","run_armed",
        "run_civi","run_csaw","run_fat","run_fatold","run_gang1","run_left","run_old","run_player","run_right","run_rocket","run_stop","run_stopr",
        "run_wuzi","seat_down","seat_idle","seat_up","shot_leftp","shot_partial","shot_partial_b","shot_rightp","shove_partial","smoke_in_car",
        "sprint_civi","sprint_panic","sprint_wuzi","swat_run","swim_tread","tap_hand","tap_handp","turn_180","turn_l","turn_r","walk_armed","walk_civi",
        "walk_csaw","walk_doorpartial","walk_drunk","walk_fat","walk_fatold","walk_gang1","walk_gang2","walk_old","walk_player","walk_rocket","walk_shuffle",
        "walk_start","walk_start_armed","walk_start_csaw","walk_start_rocket","walk_wuzi","weapon_crouch","woman_idlestance","woman_run","woman_runbusy",
        "woman_runfatold","woman_runpanic","woman_runsexy","woman_walkbusy","woman_walkfatold","woman_walknorm","woman_walkold","woman_walkpro","woman_walksexy",
        "woman_walkshop","xpressscratch"
    },

    -- We will use this for checking whether animation is partial or not for ped block
    -- if it is, we won't replace it. Partial animations can be played using setPedAnimation.
    partialAnimations = {
        ["CAR_alignHI_LHS"] = true,
        ["CAR_alignHI_RHS"] = true,
        ["DAM_armL_frmFT"] = true,
        ["endchat_01"] = true,
        ["endchat_02"] = true,
        ["endchat_03"] = true,
        ["facanger"] = true,
        ["facgum"] = true,
        ["facsurp"] = true,
        ["facsurpm"] = true,
        ["factalk"] = true,
        ["facurios"] = true,
        ["FightA_M"] = true,
        ["FightA_block"] = true,
        ["flee_lkaround_01"] = true,
        ["handscower"] = true,
        ["HIT_walk"] = true,
        ["IDLE_chat"] = true,
        ["pass_Smoke_in_car"] = true,
        ["phone_in"] = true,
        ["phone_out"] = true,
        ["phone_talk"] = true,
        ["SHOT_leftP"] = true,
        ["SHOT_partial"] = true,
        ["SHOT_partial_B"] = true,
        ["SHOT_rightP"] = true,
        ["Shove_Partial"] = true,
        ["Smoke_in_car"] = true,
        ["Walk_DoorPartial"] = true,
    }
}

function ReplacePedBlockAnimations(player)
    for _, animationName in pairs ( globalPedAnimationBlock.animations ) do 
        engineReplaceAnimation ( player, "ped", animationName, customIfpBlockName, animationName )
    end
end

addEventHandler("onClientResourceStart", resourceRoot,
    function()

        setPedWalkingStyle(localPlayer,0)
        triggerServerEvent ("onCustomAnimationSyncRequest", resourceRoot, localPlayer)

        ReplacePedBlockAnimations(localPlayer)
        triggerServerEvent("onCustomAnimationReplace", resourceRoot, localPlayer, ifpIndex)
    end
)

addEvent ("onClientCustomAnimationReplace", true )
addEventHandler ("onClientCustomAnimationReplace", root,
    function()
        if source == localPlayer then return end
        ReplacePedBlockAnimations(source)
    end 
)