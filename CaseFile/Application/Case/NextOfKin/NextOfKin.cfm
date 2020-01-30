<script language="JavaScript">
	
	function maxlength(element, maxvalue) {
	     var q = eval("document.nok."+element+".value.length");
	     var r = q - maxvalue;
	     var msg = "At maximum, you can enter "+maxvalue+" characters";
	
	     if (q > maxvalue)  {
			alert (msg);
		 	return false;
	 	} else
			return true;		
	}

</script>

<cfquery name="Claim" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Claim
	WHERE   ClaimId = '#URL.ClaimId#'	
</cfquery>

<!--- determine overall access --->
	 
<cfquery name="get" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    ClaimNextOfKin
	WHERE   ClaimId = '#URL.ClaimId#'	
	AND     ActionStatus != '9' 
</cfquery>

<cfif get.recordcount eq "0">
    <cfset URL.ID2 = "new">
<cfelse>
    <cfset URL.ID2 = "update">
</cfif>

<cfquery name="qCause" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Incident
	WHERE   Class = 'Cause'
</cfquery>

<cfquery name="qRelationship" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM         Ref_Relationship
</cfquery>
	 
<!--- ------------------------------------------------------------------------------ --->
<!--- check if access to the tabs is granted based on the fly access settings in wf- --->
<!--- ------------------------------------------------------------------------------ --->

<cfinvoke 	component = "Service.Access"  
		    method           = "CaseFileManager" 
			mission          = "#Claim.Mission#" 	   
			claimtype        = "#Claim.Claimtype#"
		    returnvariable   = "access">		
					
<cfif access eq "EDIT" or access eq "ALL">
    <cfset mode = "Edit">
<cfelse>
	<cfset mode = "View">
</cfif>   

<cfoutput>

<cfform action="#SESSION.root#/CaseFile/Application/Case/NextOfKin/NextOfKinSubmit.cfm?ClaimId=#URL.ClaimId#&id2=#URL.ID2#" 
	    method="POST" name="nok">	
		
