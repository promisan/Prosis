<!--- top menu --->

<cfparam name="openmode"           default="close">
<cfparam name="client.stafftoggle" default="#openmode#">
<cfparam name="url.scope"          default="backoffice">

<cfif client.stafftoggle eq "">
	
	<cfif openmode eq "close">	
		<cfset cl  = "hide">
		<cfset cla = "regular">		
	<cfelse>	
		<cfset cl  = "regular">
		<cfset cla = "hide">	
	</cfif>
	
<cfelse>

	<cfset openmode = client.stafftoggle>
	
	<cfif openmode eq "close">	
		<cfset cl  = "hide">
		<cfset cla = "regular">		
	<cfelse>	
		<cfset cl  = "regular">
		<cfset cla = "hide">	
	</cfif>

</cfif>	

<cfoutput>	

	<!--- table height="100%" fixes an issue in Chrome but messes up this screen in the backoffice (profile), unless we adjust the container in that BO screeen--->	
	
	<cfif url.scope eq "backoffice">
		<cfset bg = "##f1f1f1">
		<cfset vSize = 20>		
		<cfset vBackground = "background: ##f1f1f1;">
	<cfelse>
		<cfset bg="##f5f5f5">
		<cfset vSize = 15>
		<cfset vBackground = "background: ##ededed;">		
	</cfif>
	
	<table width="99%" border="0" align="center" style="background:##f1f1f1; border-radius: 0 0 10px 10px;padding-bottom: 10px;">		

	<tr><td style="height:5px"></td></tr></tr>
	
	<tr class="hide"><td id="toggleprocess"></td></tr></tr>
	
	<tr>
		
		<td width="99%" id="personinfo" class="#cl#">			
		    <cfinclude template="../../../Staffing/Application/Employee/PersonViewHeader.cfm">
             <div onclick="personviewtoggle('person')" class="clsNoPrint"
                style="cursor: pointer;padding: 0 0 2px 10px;display: block;margin: 0 auto 3px;height: 100%;width: 99%;"><h3 style="font-size: 14px;color:##033F5D;"><cf_tl id="Hide"> <img src="#Client.VirtualDir#/images/Up3.png" width="17" height="17" 
		    id="personcol"
			style="cursor: pointer;padding: 2px;margin:0;position: relative;top: 3px;"
			class="#cl#"></h3></div>
		</td>
		
		<td id="personshort" height="20" class="#cla#" onclick="personviewtoggle('person')" 
		  style="cursor:pointer;padding:2px 0 0 20px!important;">								    			  
		   <font style="color:##033F5D;font-size:17px;text-transform: uppercase; width: auto;font-weight: 600;"><cfoutput>#Employee.FirstName# #Employee.LastName# <cfif Employee.indexno neq "">(#Employee.IndexNo#)</cfif></cfoutput></font>
            
            <img src="#Client.VirtualDir#/Images/Down3.png" width="24" height="24"  		    
			id="personexp"					
			align="absmiddle"
			style="cursor: pointer;padding: 4px;float: right;margin: 0 5px 3px;"
            class="#cla#">
			
		</td>
	</tr>	
	
	<cfif ctr eq "0">
	
	<tr><td height="3"></td></tr>
	
	</cfif>
	
	<tr><td height="3"></td></tr>	
	
	</table>

</cfoutput>	