
<cfparam name="url.scope"   default="standard">
<cfparam name="url.webapp"  default="">
<cfparam name="url.header"  default="1">
<cfparam name="url.refer"   default="regular">
<cfparam name="url.drillid" default="">

<cfif url.drillid neq ""> 
	
	<cfquery name="Address" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   PersonAddress
		WHERE  AddressId = '#URL.drillid#' 
	</cfquery>
	
	<cfset url.id  = Address.Personno>
	<cfset url.id1 = Address.AddressId>

</cfif>


<cfquery name="AddressType" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM #CLIENT.LanPrefix#Ref_AddressType
</cfquery>

<cfquery name="Relationship" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Relationship
</cfquery>
		
<cfinvoke component="Service.Access" 
   method="contract"  
   personno="#URL.ID#" 
   returnvariable="ContractAccess">	
			
<cfinvoke component="Service.Access"  
	 method="employee"  
	 owner = "Yes" <!--- 01/03/2011 check if this person is the owner of the record --->
	 personno="#URL.ID#" 
	 returnvariable="HRAccess"> 
		 
<cfif HRaccess eq "EDIT" 
   or HRAccess eq "ALL" 
   or ContractAccess eq "EDIT" 
   or ContractAccess eq "ALL">		 
   
     <cfset url.mode = "edit">
	    
<cfelse>

     <cfset url.mode = "view">
   
</cfif>  


<cfif url.refer eq "workflow" or url.drillid neq "">

    <cf_screentop height="100%" scroll="yes" banner="gradient" layout="webapp" label="Address Record" option="Process workflow step">
	
	<!--- scripts --->
	<cf_dialogstaffing>
	<cf_ActionListingScript>
	<cf_fileLibraryScript>
	<cf_mapscript scope="embed">
			
	<cfajaximport tags="cfmap,cfform"
	     params="#{googlemapkey='#client.googlemapid#'}#"> 

	<cfset modeshow = "hide">
	<cfinclude template="../PersonViewHeaderToggle.cfm">
	<table width="100%">
	<tr><td class="linedotted"></td></tr>
	</table>
	
	<cfset url.mode = "view"> 
	
<cfelse>

	<cfajaximport params="#{googlemapkey='#client.googlemapid#'}#">	
	
</cfif>

<cfform name="personaddressform" onsubmit="return false">

<table width="98%" align="center" class="formpadding">

<tr><td id="addressprocess"></td></tr>

<tr>

<td>
    
<cfquery name="Address" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PersonAddress
	WHERE  PersonNo = '#URL.ID#'
	AND    AddressId = '#URL.ID1#' 
</cfquery>

  
<cfoutput>
    
	<input type="hidden" name="PersonNo"  value="#URL.ID#">
	<input type="hidden" name="AddressId" value="#URL.ID1#">
	
</cfoutput>

