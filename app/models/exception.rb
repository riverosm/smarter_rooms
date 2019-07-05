class Exception < StandardError
  def initialize (message)
    msg = message
    super
  end
end