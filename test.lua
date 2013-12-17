cURL=require("cURL")
http={}
function http.get(url,cookie)
	-- open output file
	--f = io.open("2.txt", "w")
	local retStr=''
	local c = cURL.easy_init()
	-- setup url
	c:setopt_url(url)
	c:setopt_cookie(cookie)
	c:setopt_ssl_verifypeer(0)
	c:setopt_ssl_verifyhost(0)
	--[[c:setopt_post(1)
	c:setopt_postfields("a=1&b=1")]]
	c:setopt_verbose(10)

	-- perform, invokes callbacks
	c:perform({writefunction = function(str)
	 retStr=retStr..str               --f:write(str)
	                 end})

	-- close output file
	--f:close()
	return retStr
end

url="https://mail.qq.com/cgi-bin/login?vt=passport&vm=wpt&ft=ptlogin"
cookie="xxx"
data=http.get(url,cookie)
sid=string.match(data,'"frame_html%?sid=([^"]+)";')
if sid then
	url="https://mail.qq.com/cgi-bin/mail_list?sid="..sid.."&folderid=1&page=0"
	data=http.get(url,cookie)
	while data~='' do
		nextPage=string.match(data,'<a href="([^"]+)"  name="nextpage"')
		if not nextPage then break end
		url="https://mail.qq.com"..nextPage
		print(url)
		data=http.get(url,cookie)
	end
end
print(sid)
