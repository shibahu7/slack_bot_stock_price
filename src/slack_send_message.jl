using PyCall
using HTTP

bs4 = pyimport("bs4")
requests = pyimport("requests")

function main(ARGS)
    # 株価URL取得
    url_dict = include("stock_url.jl")

    # メッセージ作成
    msg = ""
    for ( ticker, url ) in url_dict
        response = requests.get(url_dict[ticker][1])
        soup = bs4.BeautifulSoup(response.content)
        
        msg *= "*$ticker* : "
        # 株価
        price = soup.select(".kf1m0 div")[1].text
        msg *= "*$price* \n "
        # 日付
        # HACK: 時間前取引のタグを拾ってしまうときがある
        date = soup.select(".ygUjEc")[1].text
        msg *=  "$date \n"
    end

    # slack に送信
    params = Dict(
        "channel" => "#株価", # 任意チャンネル
        "text" => msg
    )

    headers = Dict("Authorization" => "Bearer " * ARGS[1])
    res = HTTP.post(
        "https://slack.com/api/chat.postMessage",
        headers;
        query = params,
        require_ssl_verification = false, # SSL証明書の検証を要求しない
    )

    # レスポンスの表示
    println( String( res.body ) )
end
main(ARGS)
println(ARGS)
println("Bearer " * ARGS[1])
