
<cfquery name="System" 
   datasource="AppsSystem">
      SELECT * FROM Parameter 
</cfquery> 

<cfif System.VirtualDirectory neq "">
	<cfset CLIENT.VirtualDir  = "/#System.VirtualDirectory#">
<cfelse>
    <cfset CLIENT.VirtualDir  = "">
</cfif>

<!--- this is removed as we do it differently based on the control

<cfinvoke component    = "Service.Process.System.UserController"  
	 method            = "ValidateFunctionAccess"  
	 SessionNo         = "#client.SessionNo#" 
	 ActionTemplate    = "#client.virtualdir#/Staffing/Reporting/PostView/Staffing/PostView.cfm"
	 ActionQueryString = "#url.mission#">	
	 
--->
		
<cfajaximport tags="cfwindow,cfdiv,cfform">

<cfparam name="URL.FilterId" 			default="00000000-0000-0000-0000-000000000000">
<cfparam name="URL.systemfunctionid" 	default="00000000-0000-0000-0000-000000000000">

<cfset link = CGI.QUERY_STRING>

<cfset size = findNoCase("&mid=",link)>
<cfif size gte "20">
	<cfset link = left(link,size-1)>
</cfif>
		
<cfquery name="Check" 
	datasource="AppsTransaction">
        SELECT * 
	    FROM   stCache
	    WHERE  DocumentId = '#URL.FilterID#' 
</cfquery>
	
<cfif Check.recordcount eq "0">

	<!--- try to find the last one --->

	<cfquery name="Check" 
		datasource="AppsTransaction">
	    SELECT   TOP 1 * 
		FROM     stCache
		-- WHERE    CacheURL LIKE '%Acc=#SESSION.acc#%' 
		WHERE   CacheURL LIKE '%_acc=#SESSION.acc#_Mission=#url.mission#_Mandate=#url.mandate#%'
		ORDER BY Created DESC
	</cfquery>
	
	<cfif Check.recordcount eq "1">
					
		<cfset link = "#replace('#link#','#URL.FilterID#','#check.documentId#','ALL')#">	
		<cfset URL.FilterId = "#check.documentId#">
	
	<cfelse>
			
		<cfset link = "#replace('#link#','#URL.FilterID#','00000000-0000-0000-0000-000000000000','ALL')#">	
		<cfset URL.FilterId = "00000000-0000-0000-0000-000000000000">
	
	</cfif>
	
</cfif>	

<cfparam name="URL.Cache" default="1">
	
<!--- ------ --->
<!--- verify --->
<!--- ------ --->

<cfquery name="Missing" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   PositionParent PP
	WHERE  Mission   = '#URL.Mission#'
	AND    MandateNo = '#URL.Mandate#'
	AND    OrgUnitOperational NOT IN
                       (SELECT  OrgUnit
                        FROM    Organization.dbo.Organization
						WHERE   Mission = '#url.mission#'
						AND     OrgUnit = PP.OrgUnitOperational)
</cfquery>		

<cfoutput>				 
					 
<cfif Missing.recordcount gte "1">
	
	<table width="100%" bgcolor="ffffaf" bordercolor="gray" class="formpadding">
	   
		<tr><td align="Center" height="30" class="cellcontent">
		<font color="FF0000"><b><cf_tl id="Problem">:</b> #Missing.recordcount# positions are not associated to a unit for this staffing period. Please contact your administrator</font>
		</td></tr>
		
	</table>

</cfif>		

</cfoutput>			
			
<cfquery name="Parameter" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_Mission 
		WHERE  Mission = '#URL.Mission#'
	</cfquery>
	
<cf_dialogPosition>	
<cf_dialogStaffing>	

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfset link = "#replace(link,"&","_",'ALL')#">	

<cfquery name="Param1" 
		datasource="AppsEmployee">
	    SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cfif Param1.StaffingViewLoad eq "0">

	<cfif FileExists("#SESSION.rootPath#\CFReports\Cache\#link#.htm")> 
	
		<cf_screentop label="Workforce summary #URL.Mission#" banner="yellow" bannerforce="Yes" systemmodule="Staffing"
			FunctionClass="Window"
			FunctionName="Main Workforce Dialog" height="100%" layout="webapp" scroll="Yes" Jquery="Yes">
		 
			<cfinclude template="../../../../CFReports/Cache/#link#.htm">				
			
		<cf_screenBottom layout="webapp">
		
		<!--- stop no need to go further doing a refresh --->
		
		<cfabort>
		
	</cfif>
	
</cfif>	

<!--- box meant to show issues with the caching as part of the refresh load --->
		
<table width="100%" cellspacing="0" cellpadding="0">		

