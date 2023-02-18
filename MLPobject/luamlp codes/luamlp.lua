--[[
-- Module: luamlp.lua
-- Author: Jhonathan Paulo Banczek
-- Copyright: jpbanczek@gmail.com
-- 09-10-2013 - 16-10-2013
-- DESCRIPTION
	Luamlp.lua is a module written in Lua, implements the algorithm
	of multilayer perceptron with back-propagation algorithm in a
	generic way.
	One can define the number of hidden layers to 1 or 2 (not require
	the use of more than two hidden layers). One can also define the
	number of neurons used in any layer. The data input and output
	(for training) must be formatted in a two-dimensional array format:
	
	Data_input = {{x1},... {xn}} or {{x1,x2} ..., {xn-1, xn}}
	Data_output y1 = {{y1},... {yn}} or {{y1,y2} ..., {yn-1, yn}}
-- DEPENDENCIES
	Lua installed in system.
	Tested in Lua 5.1 and 5.2
	Linux/Ubuntu: sudo apt-get install lua5.2
	or
	sudo apt-get install lua5.1
-- FUNCTIONS | RETURN 
-- | Narray(nl, nc, value) -> table
-- | Luamlp:New(ni, nh1, nh2, nout) -> number
-- | Luamlp:Config(lr, it, bias, ert, mm, mt, fx, dfx) -> table
-- | Luamlp:LoadConfig(name(optional)) -> None
-- | Luamlp:Training(print_error) -> None
-- | Luamlp:Propagation(x) -> table
-- | Luamlp:Backpropagation(y) -> number
-- | Luamlp:Test(dinput) -> None
--]]

-- struct luamlp
local Luamlp = {}
M = require 'M'
 
-- Modules local used
local exp = math.exp
local log = math.log
local random = math.random
local tanh = M.tanh

--Default function activation: tangent hiperbolic
local function ftanh(x) return tanh(x) end

--Default function derivate function activation
local function dftanh(x) return 1 - ((ftanh(x)) ^ 2) end
-------------------------------------------------------------------


-------------------------------------------------------------------
--- Create array (table) bi-dimensional
-- parameters: 
-- nl: number -> number of lines in array
-- nc: number -> number of coluns in array
-- value: string/number -> 'r' = randomic values
--------------------------------------------------------------------
local function Narray(nl, nc, value)

	local value = value or 0
	local array = {}
	local nl = nl or 1
	local nc = nc or 1

	for i = 1, nl do
		local line = {}
		for j = 1, nc do
			if value == 'r' then
				table.insert(line, random())
			else
				table.insert(line, value)
			end
		end
		table.insert(array, line)
	end

	return array
end


