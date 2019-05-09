function makeAnim(player)
   setPedAnimation( player, "KISSING", "gift_give", 1000, false, true, false, 2000)
end
addCommandHandler("makemyped", makeAnim)
