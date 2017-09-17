<% option explicit %>

<%
dim rewrite_url, fileExt, cType, objFSO, PARAM_VirtualFolder, ImageFilePath
PARAM_VirtualFolder = "drawImage/" 
ImageFilePath = "C:\Users\Manoj\Desktop\DrwImg\drawImage\"
rewrite_url = replace(replace(request.ServerVariables("HTTP_X_ORIGINAL_URL"), "/" & PARAM_VirtualFolder  &"secure_dzi/", ImageFilePath), "/", "\")

fileExt = lcase(mid(rewrite_url, instrrev(rewrite_url, ".")+1))

select case fileExt
	case "dzi"
		cType = "text/xml"
	case "jpeg","jpg"
		cType = "image/jpeg"
	case else
		response.end()
end select

set objFSO = server.CreateObject("scripting.fileSystemObject")
if objFSO.fileExists(rewrite_url) then
	Response.ContentType = cType
	call stream(rewrite_url)
else
	response.write("fileNotFound: " & rewrite_url)
end if
set objFSO = nothing
response.end()
function stream(path)
	dim adoStream, chunk, fileSize, i
	
	
	Set adoStream = CreateObject("ADODB.Stream") 
	
	adoStream.Open() 
	adoStream.Type = 1 
	
	adoStream.LoadFromFile(path) 
	
	fileSize = adoStream.Size 
	Response.AddHeader "Content-Length", fileSize
	Response.flush
	chunk = 1024 
	response.BinaryWrite(adoStream.read(1024))
	Response.flush
	
	For i = 1 To fileSize \ chunk 
    	If Not Response.IsClientConnected Then Exit For 
    	Response.BinaryWrite adoStream.Read(chunk) 
		response.flush()
	Next 
	
	If filesize Mod chunk > 0 Then 
    	If Response.IsClientConnected Then 
    	   	Response.BinaryWrite adoStream.Read(fileSize Mod chunk) 
			response.Flush()
    	End If 
	End If 
	
	adoStream.Close 
	Set adoStream = Nothing 
	
	
end function
%>