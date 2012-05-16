module Scripts
  
  def append_user_to_list user_id , username 
    script = "if ($('#message_to option:regex(value,#{user_id})').length == 0){" <<
                "$('#message_to').append(\"<option value = '#{user_id}'>#{username}</option>\");" <<
                "$('#message_to').trigger('liszt:updated');" <<
             "}"
    return script
  end
  
  def remove_user_from_list user_id
    return "$(\"#message_to option:regex(value,#{user_id})\").remove();$('#message_to').trigger('liszt:updated');" 
  end
end