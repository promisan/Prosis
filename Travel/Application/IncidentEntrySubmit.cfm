<!-- 
	IncidentEntrySubmit.cfm
	
	Process user request to save new incident record.

	Called by: IncidentEntry.Cfm
	
	Modification history:
	21OCt03 - created by MM
 -->	
<cfset CLIENT.DataSource = "AppsTravel">
 
<cfquery name="AggregateNo" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	  UPDATE Parameter SET Incident = Incident+1
</cfquery>

<cfquery name="LastNo" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	  SELECT * FROM Parameter
</cfquery>
 
<!-- Convert date values in the Calling form into a usable format -->
<cfset dateValue = "">
<cfif #FORM.OpenDate# NEQ "">
	<CF_DateConvert Value="#FORM.OpenDate#">
	<cfset odate = #dateValue#>
</cfif>

<cfset dateValue = "">
<cfif #FORM.CloseDate# NEQ "">
 	<CF_DateConvert Value="#FORM.CloseDate#">
	<cfset cdate = #dateValue#>	 
</cfif>

<!--- Write person record into Person table --->
<cfquery name="InsertIncident" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
  	INSERT INTO Incident
         (Incident,
		 Description,
  		 Mission,
		 MissionCaseNumber,
		 <cfif #FORM.OpenDate# NEQ "">OpenDate,</cfif>
		 <cfif #FORM.CloseDate# NEQ "">CloseDate,</cfif>
		 RequestedBy,
		 InvestigatingOffice,
		 Status,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
     VALUES ('#LastNo.Incident#',
	      RTRIM(SUBSTRING('#FORM.Description#', 1,300)),
	      '#FORM.Mission#', 		  
		  '#FORM.MissionCaseNumber#',
		  <cfif #FORM.OpenDate# NEQ "">#odate#,</cfif>
		  <cfif #FORM.CloseDate# NEQ "">#cdate#,</cfif>
		  '#FORM.RequestedBy#',
          '#FORM.InvestigatingOffice#',
		  #FORM.Status#,
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')
  </cfquery>

  <!--- Write log entry into UserAction table --->
  <CF_RegisterAction 
   SystemFunctionId="1208" 
   ActionClass="Enter Incident" 
   ActionType="Enter" 
   ActionReference="#LastNo.Incident#" 
   ActionScript="">

<script language="JavaScript">
	opener.location.reload();
</script>

<cflocation url="IncidentListing.cfm?ID_Miss=#FORM.Mission#"> 

<cfoutput>
<script language="JavaScript">
	w = 0
	h = 0
	if (screen) {
		w = screen.width - 60
		h = screen.height - 116
	}
    window.close()
    window.open("IncidentEdit.cfm?ID=#LastNo.Incident#", "IncidentEdit", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=no");
</script>
</cfoutput>