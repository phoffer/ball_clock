require 'rspec'
require_relative 'ball_clock'

RSpec.describe Clock do
  describe 'default parameters' do
    
    let(:clock_str) { Clock.new(count: 30, time: '5:32') }
    let(:clock_int) { Clock.new(count: 30, time: 332) }
    it 'should reject count outside 27..127' do
      expect{ Clock.new(count: 0) }.to   raise_error(BallCountError)
      expect{ Clock.new(count: 26) }.to  raise_error(BallCountError)
      expect{ Clock.new(count: 128) }.to raise_error(BallCountError)
    end
    it 'should accept a time as a string' do
      expect(clock_str.time).to eq('5:32')
    end
    it 'should accept a time as an integer' do
      expect(clock_int.time).to eq('5:32')
    end
  end
  describe 'ball counts at known time' do
    let(:clock) { Clock.new(count: 30, time: '5:32') }
    it 'should have 2 balls for minute indicator' do
      expect(clock.minute_queue.size).to eq(2)
    end
    it 'should have 6 balls for 5-minute indicator' do
      expect(clock.five_queue.size).to eq(6)
    end
    it 'should have 5 balls for hour indicator' do
      expect(clock.hour_queue.size).to eq(5)
    end
    it 'should have 17 balls in available queue' do
      expect(clock.queue.size).to eq(17)
    end
  end
  describe 'ball queues at known time' do
    let(:clock) { Clock.new(count: 30, time: 325) }
    let(:minute_queue_numbers) { [] }
    let(:five_queue_numbers)   { [22,13,25,3,7] }
    let(:hour_queue_numbers)   { [6,12,17,4,15] }
    let(:queue_numbers)        { [11, 5, 26, 18, 2, 30, 19, 8, 24, 10, 29, 20, 16, 21, 28, 1, 23, 14, 27, 9] }
    it 'should match balls for minute indicator' do
      expect(clock.minute_queue_numbers).to eq(minute_queue_numbers)
    end
    it 'should match balls for 5-minute indicator' do
      expect(clock.five_queue_numbers).to eq(five_queue_numbers)
    end
    it 'should match balls for hour indicator' do
      expect(clock.hour_queue_numbers).to eq(hour_queue_numbers)
    end
    it 'should match balls for available queue' do
      expect(clock.queue_numbers).to eq(queue_numbers)
    end
  end
  describe 'it should circulate correctly' do
    let(:clock) { Clock.new(count: 30) }
    it 'should correctly calculate days for reset' do
      expect(clock.days).to eq(15)
    end
  end


end
