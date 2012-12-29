require 'observer'

class AObservable
  include Observable

  def value= (v)
    @value = v
    changed
    notify_observers v
  end
end
class AObserver
  def update(value)
    puts("update value : #{value}")
  end
end

# オブジェクトを生成
obj = AObservable.new

# オブザーバーを追加
observer = AObserver.new
obj.add_observer(observer)

obj.value = "hoge"
