<!------<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">----------->
<html>
<head>
<cfoutput>
<!--- Decrypt String --->
<cfset TheKey = 'NAMASKARAM'>
<cfset fileEncode = URLDecode(url.file)>
<cfset fileId = Decrypt(ToString(ToBinary(fileEncode)), TheKey)>
<CFQUERY NAME="filesLinked" DATASOURCE="#Application.dsn#">
	SELECT * FROM FileAttachments where attachment_Id = #fileId#
</CFQUERY>
<cfcontent type="#FilegetMimeType(expandPath('../fileupload/img/#filesLinked.attachmentFileName#'))#" file="#expandpath('../fileupload/img/#filesLinked.attachmentFileName#')#">

</cfoutput>
</body>
</html>