
<cfparam name="url.filter2value" default="0">

<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   RequisitionLine	  
		WHERE  RequisitionNo = '#url.filter1value#'
</cfquery>

<cfquery name="Org" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Organization  		
		WHERE  OrgUnit= '#line.orgunit#'			
</cfquery>

<cfif Org.recordcount eq "99">
	
	<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">
		
		<tr>
		<td height="30" align="center" height="40" class="labelit"><b><font color="FF0000">We encountered a problem when locating the unit of this request.</font></b></td>
		</tr>
		
	</table>	
		
<cfelse>
	
	<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
	
	<tr class="hide">
	<td colspan="2">
				
		<cfoutput>
		<input type="text" value=""
		name="positionparentselect" id="positionparentselect"
		onclick="opener.positionrefresh(this.value,document.getElementById('fundeduntil').value,'#url.box#');window.close()">	
		</cfoutput>
			
	</td>
	</tr>
		
	<tr>
		<td colspan="2" align="center" height="100%" valign="top" style="border:0px solid silver">		
			
		 <cfoutput>	
				 	 					 		 
		  <iframe width="100%"
		      height="100%" 
			  frameborder="0" 
			  src="#SESSION.root#/Staffing/Application/Position/MandateView/MandateViewGeneral.cfm?header=requisition&ID=ORG&ID1=#org.orgunitcode#&ID2=#org.mission#&ID3=#org.mandateno#">	  
		  </iframe>
		 
		  </cfoutput>
		
		</td>
	</tr>
	
	</table>
	
</cfif>

