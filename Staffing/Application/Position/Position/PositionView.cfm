
<cfparam name="URL.ID"          default="">
<cfparam name="URL.ID1"         default="">
<cfparam name="URL.ID2"         default="">

<cfquery datasource="appsEmployee" name="getPosition">
	SELECT * 
	FROM  Position 
	WHERE PositionNo = '#URL.ID#' 
</cfquery>

<cfif getPosition.Recordcount eq "0">

  <cf_message message="Problem, request can not be completed. Try again or contact your administrator">
  <cfabort>
  
</cfif>

<cfif url.id eq "">
   <cfset url.id  = getPosition.Mission>
   <cfset url.id1 = getPosition.MandateNo>
</cfif>

<cfoutput>

	<script language="JavaScript">
		function AddAssignment(postno) {
	  	ptoken.open("#SESSION.root#/Staffing/Application/Assignment/AssignmentEntry.cfm?Box=box&Mission=#GetPosition.Mission#&ID=" + postno + "&Caller=PostDialog", "_blank", "width=930, height=920, status=yes, toolbar=no, scrollbars=no, resizable=yes");
		}	
	</script>
	
</cfoutput>

<cfinvoke component   = "Service.Access"  
   method             = "StaffingTable" 
   mission            = "#GetPosition.Mission#" 
   returnvariable     = "maintain">		

<cf_screentop height="100%"
     band="No" label="Position Profile" jquery="Yes" html="Yes" scroll="no" banner="gray" layout="webapp" ValidateSession="no">

<cfoutput>	

<input type="hidden" 
  	 name="refresh_#GetPosition.PositionParentId#" 
	 onclick="refresh('#GetPosition.PositionParentId#','')">
	 
	<cfif maintain neq "NONE">	   
	
		<cfparam name="URL.ID1" type="string" default="0">
		<cfset URL.Caller="PostDialog">
		<table width="100%" height="100%">
			<tr><td id="pos" height="100%" valign="top">
			<cf_divscroll style="height:100%">
				<cfinclude template="../../Assignment/PostAssignment.cfm">
			</cf_divscroll>
			</td></tr>
		</table>
		
	</cfif>

</cfoutput>


