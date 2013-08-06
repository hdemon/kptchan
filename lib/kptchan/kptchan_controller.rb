require "active_support/all"
require "yaml"


class KPTChanController
  def initialize
    @config = YAML.load_file "config/config.yaml"
    @interpreter = Interpreter.new

    @client = Zircon.new(
      :server   => @config["server"],
      :port     => @config["port"],
      :password => @config["password"],
      :channel  => @config["channel"],
      :username => @config["username"],
      :ssl      => @config["ssl"]
    )

    @client.on_privmsg do |message|
      interpreted_msg = @interpreter.interpret message.body, self.parseSpeaker(message.prefix)
      react_to interpreted_msg
    end
  end

  def run
    @client.run!
  end

  def parseSpeaker(message_prefix)
    message_prefix.split('!')[0]
  end

  private

  def react_to(interpreted_message)
    msg = interpreted_message
    # TODO: 条件はこれでいいのか？
    return until msg[:request] && msg[:category]

    options = {
      category: msg[:category],
      content: msg[:content],
      specified_inc_id: msg[:specified_inc_id]
    }

    Behavior.send msg[:request].to_sym,
                  @client, msg[:speaker_nickname], options
  end
end