<table width="99%" align="center">
  
  <cfif url.drillid eq "">  
  		 
	  <tr>
	    <td align="left" valign="middle" class="labellarge" style="height:60px;font-size:28px;padding-bottom:3px">
		<cfoutput>		    
		    <img src="#SESSION.root#/Images/address.png" height="48" alt="Click to view details" border="0" align="absmiddle">
	    	<cf_tl id="Modify  address"></b></font>
		</cfoutput>
	    </td>
			    
	  </tr> 
	  	  	    
  </cfif>  
      
  <tr>
    
	<td width="95%" style="padding-left:20px" align="center" colspan="2">
	
    <table width="96%" align="center" class="formpadding">
	    
	<cfoutput>
	
	<cfset mission = "">
	
	<cf_verifyOnBoard PersonNo = "#URL.ID#">		
		
	<TR class="fixlengthlist">
    <TD style="padding-left:8px" class="labelmedium" height="25"><cf_tl id="Address type">:</TD>
    <TD class="labelmedium">
	
	<table><tr><td>
	
		<cfif url.mode eq "edit">	
		  
		   	<select name="AddressType" required="No" class="regularxl enterastab">
		    <cfloop query="AddressType">
			<option value="#AddressType#" <cfif Address.AddressType eq AddressType>selected</cfif>>
			#Description#
			</option>
			</cfloop>    
		   	</select>		
		
		<cfelse>		
		#Address.AddressType#		
		</cfif>
		
	</TD>
	
    <TD style="padding-left:13px;" height="25" class="labelmedium"><cf_tl id="Effective">:</TD>
    <td class="labelmedium">
	   
	   <cfif url.mode eq "edit">
	
			<cf_intelliCalendarDate9
				FormName="addressedit"
				FieldName="DateEffective" 
				class="regularxl enterastab"
				DateFormat="#APPLICATION.DateFormat#"
				Message="Please enter an effective date for this record"
				Default="#Dateformat(Address.DateEffective, CLIENT.DateFormatShow)#"	
		    	AllowBlank="False">
		
		<cfelse>
			#Dateformat(Address.DateEffective, CLIENT.DateFormatShow)#		
		</cfif>
		
		</td>
						
		<TD style="padding-left:13px;" class="labelmedium"><cf_tl id="Expiration">:</TD>
		<TD class="labelmedium">
		 
		  <cfif url.mode eq "edit">
	
			  <cf_intelliCalendarDate9
				FormName="addressedit"
				class="regularxl enterastab"
				FieldName="DateExpiration" 
				DateFormat="#APPLICATION.DateFormat#"
				Default="#Dateformat(Address.DateExpiration, CLIENT.DateFormatShow)#"	
				AllowBlank="True">	
			
		  <cfelse>
		
			  #Dateformat(Address.DateExpiration, CLIENT.DateFormatShow)#
		
		  </cfif>	
				
	      </TD>	
	</tr>
		
	</table>
		
	</TD>
	</tr>
	
	<tr class="line"><td colspan="2"></td></tr>
			
	<tr><td colspan="2">
	
	    <!--- a NEW ddress object --->	
		<cf_address mode="#url.mode#" styleclass="labelmedium" addressid="#url.id1#" addressscope="Employee" mission="#mission#" emailrequired="No">
					
	</td></tr>
	
	<!--- address contact --->
		
	<TD colspan="1" class="labelmedium" style="min-width:109px;padding-left:5px" height="20"><cf_tl id="Contact">:</TD>
	
    <TD>
	
	   <table cellspacing="0" cellpadding="0">
	   
	   <tr>
		   <TD class="labelmedium">
		   <cfif url.mode eq "edit"> 
			   <select name="ContactRelationShip" required="No" class="regularxl enterastab">
			   <option value="" selected>n/a</option>
			    <cfloop query="Relationship">
				<option value="#Relationship#" <cfif #Address.ContactRelationship# eq #Relationship#>selected</cfif>>
					#Description#
				</option>
			</cfloop>
			<cfelse>
				#Address.ContactRelationship#
			</cfif>	
			</td>
					
			<td style="padding-left:4px" class="labelmedium">
			<cfif url.mode eq "edit">
			   	<input type="Text" name="Contact" value="#Address.Contact#" size="40" maxlength="40" class="regularxl enterastab">		
			<cfelse>
				#Address.Contact#
			</cfif>
	 		</td>
		</tr>
		
		</table>
 
	</TD>
	
	</TR>
			
	<tr><td height="2" colspan="1"></td></tr>
	
	<cfquery name="Contact" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT P.*, (
	      SELECT ContactCallSign 
		  FROM   PersonAddressContact 
		  WHERE  PersonNo = '#url.id#' 
		  AND    Addressid = '#url.id1#'
		  AND    ContactCode = P.Code ) as CallSign
       FROM Ref_Contact P   
	   ORDER BY ListingOrder
	</cfquery>	
	
	<TR class="fixlengthlist">
	<td valign="top" class="labelmedium" style="padding-left:5px;padding-top:7px"><cf_tl id="Contact Information">:</td>
    <TD colspan="1">
	
		<table class="formpadding">
		
		<cfset row = 0>
		
			<cfloop query="Contact">
			
				<cfset row = row+1>
				<cfif row eq "1"><tr></cfif>		
					<td style="height:21;padding-right:4px" class="labelit fixlength"><font color="808080"><cf_tl id="#Description#">:</td>				
				    <td style="padding-right:12px" class="labelmedium">
					
					<cfif url.mode eq "edit">
						
						<input type="Text" name="Contact_#currentrow#" value="#callsign#" size="20" maxlength="40" class="regularxl enterastab">
						
					<cfelse>				
					
						<cfif callsign eq "">n/a<cfelse>#callsign#</cfif>
					
					</cfif>
					</td>
					
				<cfif row eq "3"></tr><cfset row = 0></cfif>	
				
			</cfloop>
		
		</table>
	
	</td>
	</TR>				
	
	<tr><td height="2" colspan="1"></td></tr>
		
	<cfset url.ajaxid = url.id1>
	
	<input type="hidden" 
	   name="workflowlink_#url.ajaxid#" 
	   id="workflowlink_#url.ajaxid#" 	   
	   value="AddressWorkflow.cfm">	

	<tr>
		<td colspan = "4" id="#url.ajaxid#">	
		
		     <!---	   
			<cfif url.layout eq "direct">
			--->
				<cfinclude template = "AddressWorkflow.cfm">					
			<!---	
			</cfif>	
			--->
		</td>	
	</tr>
	
	
	<cfif mode eq "edit" and url.refer neq "workflow">		
			
		<tr><td height="1" colspan="3" class="line"></td></tr>		
		
		<tr><td height="1" colspan="3" align="center">		
		 
		 <cfif url.drillid eq "">
			
		 	  <cf_tl id="Back" var="1">				
			  <input type     = "button"  
				     name     = "cancel" 
				     value    = "#lt_text#" 
				     class    = "button10g" 
				     onClick  = "ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Address/EmployeeAddressDetail.cfm?webapp=#url.webapp#&mode=edit&id=#url.id#','addressdetail')">
			 						 
			 <cf_tl id="Delete" var="1">			 
		     <input class="button10g"  type="button" name="Delete" value="#lt_text#" onclick="personaddresseditvalidate('#url.webapp#','delete')">
			 
		 </cfif>
		 
	  	 <cf_tl id="Save" var="1">
	     <input class="button10g"  
		        type="button" 
				name="Submit" 
				value="#lt_text#" 
				onclick="personaddresseditvalidate('#url.webapp#','save')">
		 
		</td>
		</tr>
		
		<tr><td height="4"></td></tr>
		
	</cfif>
	
</TABLE>

</td>

</tr>
 
</table>

</cfoutput>

</td>

</tr>
 
</table>

</CFFORM>

<cfset ajaxonload("doCalendar")>
