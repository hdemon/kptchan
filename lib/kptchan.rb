# coding: utf-8

require "active_support/all"
require "zircon"
require "yaml"
require "mongoid"
require "pp"
require "pry"


REQUEST_DICTIONARIES = [
  [:add, ['add', 'Add', 'ADD', '足す', '足し', '加え']],
  [:remove, ['remove', 'Remove', 'REMOVE', '消']],
  [:list, ['list', 'List', 'LIST', 'リスト', '一覧']]
]

CATEGORY_DICTIONARIES = [
  [:keep, ['keep', 'Keep']],
  [:problem, ['problem', 'Problem']],
  [:try, ['try', 'Try']]
]



Mongoid.load!("config/mongoid.yaml", :production)

# tasks collectionが存在しなければ、cappedとして作成。
session = Moped::Session.new([ "127.0.0.1:27017" ])
session.use "kptchan"
until session[:tasks].present?
  session.command(create: "tasks", capped: true, size: 500 * 1024 * 1024, max: 1000)
end


class Task
  include Mongoid::Document

  field :inc_id, type: Integer
  field :nickname
  field :category, type: Symbol
  field :content
  field :created_at, type: Time
  field :done, type: Boolean
  field :available, type: Boolean
end


class Interpreter
  def interpret(parsed_sentence, speaker_nickname)
    @sentence = parsed_sentence
    {speaker_nickname: speaker_nickname, request: request, category: category, content: content}
  end

  private

  def category
    retrieve_word(CATEGORY_DICTIONARIES, @sentence)
  end

  def request
    retrieve_word(REQUEST_DICTIONARIES, @sentence)
  end

  def retrieve_word(dictionary, sentence)
    dic = dictionary.find do |element|
      element[1].any? do |request_word|
        sentence =~ /#{request_word}/
      end
    end

    return if dic.nil?
    dic[0]
  end

  def content
    @sentence =~ /(?<=\").{1,}(?=\")/
    $&
  end
end


class KPTChan
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

    # Behavior.send msg[:request].to_sym,
    #               @client
    #               msg[:speaker_nickname], msg[:category], msg[:content]
    options = {
      category: msg[:category],
      content: msg[:content],
      specified_id: msg[:specified_id]
    }

    Behavior.send msg[:request].to_sym,
                  @client, msg[:speaker_nickname], options
  end

end


module Behavior
  def self.add(client, speaker_nickname, options)
    category = options[:category].presence || ''
    content = options[:content].presence || ''
    inc_id = get_max_inc_id(category) + 1

    task = Task.new(
      inc_id: inc_id,
      nickname: speaker_nickname,
      category: category,
      content: content,
      created_at: Time.now,
      done: false,
      available: true
    )

    task.save
  end

  def self.complete(client, speaker_nickname, options)
    Task.where(inc_id: options[:inc_id]).update(done: true)
  end

  def self.disable(client, speaker_nickname, options)
    Task.where(inc_id: options[:inc_id]).update(available: false)
  end

  def self.list(client, speaker_nickname, options)
    list = Task.where(category: options[:category], done: false, available: true)

    client.privmsg "#{options[:category]}"
    list.each do |elem|
      client.privmsg "#{elem.inc_id}: #{elem.content}"
    end
  end

  def self.get_max_inc_id(category)
    result = Task.where(category: category).order_by(inc_id: :desc).limit(1)[0]
    result.present? ? result.inc_id.to_i : 0
  end
end


kpt = KPTChan.new
kpt.run
