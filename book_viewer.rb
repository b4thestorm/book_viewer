require "sinatra"
require "sinatra/reloader"
require "pry"

before do
  @toc = File.readlines("data/toc.txt")
end

helpers do
  def format_paragraphs(text)
    text.split("\n\n").map do |paragraph|
      "<p>#{paragraph}</p>"
    end.join
  end
end

get "/" do
  erb :home
end

get "/chapters/:id" do
  @id = params[:id]
  title = File.readlines("data/toc.txt")
  chapter = @id.to_i
  @title = title[chapter - 1]
  @chapter = File.read("data/chp#{@id}" + ".txt")
  erb :chapter
end

get "/search" do
  @title = @toc[0]

  if params[:query]
    count = @toc.count
    found = []
    loop do
       search_results = File.readlines("data/chp#{count}.txt")
       search_results = search_results.map {|x| x.include?(params[:query])}
      if search_results.any?(true)
        found << count
      end
      count -= 1
      break if count == 0
    end
    if found.count != 0
      @titles = found.reverse.map {|index| "#{@toc[index]}"}
      @found = found.reverse
    end
  end
  
  erb :search
end
