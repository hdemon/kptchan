require "active_support/all"
require "zircon"

require "./lib/kptchan/kptchan_controller"
require "./lib/kptchan/behavior"
require "./lib/kptchan/interpreter"
require "./lib/kptchan/task"


REQUEST_DICTIONARIES = [
  [:add, ['add', 'Add', 'ADD', '足す', '足し', '加え']],
  [:remove, ['remove', 'Remove', 'REMOVE', '消']],
  [:done, ['done', 'Done', 'complete', 'ダン', '終わ']],
  [:list, ['list', 'List', 'LIST', 'リスト', '一覧']]
]

CATEGORY_DICTIONARIES = [
  [:keep, ['keep', 'Keep', 'KEEP', 'キープ']],
  [:problem, ['problem', 'Problem', 'プロブレム', '課題']],
  [:try, ['try', 'Try', 'TRY', 'トライ']]
]


Mongoid.load!("config/mongoid.yaml", :production)

# tasks collectionが存在しなければ、cappedとして作成。
session = Moped::Session.new([ "127.0.0.1:27017" ])
session.use "kptchan"
until session[:tasks].present?
  session.command(create: "tasks", capped: true, size: 500 * 1024 * 1024, max: 1000)
end


kpt = KPTChanController.new
kpt.run
