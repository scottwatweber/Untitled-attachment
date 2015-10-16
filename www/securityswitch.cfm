<!--------------------------------------------------------------------------------------------------------------------------------------------------------->
<!--- DECLARE GATEWAYS --->
<!--------------------------------------------------------------------------------------------------------------------------------------------------------->

<!--- e.g. variables.objCustomers = getGateway("gateways.customers.customergateway", MakeParameters("dsn=#Application.dsn#")); --->
<cfscript>
	variables.objSecurityGateway = getGateway("gateways.security.securitygateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
	variables.objloadGateway = getGateway("gateways.loadgateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
	variables.objAgentGateway = getGateway("gateways.agentgateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
	variables.objPrivilegeXmlGateway = getGateway("gateways.security.privilegexmlgateway", MakeParameters("xmlFilePath=#ExpandPath('#request.strBase#../config/privileges.xml')#"));
</cfscript>

<!--------------------------------------------------------------------------------------------------------------------------------------------------------->
<!--- MAIN SECTION - DEFINE YOUR EVENTS HERE --->
<!--------------------------------------------------------------------------------------------------------------------------------------------------------->

<cfswitch expression="#request.event#">
	<cfcase value="noPrivileges">
		<cfset request.content = includeTemplate("views/security/noaccess.cfm", true) />
		<cfif IsDefined("URL.blnIsTab") And URL.blnIsTab>
			<cfset includeTemplate("views/templates/iframetemplate.cfm") />
		<cfelseif IsDefined("URL.blnIFrame") And URL.blnIFrame>
			<cfset request.blnIncludeBorder = False />
			<cfset includeTemplate("views/templates/iframetemplate.cfm") />
		<cfelse>
			<cfset includeTemplate("views/templates/maintemplate.cfm") />
		</cfif>
	</cfcase>
	<cfcase value="login">
		<cfset request.content = includeTemplate("views/security/loginform.cfm", true) />
		<cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>
	<cfcase value="login:process">
		<!--- Check if the variables exists --->
		<cfif Not StructKeyExists(Form, "txtUsername")>
			<cfthrow errorcode="1001" message="Username Missing" detail="The Username has not been specified on the previous page" />
		</cfif>
		<cfif Not StructKeyExists(Form, "txtLoginPassword")>
			<cfthrow errorcode="1001" message="Password Missing" detail="The Password has not been specified on the previous page" />
		</cfif>
		<cfset session.passport = doLogin(strUsername=FORM.txtUsername, strPassword=FORM.txtLoginPassword) />
        <cfif session.passport.isLoggedIn>
			<cfset session.AdminUserName = FORM.txtUsername>
            <cfinvoke component="#variables.objAgentGateway#" method="getUserRoleByUserName" returnvariable="request.qUserRole">
            	<cfinvokeargument name="userName" value="#session.AdminUserName#">
            </cfinvoke>
            <cfinvoke component="#variables.objAgentGateway#" method="GetUserInfoUserName" returnvariable="request.qUserInfo">
            	<cfinvokeargument name="userName" value="#session.AdminUserName#">
            </cfinvoke>
            <!---USP_GetUserInfoUserName--->
            
            <cfset session.currentUserType = request.qUserRole.RoleValue>
            <cfset session.UserFullName = request.qUserInfo.Name>
            <cfset session.rightsList = request.qUserRole.userRights>
			<cfif session.passport.PasswordExpired Or session.passport.PasswordAlmostExpired>
				<cflocation url="index.cfm?event=passwordExpired" addtoken="yes" />
			<cfelse>
				<cfif CheckObjectAccess("navMainClients")>
					<cflocation url="index.cfm?event=SearchClient" addtoken="yes" />
				<cfelse>
					<cflocation url="index.cfm?event=Myload" addtoken="yes" />
				</cfif>
			</cfif>
		<cfelse>
			<cflocation url="index.cfm?event=login&AlertMessageID=1" addtoken="yes" />
		</cfif>

	</cfcase>
	<cfcase value="customerlogin">
		<cfset request.content = includeTemplate("views/security/Customerloginform.cfm", true) />
		<cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>

	<cfcase value="Customerlogin:process">
		<!--- Check if the variables exists --->
		<cfif Not StructKeyExists(Form, "Username")>
			<cfthrow errorcode="1001" message="Username Missing" detail="The Username has not been specified on the previous page" />
		</cfif>
		<cfif Not StructKeyExists(Form, "LoginPassword")>
			<cfthrow errorcode="1001" message="Password Missing" detail="The Password has not been specified on the previous page" />
		</cfif>

		<cfset session.passport = CustomerdoLogin(strUsername=FORM.Username, strPassword=FORM.LoginPassword) />
        <cfif session.passport.isLoggedIn>
			<cfset session.AdminUserName = FORM.Username>
			<cfset request.qUserRole.RoleValue = 8>
			<cfset request.qUserRole.userRights = 'ViewLoad'>
            <cfquery name="request.qUserInfo" datasource="#Application.dsn#">
            	SELECT * FROM Customers 
            	WHERE CUSTOMERNAME = <cfqueryparam value="#session.AdminUserName#" cfsqltype="cf_sql_varchar">
            </cfquery>
            <!---USP_GetUserInfoUserName--->
            
            <cfset session.currentUserType = request.qUserRole.RoleValue>
            <cfset session.UserFullName = request.qUserInfo.CUSTOMERNAME>
            <cfset session.rightsList = request.qUserRole.userRights>
			<cfif session.passport.PasswordExpired Or session.passport.PasswordAlmostExpired>
				<cflocation url="index.cfm?event=passwordExpired" addtoken="yes" />
			<cfelse>
				<cfif CheckObjectAccess("navMainClients")>
					<cflocation url="index.cfm?event=SearchClient" addtoken="yes" />
				<cfelse>
					<cflocation url="index.cfm?event=load" addtoken="yes" />
				</cfif>
			</cfif>
		<cfelse>
			<cflocation url="index.cfm?event=CustomerLogin&AlertMessageID=1" addtoken="yes" />
		</cfif>

	</cfcase>
    
	<cfcase value="passwordExpired">
		<cfset request.content = includeTemplate("views/security/passwordexpired.cfm", true) />
		<cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>
    
	<cfcase value="changePassword:Form">
		<cfset request.SubHeading = "Change Password">
		<cfset request.content = includeTemplate("views/security/loginchangepwd.cfm", true) />
		<cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>
    
	<cfcase value="lostpassword">
		<!--- <cfset request.SubHeading = "Lost Password"> --->
		<cfset request.content = includeTemplate("views/security/lostpassword.cfm", true) />
		<cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>
    
	<cfcase value="lostpassword:process">
		<cfset NewPassword = GenerateRandomPassword()>
		<cfset request.UserDetails = variables.objSecurityGateway.checkLostPassword("#form.txtEmailAddress#","#NewPassword#")>
		<cfif request.UserDetails.recordcount GT 0>
			
            <cfmail to="#form.txtEmailAddress#" from="#Application.strEmailFromAddress#" subject="Lost Password Retrieval" type="html">
				<table>
					<tr>
						<td>Dear #request.UserDetails.sFirstName# #request.UserDetails.sLastName#</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>You entered the "Lost Password" section of the system and have asked us to retrieve your password. If you have received this email in error please contact the system administrator immediately.</td>
					</tr>
					<tr>
						<td>Username: #request.UserDetails.sUsername#</td>
					</tr>
					<tr>
						<td>Password: #NewPassword#</td>
					</tr>
				</table>
			</cfmail>
            
			<cflocation url="index.cfm?event=login&AlertMessageID=4" addtoken="yes" />
		<cfelse>
			<cflocation url="index.cfm?event=lostpassword&Failed=y" addtoken="yes" />
		</cfif>
	</cfcase>
    
	<cfcase value="changePassword:Process">
		<cfset request.SubHeading = "Change Password">
		<cfset PasswordCheck = doLogin(strUsername=FORM.txtUsername, strPassword=FORM.txtOldPassword) />
		<cfset request.siteUserBean = GetBean("beans.siteuserbean") />
		<cfif PasswordCheck.isLoggedIn>
			<cfinvoke component="#variables.objSecurityGateway#" method="ChangeUserPassword" returnvariable="request.intSiteUserID">
				<cfinvokeargument name="intSiteUserID" value="#session.passport.CurrentSiteUser.getSiteUserID()#" />
				<cfinvokeargument name="strUsername" value="#session.passport.CurrentSiteUser.getUsername()#" />
				<cfinvokeargument name="strPassword" value="#FORM.txtNewPassword#" />
			</cfinvoke>
			<cfset Session.Passport.PasswordExpired = false>
			<cfset request.content = includeTemplate("views/security/loginchangepwdsuccess.cfm", true) />
			<cfset includeTemplate("views/templates/maintemplate.cfm") />
		<cfelse>
			<cfset request.content = includeTemplate("views/security/loginchangepwd.cfm", true) />
			<cfset includeTemplate("views/templates/maintemplate.cfm") />
		</cfif>
	</cfcase>
    
	<cfcase value="logout:process">
		<cfset logoutvar = logoutuser()>
		<cfset structDelete(session, "passport") />
		<cfif StructKeyExists(session,"CustomerID") AND session.CustomerID NEQ "">
			<cfset structDelete(session, "CustomerID") />
			<cflocation url="index.cfm?event=customerlogin&AlertMessageID=3" addtoken="yes" />
		<cfelse>
			<cflocation url="index.cfm?event=login&AlertMessageID=3" addtoken="yes" />
		</cfif>
	</cfcase>
	<cfcase value="DashboardDefault">
		<cfset request.tabs = includeTemplate("views/general/tabs.cfm", true) />
		<!--- <cfset request.subnavigation = includeTemplate("views/admin/adminsubnav.cfm", true) /> --->
		<cfset request.content = includeTemplate("views/pages/load/disp_load.cfm", true) />
		<cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>
	<!--- Site Users --->
	<cfcase value="SecurityMainPage">
		<cfset request.lstTabs = "">
		<cfif CheckObjectAccess('subNavSiteUserManagement')>
			<cfset request.lstTabs = ListAppend(request.lstTabs, "Site Users,index.cfm?event=SecurityMaintenance&#Session.URLToken#") />
		</cfif>
		<cfif checkObjectAccess('lnkGroupAccess')>
			<cfset request.lstTabs = ListAppend(request.lstTabs, "|Groups,index.cfm?event=GroupMaintenance&#Session.URLToken#") />
		</cfif>
		<cfset request.tabs = includeTemplate("views/general/tabs.cfm", true) />
		<cfset request.subnavigation = includeTemplate("views/admin/adminsubnav.cfm", true) />
		<cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>
	<cfcase value="SecurityMaintenance">
		<cfset request.structGroups = getGroupList() />
		<cfset request.SubHeading = "Search Site Users">
		<cfset request.initialFunctions = includeTemplate("views/admin/security/siteusers/initialfunctions.cfm", true) />
		<cfset request.content = includeTemplate("views/admin/security/securitymaintenance.cfm", true) />
		<cfif IsDefined("URL.blnIFrame") And URL.blnIFrame>
			<cfset includeTemplate("views/templates/maintemplate.cfm") />
		<cfelse>
			<cfset includeTemplate("views/templates/iframetemplate.cfm") />
		</cfif>
	</cfcase>
	<cfcase value="ajax_GetSearchSiteUserForm">
		<cfsetting showdebugoutput="no" />	
		<cfset includeTemplate("views/admin/security/siteusers/searchsiteuserform.cfm") />
	</cfcase>
	<cfcase value="ajax_GetSiteUserList">
		<cfsetting showdebugoutput="no" />
		<cfset request.structSiteUsers = getSiteUserList() />
		
		<cfif Not (isdefined('URL.blnAllRecords') And URL.blnAllRecords)>
			<cfinvoke method="getRecordPages" returnvariable="request.structPageNumbers">
				<cfif isdefined('FORM.intPageNumber')>
					<cfinvokeargument name="intCurrentPageNumber" value="#FORM.intPageNumber#">
				</cfif>
				<cfinvokeargument name="intResultsPerPage" value="#Application.ResultsPerPage#">
				<cfinvokeargument name="intTotalRecords" value="#request.structSiteUsers.rstEnumTotalCount.iCount#">
				<cfinvokeargument name="strEvent" value="#request.event#">
			</cfinvoke>
		</cfif>
		<cfinvoke method="getListPageTableHeaders" returnvariable="request.structTableHeader">
			<cfinvokeargument name="lstHeaderNames" value="FirstName|sFirstName|left,Last Name|sLastName|left,Mobile Number|sMobileNumber|left,EmailAddress|sEmailAddress|left,Enabled?|bEnabled|center,&nbsp;,&nbsp;,&nbsp;,&nbsp;">
			<cfinvokeargument name="strEvent" value="#request.event#">
			<cfinvokeargument name="FilterVariableName" value="strOrderBy">
		</cfinvoke>
		
		<cfset includeTemplate("views/admin/security/siteusers/listsiteusers.cfm") />
	</cfcase>
	<cfcase value="ajax_ViewSiteUser">
		<cfsetting showdebugoutput="no" />
		<cfset request.SubHeading = "View Site User">
		<cfset request.siteUserBean = fetchCurrentSiteUser(intSiteUserID=URL.intSiteUserID) />
		<cfset request.content = includeTemplate("views/admin/security/siteusers/viewsiteuser.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>
	<cfcase value="ajax_GetAddEditSiteUserForm">
		<cfsetting showdebugoutput="no" />
		
		<cfif IsDefined("URL.intSiteUserID")>
			<cfset request.siteUserBean = fetchCurrentSiteUser(intSiteUserID=URL.intSiteUserID) />	
		<cfelse>
			<cfset request.siteUserBean = CreateObject('component', 'beans.siteuserbean') />
			<cfset request.siteUserBean.setCreatedSiteUser(CreateObject('component', 'beans.siteuserbean')) />
			<cfset request.siteUserBean.setUpdatedSiteUser(CreateObject('component', 'beans.siteuserbean')) />
			<cfset request.siteUserBean.setDeletedSiteUser(CreateObject('component', 'beans.siteuserbean')) />
		</cfif>
		<cfif IsDefined("URL.intSiteUserID")>
			<cfset request.SubHeading = "Edit Site User" />
		<cfelse>	
			<cfset request.SubHeading = "Add  Site User" />
		</cfif>
		<cfset request.content = includeTemplate("views/admin/security/siteusers/addeditsiteuser.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>
	<cfcase value="ajax_SaveSiteUser">
		<cfset request.siteUserBean = GetBean("beans.siteuserbean") />
		<cfsetting showdebugoutput="no" />
		<cfif FORM.hdnSiteUserID GT 0>
			<cfinvoke component="#variables.objSecurityGateway#" method="updateSiteUser" returnvariable="request.intSiteUserID">
				<cfinvokeargument name="intSiteUserID" value="#request.siteUserBean.getSiteUserID()#" />
				<cfinvokeargument name="strFirstName" value="#request.siteUserBean.getFirstName()#" />
				<cfinvokeargument name="strLastName" value="#request.siteUserBean.getLastName()#" />
				<cfinvokeargument name="strUsername" value="#request.siteUserBean.getUsername()#" />
				<cfinvokeargument name="strEmailAddress" value="#request.siteUserBean.getEmailAddress()#" />
				<cfinvokeargument name="strMobileNumber" value="#request.siteUserBean.getMobileNumber()#" />
				<cfinvokeargument name="blnEnabled" value="#request.siteUserBean.getEnabled()#" />
				<cfif LEN(request.siteUserBean.getPassword()) GT 0>
					<cfinvokeargument name="strPassword" value="#request.siteUserBean.getPassword()#" />
				</cfif>
				<cfinvokeargument name="intUpdatedSiteUserID" value="#Session.passport.currentSiteUser.getSiteUserID()#" />
			</cfinvoke>
		<cfelse>
		<!---<cfset request.structUserExists= getSiteUserList(#FORM.txtFirstName#) />
		<cfdump var="#request.structUserExists#"><cfabort>--->
			<cfinvoke component="#variables.objSecurityGateway#" method="addSiteUser" returnvariable="request.intSiteUserID">
				<cfinvokeargument name="strFirstName" value="#request.siteUserBean.getFirstName()#" />
				<cfinvokeargument name="strLastName" value="#request.siteUserBean.getLastName()#" />
				<cfinvokeargument name="strUsername" value="#request.siteUserBean.getUsername()#" />
				<cfinvokeargument name="strEmailAddress" value="#request.siteUserBean.getEmailAddress()#" />
				<cfinvokeargument name="strMobileNumber" value="#request.siteUserBean.getMobileNumber()#" />
				<cfinvokeargument name="blnEnabled" value="#request.siteUserBean.getEnabled()#" />
				<cfinvokeargument name="strPassword" value="#request.siteUserBean.getPassword()#" />
				<cfinvokeargument name="intCreatedSiteUserID" value="#Session.passport.currentSiteUser.getSiteUserID()#" />
			</cfinvoke>
		</cfif>

		<cfif IsDefined("FORM.chkResetOnNextLogin") And FORM.chkResetOnNextLogin>
			<cfinvoke component="#variables.objSecurityGateway#" method="expirePassword">
				<cfinvokeargument name="intSiteUserID" value="#request.intSiteUserID#" />
			</cfinvoke>
		</cfif>
		
		<cfif IsDefined("URL.strCriteria")>
			<cfset strExtraParams = "strCriteria=#URL.strCriteria#" />
		<cfelse>
			<cfset strExtraParams = "" />
		</cfif>
		<!---<cflocation url="index.cfm?event=ajax_GetSiteUserList&#strExtraParams#" addtoken="yes" />--->
	</cfcase>
	<cfcase value="ajax_DeleteSiteUser">
		<cfsetting showdebugoutput="no" />
		<cfinvoke component="#variables.objSecurityGateway#" method="deleteSiteUser">
			<cfinvokeargument name="intSiteUserID" value="#URL.intSiteUserID#" />
			<cfinvokeargument name="intDeletedSiteUserID" value="#Session.passport.currentSiteUser.getSiteUserID()#" />
		</cfinvoke>
		<cfif IsDefined("URL.strCriteria")>
			<cfset strExtraParams = "strCriteria=#URL.strCriteria#" />
		<cfelse>
			<cfset strExtraParams = "" />
		</cfif>
		<cflocation url="index.cfm?event=ajax_GetSiteUserList&#strExtraParams#" addtoken="yes" />
	</cfcase>
	
	<cfcase value="popup_SearchSiteUsers">
		<cfset request.content = includeTemplate("views/admin/security/siteusers/searchsiteuserform.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>	

	<cfcase value="popup_SearchSiteUsers:Results">
		<cfset request.structSiteUsers = getSiteUserList() />

		<cfif Not (isdefined('URL.blnAllRecords') And URL.blnAllRecords)>
			<cfinvoke method="getRecordPages" returnvariable="request.structPageNumbers">
				<cfif isdefined('URL.intPageNumber')>
					<cfinvokeargument name="intCurrentPageNumber" value="#URL.intPageNumber#">
				<cfelseif isdefined('FORM.intPageNumber')>
					<cfinvokeargument name="intCurrentPageNumber" value="#FORM.intPageNumber#">
				</cfif>
				<cfinvokeargument name="intResultsPerPage" value="#Application.ResultsPerPage#">
				<cfinvokeargument name="intTotalRecords" value="#request.structSiteUsers.rstEnumTotalCount.iCount#">
				<cfinvokeargument name="strEvent" value="#request.event#">
			</cfinvoke>
		</cfif>
		<cfinvoke method="getListPageTableHeaders" returnvariable="request.structTableHeader">
			<cfinvokeargument name="lstHeaderNames" value="First Name|sFirstName|left,Last Name|sLastName|left,Mobile Number|sMobileNumber|left,Email Address|sEmailAddress|left,&nbsp;,&nbsp;,&nbsp;,&nbsp;">
			<cfinvokeargument name="strEvent" value="#request.event#">
			<cfinvokeargument name="FilterVariableName" value="strOrderBy">
		</cfinvoke>
		
		<cfset request.content = includeTemplate("views/admin/security/siteusers/listsiteusers.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>	
	
	<!--- GROUPS --->
	<cfcase value="GroupMaintenance">
		<cfset request.SubHeading = "Search User Groups">
		<cfset request.initialFunctions = includeTemplate("views/admin/security/groups/initialfunctions.cfm", true) />
		<cfset request.content = includeTemplate("views/admin/security/securitymaintenance.cfm", true) />
		<!---<cfset request.content = includeTemplate("views/admin/security/groups/searchgroupform.cfm", true) />--->
		<cfif IsDefined("URL.blnIFrame") And URL.blnIFrame>
			<cfset includeTemplate("views/templates/maintemplate.cfm") />
		<cfelse>
			<cfset includeTemplate("views/templates/iframetemplate.cfm") />
		</cfif>
	</cfcase>
	
	<cfcase value="ajax_GetSearchGroupForm">
		<cfsetting showdebugoutput="no" />	
		<cfset includeTemplate("views/admin/security/groups/searchgroupform.cfm") />
	</cfcase>	

	<cfcase value="ajax_GetGroupSelecter">
		<cfsetting showdebugoutput="no" />
		<cfparam name="URL.intParentGroupID" type="integer" default="-1" />
		<cfset request.structGroups = variables.objSecurityGateway.enumGroups(blnAllRecords=True,intParentGroupID=URL.intParentGroupID) />
		<cfset includeTemplate("views/admin/groups/groupselecter.cfm") />
	</cfcase>

	<cfcase value="ajax_GetGroupList">
		<cfsetting showdebugoutput="no" />
		<cfset request.SubHeading = "List Groups">
		<cfset request.structGroups = getGroupList() />

		<cfif Not (isdefined('URL.blnAllRecords') And URL.blnAllRecords)>
			<cfinvoke method="getRecordPages" returnvariable="request.structPageNumbers">
				<cfif isdefined('FORM.intPageNumber')>
					<cfinvokeargument name="intCurrentPageNumber" value="#FORM.intPageNumber#">
				</cfif>
				<cfinvokeargument name="intResultsPerPage" value="#Application.ResultsPerPage#">
				<cfinvokeargument name="intTotalRecords" value="#request.structGroups.rstEnumTotalCount.iCount#">
				<cfinvokeargument name="strEvent" value="#request.event#">
			</cfinvoke>
		</cfif>
		<cfinvoke method="getListPageTableHeaders" returnvariable="request.structTableHeader">
			<cfinvokeargument name="lstHeaderNames" value="Group|sGroup|left,&nbsp;,&nbsp;,&nbsp;,&nbsp;,&nbsp;,&nbsp;">
			<cfinvokeargument name="strEvent" value="#request.event#">
			<cfinvokeargument name="FilterVariableName" value="strOrderBy">
		</cfinvoke>
		
		<cfset includeTemplate("views/admin/security/groups/listgroups.cfm") />			
	</cfcase>
	
	<cfcase value="ajax_GetAddEditGroupForm">
		<cfsetting showdebugoutput="no" />
		<cfif IsDefined("URL.intGroupID")>
			<cfset request.groupBean = fetchGroupAsBean(intGroupID=URL.intGroupID) />	
		<cfelse>
			<cfset request.groupBean = CreateObject('component', 'beans.groupbean') />
		</cfif>
		<cfif IsDefined("URL.intGroupID")>
			<cfset request.SubHeading = "Edit Group" />
		<cfelse>	
			<cfset request.SubHeading = "Add Group" />
		</cfif>
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
		<cfset includeTemplate("views/admin/security/groups/addeditgroup.cfm") />
	</cfcase>

	<cfcase value="ajax_SaveGroup">
		<!--- Prepare Group Bean --->
		<cfset request.groupBean = GetBean("beans.groupbean") />
		<!--- Determine Add or Edit --->
		<cfif FORM.hdnGroupID GT 0>
			<cfset strMethod = "updateGroup" />
			<cfset strSiteUserArgumentName = "intUpdatedSiteUserID" />
		<cfelse>
			<cfset strMethod = "addGroup" />
			<cfset strSiteUserArgumentName = "intCreatedSiteUserID" />
		</cfif>
		<!--- Invoke Add / Update Function --->
		<cfinvoke component="#variables.objSecurityGateway#" method="#strMethod#">
			<cfif FORM.hdnGroupID GT 0>
				<cfinvokeargument name="intGroupID" value="#FORM.hdnGroupID#" />
			</cfif>
			<cfinvokeargument name="strGroup" value="#FORM.txtGroup#" />
			<cfinvokeargument name="blnAllowEdit" value="#FORM.cboAllowEdit#" />
			<cfinvokeargument name="blnAllowDelete" value="#FORM.cboAllowDelete#" />
			<cfinvokeargument name="#strSiteUserArgumentName#" value="#Session.passport.currentSiteUser.getSiteUserID()#" />
		</cfinvoke>
		
		<!--- Get the list of Groups --->
		<!---<cflocation url="index.cfm?event=ajax_GetGroupList" addtoken="yes" />--->
	</cfcase>
	
	<cfcase value="ajax_ViewGroup">
		<cfsetting showdebugoutput="no" />
		<cfset request.groupBean = fetchGroupAsBean(intGroupID=URL.intGroupID) />	
		<cfset request.SubHeading = "View Group" />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
		<cfset includeTemplate("views/admin/security/groups/viewgroup.cfm") />
	</cfcase>

	<cfcase value="ajax_DeleteGroup">
		<cfsetting showdebugoutput="no" />
		<cfinvoke component="#variables.objSecurityGateway#" method="deleteGroup">
			<cfinvokeargument name="intGroupID" value="#URL.intGroupID#" />
			<cfinvokeargument name="intDeletedSiteUserID" value="#Session.passport.currentSiteUser.getSiteUserID()#" />
		</cfinvoke>
		<!--- Get the list of Groups --->
		<cflocation url="index.cfm?event=ajax_GetGroupList" addtoken="yes" />
	</cfcase>

	<cfcase value="popup_SearchGroups">
		<cfset request.content = includeTemplate("views/admin/groups/searchgroupform.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>	

	<cfcase value="popup_SearchGroups:Results">
		<cfset request.structGroups = getGroupList() />

		<cfif Not (isdefined('URL.blnAllRecords') And URL.blnAllRecords)>
			<cfinvoke method="getRecordPages" returnvariable="request.structPageNumbers">
				<cfif isdefined('FORM.intPageNumber')>
					<cfinvokeargument name="intCurrentPageNumber" value="#FORM.intPageNumber#">
				</cfif>
				<cfinvokeargument name="intResultsPerPage" value="#Application.ResultsPerPage#">
				<cfinvokeargument name="intTotalRecords" value="#request.structGroups.rstEnumTotalCount.iCount#">
				<cfinvokeargument name="strEvent" value="#request.event#">
			</cfinvoke>
		</cfif>
		<cfinvoke method="getListPageTableHeaders" returnvariable="request.structTableHeader">
			<cfinvokeargument name="lstHeaderNames" value="&nbsp;,Group|sGroup|left,Code|sGroupCode|left,Telephone Number|sTelephoneNumber|left,Email Address|sEmailAddress|left,&nbsp;,&nbsp;,&nbsp;,&nbsp;">
			<cfinvokeargument name="strEvent" value="#request.event#">
			<cfinvokeargument name="FilterVariableName" value="strOrderBy">
		</cfinvoke>
		
		<cfset request.content = includeTemplate("views/admin/groups/listgroups.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>
	
	<cfcase value="ajax_AddSiteUserToGroup">
		<cfsetting showdebugoutput="no">
		<!---<cfset request.SubHeading = "Add Site User to Group">--->
		<cfinvoke component="#variables.objSecurityGateway#" method="AddSiteUserToGroup">
				<cfinvokeargument name="SiteUserID" value="#URL.intSiteUserID#" />
				<cfinvokeargument name="intGroupID" value="#URL.intGroupID#"/>
		</cfinvoke>
		<cfinvoke component="#variables.objSecurityGateway#" method="GetGroupSiteUsers" returnvariable="request.structReturn">
			<cfinvokeargument name="GroupID" value="#URL.intGroupID#">
			<cfif IsDefined("FORM.strOrderBy")>
				<cfinvokeargument name="strOrderBy" value="#FORM.strOrderBy#" />
			</cfif>
			<cfif IsDefined("URL.blnAllRecords")>				
				<cfinvokeargument name="blnAllRecords" value="#URL.blnAllRecords#" />
			</cfif>
			<cfif IsDefined("FORM.intPageNumber")>
				<cfinvokeargument name="intPageNumber" value="#FORM.intPageNumber#" />
			</cfif>
			<cfinvokeargument name="intResultsPerPage" value="#Application.ResultsPerPage#" />
		</cfinvoke>
		<cfinvoke method="getRecordPages" returnvariable="request.structPageNumbers">
			<cfif isdefined('FORM.intPageNumber')>
				<cfinvokeargument name="intCurrentPageNumber" value="#FORM.intPageNumber#">
			</cfif>
			<cfinvokeargument name="intResultsPerPage" value="#Application.ResultsPerPage#">
			<cfinvokeargument name="intTotalRecords" value="#request.structReturn.rstGetGroupSiteUsersTotalCount.iCount#">
			<cfinvokeargument name="strEvent" value="#request.event#">
			<cfinvokeargument name="strExtraURLParams" value="">
		</cfinvoke>

		<cfinvoke method="getListPageTableHeaders" returnvariable="request.structTableHeader">
			<cfinvokeargument name="lstHeaderNames" value="FirstName|sFirstName|left,LastName|sLastName|left,Mobile Number|sMobileNumber|left,Email Address|sEmailAddress|left,&nbsp;,&nbsp;,&nbsp;,&nbsp;">
			<cfinvokeargument name="strEvent" value="#request.event#">
			<cfinvokeargument name="FilterVariableName" value="strOrderBy">
		</cfinvoke>
		
		<cfset request.content = includeTemplate("views/admin/security/groups/listgroupSiteUsers.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>
	
	<cfcase value="ajax_GetGroupSiteUsers">
		<cfsetting showdebugoutput="no">
		<cfset request.SubHeading = "List Group SiteUsers">
		<cfinvoke component="#variables.objSecurityGateway#" method="GetGroupSiteUsers" returnvariable="request.structReturn">
			<cfinvokeargument name="GroupID" value="#URL.intGroupID#">
			<cfif IsDefined("FORM.strOrderBy")>
				<cfinvokeargument name="strOrderBy" value="#FORM.strOrderBy#" />
			</cfif>
			<cfif IsDefined("URL.blnAllRecords")>				
				<cfinvokeargument name="blnAllRecords" value="#URL.blnAllRecords#" />
			</cfif>
			<cfif IsDefined("FORM.intPageNumber")>
				<cfinvokeargument name="intPageNumber" value="#FORM.intPageNumber#" />
			</cfif>
			<cfinvokeargument name="intResultsPerPage" value="#Application.ResultsPerPage#" />
		</cfinvoke>
		
		<cfinvoke method="getRecordPages" returnvariable="request.structPageNumbers">
			<cfif isdefined('FORM.intPageNumber')>
				<cfinvokeargument name="intCurrentPageNumber" value="#FORM.intPageNumber#">
			</cfif>
			<cfinvokeargument name="intResultsPerPage" value="#Application.ResultsPerPage#">
			<cfinvokeargument name="intTotalRecords" value="#request.structReturn.rstGetGroupSiteUsersTotalCount.iCount#">
			<cfinvokeargument name="strEvent" value="#request.event#">
			<cfinvokeargument name="strExtraURLParams" value="">
		</cfinvoke>

		<cfinvoke method="getListPageTableHeaders" returnvariable="request.structTableHeader">
			<cfinvokeargument name="lstHeaderNames" value="FirstName|sFirstName|left,LastName|sLastName|left,Mobile Number|sMobileNumber|left,Email Address|sEmailAddress|left,&nbsp;,&nbsp;,&nbsp;,&nbsp;">
			<cfinvokeargument name="strEvent" value="#request.event#">
			<cfinvokeargument name="FilterVariableName" value="strOrderBy">
		</cfinvoke>
		<cfset request.content = includeTemplate("views/admin/security/groups/listgroupSiteUsers.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>
	
	<cfcase value="ajax_SearchPrivileges">
		<cfsetting showdebugoutput="no">
		<cfif IsDefined("URL.intGroupID")>
			<cfset request.rstCurrentPrivileges = fetchGroupPrivilegeList(intGroupID=URL.intGroupID)>
		</cfif>
		<cfif IsDefined("URL.intSiteUserID")>
			<cfset request.rstCurrentPrivileges = fetchSiteUserPrivilegeList(intSiteUserID=URL.intSiteUserID)>
		</cfif>
		<cfset request.SubHeading = "Add Privileges to Group">
		<cfset rstPrivilegeSearchResults = fetchAllPrivilegeList()>
		<cfset request.content = includeTemplate("views/admin/security/privileges/listPrivileges.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>
	
	<cfcase value="ajax_AddSiteUserPrivileges">
		<cfsetting showdebugoutput="no">
		<cfif IsDefined("URL.intGroupID")>
			<cfset request.rstCurrentPrivileges = fetchGroupPrivilegeList(intGroupID=URL.intGroupID)>
		</cfif>
		<cfif IsDefined("URL.intSiteUserID")>
			<cfset request.rstCurrentPrivileges = fetchSiteUserPrivilegeList(intSiteUserID=URL.intSiteUserID)>
		</cfif>
		<cfset request.SubHeading = "Add Privileges to Site User">
		<cfset rstPrivilegeSearchResults = fetchAllPrivilegeList()>
		<cfset request.content = includeTemplate("views/admin/security/privileges/listPrivileges.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>
	
	<cfcase value="ajax_ListGroupPrivileges">
		<cfsetting showdebugoutput="no">
		<cfset request.SubHeading = "Privileges for Group">
		<cfset rstGroupPrivileges= fetchGroupPrivilegeList(intGroupID=#URL.intGroupID#)>
		<cfset request.content = includeTemplate("views/admin/security/groups/listGroupPrivileges.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>	
	
	<cfcase value="SavePrivilegesToGroup">
		<!---<cfsetting showdebugoutput="no">--->
		<cftransaction action="begin">
			<cfinvoke component="#variables.objSecurityGateway#" method="AddPrivilegeToGroup">
				<cfinvokeargument name="GroupID" value="#URL.GroupID#">
				<cfinvokeargument name="lstPrivilegeIDs" value="#Form.PrivilegeID#">
			</cfinvoke>
			<cftransaction action="commit" />
		</cftransaction>
	</cfcase>
	
	<cfcase value="SavePrivilegesToSiteUser">
		<cfsetting showdebugoutput="no">
		<cfinvoke component="#variables.objSecurityGateway#" method="AddPrivilegeToSiteUser">
			<cfinvokeargument name="SiteUserID" value="#URL.SiteUserID#">
			<cfinvokeargument name="lstPrivilegeIDs" value="#Form.PrivilegeID#">
		</cfinvoke>
	</cfcase>
	
	<cfcase value="ajax_ListSiteUserPrivileges">
		<cfsetting showdebugoutput="no">
		<cfset request.SubHeading = "Privileges for SiteUser">
		<cfset rstSiteUserPrivileges= fetchSiteUserPrivilegeList(intSiteUserID=#URL.intSiteUserID#)>
		<cfset request.content = includeTemplate("views/admin/security/SiteUsers/listSiteUserPrivileges.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>
	
	<cfcase value="ajax_DeleteSiteUserFromGroup">
		<cfsetting showdebugoutput="no">
		<cfinvoke component="#variables.objSecurityGateway#" method="removeSiteUserFromGroup">
			<cfinvokeargument name="GroupID" value="#url.intGroupID#">
			<cfinvokeargument name="SiteUserID" value="#url.intSiteUserID#">
		</cfinvoke>
	</cfcase>
	
	<cfcase value="ajax_RemovePrivilegeFromGroup">
		<cfsetting showdebugoutput="no">
		<cfinvoke component="#variables.objSecurityGateway#" method="RemovePrivilegeFromGroup">
			<cfinvokeargument name="GroupID" value="#url.intGroupID#">
			<cfinvokeargument name="PrivilegeID" value="#url.intPrivilegeID#">
		</cfinvoke>
	</cfcase>
	
	<cfcase value="ajax_RemovePrivilegeFromSiteUser">
		<cfsetting showdebugoutput="no">
		<cfinvoke component="#variables.objSecurityGateway#" method="RemovePrivilegeFromSiteUser">
			<cfinvokeargument name="SiteUserID" value="#url.intSiteUserID#">
			<cfinvokeargument name="PrivilegeID" value="#url.intPrivilegeID#">
		</cfinvoke>
	</cfcase>
    
	<cfcase value="systemsetup">
    	<cfset request.subnavigation = includeTemplate("views/admin/sysSetupSubnav.cfm", true) />
    	<cfset request.content = includeTemplate("webroot/systemSetup.cfm", true) />
        <cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>
	
	<cfcase value="companyinfo">
    	<cfset request.subnavigation = includeTemplate("views/admin/sysSetupSubnav.cfm", true) />
    	<cfset request.content = includeTemplate("webroot/companyinfo.cfm", true) />
        <cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>
    
    <cfcase value="reports">
    	<cfset request.subnavigation = includeTemplate("views/admin/reportsSubNav.cfm", true) />
    	<cfset request.content = includeTemplate("webroot/Reports.cfm", true) />
        <cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>
    
    <!---<cfcase value="quickRateAndMilesCalc">
    	<cfset request.subnavigation = includeTemplate("webroot/sysSetupSubnav.cfm", true) />
    	<cfset request.content = includeTemplate("webroot/quickRateAndMilesCalc.cfm", true) />
        <cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>--->
    
	<!--- EXAMPLE EVENT
	<cfcase value="login">
		<cfset request.content = includeTemplate("views/securitylogin.cfm", true) />
		<cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>
	<cfcase value="loginAction">
		<cfif Not StructKeyExists(Form, "txtUsername")>
			<cfthrow errorcode="1001" message="Username Missing" detail"The Username has not been specified on the previous page" />
		</cfif>
		<cfif Not StructKeyExists(Form, "txtPassword")>
			<cfthrow errorcode="1001" message="Password Missing" detail"The Password has not been specified on the previous page" />
		</cfif>
		<cfset request.rstLogin = variables.objSecurity.checkLogin(username=FORM.txtUsername, password=FORM.txtPassword) />
		<cfif request.rstLogin.RecordCount GT 0>
			<cflocation url="index.cfm?event=homepage" addtoken="yes" />
		<cfelse>
			<cflocation url="index.cfm?event=login&message=1" />
		</cfif>
	</cfcase>
	--->
</cfswitch>
