class FakeStdout

  attr_reader :output

  def initialize
    @output = []
  end

  def puts(msg)
    output << msg
  end

  def print(msg)
    output << msg
  end
end
