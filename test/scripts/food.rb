class Promised
	attr_accessor :own
	attr_accessor :sum
	
	def initialize
		@own = 0
		@sum = 0
	end
end

# add debugging methods
class Xeme
	def show_bool(bool)
		if bool.nil?
			return 'nil'
		else
			return bool.to_s
		end
	end
	
	def info
		TTM.puts "#{meta['id']} - [s=#{show_bool(@hsh['success'])}] [r=#{show_bool(@resolved)}] [t=#{show_bool(@tried)}]"
		
		if self['nested']
			TTM.indent do
				self['nested'].each do |child|
					child.info
				end
			end
		end
	end
	
	def resolved()
		return @resolved
	end
	
	def resolved=(bool)
		return @resolved = bool
	end
	
	def tried()
		return @tried
	end
	
	def tried=(bool)
		return @tried = bool
	end
	
	def promised
		if not instance_variable_defined?('@promised')
			@promised = Promised.new
		end
		
		return @promised
	end
	
	def expect_promises(own, sum)
		if own > 0
			@hsh['promises'] = []
			
			(1..own).to_a.each do |idx|
				promise idx
			end
		end
		
		promised.own = own
		promised.sum = sum
	end
end

# create_food
def create_food_tree
	# top xeme
	food = Xeme.new('food')
	food['success'] = nil
	food.resolved = false
	food.tried = false
	food['errors'] = []
	food['warnings'] = []
	food['notes'] = []
	
	# vegetables
	food.nest('vegetables') do |vegetables|
		vegetables['success'] = true
		vegetables.resolved = true
		vegetables.tried = true
	end
	
	# fruit
	food.nest('fruit') do |fruit|
		fruit['success'] = nil
		fruit.resolved = false
		fruit.tried = false
		
		# red
		fruit.nest('red') do |red|
			red['success'] = true
			red.resolved = false
			red.tried = false
			
			red['errors'] = []
			red['warnings'] = []
			red['notes'] = []
			
			# cherry
			red.nest('cherry') do |cherry|
				cherry['success'] = true
				cherry.resolved = true
				cherry.tried = true
				
				# rainier
				cherry.nest('rainier') do |rainier|
					rainier['success'] = true
					rainier.resolved = true
					rainier.tried = true
				end
			end
			
			# apple
			red.nest('apple') do |apple|
				apple['success'] = false
				apple.resolved = false
				apple.tried = false
				
				# honeycrisp
				apple.nest('honeycrisp') do |honeycrisp|
					honeycrisp['success'] = nil
					honeycrisp.resolved = nil
					honeycrisp.tried = true
				end
			end
			
			# raspberry
			red.nest('raspberry') do |raspberry|
				raspberry['success'] = true
				raspberry.resolved = false
				raspberry.tried = false
				
				# polona
				raspberry.nest('polona') do |polona|
					polona['success'] = false
					polona.resolved = false
					polona.tried = false
				end
			end
		end
		
		# yellow
		fruit.nest('yellow') do |yellow|
			yellow['success'] = nil
			yellow.resolved = nil
			yellow.tried = true
			
			# banana
			yellow.nest('banana') do |banana|
				banana['success'] = true
				banana.resolved = true
				banana.tried = true
			end
		end
		
		# green
		fruit.nest('green') do |green|
			green['success'] = nil
			green.resolved = false
			green.tried = false
			
			# kiwi
			green.nest('kiwi') do |kiwi|
				kiwi['success'] = false
				kiwi.resolved = false
				kiwi.tried = false
				
				# arguta
				kiwi.nest('arguta') do |arguta|
					arguta['success'] = true
					arguta.resolved = true
					arguta.tried = true
					
					arguta['errors'] = []
					arguta['warnings'] = []
					arguta['notes'] = []
				end
			end
			
			# starfruit
			green.nest('starfruit') do |starfruit|
				starfruit['success'] = nil
				starfruit.resolved = false
				starfruit.tried = false
				
				# sour
				starfruit.nest('sour') do |sour|
					sour['success'] = false
					sour.resolved = false
					sour.tried = false
				end
			end
			
			# avacado
			green.nest('avacado') do |avacado|
				avacado['success'] = false
				avacado.resolved = false
				avacado.tried = false
				
				# hass
				avacado.nest('hass') do |hass|
					hass['success'] = false
					hass.resolved = false
					hass.tried = false
				end
			end
			
			# breadfruit
			green.nest('breadfruit') do |breadfruit|
				breadfruit['success'] = true
				breadfruit.resolved = nil
				breadfruit.tried = nil
				breadfruit.expect_promises 0, 3
				
				# fosberg
				breadfruit.nest('fosberg') do |fosberg|
					fosberg['success'] = true
					fosberg.resolved = nil
					fosberg.tried = nil
					fosberg.expect_promises 3, 3
				end
			end
		end
		
		# blue
		fruit.nest('blue') do |blue|
			blue['success'] = true
			blue.resolved = false
			blue.tried = false
			
			# blueberry
			blue.nest('blueberry') do |blueberry|
				blueberry['success'] = true
				blueberry.resolved = false
				blueberry.tried = false
				blueberry.error 'blueberry-error'
			end
		end
		
		# purple
		fruit.nest('purple') do |purple|
			purple['success'] = nil
			purple.resolved = false
			purple.tried = false
			
			# plum
			purple.nest('plum') do |plum|
				plum['success'] = nil
				plum.resolved = false
				plum.tried = false
				
				# prune
				plum.nest('prune') do |prune|
					prune['success'] = true
					prune.resolved = false
					prune.tried = false
					prune.error 'prune-error'
				end
			end
			
			# fig
			purple.nest('fig') do |fig|
				fig['success'] = nil
				fig.resolved = false
				fig.tried = false
				
				# mission
				fig.nest('mission') do |mission|
					mission['success'] = false
					mission.resolved = false
					mission.tried = false
					mission.error 'mission-error'
				end
			end
			
			# cabbage
			purple.nest('cabbage') do |cabbage|
				cabbage['success'] = false
				cabbage.resolved = false
				cabbage.tried = false
				
				# ruby
				cabbage.nest('ruby') do |ruby|
					ruby['success'] = false
					ruby.resolved = false
					ruby.tried = false
					ruby.error 'ruby-error'
				end
			end
		end
	end
	
	# spices
	food.nest('spices') do |spices|
		spices['success'] = nil
		spices.resolved = false
		spices.tried = false
		
		# paprika
		spices.nest('paprika') do |paprika|
			paprika['success'] = nil
			paprika.resolved = false
			paprika.tried = false
			
			# sweet
			paprika.nest('sweet') do |sweet|
				sweet['success'] = true
				sweet.resolved = false
				sweet.tried = false
				
				# carolina
				sweet.nest('carolina') do |carolina|
					carolina['success'] = nil
					carolina.error 'carolina-error'
					carolina.resolved = false
					carolina.tried = false
				end
			end
			
			# hot
			paprika.nest('hot') do |hot|
				hot['success'] = nil
				hot.resolved = false
				hot.tried = false
				
				# cajun
				hot.nest('cajun') do |cajun|
					cajun['success'] = nil
					cajun.error 'cajun-error'
					cajun.resolved = false
					cajun.tried = false
				end
			end
			
			# smoked
			paprika.nest('smoked') do |smoked|
				smoked['success'] = false
				smoked.resolved = false
				smoked.tried = false
				
				# hickory
				smoked.nest('hickory') do |hickory|
					hickory['success'] = nil
					hickory.error 'cajun-error'
					hickory.resolved = false
					hickory.tried = false
				end
			end
			
			# spanish
			paprika.nest('spanish') do |spanish|
				spanish['success'] = true
				spanish.resolved = false
				spanish.tried = false
				
				# bittersweet
				spanish.nest('bittersweet') do |bittersweet|
					bittersweet['success'] = false
					bittersweet.error 'bittersweet-error'
					bittersweet.resolved = false
					bittersweet.tried = false
				end
			end
		end
		
		# pepper
		spices.nest('pepper') do |pepper|
			pepper['success'] = true
			pepper.resolved = nil
			pepper.tried = true
			
			# matico
			pepper.nest('matico') do |matico|
				matico['success'] = true
				matico.resolved = nil
				matico.tried = true
				
				# yunck
				matico.nest('yunck') do |yunck|
					yunck['success'] = nil
					yunck.resolved = nil
					yunck.tried = true
				end
			end
			
			# sichuan
			pepper.nest('sichuan') do |sichuan|
				sichuan['success'] = nil
				sichuan.resolved = nil
				sichuan.tried = true
				
				# sansho
				sichuan.nest('sansho') do |sansho|
					sansho['success'] = nil
					sansho.resolved = nil
					sansho.tried = true
				end
			end
		end
	end
	
	# return food xeme
	return food
end

__END__

child     parent    child        parent
s   s     s    s    rainier      cherry
          n    n    banana       yellow
          f    f    arguta       kiwi
se  f     s    f    bluebery     blue
          n    f    prune        plum
		  f    f    cajun        hot
n   n     s    n    yunck        matico
          n    n    sansho       sichuan
		  f    f    honeycrisp   apple
ne  f     s    f    sweet        carolina
          n    f    cajun        hot
          f    f    hickory      smoked
f   f     s    f    polana       raspberry
          n    f    sour         starfruit
		  f    f    hass         avacado
fe  f     s    f    bittersweet  spanish
          n    f    mission      fig
		  f    f    ruby         cabbage
sp  n     np   n    fosberg      breadfruit