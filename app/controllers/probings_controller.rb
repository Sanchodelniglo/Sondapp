class ProbingsController < ApplicationController


  def index
    @user = current_user
    @probings = Probing.where(:user_id == current_user.id)
  end

  def last

    cookies[:date] = DateTime.now
    @probings = Probing.where(user_id: current_user).last(42)
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Mictions du #{@probings.pluck(:created_at).map { |date| date.strftime("%d/%m/%Y") }.minmax.join(' au ')} - Collecte: #{@probings.pluck(:collect_methode).uniq.join}")
      f.xAxis(
        categories: @probings.pluck(:created_at).map { |date| date.strftime("%d/%m-%H:%M") },
        plotBands: probing_quality(@probings),
        reversed: false,
      )
      f.yAxis [
        {title: {text: "Volume en cl"} },
        {title: {text: "Fuites urinaire en cl"}, opposite: true, allowDecimals: false}
      ]
      f.series(type: 'column', name: "Fuites", yAxis: 1, data: @probings.pluck(:fleed), maxPointWidth: 15)
      f.series(type: 'spline', name: "Boisson", yAxis: 0, data: @probings.pluck(:hydratation))
      f.series(type: 'spline', name: "Miction", yAxis: 0, data: @probings.pluck(:quantity))



      f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0, layout: 'horizontal')
      f.export(:type=> 'image/pdf')
      f.global(useUTC: false)
      f.chart(
        scrollablePlotArea: {
            minWidth: 1000,
            scrollPositionX: 1
        },
        backgroundColor: {
          linearGradient: [0, 0, 500, 500],
          strokeWidth: 0,
          stops: [
            [0, "rgb(255, 255, 255)"],
            [1, "rgb(240, 240, 255)"]
          ]
        },

      )
      f.lang(thousandsSep: ",", numericSymbols: 'cl')
      f.colors(["#9feed1", "#53c7f0", "#f8c43a", "#fff6a2", "#e4d354"])
    end
  end

  def pdf_download

    cookies[:date] = DateTime.now
    @probings = Probing.where(user_id: current_user).last(42)
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Mictions du #{@probings.pluck(:created_at).map { |date| date.strftime("%d/%m/%Y") }.minmax.join(' au ')} - Collecte: #{@probings.pluck(:collect_methode).uniq.join}")
      f.xAxis(
        categories: @probings.pluck(:created_at).map { |date| date.strftime("%H:%M") },
        plotBands: probing_quality(@probings),
        reversed: false
      )

      f.yAxis [
        {title: {text: "Volume en ml"} },
        {title: {text: "Fuites urinaire en cl"}, opposite: true, allowDecimals: false}]
      f.series(type: 'column', name: "Fuites", yAxis: 1, data: @probings.pluck(:fleed), maxPointWidth: 15,enableMouseTracking: false,
            shadow: false,
            animation: false)
      f.series(type: 'spline', name: "Boisson", yAxis: 0, data: @probings.pluck(:hydratation),enableMouseTracking: false,
            shadow: false,
            animation: false)
      f.series(type: 'spline', name: "Miction", yAxis: 0, data: @probings.pluck(:quantity),enableMouseTracking: false,
            shadow: false,
            animation: false)



      f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0, layout: 'horizontal')
      f.export(:type=> 'image/pdf')
      f.global(useUTC: false)
      f.lang(thousandsSep: ",", numericSymbols: 'cl')
      f.colors(["#9feed1", "#53c7f0", "#f8c43a", "#fff6a2", "#e4d354"])
    end
    respond_to do |format|
      format.html { render :pdf_download }
      format.pdf {
        render :pdf => "graphique", :layout => 'probings_pdf.html', orientation: 'landscape'
        }
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
    bad_indexes = qualities.each_index.select { |i| qualities[i] == "Infection" }
    bad_probings = bad_indexes.map.with_index do |bad_index|
      {
      color: '#FFA5A2',
      from: bad_index,
      to: bad_index.next,
      label: {
              text: "#{qualities[bad_index]}",
              align: 'center',
              rotation: 270,
              textAlign: 'right',
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
