<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->


<cfparam name="url.mandate" default="0">

<cfquery name="Mandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		    SELECT   *
		    FROM     Ref_Mandate
			WHERE    Mission   = '#URL.Mission#' 
			AND      MandateNo = '#url.mandate#'				
</cfquery>

<cfinvoke component = "Service.Access"  
   method           = "staffing" 
   mission          = "#URL.Mission#"
   mandate          = "#URL.Mandate#"
   returnvariable   = "mandateAccessStaffing">	
   
<cfinvoke component = "Service.Access"  
   method           = "position" 
   mission          = "#URL.Mission#"
   mandate          = "#URL.Mandate#"
   returnvariable   = "mandateAccessPosition">	   

<cfif mandateAccessStaffing eq "NONE" and mandateAccessPosition eq "NONE">

	<table width="98%" align="center">
		<tr><td align="center" class="labelmedium" style="padding-top:40px"><font color="FF0000">You have no access to this staffing period.<br>Please contact your administrator</td></tr>	
	</table>	

<cfelse>
	
	<table width="98%" align="center" height="100%">	 
	 <tr><td height="4"></td></tr>	  
	 <tr>
	     <td style="padding-left:10px" class="labelmedium"><font color="red">Expired : Parent Positions which have fallen of from the workforce table as its Position expiration date was reached.</font></td>
	 </tr>	 
	 <tr><td height="4"></td></tr>		
	 <tr>
	  <td height="100%" valign="top" style="padding:5px">	
	  <cfif Mandate.dateExpiration lt now()>  
		  <cfset url.dte = dateformat(Mandate.dateExpiration,client.datesql)>			  
	  <cfelse>
	  	  <cfset url.dte = dateformat(now(),client.datesql)>		  
	  </cfif>	  
	  
	  <cfinclude template="viewMandateContent.cfm">			
	  </td>
	 </tr>						  
	</table>   
	
</cfif>	