---------------------------------------------------------------------------
--- Create new Multilayer Perceptron
-- parameters: 
-- ni = number of neuron in layer input ( ni > 0 )
-- nh1 = number of neuron in layer hidden 1 (nh1 > 0)
-- nh1 = number of neuron in layer input (nh2 > 0 exist, <= 0 not hidden 2)
-- nout = number of neuron in layer ouput (nout > 0)
----------------------------------------------------------------------------
function Luamlp:New(ni, nh1, nh2, nout)

	-- test if exist values
	assert(ni > 0 and nh1 > 0 and nh2 >= 0 and nout > 0, 'error in parameters')

	-- create struct multilayer perceptron
	local mlp = {}
	
	-- define length of a arrays
	mlp.ninput = ni
	mlp.nh1 = nh1
	if nh2 > 0 then mlp.nh2 = nh2 end
	mlp.nout = nout
	
	-- parameters
	mlp.input = nil -- Array of inputs
	mlp.output = nil -- Array of outputs
	mlp.lr = 0 -- Learning Rate
	mlp.it = 0 -- Number of iterations
	mlp.bias = 0 -- Value of Bias (developing...)
	mlp.error_training = 0 -- Value for error training
	mlp.fx = nil -- Function activation
	mlp.dfx = nil -- Function derivate activation
	mlp.mode_training = nil -- mode: 'sequential' or 'lot'
	
	-- arrays outputs --
	mlp.sum_h1 = Narray(1, mlp.nh1, 0) 
	if nh2 then mlp.sum_h2 = Narray(1, mlp.nh2, 0) else
		mlp.sum_h2 = nil
	end
	mlp.sum_out = Narray(1, mlp.nout, 0)

	-- define arrays output activations
	mlp.yinput = Narray(1, mlp.ninput)
	mlp.yhidden1 = Narray(1, mlp.nh1)
	if mlp.nh2 then mlp.yhidden2 = Narray(1, mlp.nh2) end 
	mlp.yout = Narray(1, mlp.nout)

	-- create weights
	mlp.w_i_h1 = Narray(mlp.ninput, mlp.nh1, 'r')
	if mlp.nh2 then
		mlp.w_h1_h2 = Narray(mlp.nh1, mlp.nh2, 'r')
		mlp.w_h2_out = Narray(mlp.nh2, mlp.nout, 'r')
	else
		mlp.w_h1_out = Narray(mlp.nh1, mlp.nout, 'r')
	end

	-- create weights for bias
	mlp.wbinh1 = Narray(1, mlp.nh1, 'r')
	if mlp.nh2 then mlp.wbh1h2 = Narray(1, mlp.nh2, 'r') end
	mlp.wbh2ou =  Narray(1, mlp.nout, 'r')

	-- create mommentum
	mlp.mm_i_h1 = Narray(mlp.ninput, mlp.nh1, 0)
	if mlp.nh2 then
		mlp.mm_h1_h2 = Narray(mlp.nh1, mlp.nh2, 0)
		mlp.mm_h2_out = Narray(mlp.nh2, mlp.nout, 0)
	else
		mlp.mm_h1_out = Narray(mlp.nh1, mlp.nout, 0)
	end

	---------------------------------------------------------------------
	--- Function: Config, configure as parameters of neural network
	-- parameters:
	-- lr: number
	-- it: number
	-- bias: number
	-- error_training: number
	-- fx: function (default ftanh)
	-- dfx: function (default dftanh)
	-- mm: number 
	-- mode_training: string
	---------------------------------------------------------------------
	function mlp:Config(lr, it, bias, ert, mm, mt, fx, dfx)

		self.lr = lr
		self.it = it
		self.bias = bias
		self.error_training = ert
		self.mm = mm
		self.mode_training = mt or 'sequential'
		self.fx = fx or ftanh
		self.dfx = dfx or dftanh

	end

	---------------------------------------------------------------------
	--- Function: LoadConfig, locad file for configure Luamlp
	-- parameters: name -> string name of file 
	-- default: string config.luamlp
	--------------------------------------------------------------------
	function mlp:LoadConfig(name)

		local name = name or 'config.luamlp'

		local conf = dofile(name)

		assert(conf, 'file with error or nil')
		self.lr = conf.lr
		self.it = conf.it
		self.bias = conf.bias
		self.error_training = conf.error_training
		self.mm = conf.mm
		self.mode_training = conf.mode_training
		self.fx = conf.fx or ftanh
		self.dfx = conf.dfx or dftanh
		self.input = conf.input
		self.output = conf.output

	end


	---------------------------------------------------------------------
	-- Training of neural network
	-- parameters: print_error -> if exist value, print informations errors
	-- in loops
	---------------------------------------------------------------------
	function mlp:Training(print_error)

		local print_error = print_error or nil

		if self.mode_training == 'sequential' then

			local it = 1
			while it < self.it do
				
				local verror = 0.0

				for i = 1, #self.input do
					self:Propagation(self.input[i])
					verror = verror + self:Backpropagation(self.output[i])
				end

				if print_error then
					print('iterations: ', it, '| error: ', verror)
				end

				if verror <= self.error_training then
					print("Learned Patterns!: Number of Iteractions: ", it)
					print("Value error: ", verror)
					break
				end
				it = it + 1

			end -- end iterations
		
		elseif self.mode_training == 'lot' then
			print('')
		else 
			print('Mode training not define')
		end

	end -- function


	---------------------------------------------------------------------
	-- Function: Propagation of inputs in layers
	-- parameters: x -> table (input data)
	---------------------------------------------------------------------
	function mlp:Propagation(x)

		local x = x or nil

		-- inputs x in layer
		for i = 1, self.ninput do self.yinput[i] = x[i] end

		-- calcule sum of layers hidden
		for j = 1, self.nh1 do

			local sum = 0

			for i = 1, self.ninput do
				sum = sum + self.yinput[i] * self.w_i_h1[i][j]
			end

			self.sum_h1[j] = sum
			self.yhidden1[j] = self.fx(sum)
		end

		------------ NEURAL NETWOK AS ONLY 2 HIDDEN LAYER  ------------

		if self.nh2 then

			for j = 1, self.nh2 do

				local sum = 0

				for i = 1, self.nh1 do
					sum = sum + self.yhidden1[i] * self.w_h1_h2[i][j]
				end

				self.sum_h2[j] = sum
				self.yhidden2[j] = self.fx(sum)
			end

			-- output

			for j = 1, self.nout do

				local sum = 0

				for i = 1, self.nh2 do
					sum = sum + self.yhidden2[i] * self.w_h2_out[i][j]
				end

				self.sum_out[j] = sum
				self.yout[j] = self.fx(sum)
			end

		else

			------------ NEURAL NETWOK AS ONLY 1 HIDDEN LAYER  ------------
			for j = 1, self.nout do

				local sum = 0

				for i = 1, self.nh1 do
					sum = sum + self.yhidden1[i] * self.w_h1_out[i][j]
				end

				self.sum_out[j] = sum 
				self.yout[j] = self.fx(sum)
			end
		end

		return self.yout
	end


	---------------------------------------------------------------------
	-- Function Back-Propagation 
	-- Parameters: y -> table (of expected outputs n training)
	---------------------------------------------------------------------
	function mlp:Backpropagation(y)

		local y = y or nil

		local out_delta = Narray(1, self.nout, 0)
		local nerror = 0.0
		-- value of return --
		local lms_error = 0.0 

        -- error lms algorithm (return of function)
        for i = 1, #y do
        	lms_error = lms_error + (0.5 * ((y[i] - self.yout[i]) ^ 2))
        end
		
		-- outputs delts calcule		
		for i = 1, self.nout do

			nerror = y[i] - self.yout[i]
			out_delta[i] = self.dfx(self.sum_out[i]) * nerror

		end

		---------- NEURAL NETWOK AS ONLY 2 HIDDEN LAYER  ------------
		if self.nh2 then

			local h2_delta = Narray(1, self.nh2, 0)

			for i = 1, self.nh2 do

				local nerror = 0.0

				for j = 1, self.nout do 
					nerror = nerror + out_delta[j] * self.w_h2_out[i][j]
				end

				h2_delta[i] = self.dfx(self.sum_h2[i]) * nerror
			end


			local h1_delta = Narray(1, self.nh1, 0)

			for i = 1, self.nh1 do

				local nerror = 0.0

				for j = 1, self.nh2 do 
					nerror = nerror + h2_delta[j] * self.w_h1_h2[i][j]
				end

				h1_delta[i] = self.dfx(self.sum_h1[i]) * nerror
			end

			-------------- update WEIGTHS and MOMENTUM ---------------

			for i = 1, self.nh2 do

				local mod = 0

				for j = 1, self.nout do
					mod = out_delta[j] * self.yhidden2[i]
					self.w_h2_out[i][j] = self.w_h2_out[i][j] + (self.lr * mod) +
					(self.mm * self.mm_h2_out[i][j])
					self.mm_h2_out[i][j] = mod 
				end

			end

			for i = 1, self.nh1 do

				local mod = 0

				for j = 1, self.nh2 do
					mod = h2_delta[j] * self.yhidden1[i]
					self.w_h1_h2[i][j] = self.w_h1_h2[i][j] + (self.lr * mod) +
					(self.mm * self.mm_h1_h2[i][j])
					self.mm_h1_h2[i][j] = mod 
				end

			end

			for i = 1, self.ninput do

				local mod = 0

				for j = 1, self.nh1 do
					mod = h1_delta[j] * self.yinput[i]
					self.w_i_h1[i][j] = self.w_i_h1[i][j] + (self.lr * mod) +
					(self.mm * self.mm_i_h1[i][j])
					self.mm_i_h1[i][j] = mod 
				end

			end

		else

			---------- IF NEURAL NETWORK AS ONLY 1 HIDDEN LAYER -----------

			local h1_delta = Narray(1, self.nh1, 0)

			for i = 1, self.nh1 do

				local nerror = 0.0

				for j = 1, self.nout do 
					nerror = nerror + out_delta[j] * self.w_h1_out[i][j]
				end

				h1_delta[i] = self.dfx(self.sum_h1[i]) * nerror
			end

			------------ update WEIGTHS and MOMENTUM ------------------

			for i = 1, self.nh1 do

				local mod = 0

				for j = 1, self.nout do
					mod = out_delta[j] * self.yhidden1[i]
					self.w_h1_out[i][j] = self.w_h1_out[i][j] + (self.lr * mod) +
					(self.mm * self.mm_h1_out[i][j])
					self.mm_h1_out[i][j] = mod 
				end

			end

			for i = 1, self.ninput do

				local mod = 0

				for j = 1, self.nh1 do
					mod = h1_delta[j] * self.yinput[i]
					self.w_i_h1[i][j] = self.w_i_h1[i][j] + (self.lr * mod) +
					(self.mm * self.mm_i_h1[i][j])
					self.mm_i_h1[i][j] = mod 
				end

			end
		end

        return lms_error

    end -- en function backpropagation

	---------------------------------------------------------------------
	-- Function Test
	-- Parameters: dinput: array input
	---------------------------------------------------------------------
    function mlp:Test(dinput)

    	self.input = dinput
    	print('-----------test ------------')
    	
    	for i = 1, #dinput do
    		if _VERSION == 'Lua 5.1' then
    			print(unpack(self:Propagation(dinput[i])))
    		else
    			print(table.unpack(self:Propagation(dinput[i])))
    		end
    	end

    end



    return mlp 

end -- end function New

return Luamlp