<tr id="errorbox" class="hide">
     <td id="errorcontent" height="30" align="center" bgcolor="yellow"></td>
</tr>
</table>

<cfsilent>
		
	<cfparam name="Attributes.total"  default="0">
	
	<!--- Parameter vsalues --->
	<cfparam name="URL.Mission"       default="xxxx">
	<cfparam name="URL.Mandate"       default="xxxx">
	<cfparam name="URL.snap"          default="">
	<cfparam name="URL.ID"            default="0">
	<cfparam name="URL.unit"          default="cum">
	<cfparam name="URL.tree"          default="Operational">
	<cfparam name="level1"            default="Ffffff">
	
	<cfparam name="level4"            default="e8e8e8">
	<cfparam name="level7"            default="EFEB9A">
	<cfparam name="level10"           default="YELLOW">
	<cfparam name="level13"           default="D5EC9D">
	<cfparam name="level16"           default="C2E7E2">
	<cfparam name="level19"           default="D5B5BD">
	
	<cfquery name="Parameter" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Parameter
	</cfquery>
	
	<cfquery name="Mandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     Ref_Mandate
		WHERE    Mission   = '#URL.Mission#'
		AND      MandateNo = '#URL.Mandate#'
		AND      Operational = 1	
		ORDER BY DateEffective
	</cfquery>
	
	<cfset FileNo = round(Rand()*100)>
			
</cfsilent>

<!--- create a table of missions positions to be shown in this view --->

<cfinclude template="PostViewPrepare.cfm">

<cfsavecontent variable="content"> 	
	
	<div class="clsPrintContent">
	
		<link rel="stylesheet" type="text/css" href="postviewloop.css?a=c">
		
		<style type="text/css">
		
		A.ssmItems:link		{color:black;text-decoration:none;}
		A.ssmItems:hover	{color:black;text-decoration:none;}
		A.ssmItems:active	{color:black;text-decoration:none;}
		A.ssmItems:visited	{color:black;text-decoration:none;}
			
		
		</style>
	</div>
	
	<cfset colorh = "B5E2EA">
			
	<!--- check if menu bar is to be shown --->
				
	<cfinvoke component      = "Service.Access"  
	          method         = "StaffingTable" 
			  mission        = "#URL.Mission#" 
			  returnvariable = "maintain">		
			  			
					
	<table width="100%" height="100%">
	
	    <cfoutput>		
		
			<tr class="line"><td height="20" valign="top" style="padding-top:1px;padding-bottom:1px;padding-left:1px;padding-right:1px">		
				<cfinclude template="PostViewMenuSub.cfm">	
				<input type="hidden" id="reloadpos" name="reloadpos" value="">						
			</td></tr>	   
	   
	        <!--- moved
			<tr><td height="20" style="padding-bottom:0px;padding-left:0px;padding-right:0px">		
				<cfinclude template="PostViewMenu.cfm">					
			</td></tr>	
			
			--->
													
			<cfinclude template="PostViewScript.cfm">
					
		</cfoutput>	
					
		<tr>
	
			<td valign="top" height="100%" bgcolor="white">
							
			<table width="100%" style="min-width: 1000px;" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			
				<!--- clean data for reloading --->
						
				<cfquery name="Check" 
					datasource="AppsTransaction">
				    SELECT * 
					FROM   stCache
					WHERE DocumentId = '#URL.FilterID#'
				</cfquery>
				
								
				<cfif check.recordcount eq "1">
				
				     <cfset id = url.filterId>
					 		 
					 <cfquery name="Clear" 
						datasource="AppsTransaction">
					    DELETE FROM stCache
						WHERE  CacheURL = '#SESSION.rootPath#\CFReports\Cache\#link#.htm'
						AND    DocumentId != '#URL.FilterId#' 
					</cfquery>
										 
					 <cfquery name="Cache" 
						datasource="AppsTransaction">
					    UPDATE stCache
						SET   CacheURL = '#SESSION.rootPath#\CFReports\Cache\#link#.htm'
						WHERE DocumentId = '#URL.FilterId#' 
					</cfquery>
					
				<cfelse>
				
				 	<cf_assignId>
					
					<cfset id = rowguid>
					<cfset link = "#replace('#link#','00000000-0000-0000-0000-000000000000','#id#','ALL')#">	
					
					<cftry>
			  						
					 <cfquery name="Cache" 
						datasource="AppsTransaction">
					    INSERT INTO stCache
					    (DocumentId, CacheURL) 
					    VALUES
					   	('#id#','#SESSION.rootPath#\CFReports\Cache\#link#.htm') 
					</cfquery>
										
					<cfcatch>
					
						 <cfquery name="Cache" 
							datasource="AppsTransaction">
						    SELECT * FROM stCache
							WHERE CacheURL = '#SESSION.rootPath#\CFReports\Cache\#link#.htm'						
						</cfquery>				
						
						<cfset id = cache.documentid>
					
					</cfcatch>
					
					</cftry>
				
				</cfif>		
				
				<cfoutput>
							
				<script>
				
					function refresh() {
				  
					  if (confirm("Refresh Staffing table with latest recorded information. Do you want to continue ?")) {
					    window.location = "CacheRefresh.cfm?link=#link#"
					   }					 
					}
					
				</script>
				
				</cfoutput>
						
				<cfquery name="Parameter" 
				datasource="AppsSystem">
					SELECT * FROM Parameter 
				</cfquery>			
										
				 <cfoutput>
					<input type="hidden" name="filterid" id="filterid" value="#id#">
				 </cfoutput>	
					
			<tr><td valign="top" height="100%">
													
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">	
			
			   <cfset itm = 0>
			   <cfset itm = itm+1>
		   	   
			   <cf_menucontainer item="#itm#" class="regular">				   		   
				     <cfinclude template="PostViewMain.cfm"> 					 
			   </cf_menucontainer>
			   
			   <cfset itm = itm+1>		      	      
		       <cf_menucontainer item="#itm#" class="hide">		
				     <cfinclude template="PostViewSearch.cfm"> 
			   </cf_menucontainer>
			 	
			   <cfif maintain neq "NONE">	
			   <cfset itm = itm+1>	 	   		
			   <cf_menucontainer item="#itm#" class="hide" iframe="analysisbox">
			   </cfif>
			   
			   <cfset itm = itm+1>
			   <cf_menucontainer item="#itm#" class="hide" iframe="vacancybox" style="height:100%">
			   
			   <cf_verifyOperational module="WorkOrder" Warning="No" Mission="#url.mission#">
																		
			   <cfif operational eq "1">	
			   			   
			  	   <cfset itm = itm+1>
				   <cf_menucontainer item="#itm#" class="hide"/>	
			  			   
			   </cfif>
			   
			   <!---
			    <cfset itm = itm+1>	      	     		  
			   <cf_menucontainer item="#itm#" class="hide">		
				     <cfinclude template="MandateAction.cfm"> 
			   </cf_menucontainer>		
			   --->
			   			   			   
			   <cfset itm = itm+1>
			   <cf_menucontainer item="#itm#" class="hide">		
				     <cfinclude template="MandateContract.cfm"> 
			   </cf_menucontainer>			
			  			   			  	   	   
			   <cfset itm = itm+1>					   
		       <cf_menucontainer item="#itm#" class="hide">		
				     <cfinclude template="MandateDocument.cfm"> 
			   </cf_menucontainer>		
			   			   
			   <cfset itm = itm+1>		 
			   <cf_menucontainer item="#itm#" class="hide" iframe="expirationbox"/>
			  		
		      </table>			 
			 				
		    </td>
		</tr>
		</table>
		
		</td>
	</tr>
	
	
	</table>	
		
