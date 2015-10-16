
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
<title>Admin</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"></script> 
<style type="text/css">
<!--
body,td,th {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	color: #333333;
}
body {
	margin-left: 5px;
	margin-top: 5px;
	margin-right: 5px;
	margin-bottom: 5px;
}
a:link {
	color: #0066FF;
}
a:visited {
	color: #0066FF;
}
a:hover {
	color: #16924A;
}
a:active {
	color: #0066FF;
}
-->
</style> 
<script language="javascript">
function Ajxcalcalbox(theuserid,Lastdt,cnt,C_monthw,C_yearw)
{
   $("#Div_calbox").hide();
	 $("#img_calbox").show();
	 
      	 var xmlhttp; 
		 if (window.XMLHttpRequest)
          {// code for IE7+, Firefox, Chrome, Opera, Safari
            xmlhttp=new XMLHttpRequest();
          
          }
        else
          {// code for IE6, IE5
          xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
          }
        	xmlhttp.onreadystatechange=function()
          {
          if (xmlhttp.readyState==4 && xmlhttp.status==200)
            { 
				$("#Div_calbox").html(xmlhttp.responseText);
				$("#img_calbox").hide();
				$("#Div_calbox").show();
            }
          }
        
        xmlhttp.open("get",'ajaxforcalederbox.cfm?theuserid='+theuserid+'&Lastdt='+Lastdt+'&cnt='+cnt+'&C_monthw='+C_monthw+'&C_yearw='+C_yearw,true);
        xmlhttp.send();  
}
 
	
</script>
<cfif isdefined("sec") and sec eq "calendar" or isdefined("sec") and sec eq "calllogs" or isdefined("sec") and sec eq "maintenance" or isdefined("sec") and sec eq "technician"> <!-- calendar stylesheet -->
  <link rel="stylesheet" type="text/css" media="all" href="calendar/calendar-win2k-cold-1.css" title="win2k-cold-1" />

  <!-- main calendar program -->
  <script type="text/javascript" src="calendar/calendar.js"></script>
  <!-- language for the calendar -->
  <script type="text/javascript" src="calendar/lang/calendar-en.js"></script>
  <!-- the following script defines the Calendar.setup helper function, which makes
    adding a calendar a matter of 1 or 2 lines of code. -->
  <script type="text/javascript" src="calendar/calendar-setup.js"></script></cfif>
</head>
<cfif isdefined("showfirst")>
<script language="javascript">
<cfif isdefined("sec") and sec eq "customers">
parent.main.window.location='main.cfm?sec=customers';
<cfelseif isdefined("sec") and sec eq "calendar">
parent.main.window.location='main.cfm?sec=calendar';
<cfelseif isdefined("sec") and sec eq "listings">
parent.main.window.location='main.cfm?sec=listing_list';
<cfelseif isdefined("sec") and sec eq "loans">
parent.main.window.location='main.cfm?sec=mortgage_leads';
<cfelseif isdefined("sec") and sec eq "contacts">
parent.main.window.location='main.cfm?sec=contacts';
<cfelseif isdefined("sec") and sec eq "billing">
parent.main.window.location='main.cfm?sec=billing';
<cfelseif isdefined("sec") and sec eq "technician">
parent.main.window.location='main.cfm?sec=technician';
<cfelseif isdefined("sec") and sec eq "rentalprospect">
parent.main.window.location='main.cfm?sec=rentalprospect';
<cfelseif isdefined("sec") and sec eq "investment">
parent.main.window.location='main.cfm?sec=investment';
<cfelseif isdefined("sec") and sec eq "mlsaccess">
parent.main.window.location='http://jacksonmls.fnismls.com/idx/idx.aspx?Mls=JACKSONMLS&Subscriber=cb609a02-5bcc-44cc-9c80-5fb50ab325b0';
<cfelseif isdefined("sec") and sec eq "employees">
parent.main.window.location='main.cfm?sec=employees';
<cfelseif isdefined("sec") and sec eq "collection">
parent.main.window.location='main.cfm?sec=collection_list';
<cfelseif isdefined("sec") and sec eq "reports">
parent.main.window.location='main.cfm?sec=customer_report';
<cfelseif isdefined("sec") and sec eq "calllogs">
parent.main.window.location='main.cfm?sec=calllogs';
<cfelseif isdefined("sec") and sec eq "maintenance">
parent.main.window.location='main.cfm?sec=maintenance&showincomplete=1&from=01/01/2002';
<cfelseif isdefined("sec") and sec eq "otherpayments">
parent.main.window.location='main.cfm?sec=otherpayments';
<cfelseif isdefined("sec") and sec eq "contracts">
parent.main.window.location='main.cfm?sec=contracts';
</cfif>
</script>
</cfif>
<cfset url.f_from = now()>
<CFPARAM NAME = "month" DEFAULT = "#DatePart('m', url.f_from)#">
<CFPARAM NAME = "year" DEFAULT = "#DatePart('yyyy', url.f_from)#">
<cfset ThisMonthYearw = CreateDate(year, month, '1')>
<cfset Daysw = DaysInMonth(ThisMonthYearw)>
 
  <cfset ThisMonthEndYearw = CreateDate(year, month, Daysw)>
  <!--- Set the values for the previous and next months for the back/next links. --->
  <cfset LastMonthYearw = DateAdd('m', -1, ThisMonthYearw)>
  <cfset LastMonthw = DatePart('m', LastMonthYearw)>
  <cfset LastYearw = DatePart('yyyy', LastMonthYearw)>
  <cfset NextMonthYearw = DateAdd('m', 1, ThisMonthYearw)>
  <cfset currmonthw = DateAdd('m', 0, ThisMonthYearw)><cfset C_monthw = DatePart('m', currmonthw)><cfset C_yearw = DatePart('yyyy', currmonthw)>

