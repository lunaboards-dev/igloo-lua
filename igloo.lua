--ICE Wrapper or as I like to call it, Igloo

local icekey = require("icekey")

local unpack = unpack or table.unpack

local _ig = {}

local function iv_xor(data, iv)
	local ndat = {}
	for i=1, 8 do
		ndat[i] = data:byte(i) ~ iv[i]
	end
	return string.char(unpack(ndat))
end

-- Full file (de/en)cryption

function _ig:encrypt(data)
	--Make sure the length of data, minus 1, is a multiple of 8
	local rdat = data
	local padding = {}
	if ((#data+1) % 8 ~= 0) then
		for i=1, 8-((#data+1) % 8) do
			padding[i] = math.random(1, 255)
		end
	end
	local iv = {}
	for i=1, 8 do
		iv[i] = math.random(1, 255)
	end
	padding[#padding+1] = #padding
	data = data .. string.char(unpack(padding))
	local encdat = string.char(unpack(iv))
	for i=0, (#data//8)-1 do
		local dat = data:sub((i*8)+1, (i+1)*8)
		dat = iv_xor(dat, iv)
		local enc = assert(self.ik.encrypt(dat))
		iv = {enc:byte(1, 8)}
		encdat = encdat .. enc
	end
	return encdat
end

function _ig:decrypt(data)
	local iv = {data:byte(1, 8)}
	local decdata = ""
	for i=1, (#data//8)-1 do
		local block = data:sub((i*8)+1, (i+1)*8)
		local dec = iv_xor(assert(self.ik.decrypt(block), iv))
		decdata = decdata .. dec
		iv = {block:byte(1, 8)}
	end
	local plen = decdata:byte(#decdata)
	return decdata:sub(1, #decdata-(plen+1))
end

function igloo_create(level, key)
	local t = {
		ik = icekey(level)
	}
	assert(t.ik.setkey(key))
	return setmetatable(t, {__index=_ig})
end

return {
	create = igloo_create,
}