</cfsavecontent>


<!--- Also save the data for quicker query, keep this one before the outputting  --->
	
<cfset list = "OrgUnit,Mission,OrgUnitName,OrgUnitClass,HierarchyCode,OrgUnitCode,SelectionDate,OrgExpiration,Class,ListOrder,PostGradeBudget,PostOrderBudget, ViewOrder,Code,Total,TotalCum">

<!--- -------------------------------------------------------------------------- --->

<!--- 23/3 this should trigger a window.location away from the progress box --->
<cf_tl id="Workforce Table" var="1">
<cf_screentop 
    label="&nbsp;#lt_text# - #URL.Mission#&nbsp;&nbsp;" 
	banner="gray" 
	bannerforce="Yes"
	band="No" 
	height="100%" 
	html="Yes" 		
	line="no"
	layout="webapp" 
	systemmodule="Staffing"
	FunctionClass="Window"
	FunctionName="Main Workforce Dialog"
	scroll="Yes" 	
	JQuery="yes">			
			
	<cfoutput>#content#</cfoutput>	
			
<cf_screenBottom layout="webapp">

<cfoutput>
	<script>	
	  ptoken.navigate('PostViewLoopCache.cfm?fileno=#fileno#&list=#list#&id=#id#','errorcontent')	  
	</script>
</cfoutput>

<cftry>
	<cfdirectory action="CREATE" 
	             directory="#SESSION.rootpath#/CFReports/Cache">
	<cfcatch></cfcatch>
</cftry>
	
<cftry>
	<cffile action="WRITE" file="#SESSION.rootPath#/CFReports/Cache/#link#.htm" output="#content#">
	<cfcatch></cfcatch>
</cftry>
