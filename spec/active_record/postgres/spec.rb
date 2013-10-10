require_relative 'setup'

describe 'ActiveRecord + Postgres' do

  extend Minitest::ParallelDb::ActiveRecord

  let(:model) { PARM }

  (PARM.connection_config[:pool] - 1).times do |idx|
    it "tests in parallel (#{idx + 1})" do
      PARM.create! name: 'name'

      # Give time for other parallel tests to catch up.
      sleep 1

      # If this is run in transaction,
      # we should only see the model we just created.
      PARM.count.must_equal 1
    end
  end

end