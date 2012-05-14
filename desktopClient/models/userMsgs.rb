module UserMsgs
  
  def help
    puts "Para enviar mensajes utilice el comando : send: <msg>" 
  end
  
  def user_help
    puts "canal: <nombre> . Para seleccionar un canal\nenviar: <msg> . Para enviar un mensaje al canal seleccionado"
  end
end