<table width="97%"
       border="0"      
	   class="formpadding"	   
       align="center">
	   
	   <tr><td colspan="2" height="6"></td></tr>
				
	    <tr bgcolor="FFFFFF">
			<td  height="30" width="10%" class="labelit"><cf_tl id="Country">:</td>
			<td  height="30" class="labelit">
			
			<cfif mode eq "Edit">							
								
				<cfquery name="qCountry" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  *
					FROM    Ref_Nation
				</cfquery>
				
			    <select name="Country" class="regularxl">
			      <cfloop query="qCountry">
				  	<cfif Code eq get.Country>
					    <option value="#Code#" selected>#Name#</option>
					<cfelse>
					    <option value="#Code#">#Name#</option>
					</cfif>
				  </cfloop>
				</select>				
				
			<cfelse>							
								
				<cfquery name="qCountry" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  *
					FROM    Ref_Nation
					WHERE   Code = '#get.country#'
				</cfquery>
				
				#qCountry.name#
							
			</cfif>	
			
			</td>
		</tr>
		
		<tr>	
			<td height="30" width="10%" class="labelit"><cf_tl id="Relationship">:</td>
			<td height="30" class="labelit">
			
			<cfif mode eq "Edit">	
			
			    <select name="Relationship" class="regularxl">
		  		  <cfif get.Relationship eq "UNDEFINED">
					  <option value="UNDEFINED" selected>Undefined</option>
				  <cfelse>
					  <option value="UNDEFINED">Undefined</option>
				  </cfif>			
			      <cfloop query="qRelationship">
				  	<cfif #Relationship# eq #get.Relationship#>
					    <option value="#Relationship#" selected>#Description#</option>
					<cfelse>
					    <option value="#Relationship#">#Description#</option>
					</cfif>
				  </cfloop>
				</select>	
				
			<cfelse>
			
				#get.Relationship#
			
			</cfif>	
			
			</td>
		</tr>
		
		
	    <tr>
			<td height="30" width="10%" class="labelit"><cf_tl id="First Name">:</td>
			<td height="30" class="labelit">
			
				<cfif mode eq "Edit">
				
				<cf_tl id="Please enter first name" var="1">
				
				<cfinput type="Text"
				   name="FirstName"
			       required="Yes"
				   message="#lt_text#"
				   class="regularxl"
				   value="#get.FirstName#"
		    	   visible="Yes"
			       enabled="Yes"
				   size = "30"
				   maxLength = "30">
				   
				 <cfelse>
				 
				 	#get.FirstName#
				 
				 </cfif>  
				   
			</td>
		</tr>
		<tr>	
			<td height="30" width="10%" class="labelit"><cf_tl id="Last Name">:</td>
			<td height="30" class="labelit">
			
				<cfif mode eq "Edit">
				
				<cf_tl id="Please enter last name" var="1">
				
				<cfinput type="Text"
				   name="LastName"
			       required="Yes"
				   message="#lt_text#"
				   class="regularxl"
				   value="#get.LastName#"
		    	   visible="Yes"
			       enabled="Yes"
				   size = "40"
				   maxLength = "40">	
				   
				      
				 <cfelse>
				 
				 	#get.LastName#
				 
				 </cfif>  	
			
			</td>
			
		</tr>
		
		  <tr>
			<td height="30" width="10%" class="labelit"><cf_tl id="Address 1">:</td>
			<td height="30" class="labelit">
			
				<cfif mode eq "Edit">
			
				<cf_tl id="Please enter Address" var="1">
			
				<cfinput type="Text"
				   name="AddressLine1"
			       required="No"
				   message="#lt_text#"
				   class="regularxl"
				   value="#get.addressline1#"
		    	   visible="Yes"
			       enabled="Yes"
				   size = "90"
				   maxLength = "100">		
				   
				 <cfelse>
				 
				 	#get.addressline1#
				 
				 </cfif>  
			
			</td>
		</tr>	
			
		
	    <tr>
			<td height="30" width="10%" class="labelit"><cf_tl id="Address 2">:</td>
			<td height="30" class="labelit">				
				
				<cfif mode eq "Edit">
				
				<cf_tl id="Please enter Address" var="1">
				
				<cfinput type="Text"
				   name="AddressLine2"
			       required="No"
				   message="#lt_text#"
				   class="regularxl"
				   value="#get.addressline2#"
		    	   visible="Yes"
			       enabled="Yes"
				   size = "90"
				   maxLength = "100">		
				   
				    <cfelse>
				 
				 	#get.addressline2#
				 
				 </cfif>  
				   
			</td>
		</tr>	
		
		<tr>		   	
			<td height="30" width="10%" class="labelit"><cf_tl id="Phone">:</td>
			<td height="30" class="labelit">
			
				<cfif mode eq "Edit">
			
				<cf_tl id="Please enter area code" var="1">
			
				(<cfinput type="Text"
				   name="AreaCode"
			       required="No"
				   message="#lt_text#"
				   class="regularxl"
				   value="#get.AreaCode#"
		    	   visible="Yes"
			       enabled="Yes"
				   size = "3"
				   maxLength = "3"
				   validate = "Integer"				   
				   >)&nbsp-&nbsp		

				 <cf_tl id="Please enter phone number" var="1">
				   
				<cfinput type="Text"
				   name="Phone"
			       required="No"
				   message="#lt_text#"
				   class="regularxl"
				   value="#get.phone#"
		    	   visible="Yes"
			       enabled="Yes"
				   size = "10"
				   maxLength = "10"
				   validate = "Integer">	
				   
				 <cfelse>
				 
				  (#get.AreaCode#)-#get.phone#
				 
				 </cfif>  	
			
			</td>
			
		</tr> 
		
			<td height="30" width="10%" class="labelit"><cf_tl id="Remarks">:</td>
			<td height="30" class="labelit">
					<cfif mode eq "Edit">
						<textarea style="width:95%" rows="3" class="regular" name="Memo">#get.Memo#</textarea>
					<cfelse>
						#get.Memo#
					</cfif>
			</td>
			
		</tr> 	
		
		<cfif get.recordcount eq "1">
		<tr><td height="30" width="10%" class="labelit">Updated by:</td>
		    <td class="labelit">#get.OfficerFirstName# #get.OfficerLastName# on: #dateformat(get.created, CLIENT.DateFormatShow)# #timeformat(get.created, "HH:MM")#</td>
		</tr>	
		</cfif>

		<cfif mode eq "Edit">
		
		    <tr><td class="linedotted" colspan="2"></td></tr>
			
			<tr>
				<td height="30" colspan="4" align="center">
					
					   <input type="submit" 
				        value="Save" 
						class="button10s" 
						style="width:120;height:24"
						onClick = "return maxlength('Memo',300);">
										
				</td>
			</tr>
		
		</cfif>
		
		</tr>		
	
</table>	
	
</cfform>
	
</cfoutput>	
				



<cfquery name="getHistory" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  top 5 *
	FROM    ClaimNextOfKin
	WHERE   ClaimId = '#URL.ClaimId#'	
	AND     ActionStatus = '9' 
	ORDER BY Created DESC
</cfquery>


</p>
<p>&nbsp;</p>
<table width="90%"
       border="0"
       cellspacing="0"
       cellpadding="0"
	   class="formpadding"
       align="Center">
  <tr>
    <td colspan="2" height="6"></td>
  </tr>  
  
  <cfloop query="getHistory">
  <cfoutput>
    <tr bgcolor="FFFFFF">
        <td height="30" width="10%" class="labelit">#getHistory.country#</td>
        <td height="30" width="10%" class="labelit">#getHistory.relationShip#</td>
        <td height="30" width="10%" class="labelit">#getHistory.Lastname#</td>
        <td height="30" width="10%" class="labelit">#getHistory.FirstName#</td>
        <td height="30" width="20%" class="labelit">#getHistory.Addressline1##getHistory.Addressline2#</td>
	    <td height="30" width="10%" class="labelit">#getHistory.AreaCode#-#getHistory.Phone#</td>
   	    <td height="30" width="20%" class="labelit">#getHistory.Memo#</td>	  
	    <td height="30" width="20%" class="labelit">#getHistory.OfficerLastName#</td>	  		
      </td>

      <tr>
        <td class="linedotted" colspan="11"></td>
      </tr>
</cfoutput>
</cfloop>
      <tr>
        <td height="30" colspan="4" align="center">&nbsp;        </td>
      </tr>

</table>
