
<cfoutput>


<script language="JavaScript1.2">
			
	function refreshTree() {
		location.reload();
	}
	
	function search(condition)
		    			
		<cfif URL.Mode eq "Lookup">		
		{			
		parent._cf_loadingtexthtml='';			
		parent.ColdFusion.navigate('#session.root#/staffing/application/Function/Lookup/FunctionListingFlat.cfm?edition=#url.edition#&Mode=#URL.Mode#&Owner=#URL.Owner#&ID1=' + condition + '&FormName=#URL.formname#&fldfunctionno=#URL.fldfunctionno#&fldfunctiondescription=#URL.fldfunctiondescription#','rightme')
		}		
		<cfelse>		
		{		
		parent._cf_loadingtexthtml='';	
		parent.ColdFusion.navigate('#session.root#/staffing/application/Function/Lookup/FunctionListingFlat.cfm?edition=#url.edition#&Mode=#URL.Mode#&Owner=#URL.Owner#&ID1=' + condition,'rightme')
		}
		
		</cfif>

</script>

</cfoutput>

<cf_screentop html="No" scroll="Yes">

<table width="98%" border="0" class="formspacing" cellspacing="0" cellpadding="0" align="center">

  <tr><td>
  
	  <table>
	  <tr>
	  <td class="labelit"><cf_tl id="Search">:</td>
	  <td><input type="text" onKeyUp="javascript:search(document.getElementById('condition').value)" id="condition" name="condition" size="22" maxlength="20" class="regularxl"></td>	  
	  </tr>
	  </table>
  
  </td></tr>
     
  <tr><td class="line"></td></tr>
  
  <tr><td>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
	
	<tr><td width="100%">
	
		<cfparam name="URL.Owner" default="x">
					
		<cfquery name="Parameter" 
		   datasource="AppsSelection" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   SELECT * 
		   FROM Ref_ParameterOwner 
		   <cfif url.Owner neq "">
		   WHERE Owner = '#URL.Owner#'
		   </cfif> 
		</cfquery>
		
		<cfset fclass = "">
					
		<cfloop query="Parameter">
					
		  <cfif fclass eq ""> 
		     <cfset fclass = "'#Parameter.FunctionClassSelect#'">
		  <cfelse> 
		  	 <cfset fclass = "#fclass#,'#Parameter.FunctionClassSelect#'">
		  </cfif>
		</cfloop>

		<cfif fclass is "">
		
			['<b>No access</b>',null] 
		
		<cfelse>
				
			<cfoutput>
				
			<cfquery name="OccGroupList" 
			  datasource="AppsSelection" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT DISTINCT *
			      FROM  OccGroup
				  WHERE Status = '1'
				  AND   OccupationalGroup IN (SELECT OccupationalGroup 
				                              FROM   FunctionTitle 
											  WHERE  FunctionClass IN (#preservesinglequotes(fclass)#))		  
				  
				  <cfif occ neq "" and occ neq "roster" and SESSION.isAdministrator eq "no">
				  AND OccupationalGroup = '#url.occ#'
				  </cfif>
				  ORDER BY Description 
			  </cfquery>
			  
			  <cfif URL.Mode eq "Lookup">	
			  
			  	  <cfset lk = "parent.ColdFusion.navigate('#session.root#/staffing/application/Function/Lookup/FunctionListing.cfm?ID0=OCC&edition=#url.edition#&owner=#url.owner#&mode=#url.mode#&ID1='+this.value+ '&FormName=#URL.formname#&fldfunctionno=#URL.fldfunctionno#&fldfunctiondescription=#URL.fldfunctiondescription#','rightme')">	
			 		  
			  <cfelse>
			  
				  <cfset lk = "parent.ColdFusion.navigate('#session.root#/staffing/application/Function/Lookup/FunctionListing.cfm?ID0=OCC&edition=#url.edition#&owner=#url.owner#&mode=#url.mode#&ID1='+this.value,'rightme')">	
			  
			  </cfif>

			  <cfset ht = OccgroupList.recordcount*20>			  			  
			  
			  <cfif ht gte client.height-540>
			  	<cfset ht = client.height-540>	
			  </cfif>
			  			  
			  <select name="occgroup" multiple class="regularxl" style="width:100%;border:0px solid silver;height:#ht#" 
			  onClick="parent._cf_loadingtexthtml='';#lk#" onChange="parent._cf_loadingtexthtml='';#lk#">
			      <cfloop query="OccGroupList">
			      <option value="#occupationalgroup#">#Description#</option>
				  </cfloop>
			  </select>
				 	 
			</cfoutput>
		
		</cfif>	
	
			
	</td></tr>
		
	</table>

</td></tr>

</table>
	