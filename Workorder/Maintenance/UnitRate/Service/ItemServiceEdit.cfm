
<!--- remove service item --->

<cfparam name="url.id1" default="">
<cfparam name="url.id2" default="">
<cfparam name="url.id3" default="">

<cfquery name="get" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM ServiceItemUnitWorkorderService 
		<cfif url.id1 neq "">
		WHERE UsageId = '#url.id1#'
		<cfelse>
		WHERE 1=0
		</cfif>
</cfquery>		

<cfoutput>

<cfform method="POST" name="serviceaction" onsubmit="return false">

<table width="94%" align="center" class="formpadding">
 	 
	<TR class="labelmedium2">	
		<td width="150"><cf_tl id="Entity">:<font color="FF0000">*</font>&nbsp;</td>
		<td>	
			
		<cfquery name="getLookup" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_parameterMission
				WHERE  Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule WHERE SystemModule = 'WorkOrder')
		</cfquery>
		
		<select name="mission" id="mission" class="regularxxl">
			<cfloop query="getLookup">
			  <option value="#getLookup.mission#" <cfif getLookup.mission eq get.mission>selected</cfif>>#getLookup.mission#</option>
		  	</cfloop>
		</select>	
					    	 					 
       </td>	
	   
	  </tr>
	  
	  <tr class="labelmedium2">
	     <td><cf_tl id="Domain"></td>
		 <td>
		 
			 <cfquery name="getLookup" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT DISTINCT R.Code, R.Description
					FROM   WorkOrderService AS WS INNER JOIN
	                       Ref_ServiceItemDomain AS R ON WS.ServiceDomain = R.Code
			</cfquery>
			
			<select name="servicedomain" id="servicedomain" class="regularxxl">
				<cfloop query="getLookup">
				  <option value="#Code#" <cfif Code eq get.ServiceDomain>selected</cfif>>#description#</option>
			  	</cfloop>
			</select>	 
		 
		 </td>
	  
	  </tr>  
	  
	  <tr class="labelmedium2">
	      <td><cf_tl id="Service Activity"></td>
	      <td>		  
		  <cf_securediv id="activity" bind="url:Service/getServiceReference.cfm?usageid=#get.usageid#&servicedomain={servicedomain}&selected=#get.reference#">		  
		  </td>		  
	  </tr>
	  
	 <tr class="labelmedium2">
	      <td><cf_tl id="Sort"></td>
	      <td>		  
		  <cfif get.ListingOrder eq "">
		  <input type="text" class="regularxxl" name="ListingOrder" value="1" style="width:30px;text-align:center">  		
		  <cfelse>
		  <input type="text" class="regularxxl" name="ListingOrder" value="#get.ListingOrder#" style="width:30px;text-align:center">  
		  </cfif>
		  </td>		  
	  </tr>
	  
	   <tr class="labelmedium2">
	      <td><cf_tl id="Preset"></td>
	      <td>		  
		  <input type="checkbox" name="EnableSetDefault" <cfif get.EnableSetDefault eq "1">checked</cfif> value="1" class="radiol">  
		  </td>		  
	  </tr>
	  	  
	  <tr><td height="2"></td></tr>
      <tr><td height="1" colspan="4" class="line"></td></tr>
      <tr><td colspan="3" align="center" height="35" id="processservice">
	
	  <cfif url.id1 eq "">
			  <input type="button" class="button10g" name="Save" id="Save" value=" Save "  onclick="edititemservicesubmit('','#url.id2#','#url.id3#')">	
		  <cfelse>
			  <input type="button" class="button10g" name="Delete"  id="Delete" value="Delete" onclick="return askservice()">	
			  <input type="button" class="button10g" name="Update"  id="Update" value="Update" onclick="edititemservicesubmit('#url.id1#','#url.id2#','#url.id3#')">		  
		</cfif>		
	
	</td></tr>

</table>

</cfform>

</cfoutput>	