<body<cfif isdefined("url.resetwin")> onLoad="main.window.location='blank.cfm';"</cfif>>

  
 <cfquery datasource="#DATASOURCE#" name="grab_c_qry">
	select *
	From calendar
	<cfif isdefined("assigned") and len(assigned) or isdefined("from") and len(from) or isdefined("showstatus") and len(showstatus)>where
		<cfif isdefined("assigned") and len(assigned)>and assigned=#assigned#
		<cfelseif isdefined("assigned") and assigned eq "">
		<cfelse> 
		<cfif structkeyexists(form, "sel_allowcalmang") and form.sel_allowcalmang neq "">
		and assigned = #form.sel_allowcalmang#
		<cfelse>
		and assigned = #theuserid#
		</cfif> 
		</cfif>
		<cfif isdefined("showstatus") and len(showstatus)> and status='#showstatus#'</cfif>
		<cfelse> where  
		<cfif structkeyexists(form, "sel_allowcalmang") and form.sel_allowcalmang neq "">   
		assigned = #form.sel_allowcalmang#
		<cfelseif  structkeyexists(url, "curruser") and url.curruser neq "">
		assigned = #url.curruser#<cfelse> 
		assigned = #theuserid#</cfif> and status='Not Started' </cfif>
		order by due_time desc
</cfquery>
<cfquery name="Qry_coe_today_prev" dbtype="query">
select  distinct due_date ,due_date   from grab_c_qry
 
	where due_date < '#dateformat(now(),"mm/dd/yyyy")#' order by due_date desc   
</cfquery>
 
<cfquery name="Qry_coe_today_next" dbtype="query">
select   distinct due_date ,due_date  from grab_c_qry
 
	where due_date > '#dateformat(now(),"mm/dd/yyyy")#'   
</cfquery>
<cfquery name="Qry_coe_today" dbtype="query">
select   distinct due_date,due_date  from grab_c_qry
 
	where due_date = '#dateformat(now(),"mm/dd/yyyy")#'  order by due_date desc    
