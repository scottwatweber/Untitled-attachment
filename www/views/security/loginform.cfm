<cfoutput>
<script language="JavaScript1.2" type="text/javascript">
	function Validation(objForm) {
		if(objForm.txtUserName.value == "") {
			alert('Please insert your user name');
			objForm.txtUserName.focus();
			return false;
		}
		if(objForm.txtPassword.value == "") {
			alert('Please insert your password');
			objForm.txtPassword.focus();
			return false;
		}
		return true;
	}

	function Initialize() {
		document.getElementById('txtUserName').focus();

		if(top.document.location.href != document.location.href) {
			try {
				top.locateTimeout('index.cfm?event=loginPage&#Session.URLToken#');
				window.close();
			}
			catch (e) {
			}
		}
						
	}
	
</script>
<div class="login-bg">
<div class="login-title">Login</div>
<form action="index.cfm?event=login:process&#Session.URLToken#&reinit=true" method="post" name="frmLogin" id="frmLogin" onSubmit="JavaScript: return Validation(this)" autocomplete="off">
	<cfif IsDefined("URL.AlertMessageID") And IsDefined("Session.Passport.LoginError") And URL.AlertMessageID EQ 1>
		<div class="msg-area" style="width:360px;color:red;">#Session.Passport.LoginError#</div>
		<cfelseif IsDefined("URL.AlertMessageID") and URL.AlertMessageID eq 2>
		<div class="msg-area" style="width:360px;color:red;">Session has expired</div>
	</cfif>
	<fieldset>
	<label class="user">Username:</label>
	<!--- <td class="requiredFieldLabel" nowrap="true">User Name<cfif Session.blnDebugMode><a onclick="JavaScript:document.getElementById('txtUserName').value = 'super'; document.getElementById('txtPassword').value = '@super1';">*</a><cfelse>*</cfif></td> --->
	<input type="text" id="txtUserName" name="txtUsername" class="field">
	<div class="clear"></div>
	<label class="user">Password:</label>
	<input type="Password" id="txtPassword" name="txtLoginPassword" class="field">
	<div class="clear"></div>
	<label class="user">&nbsp;</label>
	<label class="fpass"><a href="index.cfm?event=lostPassword&#Session.URLToken#">Forgot your password?</a></label>
	<input name="btnSubmit" type="submit" class="loginbttn" value="Login">
	<div class="clear"></div>	
</form>
</div>
<div class="clear"></div>

<script language="javascript" type="text/javascript">
	Initialize();
</script>
<!--LOGIN_PAGE--><!---Do not remove this HTML comment, it is used for ajax to detect when the session times out--->
</cfoutput>