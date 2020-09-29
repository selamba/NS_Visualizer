require "ruby2d"
# У Ruby2D есть свой мелкий псевдо-DSL, например четыре строки ниже


set title: "Neural Network"
set width: 1920
set height: 1080
set background: "white"
set fullscreen: true

# Узел
# Кружок любого цвета с черной границей
class Node < Circle
	
	attr_accessor :border_circle
	
	def initialize(opts = nil)
		super
		@radius = 47
		@sectors = 30
		
		@border_circle = Circle.new(x: @x, y: @y, z: @z - 1, radius: 50, sectors: 30, color: "black")
	end
	
	# Ручной setget
	def radius
		@radius
	end
	
	def radius=(rad)
		@radius = rad
	end

end

class Visualizer
	
	attr_accessor :in_layer, :inter_layers, :out_layer, :all_layers
	
	def initialize
		super
		@in_layer, @inter_layers, @out_layer, @all_layers = [], [], [], []
	end
	
	def visualize(num_in_nodes = -1, num_inter_layers = -1, num_inter_nodes = -1, num_out_nodes = -1, debug = false)
		# Проверка параметров на валидность
		if method(__method__).parameters.any? { |param| param == -1 }
			puts "One of the parameters is invalid.\n"
		end
		
		## DEBUG ##
		if debug
			# vertical
			Line.new(
				x1: 0, y1: Window.height / 2,
				x2: Window.width, y2: Window.height / 2,
				width: 1, color: "yellow",
				z: 1000
			)
			# horizontal
			Line.new(
				x1: Window.width / 2, y1: 0,
				x2: Window.width / 2, y2: Window.height,
				width: 1, color: "yellow",
				z: 1000
			)
		end
		## DEBUG ##
		
		# Рисование нейронной сети
		hor_period = Window.width / (num_inter_layers + 2)
		layer_position = hor_period / 2
		vert_in_period = Window.height / (num_in_nodes)
		vert_inter_period = Window.height / (num_inter_nodes )
		vert_out_period = Window.height / (num_out_nodes)
		
		# Рисование: Входной слой
		num_in_nodes.times do |n|
			@in_layer << Node.new(
				x: layer_position,
				y: vert_in_period * (n + 1) - vert_in_period / 2,
				color: "green"
			)
		end
		layer_position += hor_period
		@all_layers << @in_layer
		
		# Рисование: Промежуточный слой/слои
		num_inter_layers.times do |l|
			@inter_layers << []
			num_inter_nodes.times do |n|
				@inter_layers[l] << Node.new(
					x: layer_position,
					y: vert_inter_period * (n + 1) - vert_inter_period / 2,
					color: "red"
				)
			end
			layer_position += hor_period
			@all_layers << @inter_layers[l]
		end
		
		# Рисование: Выходной слой/узел
		num_out_nodes.times do |n|
			@out_layer << Node.new(
				x: layer_position,
				y: vert_out_period * (n + 1) - vert_out_period / 2,
				color: "blue"
			)
		end
		@all_layers << @out_layer
		
		# TEST LINE DRAW
		
		# TEST LINE DRAW
		
		# Обработка ввода с клавиатуры/мыши
		Window.on :key do |event|
			puts event
			
			# Numpad+ -> Увеличение размера узлов
			if event.key == "keypad +"
				@all_layers.each do |array|
					array.each do |node|
						node.radius += 1
						node.border_circle.radius += 1
					end
				end
			end
			
			# Numpad- -> Уменьшение размера узлов
			if event.key == "keypad -"
				@all_layers.each do |array|
					array.each do |node|
						node.radius -= 1
						node.border_circle.radius -= 1
					end
				end
			end
			
			# Esc -> Закрытие окна
			if event.key == "escape"
				Window.close
			end
		end
		
		
		# Показ окна
		Window.show
	end

end

# Выполнение программы
Visualizer.new.visualize 4, 3, 4, 1, true