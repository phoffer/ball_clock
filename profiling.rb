require 'stackprof'
require 'benchmark/ips'
require_relative 'optimized_ball_clock'
require_relative 'ball_clock'

profile_object = StackProf.run(mode: :cpu, interval: 1000) do
  Clock.new(count: 45).days
end
profile_optimized = StackProf.run(mode: :cpu, interval: 1000) do
  OptimizedClock.new(count: 45).days
end

StackProf::Report.new(profile_object).print_text
StackProf::Report.new(profile_optimized).print_text


Benchmark.ips do |x|
  x.report('Ball Objects') { Clock.new(count: 30) }
  x.report('Optimized') { OptimizedClock.new(count: 30) }

  x.compare!
end