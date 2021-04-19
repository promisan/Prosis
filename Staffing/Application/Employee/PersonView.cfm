
<cfparam name="URL.ID"  type="string" default="0">
<cfparam name="URL.ID1" type="any" default="0">

 <cfquery name="Employee" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Person
	    WHERE  PersonNo = '#URL.ID#'
</cfquery>

<cfif Employee.recordcount eq "1">
	
	<cfset url.id1 = Employee.IndexNo>

<cfelse>
	   	
	<cfquery name="Employee" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 * 
	    FROM   Person
	    WHERE  IndexNo = '#URL.ID#'
	</cfquery>
	
	<cfset URL.ID  = Employee.PersonNo>
	<cfset URL.ID1 = Employee.IndexNo>
	
</cfif>
	
<cfparam name="URL.ID2" type="string" default="0">
<cfparam name="URL.Template" type="string" default="regular">

<cfif isValid("GUID",url.template)>
  
      <cfquery name="getFunction" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
		    FROM   Ref_ModuleControl
			WHERE  SystemFunctionId = '#url.template#'			
	  </cfquery>
			
	  <cfset url.template = getFunction.ScriptName>	
			
</cfif> 

<cfif url.template eq "undefined"  or url.template eq "" or url.template eq "regular">

	<cfinvoke component = "Service.Authorization.Function"  
	 method           = "AuthorisedFunctions" 
	 mode             = "View"			 	  
	 SystemModule     = "'Staffing'"
	 FunctionClass    = "'Employee'"
	 MenuClass        = "'History'"
	 returnvariable   = "searchresult">	  
	 
	 <cfif searchresult.recordcount gte "1">
	 
		 <cfquery name="getFunction" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * 
			    FROM   Ref_ModuleControl
				WHERE  SystemFunctionId = '#searchresult.systemfunctionid#'			
		</cfquery>
						
		<cfset url.template = getFunction.ScriptName>	
				
	</cfif>

</cfif>
	
<cfif URL.Template eq "Contract">
   <cfset URL.Template = "#SESSION.root#/Staffing/Application/Employee/Contract/EmployeeContract.cfm">
<cfelseif URL.Template eq "Appointment">
   <cfset URL.Template = "#SESSION.root#/Staffing/Application/Employee/Contract/EmployeeContract.cfm">
<cfelseif URL.Template eq "Assignment">
   <cfset URL.Template = "#SESSION.root#/Staffing/Application/Assignment/AssignmentEdit.cfm">
<cfelseif URL.Template eq "Position">
   <cfset URL.Template = "#SESSION.root#/Staffing/Application/Assignment/EmployeeAssignment.cfm"> 
<cfelseif URL.Template eq "Travel">
   <cfset URL.Template = "#SESSION.root#/Staffing/Application/Employee/Invoices/Ledger.cfm">     
<cfelseif URL.Template eq "Payroll">
   <cfset URL.Template = "#SESSION.root#/Payroll/Application/Payroll/EmployeePayroll.cfm">
<cfelseif URL.Template eq "Advance">
   <cfset URL.Template = "#SESSION.root#/Staffing/Application/Employee/Advance/AdvanceView.cfm">   
<cfelseif URL.Template eq "PersonEvent">  	
   <cfset URL.Template = "#SESSION.root#/Staffing/Application/Employee/Events/EventsView.cfm"> 
<cfelseif URL.Template eq "Leave">  	
   <cfset URL.Template = "#SESSION.root#/Staffing/Application/Employee/Leave/EmployeeLeave.cfm">       
<cfelseif URL.Template eq "Dependent">  	
   <cfset URL.Template = "#SESSION.root#/Staffing/Application/Employee/Dependents/EmployeeDependent.cfm">      
<cfelseif URL.Template eq "Entitlement">  	
   <cfset URL.Template = "#SESSION.root#/Staffing/Application/Employee/Entitlement/EmployeeEntitlement.cfm">     
<cfelseif URL.Template eq "Miscellaneous">  
   <cfset URL.Template = "#SESSION.root#/Staffing/Application/Employee/Cost/EmployeeMiscellaneous.cfm">     
<cfelse> 
   <cfset URL.Template="#SESSION.root#/Staffing/Application/Employee/PersonViewMain.cfm">	
</cfif>
	
<cfsavecontent variable="option">
	<cfinclude template="PersonViewBanner.cfm">			
</cfsavecontent>

<cfif option eq "">
    <cfset option = "HR Administration details">
</cfif>




<cf_screentop height="100%" 
	  html="Yes" 
	  scroll="No"
	  option="#option#" 
	  menucopy="Yes"
	  menuprint="No"
	  layout="webapp"
	  jQuery="Yes"
	  banner="gray"
	  bannerheight="55"
	  bannerforce="Yes"
	  menuaccess="context"
	  systemmodule="Staffing"
	  functionclass="Window"
	  functionName="Employee Dialog"
	  label="s:#Employee.LastName# [#Employee.PersonNo#]">
	  
  		  
<cf_layoutScript>


<cfif Employee.recordcount eq "0">

	<table align="center">
		<tr><td height="40" class="labelmedium"><b><cf_tl id="Employee record is no longer on file"></td></tr>
	</table>

<cfelse>
			
	<cf_layout type="border" id="personProfileLayout">
	
		<cf_layoutArea id="leftArea" position="left" collapsible="true" size="200" maxsize="300" minsize="18%">
		
			<cf_divScroll>
				<table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0">
				    <tr><td align="left" height="100%" style="min-height:100%;padding-left:1px; padding-right:2px;" valign="top">
						<cfinclude template="PersonViewMenu.cfm"> 
						</td>
					</tr>						
				</table>	
			</cf_divScroll>
		
		</cf_layoutArea>
		
		<cf_layoutArea id="centerArea" position="center">
		
			<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
			<cfset mid = oSecurity.gethash()/> 
							
			<cfoutput>
							
				<iframe src="#URL.Template#?ID=#URL.ID#&ID1=#URL.ID2#&Caller=P&mid=#mid#" 
						 name="right" 
						 id="right" 
						 width="100%" 
						 height="100%" 						 
						 scrolling="no" 
						 frameborder="0"></iframe>
					 
			</cfoutput>
			
		</cf_layoutArea>
	
	</cf_layout>	

</cfif>	