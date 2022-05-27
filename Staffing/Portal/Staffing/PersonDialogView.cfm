
<cfquery name="qPerson"
        datasource="AppsEmployee"
        username="#SESSION.login#"
        password="#SESSION.dbpw#">
        SELECT * FROM Person
        WHERE PersonNo = '#URL.personNo#'
</cfquery>


<cfquery name="qContract"
        datasource="AppsEmployee"
        username="#SESSION.login#"
        password="#SESSION.dbpw#">
    SELECT * FROM PersonContract
    WHERE PersonNo = '#URL.personNo#'
</cfquery>

<cfoutput>

<table width="100%">

    <tr><td style="padding-top:5px"></td></tr>
	<tr style="background-color:e1e1e1">
	    <td colspan="2" style="padding-top:20px;padding:10px;font-size:20px" class="labelmedium">#qPerson.FullName#</td>
	</tr>
	
	<tr>
	
	<td style="padding:4px">
	
	      <cfif FileExists("#SESSION.rootDocumentpath#\EmployeePhoto\#pict#.jpg")>				  
			   <cf_getMid>
		  	   <cfset vPhoto = "#SESSION.root#\CFRStage\getFile.cfm?id=#pict#.jpg&mode=EmployeePhoto&mid=#mid#">						  						   
	      <cfelse>
			  <cfif qPerson.Gender eq "Female">
				  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-female.png">
			  <cfelse>
				  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-male.png">
			  </cfif>
		  </cfif> 	
		
		  <cfset size = "130px">					
		  <img src="#vPhoto#" class="img-circle clsRoundedPicture" style="cursor:pointer;height:#size#; width:#size#;">				
									  
	</td>								  
	<td style="width:100%" valign="top">
		
		<table width="100%" style="height:80px;">
			<tr><td valign="top" style="font-weight:bold">Contact information</td></tr>		
		</table>
		
	</td>
	
	</tr>
			
	<tr>
	<td colspan="2">

		<CF_UITabStrip id="d#URL.personNo#">
		
			<CF_UITabStripItem name="HR actionst" source="PersonDialogEvent.cfm">
			<CF_UITabStripItem name="Assigments"  source="PersonDialogAssignment.cfm">
		
		</CF_UITabStrip>   	

	</td>
	
	</tr>
	</table>
	
</cfoutput>

<cfsavecontent variable="vScript">
	ProsisUI.doTooltipPositioning(500);
</cfsavecontent>

<cfset ajaxOnLoad("function(){#vScript#}")>

