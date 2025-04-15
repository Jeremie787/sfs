
require 'csv'
class HomePagesController < ApplicationController
  def index
  end
  def subscribe
    raw_ids = params[:ids] || ""
    ids = raw_ids.split(/[\s,]+/).map(&:strip).reject(&:blank?)
    headers = {
      'accept' => 'application/json',
      'accept-language' => 'en',
      'authorization' => 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJjYzQ2MDc1My0yMTg4LTRmNjktYTU1YS02ZTExNjRmZTU2MGYiLCJhdWQiOiJhZG1pbl9wb3J0YWwiLCJwbGF0Zm9ybSI6IndlYnNpdGUiLCJpYXQiOjE3NDQ1NTcxNTUsInN1YiI6ImFjZmUzZjE5LWRiZWMtNDFhOC04NTA2LWFmYTY1NmVjYmI4ZCIsInJvbGUiOiJwYXJ0bmVyIiwiZW1haWwiOiJhZG1pbkA5MTF0YXhpLnZuIiwicGhvbmUiOiIrODQwOTQ1OTExOTExIiwiY291bnRyeV9jb2RlIjoiVk5NIiwicGFydG5lcl9pZCI6IjFiZTdmYjIxLTE4NmEtNDQwNi05ODkzLTI0NzljNTBiMjc0MCIsIm5hbWUiOiI5MTEgVGF4aSJ9.R-pPGgkYPLoSpH__RTB7s0Xc5iTn8ISLPx8CAojL06HA1hXQyJPd_VdSPrnry1QZDxhCHrO10rEMqfkieiNQRjzhaOCJu9lWMdTzix2qWY6-ojisNE4-tE5HuhfU3QE_VfWIsLwhgvotoX09aasCPaGTYwmHm6872SsAI01Sj-yxG-VGHWPNPleA8gWbzFge2f5ceIyCBFMvimV0mqsrl5_rq2NBVyOWvdrZ0J6B7xK4m_D2AyhuIQJUkyJCGIkvDT9TBssBHyzHH3oF35NZQR__NUoympxk2Yzgq5nCkTPjDVlOmPp7wtfkvmj2IdG20HJhVAocC6Tj5n_OilVCDsJwhRwJGcRPNeyFFu3-aCRxSxJlsVD8sM635M2El8vH8byGW9GlAN16pbQ-xbl1uLaTa3QA9-60QHm92Mdc1_64SJETkDenimDJpP7O7KA31b3dW5qF4G7L-rfUT5Yh0M45HoqWPNl16GQPp32uRgGnw6rbskySYKBZG8DRkhsORUXI0ZpV0ifSCzwaNefeDX461oJVCWUxkOSGnnFidOXIZ724jesnXgxjGQ8E9SoQySsuTGwBVXvQngQSnDL1w5v3ceGZEi989r0Ik_5SgFAOdaa7AC11lrHKIb4Q6luI0jbFah_s33sgzh-Gl7YprXF4nNe7owRI65sYP7ovZLo',
      'origin' => 'https://admin-customer.xanhsm.com',
      'priority' => 'u=1, i',
      'referer' => 'https://admin-customer.xanhsm.com/',
      'sec-ch-ua' => '"Google Chrome";v="135", "Not-A.Brand";v="8", "Chromium";v="135"',
      'sec-ch-ua-mobile' => '?0',
      'sec-ch-ua-platform' => '"Windows"',
      'sec-fetch-dest' => 'empty',
      'sec-fetch-mode' => 'cors',
      'sec-fetch-site' => 'cross-site',
      'user-agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36'
    }
    
    
    results = Parallel.map(ids, in_threads: 5) do |id|
      url = "https://api.gsm-api.net/order/v2/public/orders/#{id}?extra_components=path%2Cdriver%2Ccustomer%2Cfee%2Crating%2Ctrip%2Ctip%2Cinvoice%2Ccreator%2Cexpress%2Ccompleted_by%2Cchange_destination_log&01JRQV5PJKYAN06J3WRDAG315Y%0A01JRQV3D0W83DRJVTES40G1S3K%0A01JRQV14QENJ3PFGJBR88MPE54%0A01JRQV0YB0X1V5TK2KV2PNET2T%0A01JRQV0M8K7KCZNX2X8PM1N7EW%0A01JRQTWJ90KX69Y9TA0Y05DWAV%0A01JRQTW90YW0R4T86T5P44GW2K%0A01JRQTR6WBAQRQ5E1GQ0688F51%0A01JRQTQX9VEVT9NVMNEGHB4QBV%0A=null"
      begin
        response = HTTParty.get(url, headers: headers).parsed_response
        data = Hashie::Mash.new(response).data
        { id: id, fee: data.fee }
      rescue => e
        { id: id, error: e.message }
      end
    end

    # Xử lý và tạo file CSV
    csv_data = CSV.generate(headers: true) do |csv|
      # Ghi header
      csv << ["id", "Tong thu", "Phi bao hiem", "Phi thu tai xe"]

      # Ghi từng dòng
      results.each do |row|
        total_surcharge_cost = (row.dig(:fee, "fee_breakdown", "surcharge_fee_breakdown") || [])
        .select { |x| ["surcharge_road_tax", "surcharge_other_tax"].include?(x["name"]) }
        .map { |x| x["cost"].to_f }
        .sum
        csv << [
          row[:id],
          row.dig(:fee, "total_pay"),
          row.dig(:fee, "insurance_fee"),
          total_surcharge_cost
         ]
      end
    end

    # Gửi file CSV đã tạo
    bom = "\uFEFF"
    send_data bom + csv_data,
              filename: "fees.csv",
              type: "text/csv; charset=utf-8",
              disposition: "attachment"
    # if @response.success?
    #   data = JSON.parse(@response.body) 
    #   @payment = Hashie::Mash.new(data).data.fee
    #   surcharge_fee = @payment.fee_breakdown&.dig(:surcharge_fee_breakdown, 0, :cost) || 0
    #   addon_fee     = @payment.fee_breakdown&.dig(:addon_fee_breakdown, 0, :cost) || 0
      
    #   @total = @payment.total_pay - surcharge_fee - addon_fee
      
    #   respond_to do |format|
    #     format.turbo_stream # 👈 render turbo stream template
    #     format.html { render :subscribe } # fallback nếu không dùng turbo
    #   end
    # else
    #   render turbo_stream: turbo_stream.replace("posts-container", partial: "shared/error", locals: { message: "Không thể lấy dữ liệu." })
    # end
  end
end
