
<cfquery name="Get" 
	datasource="#url.dsn#"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  Customer
		<cfif url.customerid neq "">
		WHERE CustomerId  = '#URL.CustomerId#' 
		<cfelse>
		WHERE 1=0
		</cfif>
</cfquery>

<cfparam name="url.mission" default="">

<cfif url.customerid neq "">

	<cfif get.recordcount eq "0">
	
	<table align="center"><tr><td class="labellarge" style="padding-top:20px;padding-bottom:20px" align="center"><font color="FF0000"><cf_tl id="Customer record is no longer on file"></td></tr></table>
	
	<cfabort>
	
	</cfif>	
		
	<cfquery name="Mission" 
		datasource="#url.dsn#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM  Ref_ParameterMission		
			WHERE Mission = '#get.mission#'	
	</cfquery>

<cfelse>

	<cfquery name="Mission" 
		datasource="#url.dsn#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ParameterMission		
			WHERE  Mission = '#url.mission#'	
	</cfquery>

</cfif>

<cfset ht = "height:18">	

<cfoutput>

<table width="100%" cellspacing="0" cellpadding="0" align="center">  		      
		
	   <tr>
		 
	    <td colspan="2" class="labelmedium" style="font-size:24px;height:38px;padding-left:8px;padding-right:4px">						
		 #get.CustomerName#</b></font>							  
		  <a href="javascript:showcustomer('#url.CustomerId#','edit','#url.dsn#')"><font size="2" color="0080C0">[<cf_tl id="Edit">]</font></a>					
	    </td>
		<td colspan="2" align="right" class="labelmedium" style="padding-right:18px;height:20px">#get.Mission#</td>	
	   </tr>	 	   
	  		   	   	  				   				  				   			  			  			   
	   <cfif url.dsn eq "AppsWorkorder" and mission.CustomerDetail eq "1">
	  				   			   
	       <cfif get.address neq "">		   											  
			  					   
			   <tr>
					<td class="labelmedium" style="width:16%;height:20px;padding-left:8px;#ht#"><cf_tl id="Address">:<cfif url.mode eq "edit"><font color="FF0000">*</font></cfif></td>
					<td class="labelmedium">#get.Address# <cfif get.PostalCode neq "">#get.PostalCode#, #get.City#<cfelse> #get.City#</cfif></td>
			   </tr>
																   				   
			   <!--- india sales order, record basic info --->
			   <cfif get.EMailAddress neq "">					   
			   <tr>
				<td class="labelmedium" style="height:20px;padding-left:8px;#ht#"><cf_tl id="Contact mail">:</td>
				<td class="labelmedium" style="height:20px"><cfif get.EMailAddress eq "">n/a<cfelse>#get.eMailAddress#</cfif></td>
			   </tr>
			   </cfif>
			   
			   <cfif get.MobileNumber neq "" or get.PhoneNumber neq "">
			    <tr>			   
				<td class="labelmedium" style="height:20px;padding-left:8px;#ht#"><cf_tl id="Mobile No">:</td>
				<td class="labelmedium" style="height:20px"><cfif get.MobileNumber eq "">n/a<cfelse>#get.MobileNumber#</cfif>							 			 			 
				<td class="labelmedium" style="height:20px;padding-left:8px;#ht#"><cf_tl id="Phone No">:</td>
				<td class="labelmedium" style="height:20px"><cfif get.PhoneNumber eq "">n/a<cfelse>#get.PhoneNumber#</cfif>							 
			   </td>
			  </tr>		
			  </cfif>
			  
			</cfif>  					  
	  				   
	   </cfif>
	   
	   <cfif get.Reference eq "">

			<!--- nada --->
			
	   <cfelse>	
	      
		   <tr>
			<td class="labelmedium" style="padding-left:8px;#ht#"><cf_tl id="Reference">:</td>
			<td colspan="3" class="labelmedium">#get.Reference#</td>
		   </tr>
	   
	   </cfif>
	   
	   <cfif get.Memo eq "">
	   
	      	<!--- nada --->
	   
	   <cfelse>
				  			   
		   <tr>
			<td class="labelmedium" style="padding-left:8px;#ht#"><cf_tl id="Memo">:</td>
			<td colspan="3" class="labelmedium">#get.Memo#</td>
		   </tr>
	   
	   </cfif>  		
					   
</table>

</cfoutput>
