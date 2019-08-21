dataset =
  for rps <- 1000..1100 do
    {:ok, interval_ms, tokens} = Buckets.TokenBucket.calculate_refill_rate(rps)
    [rps, interval_ms, tokens]
  end

dataset_interval = Enum.map(dataset, fn [r, i, _] -> [r, i] end)

{:ok, _cmd} =
  Gnuplot.plot(
    [
      [:set, :title, "Requests per second - Interval"],
      ~w(set logscale y)a,
      [:plot, "-", :with, :lines, :title, "Refresh Interval (ms)"]
    ],
    [dataset_interval]
  )

dataset_tokens = Enum.map(dataset, fn [r, _i, t] -> [r, t] end)

{:ok, _cmd} =
  Gnuplot.plot(
    [
      [:set, :title, "Requests per second - Tokens"],
      # ~w(set logscale x)a,
      [:plot, "-", :with, :lines, :title, "Tokens"]
    ],
    [dataset_tokens]
  )
