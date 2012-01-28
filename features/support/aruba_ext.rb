# extension methods for Aruba
module ArubaExt

  def wait_until(seconds = 5)
    timeout(seconds) { yield }
  end

  def timeout(seconds = 50, &block)
    start_time = Time.now

    result = nil

    until result
      return result if result = yield

      delay = seconds - (Time.now - start_time)
      if delay <= 0
        raise TimeoutError, "timed out"
      end

      sleep(0.05)
    end
  end

  def wait_until_expectation
      begin
        exception = nil
        wait_until do
          begin
            yield
            true
          rescue RSpec::Expectations::ExpectationNotMetError => e
            exception = e
            false
          end
        end
      rescue TimeoutError
        raise exception
      end
    end
end