</cfquery>
<!--- <cfdump var="#Qry_coe_today_prev#">
<cfdump var="#Qry_coe_today_next#">
<cfdump var="#Qry_coe_today#"> --->
<!------> 
<div id="img_calbox" style="display:none; padding-left:20px;width:70px ">
<img src="images/loder.gif"  id="" align="middle">
</div>
 <div id="Div_calbox">
	<cfoutput>
 
	<table width="100%" border="1"   cellspacing="1" cellpadding="1"  style="border-collapse:collapse; border:1px solid ##ffffff">
	<tr>
	<td colspan="2" bgcolor="##006666"><strong style="color:##ffffff">Calendar Events(<cfoutput>#grab_c_qry.recordcount#</cfoutput>)</strong></td>
	</tr>
	<cfif Qry_coe_today_next.recordcount neq 0>
	<cfloop index="j" from="1" to="2">
	<tr >

		<td>
			<strong> 
			<cfif j eq 1><cfset j=2>
			<cfelseif j eq 2><cfset j=1>
			</cfif>
			 <cfset Mtevt1 = DatePart('m', Qry_coe_today_prev.due_date[j])>
			<cfset Dtevt1 = DatePart('d', Qry_coe_today_prev.due_date[j])>
			 <cfset dayevent = #dateformat(Qry_coe_today_prev.due_date[j],'mm-dd-yyyy')#>
			<cfquery name="Qry_coe_today_prevRec" dbtype="query">
				select   count(*) as cnt  from grab_c_qry
				where due_date = '#dayevent#'   
			</cfquery>
				#Left(DayofWeekAsString(DayOfWeek(Qry_coe_today_prev.due_date[j])),1)#   #Mtevt1#/#Dtevt1#<!---#dateformat(Qry_coe_today_prev.due_date[j],'dd-mm-yyyy')# --->
			</strong>
		</td>
		<td>
			<a href="<cfoutput>main.cfm?sec=_main_content_coe&Indv=mothvew&month=#C_monthw#&year=#C_yearw#&popup=Yes&dayevent=#dayevent#</cfoutput>" target="main">
				 #Qry_coe_today_prevRec.cnt# Events  
			</a>
		</td>
	</tr>
	</cfloop>
	</cfif>
	<cfif Qry_coe_today.recordcount neq 0>
	<tr  bgcolor="##FFD7D7">
		<td>
			<cfset Mtevt1 = DatePart('m', Qry_coe_today.due_date)>
			<cfset Dtevt1 = DatePart('d', Qry_coe_today.due_date)>
			<cfset dayevent = #dateformat(Qry_coe_today.due_date,'mm-dd-yyyy')#>
			<cfquery name="Qry_coe_tdytrecordCnt" dbtype="query">
				select   count(*) as cnt  from grab_c_qry
				where due_date = '#dayevent#'   
			</cfquery>
			<strong> 
			 Today  #Mtevt1#/#Dtevt1#
			</strong>
		</td>
		<td>
			<a href="<cfoutput>main.cfm?sec=_main_content_coe&Indv=mothvew&month=#C_monthw#&year=#C_yearw#&popup=Yes&dayevent=#dayevent#</cfoutput>" target="main">
				 #Qry_coe_tdytrecordCnt.cnt# Events  
			</a>
		</td>
	</tr>
	</cfif>
	<cfif Qry_coe_today_next.recordcount neq 0>
	<cfloop index="j" from="1" to="2">
	<tr >
			<cfset Mtevt1 = DatePart('m', Qry_coe_today_next.due_date[j])>
			<cfset Dtevt1 = DatePart('d', Qry_coe_today_next.due_date[j])>
		<td>
			<strong> 
				#Left(DayofWeekAsString(DayOfWeek(Qry_coe_today_next.due_date[j])),1)#   #Mtevt1#/#Dtevt1#
				 <!--- #dateformat(Qry_coe_today_next.due_date[j],'dd-mm-yyyy')# --->
			</strong>
		</td>
		<td><cfset dayevent = #dateformat(Qry_coe_today_next.due_date[j],'mm-dd-yyyy')#>
		<cfquery name="Qry_coe_nextrecordCnt" dbtype="query">
			select   count(*) as cnt  from grab_c_qry
			where due_date = '#dayevent#'   
		</cfquery>
	 <a href="<cfoutput>main.cfm?sec=_main_content_coe&Indv=mothvew&month=#C_monthw#&year=#C_yearw#&popup=Yes&dayevent=#dayevent#</cfoutput>" target="main">
	 #Qry_coe_nextrecordCnt.cnt# Events  </a>
		</td>
	</tr>
	</cfloop>
	</cfif>
<!---	<cfloop list="-2,-1,0,1,2" index="i">
	<cfset Ytevt = DateAdd('d', i, now())>
	<cfset Mtevt1 = DatePart('m', Ytevt)>
	<cfset Dtevt1 = DatePart('d', Ytevt)>
	<cfset Ytevt1 = DatePart('yyyy', Ytevt)>
	<cfset Dtloop = CreateDate(Ytevt1, Mtevt1, Dtevt1)> 
	
	<cfquery name="Qry_coe_today" dbtype="query">
	select ASSIGNED,CAL_ID from grab_c_qry
	where due_date between '#dateformat(Dtloop,"mm/dd/yyyy")#' and '#dateformat(Dtloop,"mm/dd/yyyy")#'  
	</cfquery>
	<cfif i eq "-2"><cfset dtback= dateformat(Dtloop,"mm/dd/yyyy")></cfif>
	
	<tr <cfif i eq 0>bgcolor="##FFD7D7"</cfif>  >
	<td><strong> <cfif i eq 0>Today <cfelse>#Left(DayofWeekAsString(DayOfWeek(Dtloop)),1)#</cfif>  #Mtevt1#/#Dtevt1#</strong></td>
	<td   ><cfset dayevent = dateformat(createdate(Ytevt1,Mtevt1,Dtevt1), "mm/dd/yyyy")>
 
	
	 <a href="<cfoutput>main.cfm?sec=_main_content_coe&Indv=mothvew&month=#C_monthw#&year=#C_yearw#&popup=Yes&dayevent=#dayevent#</cfoutput>" target="main">
	 #Qry_coe_today.recordcount# Events  </a> </td>
	</tr>
	 
	</cfloop>--->
	
	<tr>
	<td><!---<a href="##" onclick="Ajxcalcalbox(#theuserid#,'#dtback#',1,#C_monthw#,#C_yearw#);">&lt; Back</a></td><td align="right"> <a href="##" 
	onclick="Ajxcalcalbox(#theuserid#,'#dateformat(Dtloop,"mm/dd/yyyy")#',2,#C_monthw#,#C_yearw#);">Next &gt;</a>---></td><td></td>
	</tr>
	</table>  </cfoutput>
</div>
<br><br>
<table width="100%"  border="0" cellspacing="2" cellpadding="2">
<cfif isdefined("sec") and sec eq "customers">
  <tr>
    <td align="left"><strong>Customers</strong></td>
  </tr>
  <form method="post" action="main.cfm?sec=customers" target="main"> <tr>
    <td align="left">Find a Customer, Enter Name or Part of the Name:</td>
   </tr>
      <tr>
    <td align="left"><input type="text" name="criteria"></td>
   </tr>        <tr>
    <td align="left"><input type="submit" name="Submit" value="Search" style="font-size:11px;"></td>
   </tr></form>
   <tr>
    <td align="left"><a href="main.cfm?sec=new_customer" target="main">New Customer</a></td>
   </tr>
    <tr>
    <td align="left"><br><strong>Tenants</strong></td>
  </tr>
  <form method="post" action="main.cfm?sec=tenantssearch" target="main"> <tr>
    <td align="left">Find tenant by</td>
   </tr>
     <tr>
    <td align="left"><select name="findby"><option value="f_name">First Name</option><option value="l_name" selected>Last Name</option></select></td>
   </tr>
        <tr>
    <td align="left"><input type="text" name="criteria"></td>
   </tr>        <tr>
    <td align="left"><input type="submit" name="Submit" value="Search Tenants" style="font-size:11px;"></td>
   </tr></form>
   <tr>
    <td align="left"><br><strong>Properties</strong></td>
  </tr>
  <form method="post" action="main.cfm?sec=apartmentsearch" target="main"> <tr>
    <td align="left">Find properties by</td>
   </tr>
     <tr>
    <td align="left"><input type="text" name="criteria" style="font-size:11px;"> <input type="submit" name="Submit" value="Go" style="font-size:11px;"></td>
   </tr> </form>     
    <form method="post" action="main.cfm?sec=apartmentsearch" target="main">  <tr>
    <td align="left"><strong>Properties By Cities</strong><br><cfquery name="get_cities" datasource="#datasource#">select State, City, count(*) as Total 
    from properties 
    where status=1 <cfif theuserstate neq "all"> and  state='#theuserstate#'</cfif>
    group by state,city 
    order by state asc, city asc</cfquery><select name="citystate" style="font-size:11px;"><cfset  newval=""><cfset  newval2="x"><cfoutput query="get_cities" group="state"><cfset counter=0><cfoutput><option value="#state#,#city#">#state# - #city# (#Total#)</option></cfoutput></cfoutput></select> <input type="submit" name="Submit" value="Go" style="font-size:11px;"></td>
   </tr>
   </form>
   <tr>
    <td align="left"><a href="main.cfm?sec=inproperties" target="main">Inactive Properties</a> | <a href="main.cfm?sec=badproperties" target="main" title="Properties with no inspection setup, late fee and other bad data.">Bad Properties</a></td>
   </tr>  
   
   <form method="post" action="main.cfm?sec=apartmentsearch&showvacant=1" target="main">  <tr>
    <td align="left"><strong>Vacancies By Cities</strong><br><cfquery name="get_citiesx" datasource="#datasource#">select p.State, p.City, count(u.unit_id) as Total 
    from properties p,units u
    where u.occupants=0 and u.property_id=p.property_id and p.status=1<cfif theuserstate neq "all"> and p.state='#theuserstate#'</cfif> 
    group by p.state,p.city
    order by p.state asc, p.city asc</cfquery><select name="citystate" style="font-size:11px;"><cfset  newval=""><cfset  newval2="x"><cfoutput query="get_citiesx" group="state"><cfset counter=0><cfoutput><option value="#state#,#city#">#state# - #city# (#Total#)</option></cfoutput></cfoutput></select> <input type="submit" name="Submit" value="Go" style="font-size:11px;"></td>
   </tr>
   </form>
    <cfelseif isdefined("sec") and sec eq "billing">
  <tr>
    <td align="left"><strong>Billing</strong></td>
  </tr>
   <tr>
    <td align="left"><strong><a href="main.cfm?sec=billing" target="main">Create Mass Payments</a></strong></td>
  </tr>
   <cfelseif isdefined("sec") and sec eq "otherpayments">
  <tr>
    <td align="left"><strong>Payments</strong></td>
  </tr>
  <form method="post" action="main.cfm?sec=otherpayments" target="main"> <tr>
    <td align="left">Find By</td>
   </tr>
     <tr>
    <td align="left"><select name="findby"><option value="f_name">First Name</option><option value="l_name" selected>Last Name</option><option value="phone">Phone</option></select></td>
   </tr>
        <tr>
    <td align="left"><input type="text" name="criteria"></td>
   </tr>  
      <tr>
    <td align="left">Filter By:</td>
   </tr>  
      <tr>
    <td align="left"><select name="payment_type">
    <option value="all">All</option>
    <option value="paid">Paid</option>
    <option value="notpaid">Not Paid or Partial Paid</option>
    </select></td>
   </tr>  
   
         <tr>
    <td align="left"><input type="submit" name="Submit" value="Search" style="font-size:11px;"></td>
   </tr></form>
      <cfelseif isdefined("sec") and sec eq "technician">
      <cfif listfind(grabuser.access,15) and len(grabuser.access) lt 8><cfelse>  <tr>
    <td align="left"><strong>Technicians</strong></td>
   </tr>
   <form method="post" action="main.cfm?sec=technician_list" target="main"> 
   <tr>
    <td align="left">Search By Name:</td>
   </tr>
   <tr>
    <td align="left"><input type="text" name="techname" size="15" /></td>
   </tr>
     <tr>
    <td align="left" nowrap>State: <select name="state"><option value="">All</option><option>California</option><option>Michigan</option><option>Ohio</option></select></td>
   </tr>
    <td align="left"><input type="submit" name="Submit" value="Search" style="font-size:11px;"></td>
   </tr>
   </tr>
   </form></cfif>
        <tr>
    <td align="left">&nbsp;</td>
   </tr>
  <tr>
    <td align="left"><strong>Work Orders</strong></td>
  </tr>
  <form method="post" action="main.cfm?sec=technician" target="main"> <tr>
    <td align="left">Find Work Order By Date</td>
   </tr>
     <tr>
    <td align="left">From: <cfoutput><input type="text" name="from" value="#dateformat(dateadd("d",-30,now()),"mm/dd/yyyy")#" required validate="date" id="f_date_cxz" size="10"></cfoutput> <img src="images/calendar.gif" id="f_trigger_fxg" border="0" style="cursor: pointer; border:0;" title="Date selector" /> <script type="text/javascript">
    Calendar.setup({
        inputField     :    "f_date_cxz",     // id of the input field
        ifFormat       :    "%m/%d/%Y",      // format of the input field
        button         :    "f_trigger_fxg",  // trigger for the calendar (button ID)
        align          :    "Br",           // alignment (defaults to "Bl")
        singleClick    :    true
    });
</script> </td></tr> <tr>
    <td align="left">To: <cfoutput><input type="text" name="to" value="#dateformat(now(),"mm/dd/yyyy")#" required validate="date" id="f_date_cz2" size="10"></cfoutput> <img src="images/calendar.gif" id="f_trigger_fgx" border="0" style="cursor: pointer; border:0;" title="Date selector" /> <script type="text/javascript">
    Calendar.setup({
        inputField     :    "f_date_cz2",     // id of the input field
        ifFormat       :    "%m/%d/%Y",      // format of the input field
        button         :    "f_trigger_fgx",  // trigger for the calendar (button ID)
        align          :    "Br",           // alignment (defaults to "Bl")
        singleClick    :    true
    });
</script> </td></tr>  <tr>
    <td align="left"><input type="submit" name="Submit" value="Search" style="font-size:11px;"></td>
   </tr></form>
   
   
   
   
   <cfelseif isdefined("sec") and sec eq "contacts">
  <tr>
    <td align="left"><strong>Contacts</strong></td>
  </tr>
  <cfform method="post" action="main.cfm?sec=contacts" target="main"> <tr>
    <td align="left">Find contacts by</td>
   </tr>
     <tr>
    <td align="left"><select name="findby"><option value="f_name">First Name</option><option value="l_name" selected>Last Name</option><option value="phone">Phone</option><option value="company_name">Company Name</option></select></td>
   </tr>
        <tr>
    <td align="left"><cfinput type="text" name="criteria" required="yes"></td>
   </tr>        <tr>
    <td align="left"><input type="submit" name="Submit" value="Search" style="font-size:11px;"></td>
   </tr></cfform>
     <tr>
    <td align="left"><a href="main.cfm?sec=new_contact" target="main"><strong>New Contact</strong></a></td>
   </tr> 
     <cfelseif isdefined("sec") and sec eq "calllogs">
     <b>Call Logs</b>
  <cfform method="post" action="main.cfm?sec=calllogs" target="main"> <tr>
    <td align="left"><strong>Filter by:</strong></td></tr>
 <tr>
    <td align="left">From: <cfinput type="text" name="from" value="#dateformat(now(),"mm/dd/yyyy")#" required="yes" validate="date" id="f_date_cz" size="10"> <img src="images/calendar.gif" id="f_trigger_fg" border="0" style="cursor: pointer; border:0;" title="Date selector" /> <script type="text/javascript">
    Calendar.setup({
        inputField     :    "f_date_cz",     // id of the input field
        ifFormat       :    "%m/%d/%Y",      // format of the input field
        button         :    "f_trigger_fg",  // trigger for the calendar (button ID)
        align          :    "Br",           // alignment (defaults to "Bl")
        singleClick    :    true
    });
</script> </td></tr> <tr>
    <td align="left">To: <cfinput type="text" name="to" value="#dateformat(now(),"mm/dd/yyyy")#" required="yes" validate="date" id="f_date_cz2" size="10"> <img src="images/calendar.gif" id="f_trigger_fgx" border="0" style="cursor: pointer; border:0;" title="Date selector" /> <script type="text/javascript">
    Calendar.setup({
        inputField     :    "f_date_cz2",     // id of the input field
        ifFormat       :    "%m/%d/%Y",      // format of the input field
        button         :    "f_trigger_fgx",  // trigger for the calendar (button ID)
        align          :    "Br",           // alignment (defaults to "Bl")
        singleClick    :    true
    });
</script> </td></tr>
<cfif listfind(grabuser.access,4)><tr>
    <td align="left">User:<cfquery datasource="#datasource#" name="getemployees">
			select *
			from emp_users
            where status=1
            order by l_name asc, f_name asc
		</cfquery><select name="assigned" style="font-size:11px;"><option value="">All</option><cfoutput query="getemployees"><option value="#admin_id#">#f_name# #l_name# <cfif state neq "All">(#State#)</cfif></option></cfoutput></select></td></tr> <tr>
    <td align="left"> <input type="submit" name="go" value="Go"></td></tr>
    <cfelse><tr>
    <td align="left"> <input type="submit" name="go" value="Go"><cfoutput><input type="hidden" name="assigned" value="#theuserid#"></cfoutput></td></tr>
    </cfif></cfform> 
    
      
  <cfform method="post" action="main.cfm?sec=viewcalllogs" target="main">
  <tr><td><br>
<br>
<b><a href="main.cfm?sec=viewcalllogs" target="main">Inbound Calls</a></b><br>
</td>
  </tr> <tr>
    <td align="left"><strong>Filter by:</strong></td></tr>
 <tr>
    <td align="left">From: <cfinput type="text" name="from" value="#dateformat(now(),"mm/dd/yyyy")#" required="yes" validate="date" id="f_date_cza" size="10"> <img src="images/calendar.gif" id="f_trigger_fgzz" border="0" style="cursor: pointer; border:0;" title="Date selector" /> <script type="text/javascript">
    Calendar.setup({
        inputField     :    "f_date_cza",     // id of the input field
        ifFormat       :    "%m/%d/%Y",      // format of the input field
        button         :    "f_trigger_fgzz",  // trigger for the calendar (button ID)
        align          :    "Br",           // alignment (defaults to "Bl")
        singleClick    :    true
    });
</script> </td></tr> <tr>
    <td align="left">To: <cfinput type="text" name="to" value="#dateformat(now(),"mm/dd/yyyy")#" required="yes" validate="date" id="f_date_cz2a" size="10"> <img src="images/calendar.gif" id="f_trigger_fgxzz" border="0" style="cursor: pointer; border:0;" title="Date selector" /> <script type="text/javascript">
    Calendar.setup({
        inputField     :    "f_date_cz2a",     // id of the input field
        ifFormat       :    "%m/%d/%Y",      // format of the input field
        button         :    "f_trigger_fgxzz",  // trigger for the calendar (button ID)
        align          :    "Br",           // alignment (defaults to "Bl")
        singleClick    :    true
    });
</script> </td></tr>
<cfif listfind(grabuser.access,4)><tr>
    <td align="left">User:<cfquery datasource="#datasource#" name="getemployees">
			select *
			from emp_users
            where status=1
            order by l_name asc, f_name asc
		</cfquery><select name="assigned" style="font-size:11px;"><option value="All">All</option><cfoutput query="getemployees"><option value="#admin_id#">#f_name# #l_name# <cfif state neq "All">(#State#)</cfif></option></cfoutput></select></td></tr> <tr>
    <td align="left"> <input type="submit" name="go" value="Go"></td></tr>
    <cfelse><tr>
    <td align="left"> <input type="submit" name="go" value="Go"><cfoutput><input type="hidden" name="assigned" value="#theuserid#"></cfoutput></td></tr>
    </cfif>
</cfform> 
    
    
    
    

 <cfelseif isdefined("sec") and sec eq "maintenance"><b>Maintenance</b><br />

<cfquery datasource="#datasource#" name="get_tenants">
select *
From tasks
where task_start_date between '01/01/2002' and '#dateformat(now(),"mm/dd/yyyy")#' and task_name <> 'Property Inspection' and task_end_date is NULL <cfif theuserstate neq "All"> and task_state='#theuserstate#'</cfif>
</cfquery>
<cfquery datasource="#datasource#" name="get_inspections">
select *
From tasks
where task_start_date between '01/01/2002' and '#dateformat(now(),"mm/dd/yyyy")#' and task_name = 'Property Inspection' and task_end_date is NULL <cfif theuserstate neq "All"> and task_state='#theuserstate#'</cfif>
</cfquery>
 <a href="<cfoutput>main.cfm?sec=maintenance&showincomplete=1&from=01/01/2002</cfoutput>" target="main"><strong>View All Maintenance</strong></a> <cfif get_tenants.recordcount gt 0><cfoutput>(<strong>#get_tenants.recordcount#</strong>)</cfoutput></cfif><br>

<cfquery datasource="#datasource#" name="getinfo">
   select  ts.*, t.email,t.f_name, t.l_name, p.address, p.city, p.state, p.zip, u.unit_identifier
FROM         tenant_issues AS ts INNER JOIN
                      tenants AS t ON ts.tenant_id = t.tenant_id INNER JOIN
                      units AS u ON ts.unit_id = u.unit_id INNER JOIN
                      properties AS p ON u.property_id = p.property_id
   where  ts.status='New'  <cfif theuserstate neq "All"> and p.state='#theuserstate#'</cfif>
</cfquery>
 <a href="<cfoutput>main.cfm?sec=showpropertyinspection</cfoutput>" target="main"><strong>View Inspections</strong></a> <cfif get_inspections.recordcount gt 0><cfoutput>(<strong>#get_inspections.recordcount#</strong>)</cfoutput></cfif><br>
 <a href="<cfoutput>main.cfm?sec=view_all_issues</cfoutput>" target="main"><strong>Tenant Issues</strong></a> <cfif getinfo.recordcount gt 0><cfoutput>(<strong>#getinfo.recordcount#</strong>)</cfoutput></cfif><br>
 
<br> <a href="<cfoutput>main.cfm?sec=new_maintenance</cfoutput>" target="main"><strong>New Maintenance</strong></a><br><br>
 
 
  <cfform method="post" action="main.cfm?sec=maintenance" target="main"> <tr>
    <td align="left"><strong>Filter by:</strong></td></tr>
 <tr>
    <td align="left">From: <cfinput type="text" name="from" value="#dateformat(now(),"mm/dd/yyyy")#" required="yes" validate="date" id="f_date_cz" size="10"> <img src="images/calendar.gif" id="f_trigger_fg" border="0" style="cursor: pointer; border:0;" title="Date selector" /> <script type="text/javascript">
    Calendar.setup({
        inputField     :    "f_date_cz",     // id of the input field
        ifFormat       :    "%m/%d/%Y",      // format of the input field
        button         :    "f_trigger_fg",  // trigger for the calendar (button ID)
        align          :    "Br",           // alignment (defaults to "Bl")
        singleClick    :    true
    });
</script> </td></tr> <tr>
    <td align="left">To: <cfinput type="text" name="to" value="#dateformat(now(),"mm/dd/yyyy")#" required="yes" validate="date" id="f_date_cz2" size="10"> <img src="images/calendar.gif" id="f_trigger_fgx" border="0" style="cursor: pointer; border:0;" title="Date selector" /> <script type="text/javascript">
    Calendar.setup({
        inputField     :    "f_date_cz2",     // id of the input field
        ifFormat       :    "%m/%d/%Y",      // format of the input field
        button         :    "f_trigger_fgx",  // trigger for the calendar (button ID)
        align          :    "Br",           // alignment (defaults to "Bl")
        singleClick    :    true
    });
</script> </td></tr> <tr>
    <td align="left">User:<cfquery datasource="#datasource#" name="getemployees">
			select e.*,t.company_name,t.company_number
			from emp_users e, technicians t
            where t.emp_id=e.admin_id and e.access like '%15%' and t.status=1<Cfif theuserstate neq "all"> and t.state='#theuserstate#'</Cfif>
           order by l_name asc,f_name asc
		</cfquery><select name="assigned" style="font-size:11px;"><option value="">All</option><cfoutput query="getemployees"><option value="#admin_id#">#f_name# #l_name# <cfif state neq "All">(#State#)</cfif></option></cfoutput></select></td></tr>
        
        <tr>
    <td align="left">Type:<cfquery datasource="#datasource#" name="getemployees">
			SELECT     task_type, COUNT(*) AS Expr1
FROM         tasks
where task_end_date is NULL
GROUP BY task_type
		</cfquery><select name="task_type"><option value="">All</option><cfoutput query="getemployees"><option value="#task_type#">#task_type# (#Expr1#)</option></cfoutput></select></td></tr>
        <tr>
        <td><input type="checkbox" name="showincomplete" value="1"><strong>Show Incomplete Tasks Only</strong></td></tr>
         <tr>
        <td><input type="checkbox" name="showbyEnd" value="1"><strong>Ended on From Date Only</strong></td></tr>
         <tr>
    <td align="left"> <input type="submit" name="go" value="Go"></td></tr></cfform> 
    
    <tr>
    <td align="left"><br /><strong>Work Orders</strong></td>
  </tr>
  <form method="post" action="main.cfm?sec=technician" target="main"> <tr>
    <td align="left">Find Work Order By Date</td>
   </tr>
     <tr>
    <td align="left">From: <cfoutput><input type="text" name="from" value="#dateformat(dateadd("d",-30,now()),"mm/dd/yyyy")#" required validate="date" id="f_date_czy" size="10"></cfoutput> <img src="images/calendar.gif" id="f_trigger_fgy" border="0" style="cursor: pointer; border:0;" title="Date selector" /> <script type="text/javascript">
    Calendar.setup({
        inputField     :    "f_date_czy",     // id of the input field
        ifFormat       :    "%m/%d/%Y",      // format of the input field
        button         :    "f_trigger_fgy",  // trigger for the calendar (button ID)
        align          :    "Br",           // alignment (defaults to "Bl")
        singleClick    :    true
    });
</script> </td></tr> <tr>
    <td align="left">To: <cfoutput><input type="text" name="to" value="#dateformat(now(),"mm/dd/yyyy")#" required validate="date" id="f_date_cz2u" size="10"></cfoutput> <img src="images/calendar.gif" id="f_trigger_fgxu" border="0" style="cursor: pointer; border:0;" title="Date selector" /> <script type="text/javascript">
    Calendar.setup({
        inputField     :    "f_date_cz2u",     // id of the input field
        ifFormat       :    "%m/%d/%Y",      // format of the input field
        button         :    "f_trigger_fgxu",  // trigger for the calendar (button ID)
        align          :    "Br",           // alignment (defaults to "Bl")
        singleClick    :    true
    });
</script> </td></tr> 
 <tr>
    <td align="left">Assigned:</td></tr> 
<tr>
    <td align="left"><cfquery datasource="#datasource#" name="getemployees">
			select *
			from emp_users
             where access like '%15%' <cfif grabuser.state neq "All">and state='#grabuser.state#'</cfif>
		</cfquery><select name="assigned_to" style="font-size:11px;"><option value="All">All</option><cfoutput query="getemployees"><option value="#admin_id#">#f_name# #l_name# <cfif state neq "All">(#State#)</cfif></option></cfoutput></select></td>
   </tr><tr>
    <td align="left"> <input type="submit" name="go" value="Go"></td></tr></form>
   
 
   <cfelseif isdefined("sec") and sec eq "calendar">  
     <a href="<cfoutput>main.cfm?sec=_main_content_coe&Indv=mothvew&month=#C_monthw#&year=#C_yearw#</cfoutput>" target="main"><strong>Calendar View(New)</strong></a><br>
     <a href="<cfoutput>main.cfm?sec=calendar</cfoutput>" target="main"><strong>Show Calendar</strong></a><br>
   <a href="<cfoutput>main.cfm?sec=newcalendar</cfoutput>" target="main"><strong>New Calendar</strong></a><br>
    
  <cfform method="post" action="main.cfm?sec=calendar" target="main"> <tr>
    <td align="left"><strong>Filter by:</strong></td></tr>
 <tr>
    <td align="left">From: <cfinput type="text" name="from" value="#dateformat(now(),"mm/dd/yyyy")#" required="yes" validate="date" id="f_date_cz" size="10"> <img src="images/calendar.gif" id="f_trigger_fg" border="0" style="cursor: pointer; border:0;" title="Date selector" /> <script type="text/javascript">
    Calendar.setup({
        inputField     :    "f_date_cz",     // id of the input field
        ifFormat       :    "%m/%d/%Y",      // format of the input field
        button         :    "f_trigger_fg",  // trigger for the calendar (button ID)
        align          :    "Br",           // alignment (defaults to "Bl")
        singleClick    :    true
    });
</script> </td></tr> <tr>
    <td align="left">To: <cfinput type="text" name="to" value="#dateformat(now(),"mm/dd/yyyy")#" required="yes" validate="date" id="f_date_cz2" size="10"> <img src="images/calendar.gif" id="f_trigger_fgx" border="0" style="cursor: pointer; border:0;" title="Date selector" /> <script type="text/javascript">
    Calendar.setup({
        inputField     :    "f_date_cz2",     // id of the input field
        ifFormat       :    "%m/%d/%Y",      // format of the input field
        button         :    "f_trigger_fgx",  // trigger for the calendar (button ID)
        align          :    "Br",           // alignment (defaults to "Bl")
        singleClick    :    true
    });
</script> </td></tr> <tr>
    <td align="left">Status: <select name="showstatus"><option value="">All</option><option>Not Started</option><option>Pending</option><option>Completed</option><option>Daily Task</option></select></td></tr>
<cfif listfind(grabuser.access,1)>
    <tr>
<td align="left">User:<cfquery datasource="#datasource#" name="getemployees">
			select *
			from emp_users
             where status=1
            order by l_name asc, f_name asc
		</cfquery><select name="assigned" style="font-size:11px;"><option value="">All</option><cfoutput query="getemployees"><cfif theuserstate eq "All" or theuserstate eq "#State#"><option value="#admin_id#">#f_name# #l_name# <cfif state neq "All">(#State#)</cfif></option></cfif></cfoutput></select></td></tr>
        <cfelse><cfoutput><input type="hidden" name="assigned" value="#theuserid#" /></cfoutput></cfif>
        <tr>
    <td align="left"> <input type="submit" name="go" value="Go"></td></tr></cfform> 



<cfelseif isdefined("sec") and sec eq "rentalprospect">
  <tr>
    <td align="left"><strong>Rental Prospects</strong></td>
  </tr>
   <tr>
    <td align="left"><a href="main.cfm?sec=rentalprospect" target="main">Rental Prospects</a></td>
  </tr>
   <tr>
    <td align="left"><a href="main.cfm?sec=listing_list" target="main">Property Listings</a></td>
  </tr>
     <tr>
    <td align="left"><a href="main.cfm?sec=unitlisting_list" target="main">Unit Listings</a> (Rental)</td>
  </tr>  <tr>
    <td align="left"><a href="main.cfm?sec=vacancies" target="main">Vacancies</a></td>
  </tr> <form method="post" action="main.cfm?sec=apartmentsearch&showvacant=1" target="main">  <tr>
    <td align="left"><strong>Vacancies By Cities</strong><br><cfquery name="get_citiesx" datasource="#datasource#">select p.State, p.City, count(u.unit_id) as Total 
    from properties p,units u
    where u.occupants=0 and u.property_id=p.property_id and p.status=1<cfif theuserstate neq "all"> and p.state='#theuserstate#'</cfif> 
    group by p.state,p.city
    order by p.state asc, p.city asc</cfquery><select name="citystate" style="font-size:11px;"><cfset  newval=""><cfset  newval2="x"><cfoutput query="get_citiesx" group="state"><cfset counter=0><cfoutput><option value="#state#,#city#">#state# - #city# (#Total#)</option></cfoutput></cfoutput></select> <input type="submit" name="Submit" value="Go" style="font-size:11px;"></td>
   </tr>
   </form>
      <tr>
    <td align="left">&nbsp;</td>
  </tr> <tr>
    <td align="left"><strong>Rent My House</strong></td>
  </tr>
   <tr>
    <td align="left"><strong><a href="main.cfm?sec=view_rentmyhouse" target="main">Customers</a></strong></td>
  </tr>
     <tr>
    <td align="left"><strong><a href="main.cfm?sec=view_rentmyhouseproperties" target="main">Properties</a></strong></td>
  </tr>

<cfelseif isdefined("sec") and sec eq "listings">
  <tr>
    <td align="left"><strong>Listings</strong></td>
  </tr>
   <tr>
    <td align="left"><a href="main.cfm?sec=listing_list" target="main">Property Listings</a></td>
  </tr>
     <tr>
    <td align="left"><a href="main.cfm?sec=unitlisting_list" target="main">Unit Listings</a> (Rental)</td>
  </tr>  <tr>
    <td align="left"><a href="main.cfm?sec=vacancies" target="main">Vacancies</a></td>
  </tr>
  
   <form method="post" action="main.cfm?sec=apartmentsearch&showvacant=1" target="main">  <tr>
    <td align="left"><strong>Vacancies By Cities</strong><br><cfquery name="get_cities" datasource="#datasource#">select p.State, p.City, count(u.unit_id) as Total 
    from properties p,units u
    where u.occupants=0 and u.property_id=p.property_id and p.status=1<cfif theuserstate neq "all"> and p.state='#theuserstate#'</cfif> 
    group by p.state,p.city order by p.state asc, p.city asc</cfquery><select name="citystate" style="font-size:11px;"><cfset  newval=""><cfset  newval2="x"><cfoutput query="get_cities" group="state"><cfset counter=0><cfoutput><option value="#state#,#city#">#state# - #city# (#Total#)</option></cfoutput></cfoutput></select> <input type="submit" name="Submit" value="Go" style="font-size:11px;"></td>
   </tr>
   </form>
  
   <form method="post" action="main.cfm?sec=apartmentsearch&showvacant=1" target="main">  <tr>
    <td align="left"><strong>Vacancies By Cities</strong><br><cfquery name="get_citiesx" datasource="#datasource#">select p.State, p.City, count(u.unit_id) as Total 
    from properties p,units u
    where u.occupants=0 and u.property_id=p.property_id and p.status=1<cfif theuserstate neq "all"> and p.state='#theuserstate#'</cfif> 
    group by p.state,p.city
    order by p.state asc, p.city asc</cfquery><select name="citystate" style="font-size:11px;"><cfset  newval=""><cfset  newval2="x"><cfoutput query="get_citiesx" group="state"><cfset counter=0><cfoutput><option value="#state#,#city#">#state# - #city# (#Total#)</option></cfoutput></cfoutput></select> <input type="submit" name="Submit" value="Go" style="font-size:11px;"></td>
   </tr>
   </form>
   
<cfelseif isdefined("sec") and sec eq "loans">
  <tr>
    <td align="left"><strong>Loans</strong></td>
  </tr>
   <tr>
    <td align="left"><a href="main.cfm?sec=mortgage_leads" target="main">Leads</a></td>
  </tr>
   <tr>
    <td align="left"><a href="main.cfm?sec=new_listing" target="main">New</a></td>
  </tr>
  <cfelseif isdefined("sec") and sec eq "mlsaccess">
  <tr>
    <td align="left"><strong>MLS Access</strong></td>
  </tr>
   <tr>
    <td align="left"><a href="http://jacksonmls.fnismls.com/idx/idx.aspx?Mls=JACKSONMLS&Subscriber=cb609a02-5bcc-44cc-9c80-5fb50ab325b0 " target="main">IDX</a></td>
  </tr>
   <tr>
    <td align="left"><a href="http://jacksonmls.fnismls.com/idx/idx.aspx?Mls=JACKSONMLS&Subscriber=cb609a02-5bcc-44cc-9c80-5fb50ab325b0&MLSSearch=1" target="main">MLS# / Address Search</a></td>
  </tr>
    <tr>
    <td align="left"><a href="http://jacksonmls.fnismls.com/idx/idx.aspx?Mls=JACKSONMLS&Subscriber=cb609a02-5bcc-44cc-9c80-5fb50ab325b0&Featured=1" target="main">My Listings</a></td>
  </tr>
   <cfelseif isdefined("sec") and sec eq "employees">
  <tr>
    <td align="left"><strong>Employees</strong></td>
  </tr>
   <tr>
    <td align="left"><a href="main.cfm?sec=employees" target="main">Employees</a></td>
  </tr>
   <tr>
    <td align="left"><a href="main.cfm?sec=new_employee" target="main">New</a></td>
  </tr>
<cfelseif isdefined("sec") and sec eq "collection">
  <tr>
    <td align="left"><strong>Collection</strong></td>
  </tr>
   <tr>
    <td align="left"><a href="main.cfm?sec=collection_list" target="main">List All</a></td>
  </tr>
   <tr>
    <td align="left"><a href="main.cfm?sec=new_collection" target="main">New</a></td>
  </tr>
  <cfelseif isdefined("sec") and sec eq "investment">
  <tr>
    <td align="left"><strong>Development and Investments Leads</strong></td>
  </tr>
   <tr>
    <td align="left"><a href="main.cfm?sec=investment" target="main">List All</a></td>
  </tr>
   
  <cfelseif isdefined("sec") and sec eq "reports">
  <tr>
    <td align="left"><strong>Reports</strong></td>
  </tr>
   <tr>
    <td align="left"><a href="main.cfm?sec=customer_report" target="main">Customers</a></td>
  </tr>
  <tr>
    <td align="left"><a href="main.cfm?sec=receivables" target="main">Receivables</a></td>
  </tr>
   <tr>
    <td align="left"><a href="main.cfm?sec=showreport2" target="main">All Reports</a></td>
  </tr>
   <cfelseif isdefined("sec") and sec eq "contracts">
  <tr>
    <td align="left"><strong>Contracts</strong></td>
  </tr>
  <Cfif theuserstate eq "all" or theuserstate eq "California"> <tr>
    <td align="left"><a href="main.cfm?sec=contracts&state=California" target="main">California</a></td>
  </tr>
  </Cfif>
   <Cfif theuserstate eq "all" or theuserstate eq "Ohio"> <tr>
    <td align="left"><a href="main.cfm?sec=contracts&state=Ohio" target="main">Ohio</a></td>
  </tr>
  </Cfif>
   <Cfif theuserstate eq "all" or theuserstate eq "Michigan">
   <tr>
    <td align="left"><a href="main.cfm?sec=contracts&state=Michigan" target="main">Michigan</a></td>
  </tr></Cfif>
</cfif>
</table>
<br /><br />
<cfif listfind(grabuser.access,1)>
<div style="MARGIN-BOTTOM:5PX;"><strong><a href="main.cfm?sec=newcalllog" target="main">NEW CALL</a></strong></div>
<div style="MARGIN-BOTTOM:5PX;"><strong><a href="main.cfm?sec=newLead" target="main">NEW LEAD</a></strong></div>

<form method="post" action="main.cfm?sec=mastersearch" target="main"><table width="100%"  border="0" cellspacing="2" cellpadding="2">
<tr>
<td bgcolor="#990000">
<strong style="color:#FFFFFF">Master Search</strong>
</td>
</tr>
<tr>
<td>
<input type="text" name="search" value="" size="15"> <input type="submit" value="Go">
</td>
</tr>
<tr>
<td>
<span style="font-size:11px;">Search Everything...</span>
</td>
</tr></table></td></form></cfif>
<p><strong><a href="https://www.ncdevgroup.com/ra/" title="https://www.ncdevgroup.com/ra/" target="_blank">Online Rental Application:</a></strong><br>
NCDevGroup.com/<strong>RA</strong>/</p>

</body>
</html>