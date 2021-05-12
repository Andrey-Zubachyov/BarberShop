#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

# инициализируем в сенатре базу данных -> configure do


def get_db
	# функция возвращения таблицы
	return SQLite3::Database.new 'barbershop.db'
end

# будет выполнена инициализация при внесении изменений в запросе не при обновлении страницы
configure do
	# db переменная 
	db = get_db
	
	db.execute 'CREATE TABLE IF NOT EXISTS
				"Users"
				(
				"id" INTEGER PRIMARY KEY AUTOINCREMENT,
				"name" VARCHAR,
				"phone" VARCHAR,
				"datestamp" VARCHAR,
				"barber" VARCHAR,
				"color" VARCHAR
				)'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>!!!"
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do
	@user_name	= params[:user_name]
	@phone		= params[:phone]
	@time_visit	= params[:time_visit]
	@barbers	= params[:barbers]
	@color		= params[:color]
	# вывод об ошибке в случае отсуствия записи имени через хэш
	hh = {
		:user_name => 'Введите имя!',
		:phone => 'Введите номер телефона!',
		:time_visit => 'Bведите дату посещения!',
	}
	# переменной @error передаём хэш с select по значению имеющую путую строку (true == "") и через метод loin передаём строки знатечений через запятую
	@error = hh.select {|key,_| params[key] == ""}.values.join(" ")

	if @error != ""
		return erb :visit
	end

	db = get_db
	db.execute 'insert into
		Users
		(
			name,
			phone,
			datestamp,
			barber,
			color
		)
		values (?, ?, ?, ?, ?)', [@user_name, @phone, @time_visit, @barbers, @color]

	erb "Здравствуйте #{@user_name}! Вы записаны к #{@barbers} на #{@time_visit} Выбранный Вами цвет окраски: #{@color}"

end

