class ProbingsController < ApplicationController


  def index
    @probings = Probing.all
  end

  def last

    cookies[:date] = DateTime.now
    @probings = Probing.where(user_id: current_user)
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Ces dernières 24H")
      f.xAxis(
        categories: @probings.pluck(:created_at).map { |date| date.strftime("%d/%m/%Y - %H:%M") },
        plotBands: probing_quality(@probings)
      )

      f.yAxis [
        {title: {text: "Volume en cl", margin: 10} },
        {title: {text: "Fuites urinaire en cl"}, opposite: true}]
      f.series(type: 'column', name: "Fuites", yAxis: 1, data: @probings.pluck(:fleed), maxPointWidth: 20)
      f.series(type: 'spline', name: "Boisson", yAxis: 0, data: @probings.pluck(:hydratation))
      f.series(type: 'spline', name: "Miction", yAxis: 0, data: @probings.pluck(:quantity))



      f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0, layout: 'horizontal')
      f.chart({defaultSeriesType: "column"})
    end

    @chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
      f.global(useUTC: false)
      f.chart(
        backgroundColor: {
          linearGradient: [0, 0, 500, 500],
          stops: [
            [0, "rgb(255, 255, 255)"],
            [1, "rgb(240, 240, 255)"]
          ]
        },
        borderWidth: 2,
        plotBackgroundColor: "white",
        plotShadow: true,
        plotBorderWidth: 1
      )
      f.lang(thousandsSep: ",", numericSymbols: 'cl')
      f.colors(["#9feed1", "#53c7f0", "#f8c43a", "#fff6a2", "#e4d354"])
      # f.yAxis(labels: {format: "{value} cl"})
    end

  end

  def new
    @probing = Probing.new
  end

  def create
    @probing = Probing.new(probing_params)
    @probing.user = current_user
    if @probing.save
      redirect_to probings_path
    else
      render :new
    end
  end

  private

  def probing_params
    params.require(:probing).permit(:hydratation, :quantity, :quality, :fleed)
  end

  def probing_quality(probings)
    qualities = probings.pluck(:quality)
    bad_indexes = qualities.each_index.select { |i| qualities[i] == "bad" }
    bad_probings = bad_indexes.map.with_index do |bad_index|
      {
      color: '#FFA5A2',
      from: bad_index,
      to: bad_index.next,
      label: {
              text: "Infection urinaire",
              align: 'center',
              style: {
                    color: 'white',
                    fontWeight: 'bold'
                }
            }
      }
    end
    bad_probings.flatten
  end

end
