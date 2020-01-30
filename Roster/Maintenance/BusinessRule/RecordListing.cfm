<!--- 
	Definition of Roster Business Rules:
	
	a) Class 'Bucket' : These are outflow rules to determine what to do with a candidate after certain
					    condition is met. Example: A candidate is recorded and no action was taken after 3 months:
						candidate status will automatically change to : outdated.
						
	b) Class 'Process' : These are 'template driven' rules meant to condition the change of candidate's status.
						Example: If a candidate is being processed from status Recorded to Elegible, one of thes rules will
						be triggered to validate if university degree is already recorded for this candidate.
--->



<cfquery name="Rules"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT R.*, (SELECT Count(*) FROM Ref_StatusCodeProcess WHERE Code = R.Code) AS InUse
	FROM   Ref_Rule R
	ORDER  BY R.Owner, R.TriggerGroup
</cfquery>

<cf_divscroll>


<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Candidate Class">
<cfinclude template = "../HeaderRoster.cfm"> 

<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
		var w = 670;
		var h = 495;
		var left = (screen.width/2)-(w/2);
		var top  = (screen.height/2)-(h/2);

        window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left="+left+", top="+top+", width= "+w+", height= "+h+", toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {

		var w = 670;
		var h = 495;
		var left = (screen.width/2)-(w/2);
		var top  = (screen.height/2)-(h/2);

        window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left="+left+", top="+top+",  width= "+w+", height= "+h+", toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recorddelete(id1) {
		if (confirm('Are you sure that you want to delete this rule?'))
          ColdFusion.navigate("RecordSubmit.cfm?ID1=" + id1+"&action=delete&idmenu=#url.idmenu#");
}

</script>	

</cfoutput>
	
<table width="94%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

	<tr class="labelmedium line">
	    <td width="30"></td>
	    <td>Code</td>
		<td>Description</td>	
		<td>Color</td>
		<td>Op</td>
		<td>Status To</td>	
		<td></td>
	</tr>
	
	<cfoutput query="Rules" group="Owner">
	  
	  <tr>
	  	<td class="labellarge" style="font-size:25px;height:40px" colspan="7"><b>#Owner#</b></td>
	  </tr>
	  
	  <cfoutput group="TriggerGroup">
	  
		  <tr>
		  	<td class="labelmedium" colspan="7" style="padding-left:15px">#TriggerGroup#</td>
		  </tr>
	  
	  		<cfoutput>
	  
				<tr class="labelmedium linedotted navigation_row">
					<td align="center" style="padding-top:2px">
						<cf_img icon="edit" navigation="Yes" onclick="recordedit('#Code#')">
					</td>
					<td>#Code#</td>
					<td>#Description#</td>
					<td style="background-color:#color#">#color#</td>
					<td>
						<cfif Operational eq 1>Yes<cfelse>No</cfif>
					</td>
					<td>#StatusTo#</td>
					<td >
						<cfif InUse eq 0>
							<cf_img icon="delete" onclick="recorddelete('#Code#')">
						</cfif>
					</td>
				</tr>				
	
			</cfoutput>
	
		</cfoutput>
	
	   </cfoutput>
   
</table>

</cf_divscroll>