/*
Written By: Weber Systems Inc. 
Date Started: 28-01-2011
Page Purpose: Main Application page
*/
component{
	setting enablecfoutputonly="yes";
	strApplicationName = Right(ExpandPath('.'), 64);
	this.Name = strApplicationName;
	this.clientmanagement = 'no';
	this.sessionmanagement = 'yes';
	this.setclientcookies = 'no';
	this.setdomaincookies = 'no';
	this.sessiontimeout = '#CreateTimeSpan(0,2,0,0)#';
	this.applicationtimeout = '#CreateTimeSpan(10,0,0,0)#';
	
	public void function setupApplication () {
		this.QBdsn = "LMaccessQB"; //Quickbooks DSN
		this.gAPI='AIzaSyAMvv7YySXPntllOqj7509OH-9N3HgCJmw';	//Googple Maps API
		this.dsn = "dev"; 
		
		this.strWebsiteTitle = "Load Manager"; //Remember this does not effect the error template title
		this.strDeveloperEmailAddress = "ScottW@WeberSystems.com;scottnweber@gmail.com";
		this.ExtrasFolder = ExpandPath("../../extras");
		this.strDateFormat = "d MMMM YYYY";
		this.strDateFormatForTextInput = "dd/MM/YYYY";
		this.ResultsPerPage = 10;
		this.ImportDSN = "";
		this.SchedulerTimeout = 120;
		this.pwdExpiryDays = 600; // How many days before the passwords expire (by default).
		this.strTimeFormat = "HH:MM";
		this.NoAuthEvents = "login|login:process|lostpassword|lostpassword:process|customerlogin|Customerlogin:process"; // This is a Pipe(|) Separated List of events that do not require the user to be logged in first (e.g. login|login:process).
		this.strSMSAddress = "ScottW@WeberSystems.com";
		this.strEmailFromAddress = "ScottW@WeberSystems.com";
		
		StructDelete(Application, "objLoadGatewayAdd", "True");
		StructDelete(Application, "objloadGateway", "True");
		StructDelete(Application, "objLoadGatewaynew", "True");
		StructDelete(Application, "objAgentGateway", "True");
		StructDelete(Application, "objLoadgatewayUpdate", "True");
	}
	
	public function onRequestStart( targetPage ) {
		
		if( isDefined("URL.reinit") ) {
			setupApplication();
		}
		if (cgi.remote_addr == "202.88.237.237") {
			//writeDump( var = "#this#", expand = "false");
		}
		
		var basepath = GetDirectoryFromPath(GetBaseTemplatePath());
		/* publicRoot: the directory that Application.cfc resides in (the web root) */

		var publicRoot = GetDirectoryFromPath(GetCurrentTemplatePath());
		
		if( len(basepath) gt len(publicRoot)) {
			/* relativePath: the difference between basepath and publicRoot */
			var relativePath = right(basepath, len(basepath) - len(publicRoot));
			/* publicRootRelative: the relative path from the current template to the web root */
			var publicRootRelative = ReReplace(relativePath, "[^\\\/]+", "..", "ALL");
			var publicRootParentRelative = iif(Len(publicRootRelative) GT 3, 'Left(publicRootRelative, Len(publicRootRelative) - 3)', DE(publicRootRelative));
			var publicRootGrandParentRelative = iif(Len(publicRootParentRelative) GT 3, 'Left(publicRootParentRelative, Len(publicRootParentRelative) - 3)', DE(publicRootParentRelative));
		} else {
			/* the current template resides in the web root, both these variables are empty */
			var relativePath = "";
			var publicRootRelative = "";
		}
		
		var session.checkUnload = '';
		var request.webpath = Replace("http://#cgi.http_host##cgi.script_name#", "\", "/", "ALL");
		var numDirectories = ListLen(relativePath, "\/") + 1;
		
		for (i =1; i<=numDirectories ; i++) {
			var request.webpath = left(request.webpath, len(request.webpath) - find("/", reverse(request.webpath)));
		}

		var request.imagesPath = request.webpath & "/images/";
		var request.fileUploadedtemp = request.webpath & "/fileupload/imgTemp/";  
		var request.fileUploadedPer = request.webpath & "/filesUpload/imgPrmnt/";
		
		/* URL path */
		var request.cfcpath = 'dev.www.gateways';
	}
	
	function setupRequest() {
		
		/* Sample URL is http://www.loadmanager.biz/cfmps/www/webroot/index.cfm?strDebugMode=EntelDebug2012041106 */
		/* The 06 in the end is the hour of the current time in the timezone set on the server. This would need to change every hour. */
		if( isDefined("URL.strDebugMode") ) {
			if( URL.strDebugMode == "EntelDebug#DateFormat(Now(),"yyyyMMddHH")#" ) {
				this.blnDebugMode = True;
			}
		} else {
			this.blnDebugMode = false;
		}
		
		param name="Session.blnDebugMode" default="#this.blnDebugMode#";
		
		if ( this.blnDebugMode || Session.blnDebugMode) {
			setting showdebugoutput="true";
		} else {
			setting showdebugoutput="no";
			/*<cferror type="exception" template="templates/error_general.cfm" mailto="#Application.strDeveloperEmailAddress#">
			<cferror type="request" template="templates/error_general.cfm" mailto="#Application.strDeveloperEmailAddress#">*/
		}
	}
	
	public function onSessionStart() {
		Session.started = now(); 
		Session.shoppingCart = StructNew(); 
		Session.shoppingCart.items =0; 	
		lock scope="Application" type="Exclusive" timeout="5" {		
			this.sessions = this.sessions + 1;
		}		
	}
	
	public function onSessionEnd() {		
	}
	
	public function onError( required Exception, required string EventName) {		
		writeDump(Exception);
		writeDump(EventName);
		abort;
	}
	
}
