require "active_support/all"


class Interpreter
  def interpret(parsed_sentence, speaker_nickname)
    @sentence = parsed_sentence

    {
      speaker_nickname: speaker_nickname,
      request: request,
      category: category,
      content: content,
      specified_inc_id: specified_inc_id
    }
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
        sentence.force_encoding("UTF-8") =~ /#{request_word}/
      end
    end

    return if dic.nil?
    dic[0]
  end

  def content
    @sentence =~ /(?<=\").{1,}(?=\")/
    $&
  end

  def specified_inc_id
    @sentence =~ /(?<=id\:)\d{1,}/
    $&.to_i
  end
end
