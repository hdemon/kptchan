require "active_support/all"


module Behavior
  def self.add(client, speaker_nickname, options)
    return until options[:content].present
    category = options[:category].presence || ''
    # content = options[:content].presence || ''
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

  def self.done(client, speaker_nickname, options)
    Task.where(inc_id: options[:specified_inc_id]).update(done: true)
    client.notice "#{client.channel}", "#{options[:specified_inc_id]}を完了しました。"
  end

  def self.remove(client, speaker_nickname, options)
    Task.where(inc_id: options[:specified_inc_id]).update(available: false)
    client.notice "#{client.channel}", "#{options[:specified_inc_id]}を削除しました。"
  end

  def self.list(client, speaker_nickname, options)
    list = Task.where(category: options[:category], done: false, available: true)

    if list.length == 0
      client.notice "#{client.channel}", "登録がありません。"
      return
    end

    client.notice "#{client.channel}", "#{options[:category]}"
    list.each do |elem|
      # TODO: spaceや:が途中に入ると上手く出力できない。必要であればzirconのコードを修正。
      client.notice "#{client.channel}", "#{elem.inc_id}.#{elem.content}(#{elem.created_at.strftime('%Y-%m-%d_%H:%M')})"
    end
  end

  def self.get_max_inc_id(category)
    result = Task.where(category: category).order_by(inc_id: :desc).limit(1)[0]
    result.present? ? result.inc_id.to_i : 0
  end
end
