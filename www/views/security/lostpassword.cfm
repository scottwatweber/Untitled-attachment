<cfoutput>
<script language="javascript" type="text/javascript">
	function Validation()
	{
		if(document.getElementById('txtEmailAddress').value.length == 0)
		{
			alert("Please enter your email address");
			document.getElementById('txtEmailAddress').focus();
			return false;
		}
	}
</script>
<div class="login-bg">
<div class="login-title">Login</div>
<form action="index.cfm?event=lostpassword:process&#Session.URLToken#" method="post" name="frmLostPassword" id="frmLostPassword" onSubmit="JavaScript: return Validation(this)" autocomplete="off">
				<fieldset>
				<!--- <label class="user">Please enter your email address and we will send your login details to you</label> --->
				<cfif isdefined('URL.Failed')>
					Email Address Not Found
				</cfif>
				<label class="user" style="width:80px;">Email Address</label>
				<input type="text" id="txtEmailAddress" name="txtEmailAddress" class="field">
				<div class="clear"></div>
				<div style="padding-left:90px;"><input type="button" value="Cancel" class="loginbttn" style="margin-right:15px;" onclick="document.location.href='index.cfm';" /><input type="submit" value="Submit" class="loginbttn" /></div>
				<div class="clear"></div>
				</fieldset>			
</form>
<div class="clear"></div>
</div>
</cfoutput>