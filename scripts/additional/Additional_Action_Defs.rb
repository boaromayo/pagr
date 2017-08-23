module RPG
	class Enemy
		class Action
			def passive?
				return @condition_level >= 2
			end
		end
	end
end